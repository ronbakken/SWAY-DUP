using System;
using System.Collections.Generic;
using System.Fabric;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Mapping.Interfaces;
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

        public override Task<SearchOffersResponse> SearchOffers(SearchOffersRequest request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var mappingService = GetMappingService();
                    var filter = new OfferSearchFilter(
                        request.MapLevel,
                        request.NorthWest.ToServiceObject(),
                        request.SouthEast.ToServiceObject());

                    logger.Debug("Searching for offers using filter {@Filter}", filter);
                    var results = await mappingService
                        .Search(filter)
                        .ContinueOnAnyContext();
                    var resultDtos = results
                        .Select(result => result.ToDto())
                        .ToList();
                    logger.Debug("{Count} offers found matching filter {@Filter}", resultDtos.Count, filter);

                    var response = new SearchOffersResponse();
                    response.OfferMapItems.AddRange(resultDtos);

                    return response;
                });

        private static IMappingService GetMappingService() =>
            ServiceProxy.Create<IMappingService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Mapping"));

        private static IOffersService GetOffersService() =>
            ServiceProxy.Create<IOffersService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Offers"));
    }
}
