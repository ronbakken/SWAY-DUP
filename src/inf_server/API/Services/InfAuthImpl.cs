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
using SendGrid;
using SendGrid.Helpers.Mail;
using User.Interfaces;
using Utility;
using static API.Interfaces.InfAuth;

namespace API.Services
{
    public sealed class InfAuthImpl : InfAuthBase
    {
        private sealed class VerifyEmailTemplateData
        {
            [JsonProperty("name")]
            public string Name { get; set; }

            [JsonProperty("link")]
            public string Link { get; set; }
        }

        public override async Task<Empty> SendLoginEmail(SendLoginEmailRequest request, ServerCallContext context)
        {
            Log("SendLoginEmail.");

            var userId = request.Email;
            var user = GetUserActor(userId);
            var userData = await user.GetData();
            var loginToken = TokenManager.GenerateLoginToken(
                userId,
                userData.Status.ToString(),
                userData.Type.ToString());
            var link = $"https://infmarketplace.com/app/verify?token={loginToken}";

            // Store the token with the user data so that we can ensure a token provided by a client is still relevant.
            userData = userData.With(loginToken: Option.Some(loginToken));
            await user.SetData(userData);

            await SendEmailVerificationEmail(
                userId,
                userData.Name ?? userId,
                link,
                context.CancellationToken);

            return Empty.Instance;
        }

//public override async Task<InvitationCodeState> ValidateInvitationCode(Interfaces.InvitationCode request, ServerCallContext context)
//{
//    Log("ValidateInvitationCode.");

//    var invitationCodeManager = GetInvitationCodeManagerService();
//    var status = await invitationCodeManager.GetStatus(request.Code);
//    var result = new InvitationCodeState
//    {
//        State = status.ToDto(),
//    };

//    return result;
//}

        public override Task<CreateNewUserResponse> CreateNewUser(CreateNewUserRequest request, ServerCallContext context)
        {
            // TODO: invalidate invitation code/mark as used

            return base.CreateNewUser(request, context);
        }

        public override async Task<LoginWithLoginTokenResponse> LoginWithLoginToken(LoginWithLoginTokenRequest request, ServerCallContext context)
        {
            Log("RequestRefreshToken.");

            var loginToken = request.LoginToken;
            var validationResult = TokenManager.ValidateLoginToken(loginToken);
            var userId = validationResult.UserId;
            var userType = validationResult.UserType;
            var user = GetUserActor(userId);
            var userData = await user.GetData();

            if (userData.LoginToken != loginToken)
            {
                Log("Provided one-time token does not match against the user's data.");
                throw new InvalidOperationException();
            }

            // Invalidate the user's one-time access token and set them as active.
            userData = userData.With(
                loginToken: Option.Some<string>(null),
                status: Option.Some(UserStatus.Active));
            await user.SetData(userData);

            // Generate and return the refresh token.
            var refreshToken = TokenManager.GenerateRefreshToken(userId, userType);
            var result = new LoginWithLoginTokenResponse
            {
                RefreshToken = refreshToken,
                UserData = userData.ToDto(),
            };

            return result;
        }

        public override async Task<LoginWithRefreshTokenResponse> LoginWithRefreshToken(LoginWithRefreshTokenRequest request, ServerCallContext context)
        {
            Log("Login.");

            var refreshToken = request.RefreshToken;
            var validationResult = TokenManager.ValidateRefreshToken(refreshToken);
            var userId = validationResult.UserId;
            var user = GetUserActor(userId);
            var userData = await user.GetData();
            var accessToken = TokenManager.GenerateAccessToken(userId, userData.Type.ToString());

            var result = new LoginWithRefreshTokenResponse
            {
                AccessToken = accessToken,
                UserData = userData.ToDto(),
            };

            return result;
        }

        public override Task<GetUserResponse> GetUser(GetUserRequest request, ServerCallContext context)
        {
            // TODO
            return base.GetUser(request, context);
        }

        public override Task<Empty> UpdateUser(UpdateUserRequest request, ServerCallContext context)
        {
            return base.UpdateUser(request, context);
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

        private static IInvitationCodeManagerService GetInvitationCodeManagerService() =>
            ServiceProxy.Create<IInvitationCodeManagerService>(new Uri("fabric:/server/InvitationCodeManager"), new ServicePartitionKey(1));

        private static void Log(string message, params object[] args) =>
            ServiceEventSource.Current.Message(message, args);
    }
}
