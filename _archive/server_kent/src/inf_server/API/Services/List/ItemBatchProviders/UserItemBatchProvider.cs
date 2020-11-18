using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Serilog;
using Users.Interfaces;
using Utility.gRPC;
using static Users.Interfaces.UsersService;

namespace API.Services.List.ItemBatchProviders
{
    public sealed class UserItemBatchProvider : ItemBatchProvider
    {
        public static readonly UserItemBatchProvider Instance = new UserItemBatchProvider();

        private UserItemBatchProvider()
        {
        }

        public override string Name => "User";

        public override async Task<ItemBatch> GetItemBatch(ILogger logger, AuthenticatedUserType userType, ItemFilterDto filter, int pageSize, string continuationToken)
        {
            logger = logger.ForContext<UserItemBatchProvider>();

            if (continuationToken == "")
            {
                logger.Debug("Continuation token is empty");
                return null;
            }

            logger.Debug("Continuation token is {ContinuationToken}", continuationToken);
            var usersService = GetUsersServiceClient();

            var request = new ListUsersRequest
            {
                PageSize = pageSize,
                ContinuationToken = continuationToken ?? "",
                Filter = ToUsersFilter(userType, filter),
            };

            var response = await usersService
                .ListUsersAsync(request);
            var items = response
                .Users
                .Select(user => user.ToItemDto(UserDto.DataOneofCase.List))
                .ToList();
            var result = new ItemBatch(
                items,
                response.ContinuationToken);

            logger.Debug("Returning {Count} items with continuation token {ContinuationToken}", items.Count, continuationToken);

            return result;
        }

        private static ListUsersRequest.Types.Filter ToUsersFilter(AuthenticatedUserType userType, ItemFilterDto itemFilter)
        {
            var usersFilter = new ListUsersRequest.Types.Filter();

            usersFilter.CategoryIds.AddRange(itemFilter.UserFilter.CategoryIds);
            usersFilter.NorthWest = itemFilter.UserFilter.NorthWest.ToUsersGeoPoint();
            usersFilter.SouthEast = itemFilter.UserFilter.SouthEast.ToUsersGeoPoint();
            usersFilter.Phrase = itemFilter.UserFilter.Phrase;
            usersFilter.MinimumValue = itemFilter.UserFilter.MinimumValue.ToMoney();
            usersFilter.MaximumValue = itemFilter.UserFilter.MaximumValue.ToMoney();
            usersFilter.SocialMediaNetworkIds.AddRange(itemFilter.UserFilter.SocialMediaNetworkIds);
            usersFilter.UserTypes.AddRange(itemFilter.UserFilter.UserTypes.Select(x => x.ToUserType()));

            // Apply a safety net to ensure influencers cannot see other influencers, and businesses cannot see other businesses
            if (userType == AuthenticatedUserType.Influencer)
            {
                usersFilter.UserTypes.Remove(global::Users.Interfaces.UserType.Influencer);

                if (usersFilter.UserTypes.Count == 0)
                {
                    usersFilter.UserTypes.Add(global::Users.Interfaces.UserType.Business);
                }
            }

            if (userType == AuthenticatedUserType.Business)
            {
                usersFilter.UserTypes.Remove(global::Users.Interfaces.UserType.Business);

                if (usersFilter.UserTypes.Count == 0)
                {
                    usersFilter.UserTypes.Add(global::Users.Interfaces.UserType.Influencer);
                }
            }

            return usersFilter;
        }

        private static UsersServiceClient GetUsersServiceClient() =>
            APIClientResolver.Resolve<UsersServiceClient>("users", 9031);
    }
}
