using System;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Optional;
using Users.Interfaces;
using Utility;
using static API.Interfaces.InfAuth;

namespace API.Services.Auth
{
    public sealed class InfAuthImpl : InfAuthBase
    {
        private static readonly Random random = new Random();

        public override Task<Empty> SendLoginEmail(SendLoginEmailRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    await SendLoginEmailImpl(
                        request,
                        GetUsersService(),
                        new SendGridEmailService(),
                        context.CancellationToken);
                    return Empty.Instance;
                });

        internal async Task SendLoginEmailImpl(
            SendLoginEmailRequest request,
            IUsersService usersService,
            IEmailService emailService,
            CancellationToken cancellationToken)
        {
            ServiceEventSource.Current.Message("SendLoginEmail.");

            var userId = request.Email;
            var userData = await usersService.GetUserData(userId);
            var userType = request.UserType;
            var userStatus = UserStatus.WaitingForActivation;
            var userShouldAlreadyExist = userType == Interfaces.UserType.UnknownUserType;

            if (!userShouldAlreadyExist && string.IsNullOrEmpty(request.InvitationCode))
            {
                throw new RpcException(new Status(StatusCode.FailedPrecondition, "No invitation code was provided."));
            }

            if (userShouldAlreadyExist)
            {
                if (userData == null)
                {
                    ServiceEventSource.Current.Message("User '{0}' should already exist, but no data was found for them.", userId);

                    // Help mitigate "timing" attacks.
                    await Task.Delay(random.Next(100, 1000));

                    return;
                }

                userType = userData.Type.ToDto();
                userStatus = userData.Status;
                ServiceEventSource.Current.Message("User '{0}' was found, and they are of type '{1}', status '{2}'.", userId, userType, userStatus);
            }
            else
            {
                if (userData != null)
                {
                    ServiceEventSource.Current.Message("User '{0}' should not exist, but data was found for them.", userId);

                    // Help mitigate "timing" attacks.
                    await Task.Delay(random.Next(100, 1000));

                    return;
                }

                userData = UserData.Initial;
            }

            ServiceEventSource.Current.Message("Generating login token.");
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                userStatus.ToString(),
                userType.ToString(),
                request.InvitationCode);

            ServiceEventSource.Current.Message("Saving user data.");
            userData = userData
                .With(
                    type: Option.Some(userType.ToServiceObject()),
                    status: Option.Some(userStatus),
                    loginToken: Option.Some(loginToken));
            await usersService.SaveUserData(userId, userData);

            ServiceEventSource.Current.Message("Sending verification email.");
            var link = $"https://infmarketplace.com/app/verify?token={loginToken}";
            await emailService.SendVerificationEmail(
                userId,
                userData.Name ?? userId,
                link,
                cancellationToken);
        }

        public override Task<CreateNewUserResponse> CreateNewUser(CreateNewUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("CreateNewUser.");

                    ServiceEventSource.Current.Message("Validating login token.");
                    var loginTokenValidationResults = TokenManager.ValidateLoginToken(request.LoginToken);

                    if (!loginTokenValidationResults.IsValid)
                    {
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Invalid login token."));
                    }

                    ServiceEventSource.Current.Message("Validating user status.");
                    var userId = loginTokenValidationResults.UserId;
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    if (userData.Status != UserStatus.WaitingForActivation)
                    {
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' is not awaiting activation."));
                    }

                    ServiceEventSource.Current.Message("Honoring invitation code.");
                    var invitationCode = loginTokenValidationResults.InvitationCode;
                    var invitationCodesService = GetInvitationCodesService();
                    var honorResult = await invitationCodesService.Honor(invitationCode);

                    if (honorResult != InvitationCodeHonorResult.Success)
                    {
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Could not honor invitation code."));
                    }

                    ServiceEventSource.Current.Message("Generating refresh token.");
                    var refreshToken = TokenManager.GenerateRefreshToken(loginTokenValidationResults.UserId, loginTokenValidationResults.UserType);

                    ServiceEventSource.Current.Message("Saving user session.");
                    await usersService.SaveUserSession(new UserSession(refreshToken, request.DeviceId));

                    ServiceEventSource.Current.Message("Updating user data.");
                    userData = request
                        .UserData
                        .ToServiceObject(
                            loginToken: null)
                        .With(
                            status: Option.Some(UserStatus.Active));
                    userData = await usersService.SaveUserData(userId, userData);

                    var result = new CreateNewUserResponse
                    {
                        RefreshToken = refreshToken,
                        UserData = userData.ToDto(userId),
                    };

                    return result;
                });

        public override Task<LoginWithLoginTokenResponse> LoginWithLoginToken(LoginWithLoginTokenRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("LoginWithLoginToken.");

                    ServiceEventSource.Current.Message("Validating login token.");
                    var loginToken = request.LoginToken;
                    var validationResult = TokenManager.ValidateLoginToken(loginToken);

                    if (!validationResult.IsValid)
                    {
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Invalid login token."));
                    }

                    ServiceEventSource.Current.Message("Getting user data.");
                    var userId = validationResult.UserId;
                    var userType = validationResult.UserType;
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    if (userData.Status != UserStatus.WaitingForActivation && userData.Status != UserStatus.Active)
                    {
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' has a status of '{userData.Status}'. They must be waiting for activation or already active."));
                    }

                    if (userData.LoginToken != loginToken)
                    {
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"Provided login token does not match against the data for user '{userId}'."));
                    }

                    ServiceEventSource.Current.Message("Generating refresh token.");
                    var refreshToken = TokenManager.GenerateRefreshToken(userId, userType);

                    ServiceEventSource.Current.Message("Updating user session.");
                    var userSession = await usersService.GetUserSession(refreshToken);

                    userSession = userSession.With(
                        refreshToken: Option.Some(refreshToken));

                    await usersService.SaveUserSession(userSession);

                    ServiceEventSource.Current.Message("Saving user data.");
                    userData = userData.With(
                        loginToken: Option.Some<string>(null));
                    await usersService.SaveUserData(userId, userData);

                    var result = new LoginWithLoginTokenResponse
                    {
                        RefreshToken = refreshToken,
                        UserData = userData.ToDto(userId),
                    };

                    return result;
                });

        public override Task<LoginWithRefreshTokenResponse> LoginWithRefreshToken(LoginWithRefreshTokenRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("LoginWithRefreshToken.");

                    ServiceEventSource.Current.Message("Validating refresh token.");
                    var refreshToken = request.RefreshToken;
                    var validationResult = TokenManager.ValidateRefreshToken(refreshToken);

                    if (!validationResult.IsValid)
                    {
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Invalid refresh token."));
                    }

                    ServiceEventSource.Current.Message("Retrieving user data.");
                    var userId = validationResult.UserId;
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    ServiceEventSource.Current.Message("Validating user session.");
                    var userSession = usersService.GetUserSession(refreshToken);

                    if (userSession == null)
                    {
                        throw new RpcException(new Status(StatusCode.PermissionDenied, $"Refresh token is not associated with a valid session for user '{userId}'."));
                    }

                    ServiceEventSource.Current.Message("Generating access token.");
                    var accessToken = TokenManager.GenerateAccessToken(userId, userData.Type.ToString());

                    var result = new LoginWithRefreshTokenResponse
                    {
                        AccessToken = accessToken,
                        UserData = userData.ToDto(userId),
                    };

                    return result;
                });

        public override Task<GetAccessTokenResponse> GetAccessToken(GetAccessTokenRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("GetAccessToken.");

                    var refreshTokenValidationResult = TokenManager.ValidateRefreshToken(request.RefreshToken);

                    if (!refreshTokenValidationResult.IsValid)
                    {
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Invalid refresh token."));
                    }

                    var userId = refreshTokenValidationResult.UserId;
                    var userType = refreshTokenValidationResult.UserType;

                    ServiceEventSource.Current.Message("Validating refresh token.");
                    var usersService = GetUsersService();
                    var userSession = await usersService.GetUserSession(request.RefreshToken);

                    if (userSession == null)
                    {
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Session not found for user '{userId}' with the specified refresh token."));
                    }

                    ServiceEventSource.Current.Message("Generating access token.");
                    var accessToken = TokenManager.GenerateAccessToken(userId, userType);

                    var result = new GetAccessTokenResponse
                    {
                        AccessToken = accessToken,
                    };

                    return result;
                });

        public override Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("GetUser.");

                    ServiceEventSource.Current.Message("Getting user data.");
                    var usersService = GetUsersService();
                    var userId = request.UserId;
                    var userData = await usersService.GetUserData(userId);

                    return new GetUserResponse
                    {
                        UserData = userData.ToDto(request.UserId),
                    };
                });

        public override Task<UpdateUserResponse> UpdateUser(UpdateUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("UpdateUser.");

                    ServiceEventSource.Current.Message("Validating authenticated user matches request.");
                    var authenticatedUserId = context.GetAuthenticatedUserId();

                    if (authenticatedUserId != request.User.Email)
                    {
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Attempted to update data for another user."));
                    }

                    ServiceEventSource.Current.Message("Getting existing user data.");
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(authenticatedUserId);

                    ServiceEventSource.Current.Message("Saving user data.");
                    var result = await usersService.SaveUserData(authenticatedUserId, request.User.ToServiceObject(userData.LoginToken));

                    var response = new UpdateUserResponse
                    {
                        User = result.ToDto(authenticatedUserId),
                    };

                    return response;
                });

        public override Task<Empty> Logout(LogoutRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Current.Message("Logout.");

                    ServiceEventSource.Current.Message("Invalidating refresh token.");
                    var usersService = GetUsersService();
                    await usersService.InvalidateUserSession(request.RefreshToken);

                    return Empty.Instance;
                });

        private static IUsersService GetUsersService() =>
            ServiceProxy.Create<IUsersService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Users"));

        private static IInvitationCodesService GetInvitationCodesService() =>
            ServiceProxy.Create<IInvitationCodesService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/InvitationCodes"));
    }
}
