using System.Threading.Tasks;
using AutoMapper;
using Mapping.Interfaces;
using Offers.Interfaces;
using Utility;

namespace Mapping
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap(
                    "Mapping",
                    context => new Mapping(context),
                    config =>
                    {
                        config
                            .CreateMap<Offer, MapItemEntity>()
                            .ForMember(
                                x => x.SchemaVersion,
                                options => options.MapFrom((_) => 1))
                            .ForMember(
                                x => x.QuadKey,
                                options => options.Ignore())
                            .ReverseMap();

                        config
                            .CreateMap<MapItemEntity, MapItem>()
                            .ConvertUsing(
                                (source, _, context) =>
                                {
                                    return new MapItem
                                    {
                                        GeoPoint = context.Mapper.Map<Interfaces.GeoPoint>(source.GeoPoint),
                                        Status = context.Mapper.Map<MapItem.Types.Status>(source.Status),
                                        Offer = new OfferMapItem
                                        {
                                            OfferId = source.Id,
                                            UserId = source.UserId,
                                        }
                                    };
                                });

                        config.MapRepeatedFields();
                    })
                .ContinueOnAnyContext();
        }
    }
}
