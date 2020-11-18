using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Messaging.Interfaces;
using Serilog;
using Utility.gRPC;
using static Messaging.Interfaces.MessagingService;

namespace API.Services.List.ItemBatchProviders
{
    public sealed class ConversationItemBatchProvider : ItemBatchProvider
    {
        public static readonly ConversationItemBatchProvider Instance = new ConversationItemBatchProvider();

        private ConversationItemBatchProvider()
        {
        }

        public override string Name => "Conversation";

        public override async Task<ItemBatch> GetItemBatch(ILogger logger, AuthenticatedUserType userType, ItemFilterDto filter, int pageSize, string continuationToken)
        {
            logger = logger.ForContext<ConversationItemBatchProvider>();

            if (continuationToken == "")
            {
                return null;
            }

            var messagingService = GetMessagingServiceClient();

            var request = new ListConversationsRequest
            {
                PageSize = pageSize,
                ContinuationToken = continuationToken ?? "",
                Filter = ToConversationsFilter(userType, filter),
            };
            var response = await messagingService
                .ListConversationsAsync(request);
            var items = response
                .Conversations
                .Select(conversation => conversation.ToItemDto())
                .ToList();
            var result = new ItemBatch(
                items,
                response.ContinuationToken);

            return result;
        }

        private static ListConversationsRequest.Types.Filter ToConversationsFilter(AuthenticatedUserType userType, ItemFilterDto itemFilter)
        {
            var conversationsFilter = new ListConversationsRequest.Types.Filter();

            if (itemFilter.ConversationFilter != null)
            {
                conversationsFilter.UserId = itemFilter.ConversationFilter.ParticipatingUserId;
                conversationsFilter.TopicId = itemFilter.ConversationFilter.TopicId;
                conversationsFilter.ConversationStatuses.AddRange(itemFilter.ConversationFilter.ConversationStatuses.Select(x => x.ToConversationStatus()));
            }

            return conversationsFilter;
        }

        private static MessagingServiceClient GetMessagingServiceClient() =>
            APIClientResolver.Resolve<MessagingServiceClient>("messaging", 9029);
    }
}
