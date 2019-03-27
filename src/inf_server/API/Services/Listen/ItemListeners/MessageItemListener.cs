using System;
using System.Collections.Immutable;
using System.Linq;
using System.Reactive;
using System.Reactive.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using Messaging.Interfaces;
using Serilog;
using Utility.gRPC;
using static Messaging.Interfaces.MessagingService;

namespace API.Services.Listen.ItemListeners
{
    public sealed class MessageItemListener : ItemListener<Message>
    {
        private IDisposable subscription;

        public MessageItemListener(
            ILogger logger,
            string userId) : base(logger, userId)
        {
        }

        public override IObservable<Message> GetMatchingItems(
            IObservable<Message> items,
            IObservable<ImmutableList<SingleItemFilterDto>> singleItemFilters,
            IObservable<ImmutableList<ItemFilterDto>> itemFilters)
        {
            var publishedItemFilters = itemFilters.Publish();

            // Make sure that the messaging service is kept up to date with what conversations are being listened to,
            // so it knows whether it needs to send notifications to users or not.
            Observable
                .Zip(
                    publishedItemFilters.StartWith(ImmutableList<ItemFilterDto>.Empty),
                    publishedItemFilters,
                    (previous, current) =>
                    {
                        var previousIds = previous
                            .Where(x => x.MessageFilter != null)
                            .Select(x => x.MessageFilter.ConversationId)
                            .ToList();
                        var currentIds = current
                            .Where(x => x.MessageFilter != null)
                            .Select(x => x.MessageFilter.ConversationId)
                            .ToList();

                        var idsAdded = currentIds.Except(previousIds).ToImmutableList();
                        var idsRemoved = previousIds.Except(currentIds).ToImmutableList();

                        return (idsAdded, idsRemoved);
                    })
                .Where(ids => ids.idsAdded.Count > 0 || ids.idsRemoved.Count > 0)
                .SelectMany(
                    async ids =>
                    {
                        this.Logger.Debug("Kicking off register conversation listener tasks for conversation IDs {RegisterConversationIds} and deregister conversation listener tasks for conversation IDs {DeregisterConversationIds}", ids.idsAdded, ids.idsRemoved);

                        var messagingClient = await GetMessagingServiceClient().ContinueOnAnyContext();

                        var registerTasks = ids
                            .idsAdded
                            .Select(idAdded => messagingClient.RegisterConversationListenerAsync(new RegisterConversationListenerRequest { UserId = this.UserId, ConversationId = idAdded }).ResponseAsync);
                        var deregisterTasks = ids
                            .idsRemoved
                            .Select(idAdded => messagingClient.DeregisterConversationListenerAsync(new DeregisterConversationListenerRequest { UserId = this.UserId, ConversationId = idAdded }).ResponseAsync);

                        await Task
                            .WhenAll(registerTasks.Concat(deregisterTasks))
                            .ContinueOnAnyContext();

                        return Unit.Default;
                    })
                .Catch<Unit, Exception>(
                    ex =>
                    {
                        this.Logger.Error(ex, "Failed to update registered conversation listeners");
                        return Observable.Return(Unit.Default);
                    })
                .Subscribe(
                    _ => { },
                    ex => this.Logger.Error("Conversation listener registration pipeline failed"));

            this.subscription = publishedItemFilters.Connect();

            return base.GetMatchingItems(items, singleItemFilters, itemFilters);
        }

        public override void Dispose()
        {
            this.subscription?.Dispose();
            base.Dispose();
        }

        protected override bool IsMatch(Message message, SingleItemFilterDto filter)
        {
            this.Logger.Debug("Determining if message {@Message} matches single-item filter {Filter}", message, filter);

            if (string.Equals(filter.Id, message.Id, StringComparison.Ordinal))
            {
                this.Logger.Debug("Message has ID {MessageId}, which matches filter", message.Id);
                return true;
            }

            this.Logger.Debug("Message has ID {MessageId}, which does not match filter's ID of {FilterId}", message.Id, filter.Id);
            return false;
        }

        protected override bool IsMatch(Message message, ItemFilterDto filter)
        {
            this.Logger.Debug("Determining if message {@Message} matches item filter {@Filter}", message, filter);

            var messageFilter = filter.MessageFilter;

            if (messageFilter == null)
            {
                this.Logger.Debug("No message filter provided, so no match");
                return false;
            }

            if (!string.IsNullOrEmpty(messageFilter.ConversationId))
            {
                if (!string.Equals(message.ConversationId, messageFilter.ConversationId, StringComparison.Ordinal))
                {
                    this.Logger.Debug("Filter has conversation ID {@FilterConversationId} but message has conversation ID {ConversationId}, so it does not satisfy filter", messageFilter.ConversationId, message.ConversationId);
                    return false;
                }
            }

            this.Logger.Debug("Message {@Message} matches filter {@Filter}", message, filter);
            return true;
        }

        private static Task<MessagingServiceClient> GetMessagingServiceClient() =>
            APIClientResolver.Resolve<MessagingServiceClient>("Messaging");
    }
}
