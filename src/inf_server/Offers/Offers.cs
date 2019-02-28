using System.Collections.Generic;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using Offers.Interfaces;
using Serilog;
using Utility;

namespace Offers
{
    internal sealed class Offers : StatelessService
    {
        private readonly ILogger logger;
        private readonly OffersServiceImpl implementation;

        public Offers(StatelessServiceContext context)
            : base(context)
        {
            this.logger = Logging.GetLogger(this);
            var offerUpdatedTopicClient = this.Context.CodePackageActivationContext.GetServiceBusTopicClient(this.logger, "OfferUpdated");
            this.implementation = new OffersServiceImpl(this.logger, offerUpdatedTopicClient);
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
                        new gRPCCommunicationListener(
                            this.logger,
                            OffersService.BindService(this.implementation))),
            };
    }
}
