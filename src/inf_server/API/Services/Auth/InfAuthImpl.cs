using System;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using AutoMapper;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Serilog;
using Users.Interfaces;
using Utility;
using Utility.Tokens;
using static API.Interfaces.InfAuth;
using static InvitationCodes.Interfaces.InvitationCodeService;
using static Users.Interfaces.UsersService;

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
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    await SendLoginEmailImpl(
                            logger,
                            request,
                            usersService,
                            new SendGridEmailService(),
                            context.CancellationToken)
                        .ContinueOnAnyContext();
                    return Empty.Instance;
                });

        internal async Task SendLoginEmailImpl(
            ILogger logger,
            SendLoginEmailRequest request,
            UsersServiceClient usersService,
            IEmailService emailService,
            CancellationToken cancellationToken)
        {
            var email = request.Email;
            var getUserDataResponse = await usersService
                .GetUserDataByEmailAsync(new GetUserDataByEmailRequest { Email = email });
            var userData = getUserDataResponse.UserData;
            var userType = Mapper.Map<UserData.Types.Type>(request.UserType);
            var userStatus = UserData.Types.Status.WaitingForActivation;
            var userShouldAlreadyBeActive = userType == UserData.Types.Type.Unknown;

            if (!userShouldAlreadyBeActive && string.IsNullOrEmpty(request.InvitationCode))
            {
                logger.Warning("No invitation code was provided and user is not yet active - unable to send email");
                throw new RpcException(new Status(StatusCode.FailedPrecondition, "No invitation code was provided."));
            }

            if (userShouldAlreadyBeActive)
            {
                if (userData == null || userData.Status != UserData.Types.Status.Active)
                {
                    logger.Warning("User with email {Email} should already be active, but their status is {UserStatus}", email, userData?.Status);

                    // Help mitigate "timing" attacks.
                    await Task
                        .Delay(random.Next(100, 1000))
                        .ContinueOnAnyContext();

                    return;
                }

                userType = userData.Type;
                userStatus = userData.Status;
                logger.Debug("User with email {Email} was found, and they are of type {UserType}, status {UserStatus}", email, userType, userStatus);
            }
            else
            {
                if (userData != null && userData.Status != UserData.Types.Status.WaitingForActivation)
                {
                    logger.Warning("User with email {Email} should either not exist, or be awaiting activation, but they do exist with a status of {UserStatus}", email, userData.Status);

                    // Help mitigate "timing" attacks.
                    await Task
                        .Delay(random.Next(100, 1000))
                        .ContinueOnAnyContext();

                    return;
                }
            }

            if (userData == null)
            {
                logger.Debug("No data found for user with email {Email}, so creating it", email);
                userData = new UserData();
            }

            // Initial save is to ensure user is allocated an ID, which we need in the login token.
            userData.Email = email;
            userData.Type = userType;
            userData.Status = userStatus;
            logger.Debug("Saving data for user with email {Email}: {@UserData}", email, userData);
            var saveUserDataResponse = await usersService
                .SaveUserDataAsync(new SaveUserDataRequest { UserData = userData });
            userData = saveUserDataResponse.UserData;
            var userId = userData.Id;

            logger.Debug("Generating login token for user {UserId}, email {Email}, status {UserStatus}, invitation code {InvitationCode}", userId, email, userType, request.InvitationCode);
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                email,
                userStatus.ToString(),
                userType.ToString(),
                request.InvitationCode);

            // Now we can save the user again, this time with an associated login token.
            userData.LoginToken = loginToken;
            logger.Debug("Saving data for user {UserId}: {@UserData}", userId, userData);
            saveUserDataResponse = await usersService
                .SaveUserDataAsync(new SaveUserDataRequest { UserData = userData });
            userData = saveUserDataResponse.UserData;

            var link = $"https://www.swaymarketplace.com/app/verify?token={loginToken}";
            logger.Debug("Sending verification email for user {UserId} with link {Link}", userId, link);
            await emailService
                .SendVerificationEmail(
                    email,
                    userData.Name ?? email,
                    link,
                    cancellationToken)
                .ContinueOnAnyContext();
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

                    if (userId != request.UserData.Id.ValueOr(userId))
                    {
                        logger.Warning("Login token's user ID, {TokenUserId}, differs from the user ID in the request, {RequestUserId}", userId, request.UserData.Id);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "The login token's user ID differs from that in the request data."));
                    }

                    logger.Debug("Validating status of user {UserId}", userId);
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserDataResponse = await usersService
                        .GetUserDataAsync(new GetUserDataRequest { Id = userId });
                    var userData = getUserDataResponse.UserData;

                    if (userData.Status != UserData.Types.Status.WaitingForActivation)
                    {
                        logger.Warning("User {UserId} has status {UserStatus}, so they can not be created", userId, userData.Status);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' is not awaiting activation."));
                    }

                    var invitationCode = loginTokenValidationResults.InvitationCode;
                    logger.Debug("Honoring invitation code {InvitationCode} for user {UserId}", invitationCode, userId);
                    var invitationCodesService = await GetInvitationCodeServiceClient().ContinueOnAnyContext();
                    var honorResult = await invitationCodesService
                        .HonorAsync(new HonorRequest { Code = invitationCode });

                    if (honorResult.Result != HonorResponse.Types.HonorResult.Success)
                    {
                        logger.Warning("Could not honor invitation code {InvitationCode}. The result was {HonorResult}", invitationCode, honorResult);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Could not honor invitation code."));
                    }

                    var userType = loginTokenValidationResults.UserType;
                    logger.Debug("Generating refresh token for user {UserId}, type {UserType}", userId, userType);
                    var refreshToken = TokenManager.GenerateRefreshToken(userId, userType);

                    logger.Debug("Saving session for user {UserId} with refresh token {RefreshToken}, device ID {DeviceId}", userId, refreshToken, request.DeviceId);
                    var userSession = new UserSession
                    {
                        RefreshToken = refreshToken,
                        DeviceId = request.DeviceId,
                    };
                    await usersService
                        .SaveUserSessionAsync(new SaveUserSessionRequest { UserSession = userSession });

                    userData = Mapper.Map<UserData>(request.UserData);
                    userData.Status = UserData.Types.Status.Active;
                    logger.Debug("Updating data for user {UserId} to {@UserData}", userId, userData);
                    var saveUserDataResponse = await usersService
                        .SaveUserDataAsync(new SaveUserDataRequest { UserData = userData });
                    userData = saveUserDataResponse.UserData;

                    var result = new CreateNewUserResponse
                    {
                        RefreshToken = refreshToken,
                        UserData = Mapper.Map<UserDto>(userData),
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
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserDataResponse = await usersService
                        .GetUserDataAsync(new GetUserDataRequest { Id = userId });
                    var userData = getUserDataResponse.UserData;

                    if (userData.Status != UserData.Types.Status.WaitingForActivation && userData.Status != UserData.Types.Status.Active)
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
                    var getUserSessionResponse = await usersService
                        .GetUserSessionAsync(new GetUserSessionRequest { RefreshToken = refreshToken });
                    var userSession = getUserSessionResponse.UserSession;

                    if (userSession == null)
                    {
                        logger.Debug("No existing session found for user {UserId} - creating a new one", userId);
                        userSession = new UserSession();
                    }

                    userSession.RefreshToken = refreshToken;

                    logger.Debug("Updating user session for user {UserId} to {@UserSession}", userId, userSession);
                    await usersService
                        .SaveUserSessionAsync(new SaveUserSessionRequest { UserSession = userSession });

                    userData.LoginToken = "";
                    logger.Debug("Saving data for user {UserId}: {@UserData}", userId, userData);
                    var saveUserDataResponse = await usersService
                        .SaveUserDataAsync(new SaveUserDataRequest { UserData = userData });
                    userData = saveUserDataResponse.UserData;

                    var result = new LoginWithLoginTokenResponse
                    {
                        RefreshToken = refreshToken,
                        UserData = Mapper.Map<UserDto>(userData),
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
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserDataResponse = await usersService
                        .GetUserDataAsync(new GetUserDataRequest { Id = userId });
                    var userData = getUserDataResponse.UserData;

                    logger.Debug("Validating session for user {UserId}", userId);
                    var getUserSessionResponse = await usersService.GetUserSessionAsync(new GetUserSessionRequest { RefreshToken = refreshToken });
                    var userSession = getUserSessionResponse.UserSession;

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
                        UserData = Mapper.Map<UserDto>(userData),
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
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserSessionResponse = await usersService
                        .GetUserSessionAsync(new GetUserSessionRequest { RefreshToken = refreshToken });
                    var userSession = getUserSessionResponse.UserSession;

                    if (userSession == null)
                    {
                        logger.Warning("No session found for user {UserId} with refresh token {RefreshToken} - unable to get access token", userId, refreshToken);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"Session not found for user '{userId}' with the specified refresh token."));
                    }

                    logger.Debug("Generating access token for user {UserId}, type {UserType}", userId, userType);
                    var accessToken = TokenManager.GenerateAccessToken(userId, userType);

                    var result = new GetAccessTokenResponse
                    {
                        AccessToken = accessToken,
                    };

                    return result;
                });

        public override Task<Empty> Logout(LogoutRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var refreshToken = request.RefreshToken;
                    logger.Debug("Invalidating refresh token {RefreshToken}", refreshToken);
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    await usersService
                        .InvalidateUserSessionAsync(new InvalidateUserSessionRequest { RefreshToken = refreshToken });

                    return Empty.Instance;
                });

        private static Task<UsersServiceClient> GetUsersServiceClient() =>
            APIClientResolver.Resolve<UsersServiceClient>("Users");

        private static Task<InvitationCodeServiceClient> GetInvitationCodeServiceClient() =>
            APIClientResolver.Resolve<InvitationCodeServiceClient>("InvitationCodes");
    }
}
