using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Reactive;
using System.Reactive.Disposables;
using System.Reactive.Linq;
using System.Reactive.Subjects;
using System.Threading;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using API.Services.Listen.ItemListeners;
using Grpc.Core;
using Microsoft.Azure.ServiceBus;
using Offers.Interfaces;
using Serilog;
using Users.Interfaces;
using Utility;
using static API.Interfaces.InfListen;
using messaging = Messaging.Interfaces;

namespace API.Services.Listen
{
    public sealed class InfListenImpl : InfListenBase
    {
        private readonly ILogger logger;
        private readonly ISubject<messaging.Conversation> updatedConversations;
        private readonly ISubject<messaging.Message> updatedMessages;
        private readonly ISubject<Offer> updatedOffers;
        private readonly ISubject<User> updatedUsers;
        private ImmutableDictionary<Guid, ActiveListenClient> activeListenClients;

        public InfListenImpl(
            ILogger logger,
            SubscriptionClient conversationUpdatedSubscriptionClient,
            SubscriptionClient messageUpdatedSubscriptionClient,
            SubscriptionClient offerUpdatedSubscriptionClient,
            SubscriptionClient userUpdatedSubscriptionClient)
        {
            this.logger = logger.ForContext<InfListenImpl>();
            this.updatedConversations = Subject.Synchronize(new Subject<messaging.Conversation>());
            this.updatedMessages = Subject.Synchronize(new Subject<messaging.Message>());
            this.updatedOffers = Subject.Synchronize(new Subject<Offer>());
            this.updatedUsers = Subject.Synchronize(new Subject<User>());
            this.activeListenClients = ImmutableDictionary<Guid, ActiveListenClient>.Empty;

            if (conversationUpdatedSubscriptionClient != null)
            {
                var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
                {
                    AutoComplete = true,
                    MaxConcurrentCalls = 4,
                };
                conversationUpdatedSubscriptionClient.RegisterMessageHandler(this.OnConversationUpdated, messageHandlerOptions);
            }

            if (messageUpdatedSubscriptionClient != null)
            {
                var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
                {
                    AutoComplete = true,
                    MaxConcurrentCalls = 4,
                };
                messageUpdatedSubscriptionClient.RegisterMessageHandler(this.OnMessageUpdated, messageHandlerOptions);
            }

            if (offerUpdatedSubscriptionClient != null)
            {
                var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
                {
                    AutoComplete = true,
                    MaxConcurrentCalls = 4,
                };
                offerUpdatedSubscriptionClient.RegisterMessageHandler(this.OnOfferUpdated, messageHandlerOptions);
            }

            if (userUpdatedSubscriptionClient != null)
            {
                var messageHandlerOptions = new MessageHandlerOptions(this.OnServiceBusException)
                {
                    AutoComplete = true,
                    MaxConcurrentCalls = 4,
                };
                userUpdatedSubscriptionClient.RegisterMessageHandler(this.OnUserUpdated, messageHandlerOptions);
            }
        }

        public override Task Listen(IAsyncStreamReader<ListenRequest> requestStream, IServerStreamWriter<ListenResponse> responseStream, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var userId = context.GetAuthenticatedUserId();
                    var clientId = Guid.NewGuid();

                    logger = logger
                        .ForContext("ClientId", clientId)
                        .ForContext("UserId", userId);

                    logger.Debug("Generated client ID {ClientId} for new listen stream", clientId);

                    // Ticks each incoming request from the client.
                    var incomingListenRequests = new Subject<ListenRequest>();

                    // Signalled when the client disconnects.
                    var doneSignal = new Subject<Unit>();

                    var singleItemFilters = incomingListenRequests
                        .Where(incomingListenRequest => incomingListenRequest.TargetCase == ListenRequest.TargetOneofCase.SingleItemFilter)
                        .Buffer(TimeSpan.FromMilliseconds(250))
                        .Where(buffer => buffer.Count > 0)
                        .Scan(
                            ImmutableList<SingleItemFilterDto>.Empty,
                            (acc, next) =>
                            {
                                foreach (var request in next)
                                {
                                    switch (request.Action)
                                    {
                                        case ListenRequest.Types.Action.Deregister:
                                            acc = acc.Remove(request.SingleItemFilter);
                                            break;
                                        case ListenRequest.Types.Action.Register:
                                            acc = acc.Add(request.SingleItemFilter);
                                            break;
                                    }
                                }

                                return acc;
                            })
                        .StartWith(ImmutableList<SingleItemFilterDto>.Empty)
                        .TakeUntil(doneSignal)
                        // This is super important because it gives listeners a chance to clean up any resources established against
                        // individual filters once the client disconnects.
                        .Concat(Observable.Return(ImmutableList<SingleItemFilterDto>.Empty))
                        .Publish()
                        .RefCount();
                    var itemFilters = incomingListenRequests
                        .Where(incomingListenRequest => incomingListenRequest.TargetCase == ListenRequest.TargetOneofCase.Filter)
                        .Buffer(TimeSpan.FromMilliseconds(250))
                        .Where(buffer => buffer.Count > 0)
                        .Scan(
                            ImmutableList<ItemFilterDto>.Empty,
                            (acc, next) =>
                            {
                                foreach (var request in next)
                                {
                                    switch (request.Action)
                                    {
                                        case ListenRequest.Types.Action.Deregister:
                                            acc = acc.Remove(request.Filter);
                                            break;
                                        case ListenRequest.Types.Action.Register:
                                            acc = acc.Add(request.Filter);
                                            break;
                                    }
                                }

                                return acc;
                            })
                        .StartWith(ImmutableList<ItemFilterDto>.Empty)
                        .TakeUntil(doneSignal)
                        // This is super important because it gives listeners a chance to clean up any resources established against
                        // individual filters once the client disconnects.
                        .Concat(Observable.Return(ImmutableList<ItemFilterDto>.Empty))
                        .Publish()
                        .RefCount();

                    var activeListenClient = new ActiveListenClient(
                        logger,
                        userId,
                        singleItemFilters,
                        itemFilters,
                        this.updatedConversations,
                        this.updatedMessages,
                        this.updatedOffers,
                        this.updatedUsers);

                    var subscriptions = new CompositeDisposable();

                    activeListenClient
                        .AffectedItems
                        .Select(
                            item =>
                            {
                                logger.Debug("Sending item {@Item} to client with ID {ClientId}", item, clientId);

                                var response = new ListenResponse();
                                response.Items.Add(item);
                                return response;
                            })
                        .SelectMany(
                            async response =>
                            {
                                await responseStream
                                    .WriteAsync(response)
                                    .ContinueOnAnyContext();

                                return Unit.Default;
                            })
                        .Subscribe(
                            _ => { },
                            ex => logger.Error(ex, "Affected items pipeline failed for client {ClientId}", clientId))
                        .AddTo(subscriptions);

                    this.RegisterActiveListenClient(clientId, activeListenClient);

                    using (subscriptions)
                    {
                        try
                        {
                            while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                            {
                                var request = requestStream.Current;
                                logger.Debug("Received request {@Request}", request);
                                incomingListenRequests.OnNext(request);
                            }
                        }
                        finally
                        {
                            logger.Debug("Signalling done");
                            doneSignal.OnNext(Unit.Default);
                            this.UnregisterActiveListenClient(clientId);
                            activeListenClient.Dispose();
                        }
                    }
                });

        private void RegisterActiveListenClient(Guid clientId, ActiveListenClient activeListenClient)
        {
            this.logger.Debug("Registering active listen client with ID {ClientId}", clientId);

            while (true)
            {
                var existingActiveListenClients = this.activeListenClients;
                var modifiedActiveListenClients = existingActiveListenClients.Add(clientId, activeListenClient);

                if (Interlocked.CompareExchange(ref this.activeListenClients, modifiedActiveListenClients, existingActiveListenClients) == existingActiveListenClients)
                {
                    break;
                }
            }
        }

        private void UnregisterActiveListenClient(Guid clientId)
        {
            this.logger.Debug("Unregistering active listen client with ID {ClientId}", clientId);

            while (true)
            {
                var existingActiveListenClients = this.activeListenClients;
                var modifiedActiveListenClients = existingActiveListenClients.Remove(clientId);

                if (Interlocked.CompareExchange(ref this.activeListenClients, modifiedActiveListenClients, existingActiveListenClients) == existingActiveListenClients)
                {
                    break;
                }
            }
        }

        private Task OnConversationUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnConversationUpdated");

            var conversation = messaging.Conversation.Parser.ParseFrom(message.Body);
            this.logger.Debug("Updated conversation is {@Conversation}", conversation);
            this.updatedConversations.OnNext(conversation);

            return Task.CompletedTask;
        }

        private Task OnMessageUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnMessageUpdated");

            var msg = messaging.Message.Parser.ParseFrom(message.Body);
            this.logger.Debug("Updated message is {@Message}", msg);
            this.updatedMessages.OnNext(msg);

            return Task.CompletedTask;
        }

        private Task OnOfferUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnOfferUpdated");

            var offer = Offer.Parser.ParseFrom(message.Body);
            this.logger.Debug("Updated offer is {@Offer}", offer);
            this.updatedOffers.OnNext(offer);

            return Task.CompletedTask;
        }

        private Task OnUserUpdated(Message message, CancellationToken token)
        {
            this.logger.Debug("OnUserUpdated");

            var user = User.Parser.ParseFrom(message.Body);
            this.logger.Debug("Updated user is {@User}", user);
            this.updatedUsers.OnNext(user);

            return Task.CompletedTask;
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

        private sealed class ActiveListenClient : IDisposable
        {
            private readonly List<ItemListener> itemListeners;

            public ActiveListenClient(
                ILogger logger,
                string userId,
                IObservable<ImmutableList<SingleItemFilterDto>> singleItemFilters,
                IObservable<ImmutableList<ItemFilterDto>> itemFilters,
                IObservable<messaging.Conversation> conversationUpdated,
                IObservable<messaging.Message> messageUpdated,
                IObservable<Offer> offerUpdated,
                IObservable<User> userUpdated)
            {
                var conversationItemListener = new ConversationItemListener(logger, userId);
                var messageItemListener = new MessageItemListener(logger, userId);
                var offerItemListener = new OfferItemListener(logger, userId);
                var userItemListener = new UserItemListener(logger, userId);

                this.itemListeners = new List<ItemListener>
                {
                    conversationItemListener,
                    messageItemListener,
                    offerItemListener,
                    userItemListener,
                };

                var affectedConversations = conversationItemListener.GetMatchingItems(conversationUpdated, singleItemFilters, itemFilters);
                var affectedMessages = messageItemListener.GetMatchingItems(messageUpdated, singleItemFilters, itemFilters);
                var affectedOffers = offerItemListener.GetMatchingItems(offerUpdated, singleItemFilters, itemFilters);
                var affectedUsers = userItemListener.GetMatchingItems(userUpdated, singleItemFilters, itemFilters);

                this.AffectedItems = Observable
                    .Merge(
                        affectedConversations
                            .Select(conversation => conversation.ToItemDto()),
                        affectedMessages
                            .Select(message => message.ToItemDto()),
                        affectedOffers
                            .Select(offer => offer.ToItemDto(OfferDto.DataOneofCase.Full)),
                        affectedUsers
                            .Select(user => user.ToItemDto(UserDto.DataOneofCase.Full)));
            }

            // All items that should be forward onto the listening client.
            public IObservable<ItemDto> AffectedItems { get; }

            public void Dispose()
            {
                foreach (var itemListener in this.itemListeners)
                {
                    itemListener.Dispose();
                }
            }
        }
    }
}
