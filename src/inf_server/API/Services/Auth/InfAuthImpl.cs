using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using InvitationCodeManager.Interfaces;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
using Microsoft.ServiceFabric.Services.Client;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Newtonsoft.Json;
using Optional;
using RefreshToken.Interfaces;
using SendGrid;
using SendGrid.Helpers.Mail;
using User.Interfaces;
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
                ServiceFabricUserActorFactory.Instance,
                new SendGridEmailService(),
                context.CancellationToken);
            return Empty.Instance;
        }

        internal async Task SendLoginEmailImpl(
            SendLoginEmailRequest request,
            IUserActorFactory userActorFactory,
            IEmailService emailService,
            CancellationToken cancellationToken)
        {
            Log("SendLoginEmail.");

            Log("Getting user data.");
            var userId = request.Email;
            var user = userActorFactory.Get(userId);
            var userData = await user.GetData();

            Log("Generating login token.");
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                userData.Status.ToString(),
                userData.Type.ToString());

            Log("Updating user data.");
            userData = userData.With(
                loginToken: Option.Some(loginToken),
                status: Option.Some(UserStatus.WaitingForActivation));
            await user.SetData(userData);

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

            Log("Validating invitation code.");
            var invitationCodeManager = GetInvitationCodeManagerService();
            var useInvitationCodeResult = await invitationCodeManager.Use(request.InvitationCode);

            if (useInvitationCodeResult != InvitationCodeUseResult.Success)
            {
                throw new InvalidOperationException("Could not use invitation code.");
            }

            Log("Validating login token.");
            var loginTokenValidationResults = TokenManager.ValidateLoginToken(request.LoginToken);

            Log("Validating user status.");
            var userId = loginTokenValidationResults.UserId;
            var user = GetUserActor(userId);
            var userData = await user.GetData();

            if (userData.Status != UserStatus.WaitingForActivation)
            {
                throw new InvalidOperationException("User is not awaiting activation.");
            }

            Log("Generating refresh token.");
            var refreshToken = TokenManager.GenerateRefreshToken(loginTokenValidationResults.UserId, loginTokenValidationResults.UserType);

            Log("Saving refresh token.");
            var refreshTokenActor = GetRefreshTokenActor(refreshToken);
            await refreshTokenActor.Associate(userId, request.DeviceId);

            Log("Updating user data.");
            userData = request
                .UserData
                .ToService(
                    loginToken: null)
                .With(
                    status: Option.Some(UserStatus.Active));
            await user.SetData(userData);

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
            var user = GetUserActor(userId);
            var userData = await user.GetData();

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

            Log("Associating refresh token with user.");
            var refreshTokenActor = GetRefreshTokenActor(refreshToken);
            var deviceId = await refreshTokenActor.GetAssociatedDeviceId();
            await refreshTokenActor.Associate(userId, deviceId);

            Log("Updating user data.");
            userData = userData.With(
                loginToken: Option.Some<string>(null));
            await user.SetData(userData);

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
            var user = GetUserActor(userId);
            var userData = await user.GetData();

            Log("Validating refresh token.");
            var refreshTokenActor = GetRefreshTokenActor(refreshToken);
            var associatedUserId = await refreshTokenActor.GetAssociatedUserId();

            if (associatedUserId != userId)
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
            var refreshToken = GetRefreshTokenActor(request.RefreshToken);
            var associatedUserId = await refreshToken.GetAssociatedUserId();

            if (associatedUserId != userId)
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
            var user = GetUserActor(request.UserId);
            var userData = await user.GetData();

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
            var user = GetUserActor(authenticatedUserId);
            var userData = await user.GetData();

            Log("Saving user data.");
            await user.SetData(request.User.ToService(userData.LoginToken));

            return Empty.Instance;
        }

        public override async Task<Empty> Logout(LogoutRequest request, ServerCallContext context)
        {
            Log("Logout.");

            Log("Invalidating refresh token.");
            var refreshToken = GetRefreshTokenActor(request.RefreshToken);
            await refreshToken.Invalidate();

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

        private static IUser GetUserActor(string userId) =>
            ActorProxy.Create<IUser>(new ActorId(userId), new Uri("fabric:/server/UserActorService"));

        private static IRefreshToken GetRefreshTokenActor(string refreshToken) =>
            ActorProxy.Create<IRefreshToken>(new ActorId(refreshToken), new Uri("fabric:/server/RefreshTokenActorService"));

        private static IInvitationCodeManagerService GetInvitationCodeManagerService() =>
            ServiceProxy.Create<IInvitationCodeManagerService>(new Uri("fabric:/server/InvitationCodeManager"), new ServicePartitionKey(1));

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
