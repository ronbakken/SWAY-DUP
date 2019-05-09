using System;
using System.Collections.Immutable;
using System.Linq;
using System.Reactive.Linq;
using API.Interfaces;
using API.ObjectMapping;
using Messaging.Interfaces;
using Serilog;

namespace API.Services.Listen.ItemListeners
{
    public sealed class ConversationItemListener : ItemListener<Conversation>
    {
        public ConversationItemListener(
            ILogger logger,
            string userId) : base(logger, userId)
        {
        }

        protected override bool IsMatch(Conversation conversation, SingleItemFilterDto filter)
        {
            this.Logger.Debug("Determining if conversation {@Conversation} matches single-item filter {Filter}", conversation, filter);

            if (string.Equals(filter.Id, conversation.Id, StringComparison.Ordinal))
            {
                this.Logger.Debug("Conversation has ID {ConversationId}, which matches filter", conversation.Id);
                return true;
            }

            this.Logger.Debug("Conversation has ID {ConversationId}, which does not match filter's ID of {FilterId}", conversation.Id, filter.Id);
            return false;
        }

        protected override bool IsMatch(Conversation conversation, ItemFilterDto filter)
        {
            this.Logger.Debug("Determining if conversation {@Conversation} matches item filter {@Filter}", conversation, filter);

            var conversationFilter = filter.ConversationFilter;

            if (conversationFilter == null)
            {
                this.Logger.Debug("No conversation filter provided, so no match");
                return false;
            }

            if (!string.IsNullOrEmpty(conversationFilter.ParticipatingUserId))
            {
                if (!string.Equals(conversation.UserId, conversationFilter.ParticipatingUserId, StringComparison.Ordinal))
                {
                    this.Logger.Debug("Filter has participating user ID {@ParticipatingUserId} but conversation has user ID {UserId}, so it does not satisfy filter", conversationFilter.ParticipatingUserId, conversation.UserId);
                    return false;
                }
            }

            if (!string.IsNullOrWhiteSpace(conversationFilter.TopicId))
            {
                if (!string.Equals(conversation.TopicId, conversationFilter.TopicId, StringComparison.Ordinal))
                {
                    this.Logger.Debug("Filter has topic ID {TopicId} but conversation has {ConversationTopicIdId}, so it does not satisfy filter", conversationFilter.TopicId, conversation.TopicId);
                    return false;
                }
            }

            if (conversationFilter.ConversationStatuses.Count > 0)
            {
                var conversationStatus = conversation.Status.ToStatus();

                if (!conversationFilter.ConversationStatuses.Contains(conversationStatus))
                {
                    this.Logger.Debug("Filter has conversation statuses {ConversationStatuses} but conversation has status {ConversationStatus}, so it does not satisfy filter", conversationFilter.ConversationStatuses, conversationStatus);
                    return false;
                }
            }

            this.Logger.Debug("Conversation {@Conversation} matches filter {@Filter}", conversation, filter);
            return true;
        }
    }
}
