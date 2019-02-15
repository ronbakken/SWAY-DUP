using System.Threading.Tasks;
using AutoMapper;
using Users.Interfaces;
using Utility;

namespace Users
{
    internal static class Program
    {
        private static async Task Main()
        {
            await ServiceBootstrapper
                .Bootstrap(
                    "Users",
                    context => new Users(context),
                    (config) =>
                    {
                        config
                            .CreateMap<UserData, UserDataEntity>()
                            .ForMember(
                                x => x.SchemaVersion,
                                options => options.MapFrom((_) => 1))
                            .ForMember(
                                x => x.Keywords,
                                options => options.Ignore())
                            .ReverseMap();

                        config
                            .CreateMap<UserSession, UserSessionEntity>()
                            .ForMember(
                                x => x.SchemaVersion,
                                options => options.MapFrom((_) => 1))
                            .ForMember(
                                x => x.Id,
                                options => options.Ignore())
                            .ForMember(
                                x => x.UserId,
                                options => options.Ignore())
                            .ReverseMap();

                        config.MapRepeatedFields();
                    })
                .ContinueOnAnyContext();
        }
    }
}
