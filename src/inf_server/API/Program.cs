using System;
using System.Threading.Tasks;
using API.Interfaces;
using AutoMapper;
using Google.Protobuf.Collections;
using Mapping.Interfaces;
using Offers.Interfaces;
using Users.Interfaces;
using Utility;
using api = API.Interfaces;

namespace API
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap(
                    "API",
                    context => new API(context),
                    config =>
                    {
                        // Auth

                        config
                            .CreateMap<Image, ImageDto>()
                            .ForMember(
                                x => x.Url,
                                options => options.MapFrom(x => x.Uri))
                            .ReverseMap();

                        config
                            .CreateMap<SocialMediaAccount, SocialMediaAccountDto>()
                            .ForMember(
                                x => x.Verified,
                                options => options.MapFrom(x => x.IsVerified))
                            .ForMember(
                                x => x.ProfileUrl,
                                options => options.MapFrom(x => x.ProfileUri))
                            .ReverseMap();

                        config
                            .CreateMap<UserData, UserDto>()
                            .ForMember(
                                x => x.AccountState,
                                options => options.MapFrom(x => x.Status))
                            .ForMember(
                                x => x.UserType,
                                options => options.MapFrom(x => x.Type))
                            .ForMember(
                                x => x.Verified,
                                options => options.MapFrom(x => x.IsVerified))
                            .ForMember(
                                x => x.WebsiteUrl,
                                options => options.MapFrom(x => x.WebsiteUri))
                            .ReverseMap();

                        // Mapping
                        config
                            .CreateMap<api.SearchRequest, Mapping.Interfaces.SearchFilter>()
                            .ForMember(
                                x => x.QuadKey,
                                options => options.Ignore());

                        config
                            .CreateMap<MapItem, MapItemDto>()
                            .ForMember(
                                x => x.Cluster,
                                options => options.Ignore());

                        // Offers
                        config
                            .CreateMap<Offers.Interfaces.ListOffersRequest, api.ListOffersRequest>()
                            .ForMember(
                                x => x.Continuation,
                                options => options.MapFrom(
                                    (source, destination, member, context) =>
                                    {
                                        if (string.IsNullOrEmpty(source.ContinuationToken))
                                        {
                                            return new ContinuationDto
                                            {
                                                NonContinuationReason = ContinuationDto.Types.NonContinuationReason.LastPage,
                                            };
                                        }

                                        return new ContinuationDto
                                        {
                                            ContinuationToken = source.ContinuationToken,
                                        };
                                    }))
                            .ReverseMap();

                        // General
                        config.MapRepeatedFields();
                    })
                .ContinueOnAnyContext();
        }
    }
}
