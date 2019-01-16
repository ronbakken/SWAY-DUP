using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace API.Services
{
    internal sealed class DatabaseMock
    {
        private static DatabaseMock instance;
        private AppConfigData configData;

        public List<User> users { get; }

        private DatabaseMock()
        {
            configData = new AppConfigData
            {
                ConfigVersion = 1,
                PrivacyPolicyUrl = "https://google.com",
                TermsOfServiceUrl = "https://wikipedia.com",
                ServiceConfig = new ServiceConfig
                {
                    MapboxToken =
                        "pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqa2pkOThmdzFha2IzcG16aHl4M3drNTcifQ.jtaEoGuiomNgllDjUMCwNQ",
                    MapboxUrlTemplateDark = "https://api.tiles.mapbox.com/v4/mapbox.dark/{z}/{x}/{y}@2x.png" +
                                            "?access_token={accessToken}"
                },
                Categories =
                {
                    new Category
                    {
                        Id = 0,
                        ParentId = -1,
                        Name = "Cars",
                        IconData = MockHelpers.ReadIconData("./icons/cars.svg")
                    },
                    new Category
                    {
                        Id = 1,
                        ParentId = -1,
                        Name = "Drinks",
                        IconData = MockHelpers.ReadIconData("./icons/drinks.svg")
                    },
                    new Category
                    {
                        Id = 2,
                        ParentId = -1,
                        Name = "Fashion",
                        IconData = MockHelpers.ReadIconData("./icons/fashion.svg")
                    },
                    new Category
                    {
                        Id = 3,
                        ParentId = -1,
                        Name = "Food",
                        IconData = MockHelpers.ReadIconData("./icons/food.svg")
                    },
                    new Category
                    {
                        Id = 4,
                        ParentId = -1,
                        Name = "Fun",
                        IconData = MockHelpers.ReadIconData("./icons/fun.svg")
                    },
                    new Category
                    {
                        Id = 5,
                        ParentId = -1,
                        Name = "Health",
                        IconData = MockHelpers.ReadIconData("./icons/health.svg")
                    },
                    new Category
                    {
                        Id = 6,
                        ParentId = -1,
                        Name = "Services",
                        IconData = MockHelpers.ReadIconData("./icons/services.svg")
                    },
                    new Category
                    {
                        Id = 7,
                        ParentId = -1,
                        Name = "Travel",
                        IconData = MockHelpers.ReadIconData("./icons/travel.svg")
                    },
                    new Category
                    {
                        Id = 8,
                        ParentId = 3,
                        Name = "Grocery",
                    },
                    new Category
                    {
                        Id = 9,
                        ParentId = 3,
                        Name = "Fast Food",
                    },
                    new Category
                    {
                        Id = 10,
                        ParentId = 3,
                        Name = "Candy",
                    },
                    new Category
                    {
                        Id = 11,
                        ParentId = 3,
                        Name = "Dessert",
                    },
                    new Category
                    {
                        Id = 12,
                        ParentId = 3,
                        Name = "Coffee shop",
                    },
                    new Category
                    {
                        Id = 13,
                        ParentId = 3,
                        Name = "Bakeries",
                    },
                    new Category
                    {
                        Id = 14,
                        ParentId = 3,
                        Name = "other",
                    },
                    // Cars
                    new Category
                    {
                        Id = 15,
                        ParentId = 0,
                        Name = "Race Cars",
                    },
                    new Category
                    {
                        Id = 16,
                        ParentId = 0,
                        Name = "Oldtimers",
                    },
                    new Category
                    {
                        Id = 17,
                        ParentId = 0,
                        Name = "Race Cars",
                    },
                    new Category
                    {
                        Id = 18,
                        ParentId = 0,
                        Name = "Car Tech",
                    },
                    // Drinks
                    new Category
                    {
                        Id = 19,
                        ParentId = 1,
                        Name = "Coffee",
                    },
                    new Category
                    {
                        Id = 20,
                        ParentId = 1,
                        Name = "Cocktails",
                    },
                    new Category
                    {
                        Id = 21,
                        ParentId = 1,
                        Name = "Smoothies",
                    },

                    // Fashion
                    new Category
                    {
                        Id = 22,
                        ParentId = 2,
                        Name = "Beauty",
                    },
                    new Category
                    {
                        Id = 23,
                        ParentId = 2,
                        Name = "Models",
                    },
                    new Category
                    {
                        Id = 24,
                        ParentId = 2,
                        Name = "Shops",
                    },

                    // Fun
                    new Category
                    {
                        Id = 25,
                        ParentId = 4,
                        Name = "Clubs",
                    },
                    new Category
                    {
                        Id = 26,
                        ParentId = 4,
                        Name = "Movies",
                    },
                    new Category
                    {
                        Id = 27,
                        ParentId = 4,
                        Name = "Comics",
                    },

                    // Health
                    new Category
                    {
                        Id = 28,
                        ParentId = 5,
                        Name = "Fitness",
                    },
                    new Category
                    {
                        Id = 29,
                        ParentId = 5,
                        Name = "Gym",
                    },
                    new Category
                    {
                        Id = 30,
                        ParentId = 5,
                        Name = "Doctors",
                    },
                    //Services
                    new Category
                    {
                        Id = 31,
                        ParentId = 6,
                        Name = "Finance",
                    },
                    new Category
                    {
                        Id = 31,
                        ParentId = 6,
                        Name = "Taxes",
                    },
                    new Category
                    {
                        Id = 32,
                        ParentId = 6,
                        Name = "Insurance",
                    },
                    // Travel
                    new Category
                    {
                        Id = 33,
                        ParentId = 7,
                        Name = "Asia",
                    },
                    new Category
                    {
                        Id = 34,
                        ParentId = 7,
                        Name = "Europe",
                    },
                    new Category
                    {
                        Id = 35,
                        ParentId = 7,
                        Name = "Italy",
                    },

                },
                SocialNetworkProviders =
                {
                    new SocialNetworkProvider
                    {
                        Id = 0,
                        Type = SocialNetworkProviderType.Instagram,
                        LogoColoredData = MockHelpers.ReadIconData("./icons/logo_instagram.png"),
                        LogoMonochromeData =
                            MockHelpers.ReadIconData(
                                "./icons/logo_instagram_monochrome.svg"),
                        LogoBackgroundData =
                            MockHelpers.ReadIconData("./icons/instagram_background.png"),
                        Name = "Instagram"
                    },
                    new SocialNetworkProvider
                    {
                        Id = 1,
                        Type = SocialNetworkProviderType.Facebook,
                        LogoColoredData = MockHelpers.ReadIconData("./icons/logo_facebook.svg"),
                        LogoMonochromeData =
                            MockHelpers.ReadIconData(
                                "./icons/logo_facebook_monochrome.svg"),
                        LogoBackGroundColor = 0xff4e71a8,
                        Name = "Facebook"
                    },
                    new SocialNetworkProvider
                    {
                        Id = 2,
                        Type = SocialNetworkProviderType.Twitter,
                        LogoColoredData = MockHelpers.ReadIconData("./icons/logo_twitter.svg"),
                        LogoBackGroundColor = 0xff54ADEE,
                        LogoMonochromeData =
                            MockHelpers.ReadIconData(
                                "./icons/logo_twitter_monochrome.svg"),
                        Name = "Twitter"
                    },
                    new SocialNetworkProvider
                    {
                        Id = 3,
                        Type = SocialNetworkProviderType.Youtube,
                        LogoMonochromeData =
                            MockHelpers.ReadIconData(
                                "./icons/logo_youtube_monochrome.svg"),
                        LogoBackGroundColor = 0xffed1f24,
                        Name = "Youtube"
                    },
                    new SocialNetworkProvider
                    {
                        Id = 4,
                        Type = SocialNetworkProviderType.Snapchat,
                        LogoMonochromeData =
                            MockHelpers.ReadIconData(
                                "./icons/logo_snapchat_monochrome.svg"),
                        LogoBackGroundColor = 0xfffffc00,
                        Name = "Snapchat"
                    },
                    new SocialNetworkProvider
                    {
                        Id = 5,
                        Type = SocialNetworkProviderType.CustomSocialNetworkProvider,
                        Name = "Custom"
                    },
                },
                DeliverableIcons =
                {
                    new DeliverableIcon
                    {
                        Name = "Post",
                        DeliverableType = DeliverableType.Post,
                        IconData = MockHelpers.ReadIconData("./icons/post_icon.svg")

                    },
                    new DeliverableIcon
                    {
                        Name = "Mention",
                        DeliverableType = DeliverableType.Mention,
                        IconData = MockHelpers.ReadIconData("./icons/mention_icon.svg")
                    },
                    new DeliverableIcon
                    {
                        Name = "Video",
                        DeliverableType = DeliverableType.Video,
                        IconData = MockHelpers.ReadIconData("./icons/video_icon.svg")
                    },
                    new DeliverableIcon
                    {
                        Name = "Custom",
                        DeliverableType = DeliverableType.CustomDeliverable,
                        IconData = MockHelpers.ReadIconData("./icons/custom_icon.svg")
                    }
                }

            };

            users = new List<User>
            {
                new User
                {
                    Id = 42,
                    ShowLocation = true,
                    AcceptsDirectOffers = true,
                    Name = "Thomas",
                    UserType = UserType.Business,
                    AvatarUrl =
                        "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile.jpg?alt=media&token=85106a2a-f1da-45b3-b78f-2cbc1315c124",
                    AvatarThumbnailUrl =
                        "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile_small.png?alt=media&token=450f8980-a0b2-4e12-91d7-40ca73568e06",
                    AvatarThumbnailLowRes =
                        MockHelpers.ReadIconData(
                            "./icons/business_profile_thumbnail_lowres.png"),
                    AvatarLowRes = MockHelpers.ReadIconData(
                        "./icons/business_profile_lowres.png"),
                    AccountState = AccountState.Active,
                    CategoriesIds = {0, 1, 2},
                    Description = "I run a online store for baking utilities",
                    Email = "thomas@burkharts.net",
                    LocationAsString = "Germany"
                    // ,location: Location(
                    //   id: 1
                    //   latitude: 34.050863
                    //   longitude: -118.272657
                    //   activeOfferCount: 0
                    // )
                    ,
                    Verified = true,
                    WebsiteUrl = "www.google.com",
                    SocialMediaAccountIds = {1}
                },
                new User
                {
                    Id = 43,
                    Name = "Jane Dow",
                    ShowLocation = true,
                    AcceptsDirectOffers = true,
                    UserType = UserType.Influencer,
                    MinimalFee = 500,
                    AvatarUrl =
                        "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile.jpeg?alt=media&token=73d4e16d-b4dc-4527-821e-9565cd5f6c01",
                    AvatarThumbnailUrl =
                        "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78",
                    AvatarThumbnailLowRes =
                        MockHelpers.ReadIconData(
                            "./icons/inf_profile_thumbnail_lowres.png"),
                    AvatarLowRes = MockHelpers.ReadIconData(
                        "./icons/inf_profile_lowres.png"),
                    AccountState = AccountState.Active,
                    CategoriesIds = {0, 1, 2},
                    Description = "I run a online store for baking utilities",
                    Email = "thomas@burkharts.net",
                    LocationAsString = "Germany"
                    // ,location= Location(
                    //   id= 1,
                    //   latitude= 34.050863,
                    //   longitude= -118.272657,
                    //   activeOfferCount= 0,
                    // ),
                    ,
                    Verified = false,
                    WebsiteUrl = "www.google.com",
                    SocialMediaAccountIds = { 2,3,4}

                }

            };

            socialMediaAccounts = new List<SocialMediaAccount>()
            {
                new SocialMediaAccount
                {
                    Id = 1,
                    IsActive = true,
                    SocialNetworkProviderId = 0,
                    Url = "https=//twitter.com/ThomasBurkhartB",
                    DisplayName = "Thomas Burkhart",
                    Description = "The best online shop for baking",
                    FollowersCount = 900
                },
                new SocialMediaAccount
                {
                    Id = 2,
                    IsActive = true,
                    SocialNetworkProviderId = 0,
                    Url = "https://twitter.com/ThomasBurkhartB",
                    DisplayName = "Thomas Burkhart",
                    Description = "The best online shop for baking",
                    FollowersCount = 1900
                },
                new SocialMediaAccount
                {
                    Id = 3,
                    IsActive = true,
                    SocialNetworkProviderId = 1,
                    Url = "https://twitter.com/ThomasBurkhartB",
                    DisplayName = "Thomas Burkhart",
                    Description = "The best online shop for baking",
                    FollowersCount = 1000900,
                },
                new SocialMediaAccount
                {
                    Id = 4,
                    IsActive = true,
                    SocialNetworkProviderId = 2,
                    Url = "https://twitter.com/ThomasBurkhartB",
                    DisplayName = "Thomas Burkhart",
                    Description = "The best online shop for baking",
                    FollowersCount = 2100000
                },
                new SocialMediaAccount
                {
                    Id = 5,
                    IsActive = true,
                    SocialNetworkProviderId = 4,
                    Url = "https://twitter.com/ThomasBurkhartB",
                    DisplayName = "Thomas Burkhart",
                    Description = "The best online shop for baking",
                    FollowersCount = 900
                },
                new SocialMediaAccount
                {
                    Id = 6,
                    IsActive = true,
                    SocialNetworkProviderId = 3,
                    Url = "https://twitter.com/ThomasBurkhartB",
                    DisplayName = "Thomas Burkhart",
                    Description = "The best online shop for baking",
                    FollowersCount = 900
                }

            };



        }

        public List<SocialMediaAccount> socialMediaAccounts { get; set; }

        public static DatabaseMock Instance()
        {
            return instance ?? (instance = new DatabaseMock());
        }

        public AppConfigData GetAppConfigData()
        {
            return configData;
        }


        public User GetUser(string token)
        {
            if (token == "INF")
            {
                return users[1];
            }
            else if (token == "BUSINESS")

            {
                return users[0];
            }
            else
            {
                return null;
            }
        }

        public List<SocialMediaAccount> GetSocialMediaAccounts(int userId)
        {
            var user = users.FirstOrDefault(u => u.Id == userId);
            if (user == null)
            {
                Console.WriteLine("GetSocialMediaAccounts called with unknown userid: " + userId);
                return null;
            }

            return user.SocialMediaAccountIds.Select(i =>
            {
                var account = socialMediaAccounts.FirstOrDefault(a => a.Id == i);
                if (account == null)
                {
                    Console.WriteLine("GetSocialMediaAccounts called with unknown userid: " + userId);
                    return null;
                }
                return account;
            }).ToList();
        }

    }
}
