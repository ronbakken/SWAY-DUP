using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json;
using SendGrid;
using SendGrid.Helpers.Mail;

namespace API.Services.Auth
{
    public interface IEmailService
    {
        Task SendVerificationEmail(
            string emailAddress,
            string name,
            string link,
            bool isNewUser,
            CancellationToken cancellationToken = default);
    }

    public sealed class SendGridEmailService : IEmailService
    {
        public async Task SendVerificationEmail(string emailAddress, string name, string link, bool isNewUser, CancellationToken cancellationToken = default)
        {
            // TODO: parameterize these
            var apiKey = "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";
            var templateId = isNewUser ? "d-483fc2ac76984399bf6c58a411c14d45" : "d-410b5cc2a77e4357a82afede83e92621";
            var emailFromAddress = "donotreply@swaymarketplace.com";
            var emailFromName = "Sway Marketplace";

            var emailMessage = new SendGridMessage
            {
                From = new EmailAddress(emailFromAddress, emailFromName),
                Subject = "Sign in to your Sway Marketplace Account",
                TemplateId = templateId,
            };
            var templateData = new VerifyEmailTemplateData
            {
                Name = name,
                Link = link,
            };
            emailMessage.SetTemplateData(templateData);

            emailMessage.AddTos(
                new List<EmailAddress>
                {
                    new EmailAddress(emailAddress, name),
                });

            var client = new SendGridClient(apiKey);

            await client
                .SendEmailAsync(emailMessage, cancellationToken)
                .ContinueOnAnyContext();
        }

        private sealed class VerifyEmailTemplateData
        {
            [JsonProperty("name")]
            public string Name { get; set; }

            [JsonProperty("link")]
            public string Link { get; set; }
        }
    }
}
