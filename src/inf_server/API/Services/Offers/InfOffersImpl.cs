using System;
using System.Fabric;
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

                    var result = await offersService.SaveOffer(request.Offer.ToServiceObject(userId));
                    logger.Debug("Saved offer for user {UserId}: {@Offer}", userId, result);

                    var response = new CreateOfferResponse
                    {
                        Offer = result.ToDto(),
                    };

                    return response;
                });

        private static IOffersService GetOffersService() =>
            ServiceProxy.Create<IOffersService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Offers"));
    }
}
