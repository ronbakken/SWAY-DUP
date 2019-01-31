using System;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Optional;
using Serilog;
using Users.Interfaces;
using Utility.Tokens;
using static API.Interfaces.InfAuth;

namespace API.Services.Auth
{
    public sealed class InfAuthImpl : InfAuthBase
    {
        private static readonly Random random = new Random();
        private readonly ILogger logger;

        public InfAuthImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfAuthImpl>();
        }

        public override Task<Empty> SendLoginEmail(SendLoginEmailRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    await SendLoginEmailImpl(
                        logger,
                        request,
                        GetUsersService(),
                        new SendGridEmailService(),
                        context.CancellationToken);
                    return Empty.Instance;
                });

        internal async Task SendLoginEmailImpl(
            ILogger logger,
            SendLoginEmailRequest request,
            IUsersService usersService,
            IEmailService emailService,
            CancellationToken cancellationToken)
        {
            var userId = request.Email;
            var userData = await usersService.GetUserData(userId);
            var userType = request.UserType;
            var userStatus = UserStatus.WaitingForActivation;
            var userShouldAlreadyBeActive = userType == Interfaces.UserType.UnknownUserType;

            if (!userShouldAlreadyBeActive && string.IsNullOrEmpty(request.InvitationCode))
            {
                logger.Warning("No invitation code was provided and user is not yet active - unable to send email");
                throw new RpcException(new Status(StatusCode.FailedPrecondition, "No invitation code was provided."));
            }

            if (userShouldAlreadyBeActive)
            {
                if (userData == null || userData.Status != UserStatus.Active)
                {
                    logger.Warning("User {UserId} should already be active, but their status is {UserStatus}", userId, userData?.Status);

                    // Help mitigate "timing" attacks.
                    await Task.Delay(random.Next(100, 1000));

                    return;
                }

                userType = userData.Type.ToDto();
                userStatus = userData.Status;
                logger.Debug("User {UserId} was found, and they are of type {UserType}, status {UserStatus}", userId, userType, userStatus);
            }
            else
            {
                if (userData != null && userData.Status != UserStatus.WaitingForActivation)
                {
                    logger.Warning("User {UserId} should either not exist, or be awaiting activation, but they do exist with a status of {UserStatus}", userId, userData.Status);

                    // Help mitigate "timing" attacks.
                    await Task.Delay(random.Next(100, 1000));

                    return;
                }

                userData = UserData.Initial;
            }

            logger.Debug("Generating login token for {UserId}, status {UserStatus}, invitation code {InvitationCode}", userId, userType, request.InvitationCode);
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                userStatus.ToString(),
                userType.ToString(),
                request.InvitationCode);

            userData = userData
                .With(
                    type: Option.Some(userType.ToServiceObject()),
                    status: Option.Some(userStatus),
                    loginToken: Option.Some(loginToken));
            logger.Debug("Saving data for user {UserId}: {@UserData}", userId, userData);
            await usersService.SaveUserData(userId, userData);

            var link = $"https://www.swaymarketplace.com/app/verify?token={loginToken}";
            logger.Debug("Sending verification email for user {UserId} with link {Link}", userId, link);
            await emailService.SendVerificationEmail(
                userId,
                userData.Name ?? userId,
                link,
                cancellationToken);
        }

        public override Task<CreateNewUserResponse> CreateNewUser(CreateNewUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var loginToken = request.LoginToken;
                    logger.Debug("Validating login token {LoginToken}", loginToken);
                    var loginTokenValidationResults = TokenManager.ValidateLoginToken(loginToken);

                    if (!loginTokenValidationResults.IsValid)
                    {
                        logger.Warning("Login token {LoginToken} is invalid", loginToken);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Invalid login token."));
                    }

                    var userId = loginTokenValidationResults.UserId;
                    logger.Debug("Validating status of user {UserId}", userId);
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    if (userData.Status != UserStatus.WaitingForActivation)
                    {
                        logger.Warning("User {UserId} has status {UserStatus}, so they can not be created", userId, userData.Status);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' is not awaiting activation."));
                    }

                    var invitationCode = loginTokenValidationResults.InvitationCode;
                    logger.Debug("Honoring invitation code {InvitationCode} for user {UserId}", invitationCode, userId);
                    var invitationCodesService = GetInvitationCodesService();
                    var honorResult = await invitationCodesService.Honor(invitationCode);

                    if (honorResult != InvitationCodeHonorResult.Success)
                    {
                        logger.Warning("Could not honor invitation code {InvitationCode}. The result was {HonorResult}", invitationCode, honorResult);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Could not honor invitation code."));
                    }

                    var userType = loginTokenValidationResults.UserType;
                    logger.Debug("Generating refresh token for user {UserId}, type {UserType}", userId, userType);
                    var refreshToken = TokenManager.GenerateRefreshToken(userId, userType);

                    logger.Debug("Saving session for user {UserId} with refresh token {RefreshToken}, device ID {DeviceId}", userId, refreshToken, request.DeviceId);
                    await usersService.SaveUserSession(new UserSession(refreshToken, request.DeviceId));

                    userData = request
                        .UserData
                        .ToServiceObject(
                            loginToken: null)
                        .With(
                            status: Option.Some(UserStatus.Active));
                    logger.Debug("Updating data for user {UserId} to {@UserData}", userId, userData);
                    userData = await usersService.SaveUserData(userId, userData);

                    var result = new CreateNewUserResponse
                    {
                        RefreshToken = refreshToken,
                        UserData = userData.ToDto(),
                    };

                    return result;
                });

        public override Task<LoginWithLoginTokenResponse> LoginWithLoginToken(LoginWithLoginTokenRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var loginToken = request.LoginToken;
                    logger.Debug("Validating login token {LoginToken}", loginToken);
                    var validationResult = TokenManager.ValidateLoginToken(loginToken);

                    if (!validationResult.IsValid)
                    {
                        logger.Warning("Login token {LoginToken} is invalid", loginToken);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Invalid login token."));
                    }

                    var userId = validationResult.UserId;
                    logger.Debug("Getting data for user {UserId}", userId);
                    var userType = validationResult.UserType;
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    if (userData.Status != UserStatus.WaitingForActivation && userData.Status != UserStatus.Active)
                    {
                        logger.Warning("User {UserId} has status {UserStatus}, so they cannot be logged in with a login token", userId, userData.Status);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' has a status of '{userData.Status}'. They must be waiting for activation or already active."));
                    }

                    if (userData.LoginToken != loginToken)
                    {
                        logger.Warning("User {UserId} has login token {UserLoginToken} which does not match provided login token {LoginToken}, so they cannot be logged in", userId, userData.LoginToken, loginToken);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"Provided login token does not match against the data for user '{userId}'."));
                    }

                    logger.Debug("Generating refresh token for user {UserId}, type {UserType}", userId, userType);
                    var refreshToken = TokenManager.GenerateRefreshToken(userId, userType);

                    logger.Debug("Updating session for user {UserId}", userId);
                    var userSession = await usersService.GetUserSession(refreshToken);

                    if (userSession == null)
                    {
                        logger.Debug("No existing session found for user {UserId} - creating a new one", userId);
                        userSession = new UserSession(refreshToken, null);
                    }

                    userSession = userSession.With(
                        refreshToken: Option.Some(refreshToken));

                    logger.Debug("Updating user session for user {UserId} to {@UserSession}", userId, userSession);
                    await usersService.SaveUserSession(userSession);

                    userData = userData.With(
                        loginToken: Option.Some<string>(null));
                    logger.Debug("Saving data for user {UserId}: {@UserData}", userId, userData);
                    await usersService.SaveUserData(userId, userData);

                    var result = new LoginWithLoginTokenResponse
                    {
                        RefreshToken = refreshToken,
                        UserData = userData.ToDto(),
                    };

                    return result;
                });

        public override Task<LoginWithRefreshTokenResponse> LoginWithRefreshToken(LoginWithRefreshTokenRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var refreshToken = request.RefreshToken;
                    logger.Debug("Validating refresh token {RefreshToken}", refreshToken);
                    var validationResult = TokenManager.ValidateRefreshToken(refreshToken);

                    if (!validationResult.IsValid)
                    {
                        logger.Warning("Refresh token {RefreshToken} is invalid", refreshToken);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Invalid refresh token."));
                    }

                    var userId = validationResult.UserId;
                    logger.Debug("Retrieving data for user {UserId}", userId);
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);

                    logger.Debug("Validating session for user {UserId}", userId);
                    var userSession = usersService.GetUserSession(refreshToken);

                    if (userSession == null)
                    {
                        logger.Warning("Refresh token {RefreshToken} is not associated with a valid session for user {UserId}, so they could not be logged in", refreshToken, userId);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, $"Refresh token is not associated with a valid session for user '{userId}'."));
                    }

                    var userType = userData.Type;
                    logger.Debug("Generating access token for user {UserId}, type {UserType}", userId, userType);
                    var accessToken = TokenManager.GenerateAccessToken(userId, userType.ToString());

                    var result = new LoginWithRefreshTokenResponse
                    {
                        AccessToken = accessToken,
                        UserData = userData.ToDto(),
                    };

                    return result;
                });

        public override Task<GetAccessTokenResponse> GetAccessToken(GetAccessTokenRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var refreshToken = request.RefreshToken;
                    logger.Debug("Validating refresh token {RefreshToken}", refreshToken);
                    var refreshTokenValidationResult = TokenManager.ValidateRefreshToken(refreshToken);

                    if (!refreshTokenValidationResult.IsValid)
                    {
                        logger.Warning("Refresh token {RefreshToken} is invalid", refreshToken);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Invalid refresh token."));
                    }

                    var userId = refreshTokenValidationResult.UserId;
                    var userType = refreshTokenValidationResult.UserType;

                    logger.Debug("Validating session for user {UserId} using refresh token {RefreshToken}", userId, refreshToken);
                    var usersService = GetUsersService();
                    var userSession = await usersService.GetUserSession(refreshToken);

                    if (userSession == null)
                    {
                        logger.Warning("No session found for user {UserId} with refresh token {RefreshToken} - unable to get access token", userId, refreshToken);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Session not found for user '{userId}' with the specified refresh token."));
                    }

                    logger.Debug("Generating access token for user {UserId}, type {UserType}", userId, userType);
                    var accessToken = TokenManager.GenerateAccessToken(userId, userType);

                    var result = new GetAccessTokenResponse
                    {
                        AccessToken = accessToken,
                    };

                    return result;
                });

        public override Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = request.UserId;
                    logger.Debug("Getting data for user {UserId}", userId);
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(userId);
                    logger.Debug("Retrieved data for user {UserId}: {@UserData}", userId, userData);

                    return new GetUserResponse
                    {
                        UserData = userData.ToDto(),
                    };
                });

        public override Task<UpdateUserResponse> UpdateUser(UpdateUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var authenticatedUserId = context.GetAuthenticatedUserId();
                    logger.Debug("Validating authenticated user {UserId} matches user ID in request", authenticatedUserId);

                    if (authenticatedUserId != request.User.Email)
                    {
                        logger.Warning("Authenticated user {UserId} does not match user ID in request {RequestUserId} - unable to update user", authenticatedUserId, request.User.Email);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, "Attempted to update data for another user."));
                    }

                    logger.Debug("Getting data for user {UserId}", authenticatedUserId);
                    var usersService = GetUsersService();
                    var userData = await usersService.GetUserData(authenticatedUserId);

                    var updatedUserData = request
                        .User
                        .ToServiceObject(userData.LoginToken);
                    logger.Debug("Saving data for user {UserId}: {@UserData}", authenticatedUserId, updatedUserData);
                    var result = await usersService.SaveUserData(authenticatedUserId, updatedUserData);

                    var response = new UpdateUserResponse
                    {
                        User = result.ToDto(),
                    };

                    return response;
                });

        public override Task<Empty> Logout(LogoutRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var refreshToken = request.RefreshToken;
                    logger.Debug("Invalidating refresh token {RefreshToken}", refreshToken);
                    var usersService = GetUsersService();
                    await usersService.InvalidateUserSession(refreshToken);

                    return Empty.Instance;
                });

        private static IUsersService GetUsersService() =>
            ServiceProxy.Create<IUsersService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Users"));

        private static IInvitationCodesService GetInvitationCodesService() =>
            ServiceProxy.Create<IInvitationCodesService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/InvitationCodes"));
    }
}
