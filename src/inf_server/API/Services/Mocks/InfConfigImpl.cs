using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using API.Interfaces;
using Grpc.Core;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Serilog;
using Utility;

namespace API.Services.Mocks
{
    public sealed class InfConfigImpl : InfConfig.InfConfigBase
    {
        private readonly ILogger logger;

        public InfConfigImpl(ILogger logger)
        {
            this.logger = logger.ForContext<InfConfigImpl>();
        }

        public override Task<GetAppConfigResponse> GetAppConfig(Empty request, ServerCallContext context) =>
            APISanitizer.Sanitize(
                this.logger,
                async (logger) =>
                {
                    CategoryDto CategoryJObjectToDto(JToken token)
                    {
                        var id = token["id"].Value<string>();
                        var name = token["name"].Value<string>();
                        var parentId = token["parentId"]?.Value<string>();

                        var category = new CategoryDto
                        {
                            Id = id,
                            Name = name,
                            ParentId = parentId ?? "",
                        };

                        if (parentId == null)
                        {
                            var iconResourceName = $"./icons/{name.ToLowerInvariant()}.svg";
                            logger.Debug("Loading icon with resource name {IconResourceName}", iconResourceName);
                            category.IconData = MockHelpers.ReadIconData(iconResourceName);
                        }

                        return category;
                    }

                    List<CategoryDto> categories = null;

                    using (var categoriesStream = this.GetType().Assembly.GetManifestResourceStream("API.Services.Mocks.categories.json"))
                    using (var categoriesTextReader = new StreamReader(categoriesStream))
                    using (var categoriesJsonReader = new JsonTextReader(categoriesTextReader))
                    {
                        var categoriesArray = await JArray.LoadAsync(categoriesJsonReader);
                        categories = categoriesArray
                            .Select(CategoryJObjectToDto)
                            .ToList();
                    }

                    var config = new AppConfigDto
                    {
                        ConfigVersion = 2,
                        PrivacyPolicyUrl = "https://www.swaymarketplace.com/privacy",
                        TermsOfServiceUrl = "https://www.swaymarketplace.com/terms",
                        ServiceConfig = new ServiceConfigDto
                        {
                            MapboxToken =
                                "pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqa2pkOThmdzFha2IzcG16aHl4M3drNTcifQ.jtaEoGuiomNgllDjUMCwNQ",
                            MapboxUrlTemplateDark = "https://api.tiles.mapbox.com/v4/mapbox.dark/{z}/{x}/{y}@2x.png" +
                                                    "?access_token={accessToken}"
                        },
                        SocialNetworkProviders =
                        {
                            new SocialNetworkProviderDto
                            {
                                Id = "0",
                                Type = SocialNetworkProviderType.Instagram,
                                LogoColoredData = MockHelpers.ReadIconData("./icons/logo_instagram.png"),
                                LogoMonochromeData =
                                    MockHelpers.ReadIconData(
                                        "./icons/logo_instagram_monochrome.svg"),
                                LogoBackgroundData =
                                    MockHelpers.ReadIconData("./icons/instagram_background.png"),
                                Name = "Instagram",
                                ApiKey ="ce0aaa7e065f4d6cbbb85055ce98cdfc"
                            },
                            new SocialNetworkProviderDto
                            {
                                Id = "1",
                                Type = SocialNetworkProviderType.Facebook,
                                LogoColoredData = MockHelpers.ReadIconData("./icons/logo_facebook.svg"),
                                LogoMonochromeData =
                                    MockHelpers.ReadIconData(
                                        "./icons/logo_facebook_monochrome.svg"),
                                LogoBackGroundColor = 0xff4e71a8,
                                Name = "Facebook",
                                ApiKey="524476418041715"
                            },
                            new SocialNetworkProviderDto
                            {
                                Id = "2",
                                Type = SocialNetworkProviderType.Twitter,
                                LogoColoredData = MockHelpers.ReadIconData("./icons/logo_twitter.svg"),
                                LogoBackGroundColor = 0xff54ADEE,
                                LogoMonochromeData =
                                    MockHelpers.ReadIconData(
                                        "./icons/logo_twitter_monochrome.svg"),
                                Name = "Twitter",
                                ApiKey = "yebVfiIgUGwg0Ij5FwooEW5xE",
                                ApiKeySecret = "iaAfdlnXarC240VhgReeEXZxXyH1RqkidBVGNNS9gGouIiL2Cy"
                            },
                            new SocialNetworkProviderDto
                            {
                                Id = "3",
                                Type = SocialNetworkProviderType.YouTube,
                                LogoMonochromeData =
                                    MockHelpers.ReadIconData(
                                        "./icons/logo_youtube_monochrome.svg"),
                                LogoBackGroundColor = 0xffed1f24,
                                Name = "YouTube"
                            },
                            new SocialNetworkProviderDto
                            {
                                Id = "4",
                                Type = SocialNetworkProviderType.Snapchat,
                                LogoMonochromeData =
                                    MockHelpers.ReadIconData(
                                        "./icons/logo_snapchat_monochrome.svg"),
                                LogoBackGroundColor = 0xfffffc00,
                                Name = "Snapchat"
                            },
                            new SocialNetworkProviderDto
                            {
                                Id = "5",
                                Type = SocialNetworkProviderType.CustomSocialnetWorkProvider,
                                LogoBackGroundColor = 0xfffb8f30,
                                LogoMonochromeData = MockHelpers.ReadIconData("./icons/logo_custom_deliverable.svg"),
                                Name = "Custom"
                            },
                        },
                        DeliverableIcons =
                        {
                            new DeliverableIconDto
                            {
                                Name = "Post",
                                DeliverableType = DeliverableType.Post,
                                IconData = MockHelpers.ReadIconData("./icons/post_icon.svg")

                            },
                            new DeliverableIconDto
                            {
                                Name = "Mention",
                                DeliverableType = DeliverableType.Mention,
                                IconData = MockHelpers.ReadIconData("./icons/mention_icon.svg")
                            },
                            new DeliverableIconDto
                            {
                                Name = "Video",
                                DeliverableType = DeliverableType.Video,
                                IconData = MockHelpers.ReadIconData("./icons/video_icon.svg")
                            },
                            new DeliverableIconDto
                            {
                                Name = "Custom",
                                DeliverableType = DeliverableType.Custom,
                                IconData = MockHelpers.ReadIconData("./icons/custom_icon.svg")
                            }
                        }
                    };

                    config.Categories.AddRange(categories);

                    return new GetAppConfigResponse { AppConfigData = config };
                });

        public override Task<GetVersionsResponse> GetVersions(Empty request, ServerCallContext context)
        {
            Console.WriteLine("InfConfigImpl.GetVersions called");
            return Task.FromResult(new GetVersionsResponse { VersionInfo = new InfVersionInfoDto { ApiVersion = 1, ConfigVersion = 1 } });
        }

        public override async Task GetWelcomeImages(Empty request, IServerStreamWriter<GetWelcomeImagesResponse> responseStream, ServerCallContext context)
        {

            var displayedImageUrls = new List<string> {
              // Column 1
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F1.jpg?alt=media&token=d82436ae-7466-464b-a047-41e4473632c1",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F17.jpg?alt=media&token=702503d5-2c57-48a0-af11-5809fcbbd42e",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F3.jpg?alt=media&token=9ab752aa-ac5a-4474-9cc2-317bf435eddd",
              // Column 2
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F6.jpg?alt=media&token=358e4893-e127-4271-a67b-2b24cf78f6ae",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F5.jpg?alt=media&token=e636d72b-c7d4-4d7e-b883-d6f0c2f8cb3c",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F4.jpg?alt=media&token=97019eb3-f4f1-4937-b0c7-0fcf7e746170",
              // Column 3
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F16.jpg?alt=media&token=c8c1e5d8-85c3-4c1d-9ae2-8dfdfb14c1c0",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F2.jpg?alt=media&token=332345af-e679-4ac4-a02b-e8f78e4654ff",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F14.jpg?alt=media&token=d213ff40-04a8-43e2-9f4e-a00bcfc32e2b",
              // Column 4
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F11.jpg?alt=media&token=ac995705-f9ff-4c72-8b51-b4dfa690e03b",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F10.jpg?alt=media&token=17cf55be-2daa-4664-80cd-c65ba300ef39",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F12.jpg?alt=media&token=982b09b4-4862-4ae4-9b6d-f243c7cc56fb",
              // Column 5
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F7.jpg?alt=media&token=52ce575e-eb6b-4d31-abe1-ee5620ef8c3b",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F18.jpg?alt=media&token=7b4eeee9-22c5-41df-a5c4-5d224a024a06",
              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F8.jpg?alt=media&token=0862ad5a-f1dc-4017-85b6-61c707e8a37c",

            };

            var extraImageUrls = new List<string>
            {
                "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F13.jpg?alt=media&token=4f054be8-95b5-4bc6-92ef-bb8184631157",
                "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F9.jpg?alt=media&token=f1d6d22a-8213-4c99-b6f8-f0d528d6179c",
                "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fwelcome_screen_images%2F15.jpg?alt=media&token=8f89aa79-40cb-4de5-97b0-e44fbf64f3d6",

            };

            while (!context.CancellationToken.IsCancellationRequested)
            {
                var rnd = new Random();

                var toReplaceIndex = rnd.Next(14);
                var fromIndex = rnd.Next(2);

                var toReplace = displayedImageUrls[toReplaceIndex];
                displayedImageUrls[toReplaceIndex] = extraImageUrls[fromIndex];
                extraImageUrls[fromIndex] = toReplace;


                var response = new GetWelcomeImagesResponse();

                response.ImageUrls.Add(displayedImageUrls);
                await responseStream
                    .WriteAsync(response)
                    .ContinueOnAnyContext();

                Console.WriteLine("Sending ImageUrls");
                await Task
                    .Delay(TimeSpan.FromSeconds(2))
                    .ContinueOnAnyContext();
            }
        }
    }
}
