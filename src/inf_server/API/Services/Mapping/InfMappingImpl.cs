using System;
using System.Collections.Immutable;
using System.Fabric;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Mapping.Interfaces;
using Microsoft.Azure.ServiceBus;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Offers.Interfaces;
using Serilog;
using Utility.Serialization;
using static API.Interfaces.InfMapping;
using static API.Interfaces.MapItemDto.Types;

namespace API.Services.Mapping
{
    public sealed class InfMappingImpl : InfMappingBase
    {
        private readonly ILogger logger;
        private ImmutableDictionary<Guid, ActiveSearchClient> activeSearchClients;

        public InfMappingImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfMappingImpl>();
            this.activeSearchClients = ImmutableDictionary<Guid, ActiveSearchClient>.Empty;

            var configurationPackage = FabricRuntime.GetActivationContext().GetConfigurationPackageObject("Config");
            var serviceBusConnectionString = configurationPackage.Settings.Sections["ServiceBus"].Parameters["ConnectionString"].Value;
            var subscriptionClient = new SubscriptionClient(
                serviceBusConnectionString,
                "OfferUpdated",
                "mapping_api",
                receiveMode: ReceiveMode.ReceiveAndDelete);

            var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
            {
                AutoComplete = true,
                MaxConcurrentCalls = 4,
            };
            subscriptionClient.RegisterMessageHandler(this.OnOfferUpdated, messageHandlerOptions);
        }

        public override Task SearchOffers(IAsyncStreamReader<SearchRequest> requestStream, IServerStreamWriter<SearchResponse> responseStream, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var mappingService = GetMappingService();

                    var clientId = Guid.NewGuid();
                    this.logger.Debug("Generated client ID {ClientId} for new search stream", clientId);

                    while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                    {
                        var request = requestStream.Current;

                        var filter = new OfferSearchFilter(
                            request.MapLevel,
                            request.NorthWest.ToServiceObject(),
                            request.SouthEast.ToServiceObject());

                        logger.Debug("Maintaining active search registrations for client with ID {ClientId}", clientId);
                        UnregisterActiveSearchClient(clientId);
                        RegisterActiveSearchClient(clientId, responseStream, filter);

                        logger.Debug("Searching for offers using filter {@Filter}", filter);
                        var results = await mappingService
                            .Search(filter)
                            .ContinueOnAnyContext();
                        var mapItems = results
                            .Select(
                                result =>
                                    new MapItemDto
                                    {
                                        GeoPoint = result.Location.ToDto(),
                                        Offer = result.ToDto(),
                                    })
                            .ToList();
                        logger.Debug("{Count} map items found matching filter {@Filter}", mapItems.Count, filter);

                        var response = new SearchResponse();
                        response.MapItems.AddRange(mapItems);
                        await responseStream
                            .WriteAsync(response)
                            .ContinueOnAnyContext();
                    }

                    UnregisterActiveSearchClient(clientId);
                });

        private void RegisterActiveSearchClient(Guid clientId, IServerStreamWriter<SearchResponse> responseStream, OfferSearchFilter filter)
        {
            this.logger.Debug("Registering active search client with ID {ClientId}, filter {@Filter}", clientId, filter);
            var activeSearchClient = new ActiveSearchClient(responseStream, filter);

            while (true)
            {
                var existingActiveSearchClients = this.activeSearchClients;
                var modifiedActiveSearchClients = existingActiveSearchClients.Add(clientId, activeSearchClient);

                if (Interlocked.CompareExchange(ref this.activeSearchClients, modifiedActiveSearchClients, existingActiveSearchClients) == existingActiveSearchClients)
                {
                    break;
                }
            }
        }

        private void UnregisterActiveSearchClient(Guid clientId)
        {
            this.logger.Debug("Unregistering active search client with ID {ClientId}", clientId);

            while (true)
            {
                var existingActiveSearchClients = this.activeSearchClients;
                var modifiedActiveSearchClients = existingActiveSearchClients.Remove(clientId);

                if (Interlocked.CompareExchange(ref this.activeSearchClients, modifiedActiveSearchClients, existingActiveSearchClients) == existingActiveSearchClients)
                {
                    break;
                }
            }
        }

        private static IMappingService GetMappingService() =>
            ServiceProxy.Create<IMappingService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Mapping"));

        private async Task OnOfferUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnOfferUpdated");

            var offer = message.Body.FromSerializedDataContract<Offer>();
            var activeSearchClients = this.activeSearchClients;

            this.logger.Debug("Received offer {@Offer} - checking {ActiveSearchClientCount} active search clients for a matching filter", offer, activeSearchClients.Count);

            foreach (var activeSearchClientId in activeSearchClients.Keys)
            {
                var activeSearchClient = activeSearchClients[activeSearchClientId];
                var filter = activeSearchClient.Filter;

                if (Matches(offer, filter))
                {
                    this.logger.Verbose("Offer {@Offer} was found to match against filter {@Filter} for active search client with ID {ClientId} - pushing it to the response stream", offer, filter, activeSearchClientId);
                    var response = new SearchResponse();
                    var mapItem = new MapItemDto
                    {
                        GeoPoint = offer.Location.ToDto(),
                        Offer = new OfferMapItemDto
                        {
                            OfferId = offer.Id,
                            UserId = offer.UserId,
                        },
                        Status = offer.Status == global::Offers.Interfaces.OfferStatus.Active ? MapItemStatus.Active : MapItemStatus.Inactive,
                    };
                    response.MapItems.Add(mapItem);
                    this.logger.Verbose("Pushing map item {@MapItem} to active client with ID {ClientId}", mapItem, activeSearchClientId);

                    await activeSearchClient
                        .Response
                        .WriteAsync(response)
                        .ContinueOnAnyContext();
                }
                else
                {
                    this.logger.Verbose("Offer {@Offer} did not match against filter {@Filter} for active search client with ID {ClientId}", offer, filter, activeSearchClientId);
                }
            }
        }

        private static bool Matches(Offer offer, OfferSearchFilter filter)
        {
            var offerLocation = offer.Location;

            if (
                offerLocation.Latitude <= filter.NorthWest.Latitude &&
                offerLocation.Latitude > filter.SouthEast.Latitude &&
                offerLocation.Longitude >= filter.NorthWest.Longitude &&
                offerLocation.Longitude < filter.SouthEast.Longitude)
            {
                return true;
            }

            return false;
        }

        private Task OnServiceBusException(ExceptionReceivedEventArgs e)
        {
            this.logger.Error(
                e.Exception,
                "Error occurred on service bus for client ID {ClientId}, endpoint {Endpoint}, entity path {EntityPath}, action {Action}",
                e.ExceptionReceivedContext.ClientId,
                e.ExceptionReceivedContext.Endpoint,
                e.ExceptionReceivedContext.EntityPath,
                e.ExceptionReceivedContext.Action);
            return Task.CompletedTask;
        }

        private struct ActiveSearchClient
        {
            public ActiveSearchClient(IServerStreamWriter<SearchResponse> response, OfferSearchFilter filter)
            {
                this.Response = response;
                this.Filter = filter;
            }

            public IServerStreamWriter<SearchResponse> Response { get; }

            public OfferSearchFilter Filter { get; }
        }
    }
}
