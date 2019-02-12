using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Diagnostics;
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
using Optional;
using Serilog;
using Utility.Mapping;
using Utility.Serialization;
using static API.Interfaces.InfMapping;
using api = global::API.Interfaces.MapItemDto.Types;

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

        public override Task Search(IAsyncStreamReader<SearchRequest> requestStream, IServerStreamWriter<SearchResponse> responseStream, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    // The below is a preliminary implementation of map searching, with support for clustering. It is far from complete,
                    // but should suffice for MVP. It currently assumes clients throw away all data and replace it with that given, and
                    // it does not support updates to the stream (see commented out code below).

                    var mappingService = GetMappingService();

                    var clientId = Guid.NewGuid();
                    this.logger.Debug("Generated client ID {ClientId} for new search stream", clientId);

                    var activeSearchClient = RegisterActiveSearchClient(clientId, responseStream);

                    while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                    {
                        var filter = requestStream.Current;

                        using (this.logger.Performance("Updating filter to {@Filter} for client with ID {ClientId}", filter, clientId))
                        {
                            activeSearchClient = activeSearchClient
                                .SetFilter(filter);

                            var northWestQuadKey = QuadKey.From(filter.NorthWest.Latitude, filter.NorthWest.Longitude, filter.MapLevel);
                            var southEastQuadKey = QuadKey.From(filter.SouthEast.Latitude, filter.SouthEast.Longitude, filter.MapLevel);
                            var quadKeys = QuadKey
                                .GetRange(northWestQuadKey, southEastQuadKey)
                                .ToImmutableList();
                            logger.Debug("Determined that filter {@Filter} encompasses quad keys {QuadKeys}", filter, quadKeys);

                            // Reset all relevant quads, since we're about to get all data in that quad again.
                            foreach (var quadKey in quadKeys)
                            {
                                activeSearchClient = activeSearchClient.ResetQuad(quadKey);
                            }

                            // Update the filter before we kick of asynchronous work, so that any change notifications we receive in
                            // the meantime are processed against the most up to date information.
                            UpdateActiveSearchClient(clientId, activeSearchClient);

                            var mapItemTypes = filter
                                .ItemTypes
                                .Select(itemType => itemType.ToServiceObject())
                                .Aggregate(MapItemTypes.None, (acc, next) => acc | next);
                            logger.Debug("Determined that filter {@Filter} encompasses map item types {MapItemTypes}", filter, mapItemTypes);

                            logger.Debug("Instigating service calls for client with ID {ClientId}", clientId);
                            var serviceCalls = quadKeys
                                .Select(quadKey => new SearchFilter(mapItemTypes, quadKey.ToString()))
                                .Select(serviceFilter => mappingService.Search(serviceFilter))
                                .ToList();

                            var serviceCallResults = await Task
                                .WhenAll(serviceCalls)
                                .ContinueOnAnyContext();

                            logger.Debug("Populating active search client with ID {ClientId} with results of service calls", clientId);

                            foreach (var serviceCallResult in serviceCallResults)
                            {
                                foreach (var mapItem in serviceCallResult)
                                {
                                    var mapItemDto = mapItem.ToDto();

                                    switch (mapItem.Status)
                                    {
                                        case MapItemStatus.Active:
                                            activeSearchClient = activeSearchClient.AddItem(mapItemDto, out var addResult);
                                            logger.Debug("Added map item {MapItem} to active search client with ID {ClientId} and got result {Result}", mapItemDto, clientId, addResult);
                                            break;
                                        case MapItemStatus.Inactive:
                                            activeSearchClient = activeSearchClient.RemoveItem(mapItemDto, out var removeResult);
                                            logger.Debug("Removed map item {MapItem} from active search client with ID {ClientId} and got result {Result}", mapItemDto, clientId, removeResult);
                                            break;
                                        default:
                                            throw new NotSupportedException();
                                    }
                                }
                            }

                            // Update the search client again, now with the details of all the above data within it.
                            UpdateActiveSearchClient(clientId, activeSearchClient);

                            var initialResultSet = activeSearchClient
                                .GetItems(quadKeys)
                                .ToList();
                            logger.Debug("Streaming initial result set of {Count} map items to client with ID {ClientId}", initialResultSet.Count, clientId);

                            var response = new SearchResponse();
                            response.MapItems.AddRange(initialResultSet);
                            await responseStream
                                .WriteAsync(response)
                                .ContinueOnAnyContext();
                        }
                    }

                    UnregisterActiveSearchClient(clientId);
                });

        private ActiveSearchClient RegisterActiveSearchClient(Guid clientId, IServerStreamWriter<SearchResponse> responseStream)
        {
            this.logger.Debug("Registering active search client with ID {ClientId}", clientId);
            var activeSearchClient = ActiveSearchClient.For(responseStream);

            while (true)
            {
                var existingActiveSearchClients = this.activeSearchClients;
                var modifiedActiveSearchClients = existingActiveSearchClients.Add(clientId, activeSearchClient);

                if (Interlocked.CompareExchange(ref this.activeSearchClients, modifiedActiveSearchClients, existingActiveSearchClients) == existingActiveSearchClients)
                {
                    break;
                }
            }

            return activeSearchClient;
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

        private void UpdateActiveSearchClient(Guid clientId, ActiveSearchClient activeSearchClient)
        {
            this.logger.Debug("Updating active search client with ID {ClientId}", clientId);

            while (true)
            {
                var existingActiveSearchClients = this.activeSearchClients;
                var modifiedActiveSearchClients = existingActiveSearchClients
                    .Remove(clientId)
                    .Add(clientId, activeSearchClient);

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

            //this.logger.Debug("Received offer {@Offer} - checking {ActiveSearchClientCount} active search clients for a matching filter", offer, activeSearchClients.Count);

            //foreach (var activeSearchClientId in activeSearchClients.Keys)
            //{
            //    var activeSearchClient = activeSearchClients[activeSearchClientId];
            //    var filter = activeSearchClient.Filter;

            //    if (Matches(offer, filter))
            //    {
            //        this.logger.Verbose("Offer {@Offer} was found to match against filter {@Filter} for active search client with ID {ClientId} - pushing it to the response stream", offer, filter, activeSearchClientId);
            //        var response = new SearchResponse();
            //        var mapItem = new MapItemDto
            //        {
            //            GeoPoint = offer.Location.ToDto(),
            //            Offer = new OfferMapItemDto
            //            {
            //                OfferId = offer.Id,
            //                UserId = offer.UserId,
            //            },
            //            Status = offer.Status == global::Offers.Interfaces.OfferStatus.Active ? MapItemStatus.Active : MapItemStatus.Inactive,
            //        };
            //        response.MapItems.Add(mapItem);
            //        this.logger.Verbose("Pushing map item {@MapItem} to active client with ID {ClientId}", mapItem, activeSearchClientId);

            //        await activeSearchClient
            //            .Response
            //            .WriteAsync(response)
            //            .ContinueOnAnyContext();
            //    }
            //    else
            //    {
            //        this.logger.Verbose("Offer {@Offer} did not match against filter {@Filter} for active search client with ID {ClientId}", offer, filter, activeSearchClientId);
            //    }
            //}
        }

        private static bool Matches(Offer offer, SearchRequest filter)
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

        private sealed class ActiveSearchClient
        {
            // This is a trade-off between the caching/performance for an individual client versus memory usage for the system as a whole.
            // Hopefully we can increase this number in practice.
            private const int maximumActiveQuads = 32;

            private ActiveSearchClient(
                IServerStreamWriter<SearchResponse> response,
                SearchRequest filter,
                ImmutableDictionary<QuadKey, ActiveSearchClientQuad> quads,
                ImmutableList<QuadKey> quadUsageHistory)
            {
                this.Response = response;
                this.Filter = filter;
                this.Quads = quads;
                this.QuadUsageHistory = quadUsageHistory;

                this.ValidateInvariants();
            }

            public static ActiveSearchClient For(IServerStreamWriter<SearchResponse> response) =>
                new ActiveSearchClient(
                    response,
                    null,
                    ImmutableDictionary<QuadKey, ActiveSearchClientQuad>.Empty,
                    ImmutableList<QuadKey>.Empty);

            public IServerStreamWriter<SearchResponse> Response { get; }

            public SearchRequest Filter { get; }

            private ImmutableDictionary<QuadKey, ActiveSearchClientQuad> Quads { get; }

            // Quads in order of usage, from most-recently-used to least-recently-used. This is so we can expel the most appropriate quad
            // from the cache as needed.
            private ImmutableList<QuadKey> QuadUsageHistory { get; }

            public ActiveSearchClient SetFilter(SearchRequest filter) =>
                this.With(
                    filter: Option.Some(filter));

            public ActiveSearchClient ResetQuad(QuadKey quadKey)
            {
                var modifiedQuads = this
                    .Quads
                    .Remove(quadKey);
                var modifiedQuadUsageHistory = this
                    .QuadUsageHistory
                    .Remove(quadKey);

                return this.With(
                    quads: Option.Some(modifiedQuads),
                    quadUsageHistory: Option.Some(modifiedQuadUsageHistory));
            }

            public ActiveSearchClient AddItem(MapItemDto item, out AddItemOutcome outcome)
            {
                var quadKey = QuadKey.From(item.GeoPoint.Latitude, item.GeoPoint.Longitude, this.Filter.MapLevel);

                if (!this.Quads.TryGetValue(quadKey, out var quad))
                {
                    quad = ActiveSearchClientQuad.For(quadKey);
                }

                var modifiedQuad = quad.AddItem(item, out outcome);
                var modifiedQuads = this
                    .Quads
                    .Remove(quadKey)
                    .Add(quadKey, modifiedQuad);
                var modifiedQuadUsageHistory = this
                    .QuadUsageHistory
                    .Remove(quadKey)
                    .Insert(0, quadKey);

                if (modifiedQuads.Count > maximumActiveQuads)
                {
                    // Too many quads cached, so remove the least recently used one.
                    var quadToRemove = modifiedQuadUsageHistory[modifiedQuadUsageHistory.Count - 1];
                    modifiedQuads = modifiedQuads
                        .Remove(quadToRemove);
                    modifiedQuadUsageHistory = modifiedQuadUsageHistory
                        .RemoveAt(modifiedQuadUsageHistory.Count - 1);
                }

                return this.With(
                    quads: Option.Some(modifiedQuads),
                    quadUsageHistory: Option.Some(modifiedQuadUsageHistory));
            }

            public ActiveSearchClient RemoveItem(MapItemDto item, out RemoveItemOutcome outcome)
            {
                var quadKey = QuadKey.From(item.GeoPoint.Latitude, item.GeoPoint.Longitude, this.Filter.MapLevel);

                if (!this.Quads.TryGetValue(quadKey, out var quad))
                {
                    outcome = RemoveItemOutcome.QuadNotCached;
                    return this;
                }

                var modifiedQuad = quad.RemoveItem(item, out outcome);
                var modifiedQuads = this
                    .Quads
                    .Remove(quadKey)
                    .Add(quadKey, modifiedQuad);
                var modifiedQuadUsageHistory = this
                    .QuadUsageHistory
                    .Remove(quadKey)
                    .Insert(0, quadKey);

                return this.With(
                    quads: Option.Some(modifiedQuads),
                    quadUsageHistory: Option.Some(modifiedQuadUsageHistory));
            }

            public IEnumerable<MapItemDto> GetItems(ImmutableList<QuadKey> quadKeys)
            {
                foreach (var quadKey in quadKeys)
                {
                    if (!this.Quads.TryGetValue(quadKey, out var quad))
                    {
                        continue;
                    }

                    foreach (var item in quad.GetItems())
                    {
                        yield return item;
                    }
                }
            }

            [Conditional("DEBUG")]
            private void ValidateInvariants()
            {
                Debug.Assert(this.Response != null, "Response must not be null.");
                Debug.Assert(this.Quads != null, "Quads must not be null.");
                Debug.Assert(this.QuadUsageHistory != null, "Quad usage history must not be null.");
                Debug.Assert(this.Quads.Count == this.QuadUsageHistory.Count, "Quads and quad usage history must have matching number of items in them.");
                Debug.Assert(this.Quads.Count <= maximumActiveQuads, "The number of quads should not surpass maximumActiveQuads constant.");
            }

            private ActiveSearchClient With(
                    Option<SearchRequest> filter = default,
                    Option<ImmutableDictionary<QuadKey, ActiveSearchClientQuad>> quads = default,
                    Option<ImmutableList<QuadKey>> quadUsageHistory = default) =>
                new ActiveSearchClient(
                    this.Response,
                    filter.ValueOr(this.Filter),
                    quads.ValueOr(this.Quads),
                    quadUsageHistory.ValueOr(this.QuadUsageHistory));
        }

        private sealed class ActiveSearchClientQuad
        {
            // How many generations to split within the quad in order to determine cluster boundaries.
            // For example, two generations deep means this quad is split once, then each of those quads again, resulting
            // in a 4x4 matrix of cluster quads.
            public const int clusterGenerationCount = 2;

            private ActiveSearchClientQuad(QuadKey quadKey, ImmutableDictionary<QuadKey, ActiveSearchClientQuadCluster> clusters)
            {
                this.QuadKey = quadKey;
                this.Clusters = clusters;

                this.ValidateInvariants();
            }

            public static ActiveSearchClientQuad For(QuadKey quadKey) =>
                new ActiveSearchClientQuad(
                    quadKey,
                    GetDescendentsInGeneration(quadKey, clusterGenerationCount)
                        .Select(clusterQuadKey => ActiveSearchClientQuadCluster.For(clusterQuadKey))
                        .ToImmutableDictionary((quadCluster) => quadCluster.ClusterQuadKey));

            public QuadKey QuadKey { get; }

            // TODO: as an optimization, it might make sense to number clusters sequentially in the form $quadKey.$clusterIndex. I
            // could formalize this in a ClusterKey type and store clusters in an ImmutableArray instead, making them faster to resolve.
            private ImmutableDictionary<QuadKey, ActiveSearchClientQuadCluster> Clusters { get; }

            public ActiveSearchClientQuad AddItem(MapItemDto item, out AddItemOutcome outcome)
            {
                var clusterQuadKey = this.GetClusterQuadKeyFor(item);
                Debug.Assert(this.Clusters.ContainsKey(clusterQuadKey));

                var modifiedCluster = this
                    .Clusters[clusterQuadKey]
                    .AddItem(item, out outcome);
                var modifiedClusters = this
                    .Clusters
                    .Remove(clusterQuadKey)
                    .Add(clusterQuadKey, modifiedCluster);

                return this.With(
                    clusters: Option.Some(modifiedClusters));
            }

            public ActiveSearchClientQuad RemoveItem(MapItemDto item, out RemoveItemOutcome outcome)
            {
                var clusterQuadKey = this.GetClusterQuadKeyFor(item);
                Debug.Assert(this.Clusters.ContainsKey(clusterQuadKey));

                var modifiedCluster = this
                    .Clusters[clusterQuadKey]
                    .RemoveItem(item, out outcome);
                var modifiedClusters = this
                    .Clusters
                    .Remove(clusterQuadKey)
                    .Add(clusterQuadKey, modifiedCluster);

                return this.With(
                    clusters: Option.Some(modifiedClusters));
            }

            public IEnumerable<MapItemDto> GetItems()
            {
                foreach (var cluster in this.Clusters.Values)
                {
                    var item = cluster.GetItem();

                    if (item == null)
                    {
                        continue;
                    }

                    yield return item;
                }
            }

            private ActiveSearchClientQuad With(
                    Option<ImmutableDictionary<QuadKey, ActiveSearchClientQuadCluster>> clusters = default) =>
                new ActiveSearchClientQuad(
                    this.QuadKey,
                    clusters.ValueOr(this.Clusters));

            // Determine the cluster quad key for a given item. The item is assumed to reside within this quad.
            private QuadKey GetClusterQuadKeyFor(MapItemDto item) =>
                QuadKey.From(item.GeoPoint.Latitude, item.GeoPoint.Longitude, this.QuadKey.LevelOfDetail + clusterGenerationCount);

            [Conditional("DEBUG")]
            private void ValidateInvariants()
            {
                Debug.Assert(this.QuadKey.IsValid, "Quad key must be valid.");
                Debug.Assert(this.Clusters != null, "Clusters must not be null.");
                Debug.Assert(this.Clusters.Count == Math.Pow(2, clusterGenerationCount * 2), "Clusters does not contain the expected number of clusters.");
            }

            // Gets descendent quad keys, but only those in a specific generation count below the given quad key.
            // TODO: If I can name this better, maybe it should belong in QuadKey?
            private static IEnumerable<QuadKey> GetDescendentsInGeneration(QuadKey quadKey, int generation)
            {
                if (generation == 0)
                {
                    yield return quadKey;
                    yield break;
                }

                foreach (var child in quadKey.GetChildren())
                {
                    foreach (var descendent in GetDescendentsInGeneration(child, generation - 1))
                    {
                        yield return descendent;
                    }
                }
            }
        }

        private enum AddItemOutcome
        {
            // No cluster yet - it's the first item.
            AcceptedFirstItem,

            // A cluster has formed because it's the second item.
            AcceptedSecondItem,

            // A cluster was already formed because it's a subsequent item.
            AcceptedSubsequentItem,
        }

        private enum RemoveItemOutcome
        {
            // The quad containing the item isn't even in the cache, so there was no need to remove it.
            QuadNotCached,

            // There were no items in the cluster, so it remained unaffected by the removal request.
            NoItemInCluster,

            // The item was removed, and it was the only item in the "cluster", so the cluster has effectively been reset.
            NoItemRemaining,

            // The item was removed, and there are multiple items still within the cluster.
            MultipleItemsRemaining,

            // The item was removed, and there is only one item remaining in the cluster. This makes the ActiveSearchClientQuadCluster
            // invalid, since there is no way to know which item remains. It should be discarded and replaced with valid data.
            SingleItemRemaining
        }

        private sealed class ActiveSearchClientQuadCluster
        {
            private ActiveSearchClientQuadCluster(
                QuadKey clusterQuadKey,
                int count,
                double averageLongitude,
                double averageLatitude,
                MapItemDto singleItem)
            {
                this.ClusterQuadKey = clusterQuadKey;
                this.Count = count;
                this.AverageLongitude = averageLongitude;
                this.AverageLatitude = averageLatitude;
                this.SingleItem = singleItem;

                this.ValidateInvariants();
            }

            public static ActiveSearchClientQuadCluster For(QuadKey clusterQuadKey) =>
                new ActiveSearchClientQuadCluster(clusterQuadKey, default, default, default, default);

            public QuadKey ClusterQuadKey { get; }

            public string ClusterId
            {
                get
                {
                    var clusterQuadKey = ClusterQuadKey.ToString();
                    return clusterQuadKey.Insert(clusterQuadKey.Length - ActiveSearchClientQuad.clusterGenerationCount, ".");
                }
            }

            public int Count { get; }

            public double AverageLongitude { get; }

            public double AverageLatitude { get; }

            // If the cluster consists of a single item, this is it.
            private MapItemDto SingleItem { get; }

            public MapItemDto GetItem()
            {
                if (this.Count == 0)
                {
                    return null;
                }
                else if (this.Count == 1)
                {
                    var singleItem = this.SingleItem.Clone();
                    singleItem.ParentClusterId = this.ClusterQuadKey.ToString();
                    return singleItem;
                }
                else
                {
                    return new MapItemDto
                    {
                        GeoPoint = new GeoPointDto
                        {
                            Longitude = this.AverageLongitude,
                            Latitude = this.AverageLatitude,
                        },
                        // TODO: clusters need to come and go too? Or does invalidation take care of this scenario?
                        Status = api.MapItemStatus.Active,
                        Cluster = new ClusterMapItemDto
                        {
                            ClusterId = this.ClusterId,
                            ItemCount = this.Count,
                        },
                        ParentClusterId = this.ClusterQuadKey.ToString(),
                    };
                }
            }

            private ActiveSearchClientQuadCluster With(
                    Option<int> count = default,
                    Option<double> averageLongitude = default,
                    Option<double> averageLatitude = default,
                    Option<MapItemDto> singleItem = default) =>
                new ActiveSearchClientQuadCluster(
                    this.ClusterQuadKey,
                    count.ValueOr(this.Count),
                    averageLongitude.ValueOr(this.AverageLongitude),
                    averageLatitude.ValueOr(this.AverageLatitude),
                    singleItem.ValueOr(this.SingleItem));

            public ActiveSearchClientQuadCluster AddItem(MapItemDto item, out AddItemOutcome outcome)
            {
                if (this.Count == 0)
                {
                    outcome = AddItemOutcome.AcceptedFirstItem;
                    return this.With(
                        count: Option.Some(1),
                        singleItem: Option.Some(item),
                        averageLongitude: Option.Some(item.GeoPoint.Longitude),
                        averageLatitude: Option.Some(item.GeoPoint.Latitude));
                }
                else
                {
                    outcome = this.Count == 1 ? AddItemOutcome.AcceptedSecondItem : AddItemOutcome.AcceptedSubsequentItem;
                    return this.With(
                        count: Option.Some(this.Count + 1),
                        singleItem: Option.Some<MapItemDto>(null),
                        averageLongitude: Option.Some(CalculateMovingAverage(this.AverageLongitude, this.Count, item.GeoPoint.Longitude, countDelta: 1)),
                        averageLatitude: Option.Some(CalculateMovingAverage(this.AverageLatitude, this.Count, item.GeoPoint.Latitude, countDelta: 1)));
                }
            }

            public ActiveSearchClientQuadCluster RemoveItem(MapItemDto item, out RemoveItemOutcome outcome)
            {
                if (this.Count == 0)
                {
                    outcome = RemoveItemOutcome.NoItemInCluster;
                    return this;
                }

                if (this.Count == 1)
                {
                    outcome = RemoveItemOutcome.NoItemRemaining;
                    return this.With(
                        count: Option.Some(0),
                        singleItem: Option.Some<MapItemDto>(null),
                        averageLongitude: Option.Some(0d),
                        averageLatitude: Option.Some(0d));
                }

                if (this.Count == 2)
                {
                    outcome = RemoveItemOutcome.SingleItemRemaining;

                    // The cluster is now effectively invalid and should be discarded, so we only update the count.
                    return this.With(
                        count: Option.Some(1));
                }

                outcome = RemoveItemOutcome.MultipleItemsRemaining;
                return this.With(
                    count: Option.Some(this.Count - 1),
                    averageLongitude: Option.Some(CalculateMovingAverage(this.AverageLongitude, this.Count, item.GeoPoint.Longitude, countDelta: -1)),
                    averageLatitude: Option.Some(CalculateMovingAverage(this.AverageLatitude, this.Count, item.GeoPoint.Latitude, countDelta: -1)));
            }

            [Conditional("DEBUG")]
            private void ValidateInvariants()
            {
                Debug.Assert(this.ClusterQuadKey.IsValid, "Cluster quad key must be valid.");
                Debug.Assert(this.Count >= 0, "Count must be >= 0.");
                Debug.Assert(this.SingleItem == null || this.Count == 1, "If single item is provided, count must be 1.");
                Debug.Assert(this.SingleItem != null || this.Count != 1, "If single item is not provided, count must not be 1.");
                Debug.Assert(this.AverageLongitude >= -180 && this.AverageLongitude <= 180, "Average longitude must be between -180 and 180.");
                Debug.Assert(this.AverageLatitude >= -90 && this.AverageLatitude <= 90, "Average latitude must be between -90 and 90.");
            }

            private static double CalculateMovingAverage(double currentAverage, int currentCount, double newAmount, int countDelta) =>
                ((currentCount * currentAverage) + newAmount) / (currentCount + countDelta);
        }
    }
}
