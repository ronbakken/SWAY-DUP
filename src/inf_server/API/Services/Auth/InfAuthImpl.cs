using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodes.Interfaces;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Optional;
using SendGrid;
using SendGrid.Helpers.Mail;
using Users.Interfaces;
using Utility;
using static API.Interfaces.InfAuth;

namespace API.Services.Auth
{
    public sealed class InfAuthImpl : InfAuthBase
    {
        public override async Task<Empty> SendLoginEmail(SendLoginEmailRequest request, ServerCallContext context)
        {
            await SendLoginEmailImpl(
                request,
                GetUsersService(),
                new SendGridEmailService(),
                context.CancellationToken);
            return Empty.Instance;
        }

        internal async Task SendLoginEmailImpl(
            SendLoginEmailRequest request,
            IUsersService usersService,
            IEmailService emailService,
            CancellationToken cancellationToken)
        {
            Log("SendLoginEmail.");

            Log("Generating login token.");
            var userId = request.Email;
            var userType = request.UserType;
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                UserStatus.WaitingForActivation.ToString(),
                userType.ToString());

            Log("Saving user data.");
            var userData = new UserData(
                Users.Interfaces.UserType.Unknown,
                UserStatus.WaitingForActivation,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                default,
                loginToken);
            await usersService.SaveUserData(userId, userData);

            Log("Sending verification email.");
            var link = $"https://infmarketplace.com/app/verify?token={loginToken}";
            await emailService.SendVerificationEmail(
                userId,
                userData.Name ?? userId,
                link,
                cancellationToken);
        }

        public override async Task<CreateNewUserResponse> CreateNewUser(CreateNewUserRequest request, ServerCallContext context)
        {
            Log("CreateNewUser.");

            Log("Honoring invitation code.");
            var invitationCodeManager = GetInvitationCodesService();
            var honorResult = await invitationCodeManager.Honor(request.InvitationCode);

            if (honorResult != InvitationCodeHonorResult.Success)
            {
                throw new InvalidOperationException("Could not honor invitation code.");
            }

            Log("Validating login token.");
            var loginTokenValidationResults = TokenManager.ValidateLoginToken(request.LoginToken);

            Log("Validating user status.");
            var userId = loginTokenValidationResults.UserId;
            var usersService = GetUsersService();
            var userData = await usersService.GetUserData(userId);

            if (userData.Status != UserStatus.WaitingForActivation)
            {
                throw new InvalidOperationException("User is not awaiting activation.");
            }

            Log("Generating refresh token.");
            var refreshToken = TokenManager.GenerateRefreshToken(loginTokenValidationResults.UserId, loginTokenValidationResults.UserType);

            Log("Saving user session.");
            await usersService.SaveUserSession(new UserSession(refreshToken, request.DeviceId));

            Log("Updating user data.");
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
        }

        public override async Task<LoginWithLoginTokenResponse> LoginWithLoginToken(LoginWithLoginTokenRequest request, ServerCallContext context)
        {
            Log("LoginWithLoginToken.");

            Log("Validating login token.");
            var loginToken = request.LoginToken;
            var validationResult = TokenManager.ValidateLoginToken(loginToken);

            Log("Getting user data.");
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
                Log("Provided login token does not match against the user's data.");
                throw new InvalidOperationException();
            }

            Log("Generating refresh token.");
            var refreshToken = TokenManager.GenerateRefreshToken(userId, userType);

            Log("Updating user session.");
            var userSession = await usersService.GetUserSession(refreshToken);

            userSession = userSession.With(
                refreshToken: Option.Some(refreshToken));

            await usersService.SaveUserSession(userSession);

            Log("Saving user data.");
            userData = userData.With(
                loginToken: Option.Some<string>(null));
            await usersService.SaveUserData(userId, userData);

            var result = new LoginWithLoginTokenResponse
            {
                RefreshToken = refreshToken,
                UserData = userData.ToDto(userId),
            };

            return result;
        }

        public override async Task<LoginWithRefreshTokenResponse> LoginWithRefreshToken(LoginWithRefreshTokenRequest request, ServerCallContext context)
        {
            Log("LoginWithRefreshToken.");

            Log("Validating refresh token.");
            var refreshToken = request.RefreshToken;
            var validationResult = TokenManager.ValidateRefreshToken(refreshToken);

            Log("Retrieving user data.");
            var userId = validationResult.UserId;
            var usersService = GetUsersService();
            var userData = await usersService.GetUserData(userId);

            Log("Validating refresh token.");
            var userSession = usersService.GetUserSession(refreshToken);

            if (userSession == null)
            {
                throw new InvalidOperationException("Refresh token is invalid.");
            }

            Log("Generating access token.");
            var accessToken = TokenManager.GenerateAccessToken(userId, userData.Type.ToString());

            var result = new LoginWithRefreshTokenResponse
            {
                AccessToken = accessToken,
                UserData = userData.ToDto(userId),
            };

            return result;
        }

        public override async Task<GetAccessTokenResponse> GetAccessToken(GetAccessTokenRequest request, ServerCallContext context)
        {
            Log("GetAccessToken.");

            Log("Validating refresh token.");
            var refreshTokenValidationResult = TokenManager.ValidateRefreshToken(request.RefreshToken);
            var userId = refreshTokenValidationResult.UserId;
            var userType = refreshTokenValidationResult.UserType;
            var usersService = GetUsersService();
            var userSession = await usersService.GetUserSession(request.RefreshToken);

            if (userSession == null)
            {
                throw new InvalidOperationException("Mismatch in refresh token association.");
            }

            Log("Generating access token.");
            var accessToken = TokenManager.GenerateAccessToken(userId, userType);

            var result = new GetAccessTokenResponse
            {
                AccessToken = accessToken,
            };

            return result;
        }

        public override async Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context)
        {
            Log("GetUser.");

            Log("Getting user data.");
            var usersService = GetUsersService();
            var userId = request.UserId;
            var userData = await usersService.GetUserData(userId);

            return new GetUserResponse
            {
                UserData = userData.ToDto(request.UserId),
            };
        }

        public override async Task<Empty> UpdateUser(UpdateUserRequest request, ServerCallContext context)
        {
            Log("UpdateUser.");

            Log("Validating authenticated user matches request.");
            var authenticatedUserId = context.GetAuthenticatedUserId();

            if (authenticatedUserId != request.User.Email)
            {
                throw new InvalidOperationException("Attempted to update data for another user.");
            }

            Log("Getting existing user data.");
            var usersService = GetUsersService();
            var userData = await usersService.GetUserData(authenticatedUserId);

            Log("Saving user data.");
            await usersService.SaveUserData(authenticatedUserId, request.User.ToServiceObject(userData.LoginToken));

            return Empty.Instance;
        }

        public override async Task<Empty> Logout(LogoutRequest request, ServerCallContext context)
        {
            Log("Logout.");

            Log("Invalidating refresh token.");
            var usersService = GetUsersService();
            await usersService.InvalidateUserSession(request.RefreshToken);

            return Empty.Instance;
        }

        private static async Task SendEmailVerificationEmail(string email, string name, string link, CancellationToken cancellationToken = default)
        {
            // TODO: parameterize these
            var apiKey = "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";
            var templateId = "d-410b5cc2a77e4357a82afede83e92621";
            var emailFromAddress = "donotreply@inf-marketplace-llc.com";
            var emailFromName = "INF Marketplace LLC";

            var emailMessage = new SendGridMessage
            {
                From = new EmailAddress(emailFromAddress, emailFromName),
                Subject = "Sign in to your INF Marketplace Account",
                TemplateId = templateId,
            };
            var templateData = new VerifyEmailTemplateData {
                Name = name,
                Link = link,
            };
            emailMessage.SetTemplateData(templateData);

            emailMessage.AddTos(
                new List<EmailAddress>
                {
                    new EmailAddress(email, name),
                });

            var client = new SendGridClient(apiKey);

            await client.SendEmailAsync(emailMessage, cancellationToken);
        }

        private static IUsersService GetUsersService() =>
            ServiceProxy.Create<IUsersService>(new Uri("fabric:/server/Users"));

        private static IInvitationCodesService GetInvitationCodesService() =>
            ServiceProxy.Create<IInvitationCodesService>(new Uri("fabric:/server/InvitationCodes"));

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
