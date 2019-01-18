using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Microsoft.ServiceFabric.Actors;
using Microsoft.ServiceFabric.Actors.Client;
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

        private static async Task SendEmailVerificationEmail(string email, string name, string link, CancellationToken cancellationToken = default)
        {
            var apiKey = "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";
            var templateId = "d-410b5cc2a77e4357a82afede83e92621";

            var emailMessage = new SendGridMessage
            {
                From = new EmailAddress("donotreply@inf-marketplace-llc.com", "INF Marketplace LLC"),
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
    }
}
