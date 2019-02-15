using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using AutoMapper;
using Grpc.Core;
using Offers.Interfaces;
using Serilog;
using Utility;
using static API.Interfaces.InfOffers;
using static Offers.Interfaces.OffersService;
using api = API.Interfaces;

namespace API.Services.Offers
{
    public sealed class InfOffersImpl : InfOffersBase
    {
        private readonly ILogger logger;

        public InfOffersImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfOffersImpl>();
        }

        public override Task<CreateOfferResponse> CreateOffer(CreateOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offersService = await GetOffersServiceClient().ContinueOnAnyContext();
                    var userId = context.GetAuthenticatedUserId();
                    logger.Debug("Creating offer for user {UserId}: {@Offer}", userId, request.Offer);

                    var offerDto = request.Offer;
                    var offer = Mapper.Map<Offer>(offerDto);
                    offer.UserId = userId;

                    var result = await offersService
                        .SaveOfferAsync(new SaveOfferRequest { Offer = offer });
                    logger.Debug("Saved offer for user {UserId}: {@Offer}", userId, result);

                    var response = new CreateOfferResponse
                    {
                        Offer = Mapper.Map<OfferDto>(result.Offer),
                    };

                    return response;
                });

        public override Task<api.GetOfferResponse> GetOffer(api.GetOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offersService = await GetOffersServiceClient().ContinueOnAnyContext();
                    var offer = await offersService
                        .GetOfferAsync(Mapper.Map<global::Offers.Interfaces.GetOfferRequest>(request));
                    logger.Debug("Retrieved offer with ID {Id}: {@Offer}", request.Id, offer);

                    var response = new api.GetOfferResponse
                    {
                        Offer = Mapper.Map<OfferDto>(offer),
                    };

                    return response;
                });

        public override Task ListOffers(IAsyncStreamReader<api.ListOffersRequest> requestStream, IServerStreamWriter<api.ListOffersResponse> responseStream, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offersService = await GetOffersServiceClient().ContinueOnAnyContext();

                    while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                    {
                        var request = requestStream.Current;
                        var continuationToken = request.Continuation.ContinuationCase == ContinuationDto.ContinuationOneofCase.ContinuationToken ? request.Continuation.ContinuationToken : null;
                        var result = await offersService
                            .ListOffersAsync(Mapper.Map<global::Offers.Interfaces.ListOffersRequest>(request));

                        var response = new api.ListOffersResponse
                        {
                            Continuation =
                                string.IsNullOrEmpty(result.ContinuationToken) ?
                                new ContinuationDto
                                {
                                    NonContinuationReason = ContinuationDto.Types.NonContinuationReason.LastPage,
                                } :
                                new ContinuationDto
                                {
                                    ContinuationToken = result.ContinuationToken,
                                },
                        };
                        response.Items.AddRange(result.Offers.Select(item => Mapper.Map<OfferDto>(item)));
                        await responseStream
                            .WriteAsync(response)
                            .ContinueOnAnyContext();
                    }
                });

        private static Task<OffersServiceClient> GetOffersServiceClient() =>
            APIClientResolver.Resolve<OffersServiceClient>("Offers");
    }
}
