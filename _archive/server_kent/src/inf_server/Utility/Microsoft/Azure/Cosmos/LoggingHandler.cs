using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Serilog;

namespace Utility.Microsoft.Azure.Cosmos
{
    // A handler for Cosmos DB that logs performance of all calls.
    public sealed class LoggingHandler : CosmosRequestHandler
    {
        public static readonly LoggingHandler Instance = new LoggingHandler();

        private static readonly ILogger logger = Logging.GetLogger<LoggingHandler>();

        private LoggingHandler()
        {
        }

        public override async Task<CosmosResponseMessage> SendAsync(CosmosRequestMessage request, CancellationToken cancellationToken)
        {
            using (var performanceBlock = logger.Performance("Cosmos DB request: method {Method}, URI {Uri}, headers {@Headers}, properties {@Properties}", request.Method, request.RequestUri, request.Headers, request.Properties))
            {
                var response = await base.SendAsync(request, cancellationToken);

                performanceBlock.ReplaceMessage(
                    "Cosmos DB request: method {Method}, URI {Uri}, headers {@Headers}, properties {@Properties}. Response: status code {StatusCode} (is success {IsSuccess}), error message {ErrorMessage}, headers {@Headers}",
                    request.Method,
                    request.RequestUri,
                    request.Headers,
                    request.Properties,
                    response.StatusCode,
                    response.IsSuccessStatusCode,
                    response.ErrorMessage,
                    response.Headers);

                return response;
            }
        }
    }
}
