using System;
using System.Collections.Generic;
using System.Linq;
using System.Reactive;
using System.Reactive.Linq;
using System.Reactive.Subjects;
using System.Reactive.Threading.Tasks;
using System.Threading.Tasks;
using API.Interfaces;
using API.Services.List.ItemBatchProviders;
using Grpc.Core;
using Serilog;
using Utility;
using static API.Interfaces.InfList;

namespace API.Services.List
{
    public sealed class InfListImpl : InfListBase
    {
        private readonly ILogger logger;

        public InfListImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfListImpl>();
        }

        public override Task List(IAsyncStreamReader<ListRequest> requestStream, IServerStreamWriter<ListResponse> responseStream, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userType = context.GetAuthenticatedUserType();
                    var clientId = Guid.NewGuid();
                    logger.Debug("Generated client ID {ClientId} for new list stream associated with a user of type {UserType}", clientId, userType);

                    var isPaused = new BehaviorSubject<bool>(true);
                    var filter = new BehaviorSubject<ItemFilterDto>(null);
                    var activeClient = new ActiveListClient(
                        this.logger,
                        clientId,
                        userType,
                        isPaused.DistinctUntilChanged(),
                        filter.DistinctUntilChanged());

                    var subscription = activeClient
                        .GetItemBatches()
                        .Where(itemBatch => itemBatch.Count > 0)
                        .Select(
                            itemBatch =>
                            {
                                var response = new ListResponse();
                                response.Items.AddRange(itemBatch);
                                return response;
                            })
                        .SelectMany(
                            async response =>
                            {
                                logger.Debug("Sending batch of {Count} items to client with ID {ClientId}", response.Items.Count, clientId);
                                await responseStream
                                    .WriteAsync(response)
                                    .ContinueOnAnyContext();

                                return Unit.Default;
                            })
                        .Subscribe(
                            _ => { },
                            ex => logger.Error(ex, "Item batches pipeline failed for client {ClientId}", clientId));

                    using (subscription)
                    {
                        while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                        {
                            var request = requestStream.Current;
                            logger.Debug("Received request {@Request}", request);
                            isPaused.OnNext(request.State == ListRequest.Types.State.Paused);
                            filter.OnNext(request.Filter);
                        }
                    }
                });

        private sealed class ActiveListClient
        {
            public ActiveListClient(
                ILogger logger,
                Guid id,
                AuthenticatedUserType userType,
                IObservable<bool> isPaused,
                IObservable<ItemFilterDto> filter)
            {
                this.Logger = logger
                    .ForContext<ActiveListClient>()
                    .ForContext("ClientId", id);
                this.Id = id;
                this.UserType = userType;
                this.IsPaused = isPaused;
                this.Filter = filter;
            }

            private ILogger Logger { get; }

            public Guid Id { get; }

            public AuthenticatedUserType UserType { get; }

            public IObservable<bool> IsPaused { get; }

            public IObservable<ItemFilterDto> Filter { get; }

            public IObservable<List<ItemDto>> GetItemBatches()
            {
                IObservable<List<ItemDto>> DrainItemBatchProvider(ILogger logger, AuthenticatedUserType userType, ItemFilterDto filter, int pageSize, ItemBatchProvider itemBatchProvider, IObservable<Unit> getNextBatch)
                {
                    // TODO:
                    //   - encapsulate state in pipeline
                    //   - make this easier to understand
                    string continuationToken = null;

                    return getNextBatch
                        .Select(
                            _ =>
                                // We defer so that the async operation is not started until the previous one does (by virtue of the Concat)
                                // This is so the continuation token is updated first, even if it takes a long time for a batch to be retrieved.
                                Observable
                                    .Defer(() => itemBatchProvider.GetItemBatch(logger, userType, filter, pageSize, continuationToken).ToObservable())
                                    .Do(itemBatch => continuationToken = itemBatch?.ContinuationToken))
                        .Concat()
                        .TakeWhile(itemBatch => itemBatch != null)
                        .Select(itemBatch => itemBatch.Items)
                        .Do(
                            _ => { },
                            () => logger.Debug("Finished draining item batch provider {ItemBatchProvider}", itemBatchProvider.Name));
                }

                var itemBatchProvidersWithFilter = this
                    .Filter
                    .Select(filter => (itemBatchProviders: GetItemBatchProvidersFor(filter), filter: filter));

                // A signal that indicates that the next batch should be retrieved. Supports pause/resume and incremental back-off.
                var getNextBatchSignal = this
                    .IsPaused
                    .Select(
                        paused =>
                        {
                            if (paused)
                            {
                                return Observable.Never<Unit>();
                            }

                            return Observable
                                .Generate(
                                    initialState: 0,
                                    condition: _ => true,
                                    iterate: state => Math.Min(8, Math.Max(1, state * 2)),
                                    resultSelector: _ => Unit.Default,
                                    timeSelector: state => TimeSpan.FromSeconds(state));
                        })
                    .Switch()
                    .Publish()
                    .RefCount();

                var itemBatchProviderResults = itemBatchProvidersWithFilter
                    .Select(
                        x => x.itemBatchProviders == null ?
                            Observable.Empty<List<ItemDto>>() :
                            Observable
                                .Merge(
                                    x
                                        .itemBatchProviders
                                        .Select(bp => DrainItemBatchProvider(Logger, this.UserType, x.filter, 25, bp, getNextBatchSignal))))
                    .Switch();

                return itemBatchProviderResults;
            }

            private static List<ItemBatchProvider> GetItemBatchProvidersFor(ItemFilterDto filter)
            {
                if (filter == null)
                {
                    return null;
                }

                var itemBatchProviders = new List<ItemBatchProvider>();

                if (filter.ConversationFilter != null)
                {
                    itemBatchProviders.Add(ConversationItemBatchProvider.Instance);
                }

                if (filter.MessageFilter != null)
                {
                    itemBatchProviders.Add(MessageItemBatchProvider.Instance);
                }

                if (filter.OfferFilter != null)
                {
                    if (filter.OfferFilter.MapLevel > 0)
                    {
                        itemBatchProviders.Add(new MapItemBatchProvider(SourceFilter.Offers));
                    }
                    else
                    {
                        itemBatchProviders.Add(OfferItemBatchProvider.Instance);
                    }
                }

                if (filter.UserFilter != null)
                {
                    if (filter.UserFilter.MapLevel > 0)
                    {
                        itemBatchProviders.Add(new MapItemBatchProvider(SourceFilter.Users));
                    }
                    else
                    {
                        itemBatchProviders.Add(UserItemBatchProvider.Instance);
                    }
                }

                if (itemBatchProviders.Count == 0)
                {
                    return null;
                }

                return itemBatchProviders;
            }
        }
    }
}
