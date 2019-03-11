using System;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Serilog;
using Users.Interfaces;
using Utility;
using Utility.gRPC;
using Utility.Tokens;
using static API.Interfaces.InfAuth;
using static InvitationCodes.Interfaces.InvitationCodeService;
using static Users.Interfaces.UsersService;
using service = Users.Interfaces;

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
            var getUserResponse = await usersService
                .GetUserByEmailAsync(new GetUserByEmailRequest { Email = email });
            var user = getUserResponse.User;

            logger.Debug("Resolved user with email {Email}: {@User}", email, user);

            var userType = request.UserType.ToUserType();
            var userStatus = UserStatus.WaitingForActivation;
            var userShouldAlreadyBeActive = userType == service.UserType.Unknown;

            if (!userShouldAlreadyBeActive && string.IsNullOrEmpty(request.InvitationCode))
            {
                logger.Warning("No invitation code was provided and user is not yet active - unable to send email");
                throw new RpcException(new Status(StatusCode.FailedPrecondition, "No invitation code was provided."));
            }

            if (userShouldAlreadyBeActive)
            {
                if (user == null || user.Status != UserStatus.Active)
                {
                    logger.Warning("User with email {Email} should already be active, but their status is {UserStatus}", email, user?.Status);

                    // Help mitigate "timing" attacks.
                    await Task
                        .Delay(random.Next(100, 1000))
                        .ContinueOnAnyContext();

                    return;
                }

                userType = user.Type;
                userStatus = user.Status;
                logger.Debug("User with email {Email} was found, and they are of type {UserType}, status {UserStatus}", email, userType, userStatus);
            }
            else
            {
                if (user != null && user.Status != UserStatus.WaitingForActivation)
                {
                    logger.Warning("User with email {Email} should either not exist, or be awaiting activation, but they do exist with a status of {UserStatus}", email, user.Status);

                    // Help mitigate "timing" attacks.
                    await Task
                        .Delay(random.Next(100, 1000))
                        .ContinueOnAnyContext();

                    return;
                }
            }

            if (user == null)
            {
                logger.Debug("No user with email {Email} was found, so creating one", email);
                user = new User();
            }

            // Initial save is to ensure user is allocated an ID, which we need in the login token.
            user.Email = email;
            user.Type = userType;
            user.Status = userStatus;
            logger.Debug("Saving user with email {Email}: {@User}", email, user);
            var saveUserResponse = await usersService
                .SaveUserAsync(new SaveUserRequest { User = user });
            user = saveUserResponse.User;
            var userId = user.Id;

            logger.Debug("Generating login token for user {UserId}, email {Email}, status {UserStatus}, invitation code {InvitationCode}", userId, email, userType, request.InvitationCode);
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                email,
                userStatus.ToString(),
                userType.ToString(),
                request.InvitationCode);

            // Now we can save the user again, this time with an associated login token.
            user.LoginToken = loginToken;
            logger.Debug("Saving user {UserId}: {@User}", userId, user);
            saveUserResponse = await usersService
                .SaveUserAsync(new SaveUserRequest { User = user });
            user = saveUserResponse.User;

            var link = $"https://www.swaymarketplace.com/app/verify?token={loginToken}";
            logger.Debug("Sending verification email for user {UserId} with link {Link}", userId, link);

            try
            {
                await emailService
                    .SendVerificationEmail(
                        email,
                        user.Name ?? email,
                        link,
                        !userShouldAlreadyBeActive,
                        cancellationToken)
                    .ContinueOnAnyContext();
            }
            catch (Exception ex)
            {
                logger.Warning(ex, "Failed to send verification email for user {UserId}", userId);
                throw new RpcException(new Status(StatusCode.Unavailable, "Email failed to send."));
            }
        }

        public override Task<ActivateUserResponse> ActivateUser(ActivateUserRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = context.GetAuthenticatedUserId();

                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserResponse = await usersService
                        .GetUserAsync(new service.GetUserRequest { Id = userId });
                    var user = getUserResponse.User;

                    if (user == null)
                    {
                        logger.Warning("No user could be found with ID {UserId}", userId);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "User not found."));
                    }

                    if (userId != request.User.Id.ValueOr(userId))
                    {
                        logger.Warning("The authenticated user ID is {UserId}. However, the user ID in the request data is {RequestUserId}, which does not match", userId, request.User.Id);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Mismatch between the authenticated user ID and the user ID in the request data."));
                    }

                    logger.Debug("Validating status of user {UserId}", userId);

                    if (user.Status != UserStatus.WaitingForActivation)
                    {
                        logger.Warning("User {UserId} has status {UserStatus}, so they cannot be activated", userId, user.Status);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' is not awaiting activation."));
                    }

                    var loginTokenValidationResults = TokenManager.ValidateLoginToken(request.LoginToken);

                    if (!loginTokenValidationResults.IsValid)
                    {
                        logger.Warning("The provided login token {LoginToken} is not valid", request.LoginToken);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Login token is not valid."));
                    }

                    if (userId != loginTokenValidationResults.UserId)
                    {
                        logger.Warning("The user ID in the login token {LoginToken} is {TokenUserId}, which does not match the authenticated user's ID of {UserId}", request.LoginToken, loginTokenValidationResults.UserId, userId);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, "Login token is not valid."));
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

                    user = request.User.ToUser();
                    user.Id = userId;
                    user.Status = UserStatus.Active;
                    user.LoginToken = "";
                    logger.Debug("Updating user {UserId} to {@User}", userId, user);
                    var saveUserResponse = await usersService
                        .SaveUserAsync(new SaveUserRequest { User = user });
                    user = saveUserResponse.User;

                    var result = new ActivateUserResponse
                    {
                        User = user.ToUserDto(UserDto.DataOneofCase.Full),
                    };

                    logger.Information("User {UserId} has been activated", userId);

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
                    logger.Debug("Getting user {UserId}", userId);
                    var userType = validationResult.UserType;
                    var userShouldAlreadyBeActive = userType == service.UserType.Unknown.ToString();
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserResponse = await usersService
                        .GetUserAsync(new service.GetUserRequest { Id = userId });
                    var user = getUserResponse.User;

                    if (user == null)
                    {
                        logger.Warning("Refresh token {LoginToken} for user with ID {UserId} has no associated user", loginToken, userId);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, $"Login token is for user with ID '{userId}', but that user was not found."));
                    }

                    if (user.Status != UserStatus.WaitingForActivation && user.Status != UserStatus.Active)
                    {
                        logger.Warning("User {UserId} has status {UserStatus}, so they cannot be logged in with a login token", userId, user.Status);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"User '{userId}' has a status of '{user.Status}'. They must be waiting for activation or already active."));
                    }

                    if (user.LoginToken != loginToken)
                    {
                        logger.Warning("User {UserId} has login token {UserLoginToken} which does not match provided login token {LoginToken}, so they cannot be logged in", userId, user.LoginToken, loginToken);
                        throw new RpcException(new Status(StatusCode.FailedPrecondition, $"Provided login token does not match against the user '{userId}'."));
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

                    if (userShouldAlreadyBeActive)
                    {
                        logger.Debug("User is already active, so clearing their login token");
                        user.LoginToken = "";
                    }

                    logger.Debug("Saving user {UserId}: {@User}", userId, user);
                    var saveUserResponse = await usersService
                        .SaveUserAsync(new SaveUserRequest { User = user });
                    user = saveUserResponse.User;

                    var result = new LoginWithLoginTokenResponse
                    {
                        RefreshToken = refreshToken,
                        User = user.ToUserDto(UserDto.DataOneofCase.Full),
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
                    logger.Debug("Retrieving user {UserId}", userId);
                    var usersService = await GetUsersServiceClient().ContinueOnAnyContext();
                    var getUserResponse = await usersService
                        .GetUserAsync(new service.GetUserRequest { Id = userId });
                    var user = getUserResponse.User;

                    if (user == null)
                    {
                        logger.Warning("Refresh token {RefreshToken} for user with ID {UserId} has no associated user", refreshToken, userId);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, $"Refresh token is for user with ID '{userId}', but that user was not found."));
                    }

                    logger.Debug("Validating session for user {UserId}", userId);
                    var getUserSessionResponse = await usersService.GetUserSessionAsync(new GetUserSessionRequest { RefreshToken = refreshToken });
                    var userSession = getUserSessionResponse.UserSession;

                    if (userSession == null)
                    {
                        logger.Warning("Refresh token {RefreshToken} is not associated with a valid session for user {UserId}, so they could not be logged in", refreshToken, userId);
                        throw new RpcException(new Status(StatusCode.PermissionDenied, $"Refresh token is not associated with a valid session for user '{userId}'."));
                    }

                    var userType = user.Type;
                    logger.Debug("Generating access token for user {UserId}, type {UserType}", userId, userType);
                    var accessToken = TokenManager.GenerateAccessToken(userId, userType.ToString());

                    var result = new LoginWithRefreshTokenResponse
                    {
                        AccessToken = accessToken,
                        User = user.ToUserDto(UserDto.DataOneofCase.Full),
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
