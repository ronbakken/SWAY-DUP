using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Offers.Interfaces;
using Serilog;
using Utility.gRPC;
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
            logger = logger.ForContext<OfferItemBatchProvider>();

            if (continuationToken == "")
            {
                return null;
            }

            var offersService = GetOffersServiceClient();

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

            offersFilter.CategoryIds.AddRange(itemFilter.OfferFilter.CategoryIds);
            offersFilter.NorthWest = itemFilter.OfferFilter.NorthWest.ToOffersGeoPoint();
            offersFilter.SouthEast = itemFilter.OfferFilter.SouthEast.ToOffersGeoPoint();
            offersFilter.Phrase = itemFilter.OfferFilter.Phrase;
            offersFilter.BusinessAccountId = itemFilter.OfferFilter.BusinessAccountId;
            offersFilter.DeliverableTypes.AddRange(itemFilter.OfferFilter.DeliverableTypes.Select(x => x.ToDeliverableType()));
            offersFilter.MinimumRewardCash = itemFilter.OfferFilter.MinimumRewardCash.ToOffersMoney();
            offersFilter.MinimumRewardService = itemFilter.OfferFilter.MinimumRewardService.ToOffersMoney();
            offersFilter.OfferAcceptancePolicies.AddRange(itemFilter.OfferFilter.AcceptancePolicies.Select(x => x.ToOfferAcceptancePolicy()));
            offersFilter.OfferStatuses.AddRange(itemFilter.OfferFilter.OfferStatuses.Select(x => x.ToOfferStatus()));

            return offersFilter;
        }

        private static OffersServiceClient GetOffersServiceClient() =>
            APIClientResolver.Resolve<OffersServiceClient>("offers", 9030);
    }
}
