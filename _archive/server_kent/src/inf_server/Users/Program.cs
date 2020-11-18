using System.Threading;
using System.Threading.Tasks;
using Utility;
using Utility.gRPC;
using Utility.Microsoft.Azure.Cosmos;
using Utility.Microsoft.Azure.ServiceBus;

namespace Users
{
    static class Program
    {
        static async Task Main(string[] args)
        {
            var logger = Logging.GetLogger(typeof(Program));
            var userUpdated = ServiceBus.GetServiceBusTopicClient(logger, "UserUpdated");
            var usersService = new UsersServiceImpl(logger, userUpdated);
            var cosmosClient = Cosmos.GetCosmosClient();
            await usersService
                .Initialize(cosmosClient)
                .ContinueOnAnyContext();
            var server = ServerFactory.Create(
                useSsl: false,
                Interfaces.UsersService.BindService(usersService));

            logger.Debug("Starting server");
            server.Start();
            logger.Debug("Server started");

            await Task.Delay(Timeout.Infinite);
        }
    }
}
