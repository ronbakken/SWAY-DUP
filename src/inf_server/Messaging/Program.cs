using System.Threading;
using System.Threading.Tasks;
using Utility;
using Utility.gRPC;
using Utility.Microsoft.Azure.Cosmos;
using Utility.Microsoft.Azure.ServiceBus;

namespace Messaging
{
    static class Program
    {
        static async Task Main(string[] args)
        {
            var logger = Logging.GetLogger(typeof(Program));
            var conversationUpdated = ServiceBus.GetServiceBusTopicClient(logger, "ConversationUpdated");
            var messageUpdated = ServiceBus.GetServiceBusTopicClient(logger, "MessageUpdated");
            var messagingService = new MessagingServiceImpl(logger, conversationUpdated, messageUpdated);
            var cosmosClient = Cosmos.GetCosmosClient();
            await messagingService
                .Initialize(cosmosClient)
                .ContinueOnAnyContext();
            var server = ServerFactory.Create(
                useSsl: false,
                Interfaces.MessagingService.BindService(messagingService));

            logger.Debug("Starting server");
            server.Start();
            logger.Debug("Server started");

            await Task.Delay(Timeout.Infinite);
        }
    }
}
