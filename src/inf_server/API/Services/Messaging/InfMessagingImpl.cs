using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Serilog;
using static API.Interfaces.InfMessaging;

namespace API.Services.Messaging
{
    public sealed class InfMessagingImpl : InfMessagingBase
    {
        private readonly ILogger logger;

        public InfMessagingImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfMessagingImpl>();
        }

        public override async Task<NotifyResponse> Notify(NotifyRequest request, ServerCallContext context)
        {
            using (var client = new HttpClient())
            {
                var json = $@"{{
  ""to"": ""{request.RegistrationToken}"",
  ""notification"": {{
    ""body"": ""{request.Body}"",
    ""title"": ""{request.Title}""
  }},
  ""priority"": ""high"",
  ""data"": {{
    ""click_action"": ""FLUTTER_NOTIFICATION_CLICK"",
    ""id"": ""1"",
    ""status"": ""done""
  }}
}}";

                var httpRequest = new HttpRequestMessage
                {
                    Method = HttpMethod.Post,
                    RequestUri = new Uri("https://fcm.googleapis.com/fcm/send"),
                };
                httpRequest.Headers.TryAddWithoutValidation("Authorization", $"key={request.Token}");

                var content = new StringContent(json, Encoding.UTF8, "application/json");
                httpRequest.Content = content;

                var result = await client
                    .SendAsync(httpRequest)
                    .ContinueOnAnyContext();

                result.EnsureSuccessStatusCode();

                return new NotifyResponse();
            }
        }
    }
}
