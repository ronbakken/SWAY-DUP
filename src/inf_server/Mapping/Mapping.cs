using System.Collections.Generic;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using Mapping.Interfaces;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Serilog;
using Utility;
using Utility.gRPC;

namespace Mapping
{
    internal sealed class Mapping : StatelessService
    {
        private readonly ILogger logger;
        private readonly MappingServiceImpl implementation;

        public Mapping(StatelessServiceContext context)
            : base(context)
        {
            this.logger = Logging.GetLogger(this);
            var offerUpdatedSubscriptionClient = this.Context.CodePackageActivationContext.GetServiceBusSubscriptionClient(this.logger, "OfferUpdated", "mapping_service", ReceiveMode.ReceiveAndDelete);
            var userUpdatedSubscriptionClient = this.Context.CodePackageActivationContext.GetServiceBusSubscriptionClient(this.logger, "UserUpdated", "mapping_service", ReceiveMode.ReceiveAndDelete);
            this.implementation = new MappingServiceImpl(this.logger, offerUpdatedSubscriptionClient, userUpdatedSubscriptionClient);
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            await implementation
                .Initialize(this.Context.CodePackageActivationContext.GetCosmosClient(), cancellationToken)
                .ContinueOnAnyContext();
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            new[]
            {
                new ServiceInstanceListener(
                    initParams =>
                        new CommunicationListener(
                            this.logger,
                            useSsl: false,
                            MappingService.BindService(this.implementation))),
            };
    }
}
