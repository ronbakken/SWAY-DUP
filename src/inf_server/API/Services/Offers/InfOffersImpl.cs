using System.Threading.Tasks;
using API.Interfaces;
using API.ObjectMapping;
using Grpc.Core;
using Offers.Interfaces;
using Serilog;
using Utility;
using static API.Interfaces.InfOffers;
using static Offers.Interfaces.OffersService;
using api = API.Interfaces;
using offers = Offers.Interfaces;

namespace API.Services.Offers
{
    public sealed class InfOffersImpl : InfOffersBase
    {
        private readonly ILogger logger;

        public InfOffersImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfOffersImpl>();
        }

        public override Task<UpdateOfferResponse> UpdateOffer(UpdateOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offersService = await GetOffersServiceClient().ContinueOnAnyContext();
                    var userId = context.GetAuthenticatedUserId();
                    logger.Debug("Updating offer for user {UserId}: {@Offer}", userId, request.Offer);

                    var offerDto = request.Offer;
                    var offer = offerDto.ToOffer();
                    // TODO: should maybe assert that the business account ID is either empty or the current user's ID? Set it if empty.
                    //offer.BusinessAccountId = userId;

                    var result = await offersService
                        .SaveOfferAsync(new SaveOfferRequest { Offer = offer });
                    logger.Debug("Saved offer for user {UserId}: {@Offer}", userId, result);

                    var response = new UpdateOfferResponse
                    {
                        Offer = result.Offer.ToOfferDto(OfferDto.DataOneofCase.Full),
                    };

                    return response;
                });

        public override Task<api.GetOfferResponse> GetOffer(api.GetOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offersService = await GetOffersServiceClient().ContinueOnAnyContext();
                    var getOfferRequest = new offers.GetOfferRequest
                    {
                        Id = request.Id,
                        UserId = request.UserId,
                    };
                    var getOfferResponse = await offersService
                        .GetOfferAsync(getOfferRequest);
                    var offer = getOfferResponse.Offer;
                    logger.Debug("Retrieved offer with ID {Id}: {@Offer}", request.Id, offer);

                    var response = new api.GetOfferResponse
                    {
                        Offer = getOfferResponse.Offer.ToOfferDto(OfferDto.DataOneofCase.Full),
                    };

                    return response;
                });

        private static Task<OffersServiceClient> GetOffersServiceClient() =>
            APIClientResolver.Resolve<OffersServiceClient>("Offers");
    }
}
