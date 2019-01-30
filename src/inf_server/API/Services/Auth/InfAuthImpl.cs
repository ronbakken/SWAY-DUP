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
            ServiceEventSource.Instance.Info("SendLoginEmail.");

            var userId = request.Email;
            var userData = await usersService.GetUserData(userId);
            var userType = request.UserType;
            var userShouldAlreadyExist = userType == Interfaces.UserType.UnknownUserType;

            if (userShouldAlreadyExist)
            {
                if (userData == null)
                {
                    ServiceEventSource.Instance.Warn("User '{0}' should already exist, but no data was found for them.", userId);
                    return;
                }

                userType = userData.Type.ToDto();
                ServiceEventSource.Instance.Info("User '{0}' was found, and they are of type '{1}'.", userId, userType);
            }
            else
            {
                if (userData != null)
                {
                    ServiceEventSource.Instance.Warn("User '{0}' should not exist, but data was found for them.", userId);
                    return;
                }

                userData = UserData.Initial;
            }

            ServiceEventSource.Instance.Info("Generating login token.");
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                UserStatus.WaitingForActivation.ToString(),
                userType.ToString());

            ServiceEventSource.Instance.Info("Saving user data.");
            userData = userData
                .With(
                    type: Option.Some(userType.ToServiceObject()),
                    status: Option.Some(UserStatus.WaitingForActivation),
                    loginToken: Option.Some(loginToken));
            await usersService.SaveUserData(userId, userData);

            ServiceEventSource.Instance.Info("Sending verification email.");
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
                    ServiceEventSource.Instance.Info("CreateNewUser.");

                    ServiceEventSource.Instance.Info("Honoring invitation code.");
                    var invitationCodeManager = GetInvitationCodesService();
                    var honorResult = await invitationCodeManager.Honor(request.InvitationCode);

                    if (honorResult != InvitationCodeHonorResult.Success)
                    {
                        throw new InvalidOperationException("Could not honor invitation code.");
                    }

                    ServiceEventSource.Instance.Info("Validating login token.");
                    var loginTokenValidationResults = TokenManager.ValidateLoginToken(request.LoginToken);

                    ServiceEventSource.Instance.Info("Validating user status.");
                    var userId = loginTokenValidationResults.UserId;
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    if (userData.Status != UserStatus.WaitingForActivation)
                    {
                        throw new InvalidOperationException("User is not awaiting activation.");
                    }

                    ServiceEventSource.Instance.Info("Generating refresh token.");
                    var refreshToken = TokenManager.GenerateRefreshToken(loginTokenValidationResults.UserId, loginTokenValidationResults.UserType);

                    ServiceEventSource.Instance.Info("Saving user session.");
                    await usersService.SaveUserSession(new UserSession(refreshToken, request.DeviceId));

                    ServiceEventSource.Instance.Info("Updating user data.");
                    userData = request
                        .UserData
                        .ToServiceObject(
                            loginToken: null)
                        .With(
                            status: Option.Some(UserStatus.Active));
                    await usersService.SaveUserData(userId, userData);

                    var result = new CreateNewUserResponse
                    {
                        RefreshToken = refreshToken,
                    };

                    return result;
                });

        public override Task<LoginWithLoginTokenResponse> LoginWithLoginToken(LoginWithLoginTokenRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                async () =>
                {
                    ServiceEventSource.Instance.Info("LoginWithLoginToken.");

                    ServiceEventSource.Instance.Info("Validating login token.");
                    var loginToken = request.LoginToken;
                    var validationResult = TokenManager.ValidateLoginToken(loginToken);

                    ServiceEventSource.Instance.Info("Getting user data.");
                    var userId = validationResult.UserId;
                    var userType = validationResult.UserType;
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    if (userData.Status != UserStatus.Active)
                    {
                        throw new InvalidOperationException("User is not active.");
                    }

                    if (userData.LoginToken != loginToken)
                    {
                        ServiceEventSource.Instance.Info("Provided login token does not match against the user's data.");
                        throw new InvalidOperationException();
                    }

                    ServiceEventSource.Instance.Info("Generating refresh token.");
                    var refreshToken = TokenManager.GenerateRefreshToken(userId, userType);

                    ServiceEventSource.Instance.Info("Updating user session.");
                    var userSession = await usersService.GetUserSession(refreshToken);

                    userSession = userSession.With(
                        refreshToken: Option.Some(refreshToken));

                    await usersService.SaveUserSession(userSession);

                    ServiceEventSource.Instance.Info("Saving user data.");
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
                    ServiceEventSource.Instance.Info("LoginWithRefreshToken.");

                    ServiceEventSource.Instance.Info("Validating refresh token.");
                    var refreshToken = request.RefreshToken;
                    var validationResult = TokenManager.ValidateRefreshToken(refreshToken);

                    ServiceEventSource.Instance.Info("Retrieving user data.");
                    var userId = validationResult.UserId;
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    ServiceEventSource.Instance.Info("Validating refresh token.");
                    var userSession = usersService.GetUserSession(refreshToken);

                    if (userSession == null)
                    {
                        throw new InvalidOperationException("Refresh token is invalid.");
                    }

                    ServiceEventSource.Instance.Info("Generating access token.");
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
                    ServiceEventSource.Instance.Info("GetAccessToken.");

                    ServiceEventSource.Instance.Info("Validating refresh token.");
                    var refreshTokenValidationResult = TokenManager.ValidateRefreshToken(request.RefreshToken);
                    var userId = refreshTokenValidationResult.UserId;
                    var userType = refreshTokenValidationResult.UserType;
                    var usersService = GetUsersService();
                    var userSession = await usersService.GetUserSession(request.RefreshToken);

                    if (userSession == null)
                    {
                        throw new InvalidOperationException("Mismatch in refresh token association.");
                    }

                    ServiceEventSource.Instance.Info("Generating access token.");
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
                    ServiceEventSource.Instance.Info("GetUser.");

                    ServiceEventSource.Instance.Info("Getting user data.");
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
                    ServiceEventSource.Instance.Info("UpdateUser.");

                    ServiceEventSource.Instance.Info("Validating authenticated user matches request.");
                    var authenticatedUserId = context.GetAuthenticatedUserId();

                    if (authenticatedUserId != request.User.Email)
                    {
                        throw new InvalidOperationException("Attempted to update data for another user.");
                    }

                    ServiceEventSource.Instance.Info("Getting existing user data.");
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(authenticatedUserId);

                    ServiceEventSource.Instance.Info("Saving user data.");
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
                    ServiceEventSource.Instance.Info("Logout.");

                    ServiceEventSource.Instance.Info("Invalidating refresh token.");
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
