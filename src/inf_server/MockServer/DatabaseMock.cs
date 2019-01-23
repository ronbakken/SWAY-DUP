using System.Collections.Generic;
using API.Interfaces;

namespace MockServer
{
    class DatabaseMock
    {
        private static DatabaseMock instance;
        private AppConfigDto configData;

        public List<UserDto> users { get; }

        private UserDto updatedUser = null;

        private DatabaseMock()
        {
            configData = new AppConfigDto
            {
                ConfigVersion = 1,
                PrivacyPolicyUrl = "https://google.com",
                TermsOfServiceUrl = "https://wikipedia.com",
                ServiceConfig = new ServiceConfigDto
                {
                    MapboxToken =
                        "pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqa2pkOThmdzFha2IzcG16aHl4M3drNTcifQ.jtaEoGuiomNgllDjUMCwNQ",
                    MapboxUrlTemplateDark = "https://api.tiles.mapbox.com/v4/mapbox.dark/{z}/{x}/{y}@2x.png" +
                                            "?access_token={accessToken}"
                },
                Categories =
                {
                    new CategoryDto
                    {
                        Id = 0,
                        ParentId = -1,
                        Name = "Cars",
                        IconData = MockHelpers.ReadIconData("./icons/cars.svg")
                    },
                    new CategoryDto
                    {
                        Id = 1,
                        ParentId = -1,
                        Name = "Drinks",
                        IconData = MockHelpers.ReadIconData("./icons/drinks.svg")
                    },
                    new CategoryDto
                    {
                        Id = 2,
                        ParentId = -1,
                        Name = "Fashion",
                        IconData = MockHelpers.ReadIconData("./icons/fashion.svg")
                    },
                    new CategoryDto
                    {
                        Id = 3,
                        ParentId = -1,
                        Name = "Food",
                        IconData = MockHelpers.ReadIconData("./icons/food.svg")
                    },
                    new CategoryDto
                    {
                        Id = 4,
                        ParentId = -1,
                        Name = "Fun",
                        IconData = MockHelpers.ReadIconData("./icons/fun.svg")
                    },
                    new CategoryDto
                    {
                        Id = 5,
                        ParentId = -1,
                        Name = "Health",
                        IconData = MockHelpers.ReadIconData("./icons/health.svg")
                    },
                    new CategoryDto
                    {
                        Id = 6,
                        ParentId = -1,
                        Name = "Services",
                        IconData = MockHelpers.ReadIconData("./icons/services.svg")
                    },
                    new CategoryDto
                    {
                        Id = 7,
                        ParentId = -1,
                        Name = "Travel",
                        IconData = MockHelpers.ReadIconData("./icons/travel.svg")
                    },
                    new CategoryDto
                    {
                        Id = 8,
                        ParentId = 3,
                        Name = "Grocery",
                    },
                    new CategoryDto
                    {
                        Id = 9,
                        ParentId = 3,
                        Name = "Fast Food",
                    },
                    new CategoryDto
                    {
                        Id = 10,
                        ParentId = 3,
                        Name = "Candy",
                    },
                    new CategoryDto
                    {
                        Id = 11,
                        ParentId = 3,
                        Name = "Dessert",
                    },
                    new CategoryDto
                    {
                        Id = 12,
                        ParentId = 3,
                        Name = "Coffee shop",
                    },
                    new CategoryDto
                    {
                        Id = 13,
                        ParentId = 3,
                        Name = "Bakeries",
                    },
                    new CategoryDto
                    {
                        Id = 14,
                        ParentId = 3,
                        Name = "other",
                    },
                    // Cars
                    new CategoryDto
                    {
                        Id = 15,
                        ParentId = 0,
                        Name = "Race Cars",
                    },
                    new CategoryDto
                    {
                        Id = 16,
                        ParentId = 0,
                        Name = "Oldtimers",
                    },
                    new CategoryDto
                    {
                        Id = 17,
                        ParentId = 0,
                        Name = "Race Cars",
                    },
                    new CategoryDto
                    {
                        Id = 18,
                        ParentId = 0,
                        Name = "Car Tech",
                    },
                    // Drinks
                    new CategoryDto
                    {
                        Id = 19,
                        ParentId = 1,
                        Name = "Coffee",
                    },
                    new CategoryDto
                    {
                        Id = 20,
                        ParentId = 1,
                        Name = "Cocktails",
                    },
                    new CategoryDto
                    {
                        Id = 21,
                        ParentId = 1,
                        Name = "Smoothies",
                    },

                    // Fashion
                    new CategoryDto
                    {
                        Id = 22,
                        ParentId = 2,
                        Name = "Beauty",
                    },
                    new CategoryDto
                    {
                        Id = 23,
                        ParentId = 2,
                        Name = "Models",
                    },
                    new CategoryDto
                    {
                        Id = 24,
                        ParentId = 2,
                        Name = "Shops",
                    },

                    // Fun
                    new CategoryDto
                    {
                        Id = 25,
                        ParentId = 4,
                        Name = "Clubs",
                    },
                    new CategoryDto
                    {
                        Id = 26,
                        ParentId = 4,
                        Name = "Movies",
                    },
                    new CategoryDto
                    {
                        Id = 27,
                        ParentId = 4,
                        Name = "Comics",
                    },

                    // Health
                    new CategoryDto
                    {
                        Id = 28,
                        ParentId = 5,
                        Name = "Fitness",
                    },
                    new CategoryDto
                    {
                        Id = 29,
                        ParentId = 5,
                        Name = "Gym",
                    },
                    new CategoryDto
                    {
                        Id = 30,
                        ParentId = 5,
                        Name = "Doctors",
                    },
                    //Services
                    new CategoryDto
                    {
                        Id = 31,
                        ParentId = 6,
                        Name = "Finance",
                    },
                    new CategoryDto
                    {
                        Id = 31,
                        ParentId = 6,
                        Name = "Taxes",
                    },
                    new CategoryDto
                    {
                        Id = 32,
                        ParentId = 6,
                        Name = "Insurance",
                    },
                    // Travel
                    new CategoryDto
                    {
                        Id = 33,
                        ParentId = 7,
                        Name = "Asia",
                    },
                    new CategoryDto
                    {
                        Id = 34,
                        ParentId = 7,
                        Name = "Europe",
                    },
                    new CategoryDto
                    {
                        Id = 35,
                        ParentId = 7,
                        Name = "Italy",
                    },

                },
                SocialNetworkProviders =
                {
                    new SocialNetworkProviderDto
                    {
                        Id = 0,
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
                        Id = 1,
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
                        Id = 2,
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
                        Id = 3,
                        Type = SocialNetworkProviderType.YouTube,
                        LogoMonochromeData =
                            MockHelpers.ReadIconData(
                                "./icons/logo_youtube_monochrome.svg"),
                        LogoBackGroundColor = 0xffed1f24,
                        Name = "Youtube"
                    },
                    new SocialNetworkProviderDto
                    {
                        Id = 4,
                        Type = SocialNetworkProviderType.Snapchat,
                        LogoMonochromeData =
                            MockHelpers.ReadIconData(
                                "./icons/logo_snapchat_monochrome.svg"),
                        LogoBackGroundColor = 0xfffffc00,
                        Name = "Snapchat"
                    },
                    new SocialNetworkProviderDto
                    {
                        Id = 5,
                        Type = SocialNetworkProviderType.CustomSocialnetWorkProvider,
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
                        DeliverableType = DeliverableType.CustomDeliverable,
                        IconData = MockHelpers.ReadIconData("./icons/custom_icon.svg")
                    }
                }

            };

            users = new List<UserDto>
            {
                new UserDto
                {
                    ShowLocation = true,
                    AcceptsDirectOffers = true,
                    Name = "Thomas",
                    UserType = UserType.Business,
                    Avatar = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile.jpg?alt=media&token=85106a2a-f1da-45b3-b78f-2cbc1315c124",
                        LowResData = MockHelpers.ReadIconData("./icons/business_profile_lowres.png"),
                    },
                    AvatarThumbnail = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile_small.png?alt=media&token=450f8980-a0b2-4e12-91d7-40ca73568e06",
                        LowResData = MockHelpers.ReadIconData("./icons/business_profile_thumbnail_lowres.png"),
                    },
                    AccountState = AccountState.Active,
                    CategoryIds = {0, 1, 2},
                    Description = "I run a online store for baking utilities",
                    Email = "thomas@burkharts.net",
                    Location= new LocationDto{
                     Name = "Germany",
                     Latitude= 34.050863,
                     Longitude= -118.272657
                    }
                    ,
                    Verified = true,
                    WebsiteUrl = "www.google.com",
                },
                new UserDto
                {
                    Name = "Jane Dow",
                    ShowLocation = true,
                    AcceptsDirectOffers = true,
                    UserType = UserType.Influencer,
                    MinimalFee = 500,
                    Avatar = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile.jpeg?alt=media&token=73d4e16d-b4dc-4527-821e-9565cd5f6c01",
                        LowResData = MockHelpers.ReadIconData("./icons/inf_profile_lowres.png"),
                    },
                    AvatarThumbnail = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78",
                        LowResData = MockHelpers.ReadIconData("./icons/inf_profile_thumbnail_lowres.png"),
                    },
                    AccountState = AccountState.Active,
                    CategoryIds = {0, 1, 2},
                    Description = "I run a online store for baking utilities",
                    Email = "thomas@burkharts.net",
                    Location= new LocationDto{
                        Name = "Germany",
                    Latitude= 34.050863,
                    Longitude= -118.272657
                }
                    ,
                    Verified = false,
                    WebsiteUrl = "www.google.com",
                    SocialMediaAccounts = {
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = 0,
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 1900
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = 1,
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 1000900,
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = 2,
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 2100000
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = 4,
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 900
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = 3,
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 900
                        }
                    },

                }

            };

        }


        public static DatabaseMock Instance()
        {
            return instance ?? (instance = new DatabaseMock());
        }

        public AppConfigDto GetAppConfigData()
        {
            return configData;
        }


        public void UpdateUser(UserDto user)
        {
            updatedUser = user;
        }

        public UserDto GetUser(string token)
        {
            if (token == "INF")
            {
                if ( (updatedUser != null) && (updatedUser.UserType == UserType.Influencer))
                {
                    return updatedUser;
                }
                return users[1];
            }
            else if (token == "BUSINESS")

            {
                if ((updatedUser != null) && (updatedUser.UserType == UserType.Business))
                {
                    return updatedUser;
                }
                return users[0];
            }
            else
            {
                return null;
            }
        }

    }
}
