using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.ServiceBus;
using Utility;
using Utility.gRPC;
using Utility.Microsoft.Azure.Cosmos;
using Utility.Microsoft.Azure.ServiceBus;

namespace Mapping
{
    static class Program
    {
        static async Task Main(string[] args)
        {
            var logger = Logging.GetLogger(typeof(Program));
            var offerUpdated = ServiceBus.GetServiceBusSubscriptionClient(logger, "OfferUpdated", "mapping_service", ReceiveMode.ReceiveAndDelete);
            var userUpdated = ServiceBus.GetServiceBusSubscriptionClient(logger, "UserUpdated", "mapping_service", ReceiveMode.ReceiveAndDelete);
            var mappingService = new MappingServiceImpl(logger, offerUpdated, userUpdated);
            var cosmosClient = Cosmos.GetCosmosClient();
            await mappingService
                .Initialize(cosmosClient)
                .ContinueOnAnyContext();
            var server = ServerFactory.Create(
                useSsl: false,
                Interfaces.MappingService.BindService(mappingService));

            logger.Debug("Starting server");
            server.Start();
            logger.Debug("Server started");

            await Task.Delay(Timeout.Infinite);
        }
    }
}
