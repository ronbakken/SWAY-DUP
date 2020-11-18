using System.Threading;
using System.Threading.Tasks;
using Utility;
using Utility.gRPC;
using Utility.Microsoft.Azure.Cosmos;

namespace InvitationCodes
{
    static class Program
    {
        static async Task Main(string[] args)
        {
            var logger = Logging.GetLogger(typeof(Program));
            var invitationCodesService = new InvitationCodesServiceImpl(logger);
            var cosmosClient = Cosmos.GetCosmosClient();
            await invitationCodesService
                .Initialize(cosmosClient)
                .ContinueOnAnyContext();
            var server = ServerFactory.Create(
                useSsl: false,
                Interfaces.InvitationCodeService.BindService(invitationCodesService));

            logger.Debug("Starting server");
            server.Start();
            logger.Debug("Server started");

            await Task.Delay(Timeout.Infinite);
        }
    }
}
