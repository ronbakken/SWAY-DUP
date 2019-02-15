﻿using System.Collections.Generic;
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
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            this.logger = Logging.GetLogger(this, logStorageConnectionString);
            var serviceBusConnectionString = configurationPackage.Settings.Sections["ServiceBus"].Parameters["ConnectionString"].Value;
            var offerUpdatedTopicClient = new TopicClient(serviceBusConnectionString, "OfferUpdated");
            this.implementation = new OffersServiceImpl(this.logger, offerUpdatedTopicClient);
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
                            OffersService.BindService(this.implementation))),
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
