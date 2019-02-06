using System;
using System.Fabric;
using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Mapping.Interfaces;
using Microsoft.ServiceFabric.Services.Remoting.Client;
using Serilog;
using static API.Interfaces.InfMapping;

namespace API.Services.Mapping
{
    public sealed class InfMappingImpl : InfMappingBase
    {
        private readonly ILogger logger;

        public InfMappingImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfMappingImpl>();
        }

        public override Task SearchOffers(IAsyncStreamReader<SearchRequest> requestStream, IServerStreamWriter<SearchResponse> responseStream, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    var mappingService = GetMappingService();

                    while (await requestStream.MoveNext(context.CancellationToken).ContinueOnAnyContext())
                    {
                        var request = requestStream.Current;

                        var filter = new OfferSearchFilter(
                            request.MapLevel,
                            request.NorthWest.ToServiceObject(),
                            request.SouthEast.ToServiceObject());

                        logger.Debug("Searching for offers using filter {@Filter}", filter);
                        var results = await mappingService
                            .Search(filter)
                            .ContinueOnAnyContext();
                        var mapItems = results
                            .Select(
                                result =>
                                    new MapItemDto
                                    {
                                        GeoPoint = result.Location.ToDto(),
                                        Offer = result.ToDto(),
                                    })
                            .ToList();
                        logger.Debug("{Count} map items found matching filter {@Filter}", mapItems.Count, filter);

                        var response = new SearchResponse();
                        response.MapItems.AddRange(mapItems);
                        await responseStream
                            .WriteAsync(response)
                            .ContinueOnAnyContext();
                    }
                });

        private static IMappingService GetMappingService() =>
            ServiceProxy.Create<IMappingService>(new Uri($"{FabricRuntime.GetActivationContext().ApplicationName}/Mapping"));
    }
}
