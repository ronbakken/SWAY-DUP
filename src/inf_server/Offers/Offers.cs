using System;
using System.Collections.Generic;
using System.Fabric;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.ServiceBus;
using Microsoft.ServiceFabric.Services.Communication.Runtime;
using Microsoft.ServiceFabric.Services.Remoting.Runtime;
using Microsoft.ServiceFabric.Services.Runtime;
using NodaTime;
using Offers.Interfaces;
using Optional;
using Serilog;
using Utility;
using Utility.Serialization;

namespace Offers
{
    internal sealed class Offers : StatelessService, IOffersService
    {
        private const string databaseId = "offers";
        private const string offersCollectionId = "offers";
        private readonly ILogger logger;
        private readonly TopicClient offerUpdatedTopicClient;
        private readonly TopicClient offerRemovedTopicClient;
        private CosmosContainer offersContainer;

        public Offers(StatelessServiceContext context)
            : base(context)
        {
            var configurationPackage = this.Context.CodePackageActivationContext.GetConfigurationPackageObject("Config");
            var logStorageConnectionString = configurationPackage.Settings.Sections["Logging"].Parameters["StorageConnectionString"].Value;
            this.logger = Logging.GetLogger(this, logStorageConnectionString);
            var serviceBusConnectionString = configurationPackage.Settings.Sections["ServiceBus"].Parameters["ConnectionString"].Value;
            this.offerUpdatedTopicClient = new TopicClient(serviceBusConnectionString, "OfferUpdated");
            this.offerRemovedTopicClient = new TopicClient(serviceBusConnectionString, "OfferRemoved");
        }

        protected override async Task RunAsync(CancellationToken cancellationToken)
        {
            logger.Debug("Creating database if required");

            var cosmosClient = this.GetCosmosClient();
            var databaseResult = await cosmosClient.Databases.CreateDatabaseIfNotExistsAsync(databaseId);
            var database = databaseResult.Database;
            var offersContainerResult = await database.Containers.CreateContainerIfNotExistsAsync(offersCollectionId, "/userId");
            this.offersContainer = offersContainerResult.Container;

            logger.Debug("Database creation complete");
        }

        public Task<Offer> SaveOffer(Offer offer) =>
            this.ReportExceptionsWithin(this.logger, (logger) => SaveOfferImpl(logger, offer));

        internal async Task<Offer> SaveOfferImpl(ILogger logger, Offer offer)
        {
            if (offer.Status == OfferStatus.Inactive)
            {
                throw new ArgumentException("Cannot save inactive offer.");
            }

            var offerEntity = offer
                .ToEntity()
                .With(
                    id: Option.Some(offer.Id ?? Guid.NewGuid().ToString()),
                    status: Option.Some(OfferStatusEntity.Active),
                    statusTimestamp: Option.Some(SystemClock.Instance.GetCurrentInstant().InUtc()));
            offer = offerEntity.ToServiceObject();

            logger.Debug("Saving offer {@Offer}", offerEntity);
            await this.offersContainer.Items.UpsertItemAsync(offerEntity.UserId, offerEntity);
            logger.Debug("Offer saved: {@Offer}", offerEntity);

            logger.Debug("Publishing offer {@Offer} to service bus", offer);
            var message = new Message(offer.ToSerializedDataContract());
            await this
                .offerUpdatedTopicClient
                .SendAsync(message)
                .ContinueOnAnyContext();

            return offer;
        }

        public Task<Offer> RemoveOffer(Offer offer) =>
            this.ReportExceptionsWithin(this.logger, (logger) => RemoveOfferImpl(logger, offer));

        internal async Task<Offer> RemoveOfferImpl(ILogger logger, Offer offer)
        {
            if (offer.Id == null)
            {
                throw new ArgumentException("Cannot remove an offer that has no ID.");
            }

            if (offer.Status != OfferStatus.Active)
            {
                throw new ArgumentException("Cannot remove an offer unless it is active.");
            }

            var offerEntity = offer
                .ToEntity()
                .With(
                    status: Option.Some(OfferStatusEntity.Inactive),
                    statusTimestamp: Option.Some(SystemClock.Instance.GetCurrentInstant().InUtc()));

            logger.Debug("Removing offer {@Offer}", offerEntity);
            await this.offersContainer.Items.UpsertItemAsync(offerEntity.UserId, offerEntity);
            logger.Debug("Offer removed: {@Offer}", offerEntity);

            logger.Debug("Publishing removal of offer {@Offer} to service bus", offer);
            var message = new Message(offer.ToSerializedDataContract());
            await this
                .offerRemovedTopicClient
                .SendAsync(message)
                .ContinueOnAnyContext();

            return offer;
        }

        protected override IEnumerable<ServiceInstanceListener> CreateServiceInstanceListeners() =>
            this.CreateServiceRemotingInstanceListeners();

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
