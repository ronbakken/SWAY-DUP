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

        public override async Task<Empty> SendLoginEmail(LoginEmailRequest request, ServerCallContext context)
        {
            Log("SendLoginEmail.");

            var userId = request.Email;
            var user = GetUserActor(userId);
            var userData = await user.GetData();
            var oneTimeAccessToken = TokenManager.GenerateOneTimeAccessToken(
                userId,
                userData.Status.ToDtoString(),
                userData.Type.ToDtoString());
            var link = $"inf://verify?token={oneTimeAccessToken}";

            // Store the token with the user data so that we can ensure a token provided by a client is still relevant.
            userData = userData.With(oneTimeAccessToken: Option.Some(oneTimeAccessToken));
            await user.SetData(userData);

            await SendEmailVerificationEmail(
                userId,
                userData.Name ?? userId,
                link,
                context.CancellationToken);

            return Empty.Instance;
        }

        public override async Task<InvitationCodeState> ValidateInvitationCode(Interfaces.InvitationCode request, ServerCallContext context)
        {
            Log("ValidateInvitationCode.");

            var invitationCodeManager = GetInvitationCodeManagerService();
            var status = await invitationCodeManager.GetStatus(request.Code);
            var result = new InvitationCodeState
            {
                State = status.ToDto(),
            };

            return result;
        }

        public override async Task<RefreshTokenMessage> RequestRefreshToken(RefreshTokenRequest request, ServerCallContext context)
        {
            Log("RequestRefreshToken.");

            var oneTimeAccessToken = request.OneTimeToken;
            var validationResult = TokenManager.ValidateOneTimeAccessToken(oneTimeAccessToken);
            var userId = validationResult.UserId;
            var user = GetUserActor(userId);
            var userData = await user.GetData();

            if (userData.OneTimeAccessToken != oneTimeAccessToken)
            {
                Log("Provided one-time token does not match against the user's data.");
                throw new InvalidOperationException();
            }

            // Invalidate the user's one-time access token.
            userData = userData.With(oneTimeAccessToken: Option.Some<string>(null));
            await user.SetData(userData);

            // Generate and return the refresh token.
            var refreshToken = TokenManager.GenerateRefreshToken(userId);
            var result = new RefreshTokenMessage
            {
                RefreshToken = refreshToken,
            };

            return result;
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

    internal static class InvitationCodeStatusExtensions
    {
        public static InvitationCodeStates ToDto(this InvitationCodeStatus @this)
        {
            switch (@this)
            {
                case InvitationCodeStatus.DoesNotExist:
                case InvitationCodeStatus.Used:
                    return InvitationCodeStates.Invalid;
                case InvitationCodeStatus.Expired:
                    return InvitationCodeStates.Expired;
                case InvitationCodeStatus.PendingUse:
                    return InvitationCodeStates.Valid;
                default:
                    throw new NotSupportedException();
            }
        }
    }
}
