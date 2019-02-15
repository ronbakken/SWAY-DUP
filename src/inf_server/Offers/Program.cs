using System;
using System.Threading.Tasks;
using AutoMapper;
using Google.Protobuf.WellKnownTypes;
using Offers.Interfaces;
using Utility;

namespace Offers
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap(
                    "Offers",
                    context => new Offers(context),
                    config =>
                    {
                        config
                            .CreateMap<Offer, OfferEntity>()
                            .ForMember(
                                x => x.SchemaVersion,
                                options => options.MapFrom((_) => 1))
                            .ForMember(
                                x => x.StatusTimestamp,
                                options => options.MapFrom((_) => Timestamp.FromDateTime(DateTime.UtcNow)))
                            .ReverseMap();

                        config.MapRepeatedFields();
                    })
                .ContinueOnAnyContext();
        }
    }
}
