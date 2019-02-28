using System;
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
using Grpc.Core;
using Microsoft.Azure.ServiceBus;
using Offers.Interfaces;
using Serilog;
using Users.Interfaces;
using Utility;
using Utility.Search;
using static API.Interfaces.InfListen;
using Money = Utility.Money;

namespace API.Services.Listen
{
    public sealed class InfListenImpl : InfListenBase
    {
        private readonly ILogger logger;
        private readonly ISubject<Offer> updatedOffers;
        private readonly ISubject<User> updatedUsers;
        private ImmutableDictionary<Guid, ActiveListenClient> activeListenClients;

        public InfListenImpl(
            ILogger logger,
            SubscriptionClient offerUpdatedSubscriptionClient,
            SubscriptionClient userUpdatedSubscriptionClient)
        {
            this.logger = logger.ForContext<InfListenImpl>();
            this.updatedOffers = Subject.Synchronize(new Subject<Offer>());
            this.updatedUsers = Subject.Synchronize(new Subject<User>());
            this.activeListenClients = ImmutableDictionary<Guid, ActiveListenClient>.Empty;

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
                    var clientId = Guid.NewGuid();
                    logger.Debug("Generated client ID {ClientId} for new listen stream", clientId);

                    var incomingListenRequests = new Subject<ListenRequest>();
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
                        .Publish()
                        .RefCount();

                    var activeListenClient = new ActiveListenClient(
                        logger.ForContext("ClientId", clientId),
                        singleItemFilters,
                        itemFilters,
                        this.updatedOffers,
                        this.updatedUsers);

                    var subscriptions = new CompositeDisposable();

                    activeListenClient
                        .AffectedOffers
                        .Select(
                            offer =>
                            {
                                logger.Debug("Sending offer {Offer} to client with ID {ClientId}", offer, clientId);

                                var response = new ListenResponse();
                                response.Items.Add(offer.ToItemDto());
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
                            ex => logger.Error(ex, "Affected offers pipeline failed for client {ClientId}", clientId))
                        .AddTo(subscriptions);

                    activeListenClient
                        .AffectedUsers
                        .Select(
                            user =>
                            {
                                logger.Debug("Sending user {User} to client with ID {ClientId}", user, clientId);

                                var response = new ListenResponse();
                                response.Items.Add(user.ToItemDto());
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
                            ex => logger.Error(ex, "Affected users pipeline failed for client {ClientId}", clientId))
                        .AddTo(subscriptions);

                    this.RegisterActiveListenClient(clientId, activeListenClient);

                    try
                    {
                        using (subscriptions)
                        {
                            while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                            {
                                var request = requestStream.Current;
                                logger.Debug("Received request {@Request}", request);
                                incomingListenRequests.OnNext(request);
                            }
                        }
                    }
                    finally
                    {
                        this.UnregisterActiveListenClient(clientId);
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

        private sealed class ActiveListenClient
        {
            private readonly IObservable<Offer> affectedOffers;
            private readonly IObservable<User> affectedUsers;

            public ActiveListenClient(
                ILogger logger,
                IObservable<ImmutableList<SingleItemFilterDto>> singleItemFilters,
                IObservable<ImmutableList<ItemFilterDto>> itemFilters,
                IObservable<Offer> offerUpdated,
                IObservable<User> userUpdated)
            {
                logger = logger.ForContext<ActiveListenClient>();

                this.affectedOffers = Observable
                    .Merge(
                        offerUpdated
                            .WithLatestFrom(singleItemFilters, (offer, filters) => (offer, isMatch: IsMatch(logger, offer, filters)))
                            .Where(result => result.isMatch)
                            .Select(result => result.offer),
                        offerUpdated
                            .WithLatestFrom(itemFilters, (offer, filters) => (offer, isMatch: IsMatch(logger, offer, filters)))
                            .Where(result => result.isMatch)
                            .Select(result => result.offer));

                this.affectedUsers = Observable
                    .Merge(
                        userUpdated
                            .WithLatestFrom(singleItemFilters, (user, filters) => (user, isMatch: IsMatch(logger, user, filters)))
                            .Where(result => result.isMatch)
                            .Select(result => result.user),
                        userUpdated
                            .WithLatestFrom(itemFilters, (user, filters) => (user, isMatch: IsMatch(logger, user, filters)))
                            .Where(result => result.isMatch)
                            .Select(result => result.user));
            }

            public IObservable<Offer> AffectedOffers => this.affectedOffers;

            public IObservable<User> AffectedUsers => this.affectedUsers;

            private static bool IsMatch(ILogger logger, Offer offer, ImmutableList<SingleItemFilterDto> filters)
            {
                if (filters.Count == 0)
                {
                    return false;
                }

                logger.Debug("Determining if offer {@Offer} matches any one of {Count} single-item filters", offer, filters.Count);

                foreach (var filter in filters)
                {
                    if (IsMatch(logger, offer, filter))
                    {
                        return true;
                    }
                }

                return false;
            }

            private static bool IsMatch(ILogger logger, Offer offer, SingleItemFilterDto filter)
            {
                logger.Debug("Determining if offer {@Offer} matches single-item filter {Filter}", offer, filter);

                if (string.Equals(filter.Id, offer.Id, StringComparison.Ordinal))
                {
                    logger.Debug("Offer has ID {OfferId}, which matches filter", offer.Id);
                    return true;
                }

                logger.Debug("Offer has ID {OfferId}, which does not match filter's ID of {FilterId}", offer.Id, filter.Id);
                return false;
            }

            private static bool IsMatch(ILogger logger, Offer offer, ImmutableList<ItemFilterDto> filters)
            {
                if (filters.Count == 0)
                {
                    return false;
                }

                logger.Debug("Determining if offer {@Offer} matches any one of {Count} item filters", offer, filters.Count);

                foreach (var itemFilter in filters)
                {
                    if (IsMatch(logger, offer, itemFilter))
                    {
                        return true;
                    }
                }

                return false;
            }

            private static bool IsMatch(ILogger logger, Offer offer, ItemFilterDto filter)
            {
                logger.Debug("Determining if offer {@Offer} matches item filter {@Filter}", offer, filter);

                var offerFilter = filter.OfferFilter;

                if (offerFilter != null)
                {
                    if (offerFilter.MinimumReward != null)
                    {
                        var cashValue = offer.Terms?.Reward?.CashValue;

                        if (cashValue == null)
                        {
                            logger.Debug("Filter has minimum reward {@MinimumReward} but offer has no cash value, so it does not satisfy filter", offerFilter.MinimumReward);
                            return false;
                        }

                        if (!string.Equals(offerFilter.MinimumReward.CurrencyCode, cashValue.CurrencyCode, StringComparison.Ordinal))
                        {
                            logger.Debug("Filter has minimum reward {@MinimumReward} but offer's cash value has differing currency code {CurrencyCode}, so it does not satisfy filter", offerFilter.MinimumReward, cashValue.CurrencyCode);
                            return false;
                        }

                        var cashValueMoney = new Money(cashValue.CurrencyCode, cashValue.Units, cashValue.Nanos);
                        var minimumRewardMoney = new Money(offerFilter.MinimumReward.CurrencyCode, offerFilter.MinimumReward.Units, offerFilter.MinimumReward.Nanos);

                        if (cashValueMoney < minimumRewardMoney)
                        {
                            logger.Debug("Filter has minimum reward {@MinimumReward} but offer's cash value is {CashValue}, so it does not satisfy filter", offerFilter.MinimumReward, cashValue);
                            return false;
                        }
                    }

                    if (!string.IsNullOrWhiteSpace(offerFilter.BusinessAccountId))
                    {
                        if (!string.Equals(offer.BusinessAccountId, offerFilter.BusinessAccountId, StringComparison.Ordinal))
                        {
                            logger.Debug("Filter has business account ID {FilterBusinessAccountId} but offer has {OfferBusinessAccountId}, so it does not satisfy filter", offerFilter.BusinessAccountId, offer.BusinessAccountId);
                            return false;
                        }
                    }

                    if (offerFilter.OfferStatuses.Count > 0)
                    {
                        var offerStatus = offer.Status.ToStatus();

                        if (!offerFilter.OfferStatuses.Contains(offerStatus))
                        {
                            logger.Debug("Filter has offer statuses {OfferStatuses} but offer has status {OfferStatus}, so it does not satisfy filter", offerFilter.OfferStatuses, offerStatus);
                            return false;
                        }
                    }

                    if (offerFilter.AcceptancePolicies.Count > 0)
                    {
                        var offerAcceptancePolicy = offer.AcceptancePolicy.ToAcceptancePolicy();

                        if (!offerFilter.AcceptancePolicies.Contains(offerAcceptancePolicy))
                        {
                            logger.Debug("Filter has acceptance policies {AcceptancePolicies} but offer has acceptance policy {OfferAcceptancePolicy}, so it does not satisfy filter", offerFilter.AcceptancePolicies, offerAcceptancePolicy);
                            return false;
                        }
                    }

                    if (offerFilter.DeliverableTypes.Count > 0)
                    {
                        var deliverableTypes = offer
                            .Terms
                            ?.Deliverable
                            ?.DeliverableTypes
                            ?.Select(x => x.ToDeliverableType())
                            ?.ToList();

                        if (deliverableTypes == null)
                        {
                            logger.Debug("Filter has deliverable types {DeliverableTypes} but offer has no deliverable types, so it does not satisfy filter", offerFilter.DeliverableTypes);
                            return false;
                        }

                        if (!deliverableTypes.Intersect(offerFilter.DeliverableTypes).Any())
                        {
                            logger.Debug("Filter has deliverable types {DeliverableTypes} but offer has deliverable types {OfferDeliverableTypes}, so it does not satisfy filter", offerFilter.DeliverableTypes, deliverableTypes);
                            return false;
                        }
                    }

                    if (offerFilter.RewardTypes.Count > 0)
                    {
                        var rewardType = offer.Terms?.Reward?.Type.ToType();

                        if (rewardType == null)
                        {
                            logger.Debug("Filter has reward types {RewardTypes} but offer has no reward type, so it does not satisfy filter", offerFilter.RewardTypes);
                            return false;
                        }

                        if (!offerFilter.RewardTypes.Contains(rewardType.Value))
                        {
                            logger.Debug("Filter has reward types {RewardTypes} but offer has reward type {OfferRewardType}, so it does not satisfy filter", offerFilter.RewardTypes, rewardType.Value);
                            return false;
                        }
                    }
                }

                if (offer.CategoryIds.Intersect(filter.CategoryIds).Count() != filter.CategoryIds.Count)
                {
                    logger.Debug("Filter has category IDs {CategoryIds} but offer has category IDs {OfferCategoryIds}, so it does not satisfy filter", filter.CategoryIds, offer.CategoryIds);
                    return false;
                }

                if (filter.NorthWest != null && filter.SouthEast != null)
                {
                    var geoPoint = offer.Location?.GeoPoint;

                    if (geoPoint == null)
                    {
                        logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but offer has no location, so it does not satisfy filter", filter.NorthWest, filter.SouthEast);
                        return false;
                    }

                    if (
                        geoPoint.Latitude > filter.NorthWest.Latitude ||
                        geoPoint.Longitude < filter.NorthWest.Longitude ||
                        geoPoint.Latitude < filter.SouthEast.Latitude ||
                        geoPoint.Longitude > filter.SouthEast.Longitude)
                    {
                        logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but offer has geopoint {@OfferGeoPoint}, so it does not satisfy filter", filter.NorthWest, filter.SouthEast, offer.Location.GeoPoint);
                        return false;
                    }
                }

                if (!string.IsNullOrWhiteSpace(filter.Phrase))
                {
                    var phraseKeywords = Keywords
                        .Extract(filter.Phrase)
                        .ToList();

                    if (offer.Keywords.Intersect(phraseKeywords).Count() != phraseKeywords.Count)
                    {
                        logger.Debug("Filter has phrase {Phrase} equating to keywords {PhraseKeywords}, but offer has keywords {OfferKeywords}, so it does not satisfy filter", filter.Phrase, phraseKeywords, offer.Keywords);
                        return false;
                    }
                }

                logger.Debug("Offer {@Offer} matches filter {@Filter}", offer, filter);
                return true;
            }

            private static bool IsMatch(ILogger logger, User user, ImmutableList<SingleItemFilterDto> filters)
            {
                if (filters.Count == 0)
                {
                    return false;
                }

                logger.Debug("Determining if user {@User} matches any one of {Count} single-item filters", user, filters.Count);

                foreach (var filter in filters)
                {
                    if (IsMatch(logger, user, filter))
                    {
                        return true;
                    }
                }

                return false;
            }

            private static bool IsMatch(ILogger logger, User user, SingleItemFilterDto filter)
            {
                logger.Debug("Determining if user {@User} matches single-item filter {Filter}", user, filter);

                if (string.Equals(filter.Id, user.Id, StringComparison.Ordinal))
                {
                    logger.Debug("User has ID {UserId}, which matches filter", user.Id);
                    return true;
                }

                logger.Debug("User has ID {UserId}, which does not match filter's ID of {FilterId}", user.Id, filter.Id);
                return false;
            }

            private static bool IsMatch(ILogger logger, User user, ImmutableList<ItemFilterDto> filters)
            {
                if (filters.Count == 0)
                {
                    return false;
                }

                logger.Debug("Determining if user {@User} matches any one of {Count} item filters", user, filters.Count);

                foreach (var itemFilter in filters)
                {
                    if (IsMatch(logger, user, itemFilter))
                    {
                        return true;
                    }
                }

                return false;
            }

            private static bool IsMatch(ILogger logger, User user, ItemFilterDto filter)
            {
                logger.Debug("Determining if user {@User} matches item filter {@Filter}", user, filter);

                var userFilter = filter.UserFilter;

                if (userFilter != null)
                {
                    var socialMediaNetworkIds = user
                        .SocialMediaAccounts
                        .Select(x => x.SocialNetworkProviderId)
                        .ToList();

                    if (socialMediaNetworkIds.Intersect(userFilter.SocialMediaNetworkIds).Count() != userFilter.SocialMediaNetworkIds.Count)
                    {
                        logger.Debug("Filter has social media accounts {FilterSocialMediaNetworkIds} but user has {UserSocialMediaNetworkIds}, so it does not satisfy filter", userFilter.SocialMediaNetworkIds, socialMediaNetworkIds);
                        return false;
                    }

                    if (userFilter.UserTypes.Count > 0)
                    {
                        var userType = user.Type.ToUserType();

                        if (!userFilter.UserTypes.Contains(userType))
                        {
                            logger.Debug("Filter has user types {FilterUserTypes} but user has user type {UserType}, so it does not satisfy filter", userFilter.UserTypes, userType);
                            return false;
                        }
                    }
                }

                if (user.CategoryIds.Intersect(filter.CategoryIds).Count() != filter.CategoryIds.Count)
                {
                    logger.Debug("Filter has category IDs {CategoryIds} but user has category IDs {UserCategoryIds}, so it does not satisfy filter", filter.CategoryIds, user.CategoryIds);
                    return false;
                }

                if (filter.NorthWest != null && filter.SouthEast != null)
                {
                    var geoPoint = user.Location?.GeoPoint;

                    if (geoPoint == null)
                    {
                        logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but user has no location, so it does not satisfy filter", filter.NorthWest, filter.SouthEast);
                        return false;
                    }

                    if (
                        geoPoint.Latitude > filter.NorthWest.Latitude ||
                        geoPoint.Longitude < filter.NorthWest.Longitude ||
                        geoPoint.Latitude < filter.SouthEast.Latitude ||
                        geoPoint.Longitude > filter.SouthEast.Longitude)
                    {
                        logger.Debug("Filter has geopoints {@NorthWest}-{@SouthEast} but user has geopoint {@OfferGeoPoint}, so it does not satisfy filter", filter.NorthWest, filter.SouthEast, user.Location.GeoPoint);
                        return false;
                    }
                }

                if (!string.IsNullOrWhiteSpace(filter.Phrase))
                {
                    var phraseKeywords = Keywords
                        .Extract(filter.Phrase)
                        .ToList();

                    if (user.Keywords.Intersect(phraseKeywords).Count() != phraseKeywords.Count)
                    {
                        logger.Debug("Filter has phrase {Phrase} equating to keywords {PhraseKeywords}, but user has keywords {UserKeywords}, so it does not satisfy filter", filter.Phrase, phraseKeywords, user.Keywords);
                        return false;
                    }
                }

                logger.Debug("User {@User} matches filter {@Filter}", user, filter);
                return true;
            }
        }
    }
}
