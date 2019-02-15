using System.Collections.Generic;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using InvitationCodes.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Utility;

namespace InvitationCodes
{
    internal sealed class InvitationCodes : StatelessService
    {
        private readonly ILogger logger;
        private readonly InvitationCodesServiceImpl implementation;

        public InvitationCodes(StatelessServiceContext context)
            : base(context)
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            this.logger = Logging.GetLogger(this, logStorageConnectionString);
            this.implementation = new InvitationCodesServiceImpl(this.logger);
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            await implementation
                .Initialize(this.GetCosmosClient(), cancellationToken)
                .ContinueOnAnyContext();
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            new[]
            {
                new ServiceInstanceListener(
                    initParams =>
                        new gRPCCommunicationListener(
                            this.logger,
                            InvitationCodeService.BindService(this.implementation))),
            };

        private CosmosClient GetCosmosClient()
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var databaseConnectionString = configurationPackage.Settings.Sections["Database"].Parameters["ConnectionString"].Value;
            var cosmosConfiguration = new InfCosmosConfiguration(databaseConnectionString);
            var cosmosClient = new CosmosClient(cosmosConfiguration);

            return cosmosClient;
        }
    }
}
