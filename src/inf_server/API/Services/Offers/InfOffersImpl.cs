using System;
using System.Fabric;
using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Offers.Interfaces;
using Serilog;
using static API.Interfaces.InfOffers;

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
                    var offersService = GetOffersService();
                    var userId = context.GetAuthenticatedUserId();
                    logger.Debug("Creating offer for user {UserId}: {@Offer}", userId, request.Offer);

                    var result = await offersService
                        .SaveOffer(request.Offer.ToServiceObject(userId))
                        .ContinueOnAnyContext();
                    logger.Debug("Saved offer for user {UserId}: {@Offer}", userId, result);

                    var response = new CreateOfferResponse
                    {
                        Offer = result.ToDto(),
                    };

                    return response;
                });

        public override Task<GetOfferResponse> GetOffer(GetOfferRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offersService = GetOffersService();
                    var offer = await offersService
                        .GetOffer(request.Id)
                        .ContinueOnAnyContext();
                    logger.Debug("Retrieved offer with ID {Id}: {@Offer}", request.Id, offer);

                    var response = new GetOfferResponse
                    {
                        Offer = offer.ToDto(),
                    };

                    return response;
                });

        public override Task ListOffers(IAsyncStreamReader<ListOffersRequest> requestStream, IServerStreamWriter<ListOffersResponse> responseStream, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var offersService = GetOffersService();

                    while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                    {
                        var request = requestStream.Current;
                        var continuationToken = request.Continuation.ContinuationCase == ContinuationDto.ContinuationOneofCase.ContinuationToken ? request.Continuation.ContinuationToken : null;
                        var result = await offersService
                            .ListOffers(continuationToken, request.PageSize)
                            .ContinueOnAnyContext();

                        var response = new ListOffersResponse
                        {
                            Continuation =
                                result.ContinuationToken == null ?
                                new ContinuationDto
                                {
                                    NonContinuationReason = ContinuationDto.Types.NonContinuationReason.LastPage,
                                } :
                                new ContinuationDto
                                {
                                    ContinuationToken = result.ContinuationToken,
                                },
                        };
                        response.Items.AddRange(result.Items.Select(item => item.ToDto()));
                        await responseStream
                            .WriteAsync(response)
                            .ContinueOnAnyContext();
                    }
                });

        private static IOffersService GetOffersService() =>
            ServiceProxy.Create<IOffersService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Offers"));
    }
}
