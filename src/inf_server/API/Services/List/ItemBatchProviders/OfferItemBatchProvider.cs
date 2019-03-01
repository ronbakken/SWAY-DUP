using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Offers.Interfaces;
using Serilog;
using Utility;
using static Offers.Interfaces.OffersService;

namespace API.Services.List.ItemBatchProviders
{
    public sealed class OfferItemBatchProvider : ItemBatchProvider
    {
        public static readonly OfferItemBatchProvider Instance = new OfferItemBatchProvider();

        private OfferItemBatchProvider()
        {
        }

        public override string Name => "Offer";

        public override async Task<ItemBatch> GetItemBatch(ILogger logger, AuthenticatedUserType userType, ItemFilterDto filter, int pageSize, string continuationToken)
        {
            logger = logger.ForContext<UserItemBatchProvider>();

            if (continuationToken == "")
            {
                return null;
            }

            var offersService = await GetOffersServiceClient().ContinueOnAnyContext();

            var request = new ListOffersRequest
            {
                PageSize = pageSize,
                ContinuationToken = continuationToken ?? "",
                Filter = ToOffersFilter(userType, filter),
            };
            var response = await offersService
                .ListOffersAsync(request);
            var items = response
                .Offers
                .Select(offer => offer.ToItemDto(OfferDto.DataOneofCase.List))
                .ToList();
            var result = new ItemBatch(
                items,
                response.ContinuationToken);

            return result;
        }

        private static ListOffersRequest.Types.Filter ToOffersFilter(AuthenticatedUserType userType, ItemFilterDto itemFilter)
        {
            var offersFilter = new ListOffersRequest.Types.Filter();

            offersFilter.CategoryIds.AddRange(itemFilter.CategoryIds);
            offersFilter.NorthWest = itemFilter.NorthWest.ToOffersGeoPoint();
            offersFilter.SouthEast = itemFilter.SouthEast.ToOffersGeoPoint();
            offersFilter.Phrase = itemFilter.Phrase;

            if (itemFilter.OfferFilter != null)
            {
                offersFilter.BusinessAccountId = itemFilter.OfferFilter.BusinessAccountId;
                offersFilter.DeliverableTypes.AddRange(itemFilter.OfferFilter.DeliverableTypes.Select(x => x.ToDeliverableType()));
                offersFilter.MinimumReward = itemFilter.OfferFilter.MinimumReward.ToOffersMoney();
                offersFilter.OfferAcceptancePolicies.AddRange(itemFilter.OfferFilter.AcceptancePolicies.Select(x => x.ToOfferAcceptancePolicy()));
                offersFilter.OfferStatuses.AddRange(itemFilter.OfferFilter.OfferStatuses.Select(x => x.ToOfferStatus()));
                offersFilter.RewardTypes.AddRange(itemFilter.OfferFilter.RewardTypes.Select(x => x.ToRewardType()));
            }

            return offersFilter;
        }

        private static Task<OffersServiceClient> GetOffersServiceClient() =>
            APIClientResolver.Resolve<OffersServiceClient>("Offers");
    }
}
