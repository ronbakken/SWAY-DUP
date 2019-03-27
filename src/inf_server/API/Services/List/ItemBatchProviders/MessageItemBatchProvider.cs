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
    public sealed class MessageItemBatchProvider : ItemBatchProvider
    {
        public static readonly MessageItemBatchProvider Instance = new MessageItemBatchProvider();

        private MessageItemBatchProvider()
        {
        }

        public override string Name => "Message";

        public override async Task<ItemBatch> GetItemBatch(ILogger logger, AuthenticatedUserType userType, ItemFilterDto filter, int pageSize, string continuationToken)
        {
            logger = logger.ForContext<MessageItemBatchProvider>();

            if (continuationToken == "")
            {
                return null;
            }

            var messagingService = await GetMessagingServiceClient().ContinueOnAnyContext();

            var request = new ListMessagesRequest
            {
                PageSize = pageSize,
                ContinuationToken = continuationToken ?? "",
                Filter = ToMessagesFilter(userType, filter),
            };
            var response = await messagingService
                .ListMessagesAsync(request);
            var items = response
                .Messages
                .Select(message => message.ToItemDto())
                .ToList();
            var result = new ItemBatch(
                items,
                response.ContinuationToken);

            return result;
        }

        private static ListMessagesRequest.Types.Filter ToMessagesFilter(AuthenticatedUserType userType, ItemFilterDto itemFilter)
        {
            var messagesFilter = new ListMessagesRequest.Types.Filter();

            if (itemFilter.MessageFilter != null)
            {
                messagesFilter.ConversationId = itemFilter.MessageFilter.ConversationId;
            }

            return messagesFilter;
        }

        private static Task<MessagingServiceClient> GetMessagingServiceClient() =>
            APIClientResolver.Resolve<MessagingServiceClient>("Messaging");
    }
}
