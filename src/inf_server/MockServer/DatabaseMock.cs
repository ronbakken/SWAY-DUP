using System.Collections.Generic;
using API.Interfaces;
using Google.Protobuf.WellKnownTypes;
using System;
using System.Diagnostics;
using System.Linq;

namespace MockServer
{
    class DatabaseMock
    {
        private static DatabaseMock instance;
        private AppConfigDto configData;

        public List<UserDto> users { get; }

        public List<OfferDto> offersList;
        public Dictionary<string, OfferDto> offers = new Dictionary<string, OfferDto>();

        private UserDto updatedUser = null;

        private int lastOfferId = 3;

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
                        Id = "0",
                        ParentId = "",
                        Name = "Cars",
                        IconData = MockHelpers.ReadIconData("./icons/cars.svg")
                    },
                    new CategoryDto
                    {
                        Id = "1",
                        ParentId = "",
                        Name = "Drinks",
                        IconData = MockHelpers.ReadIconData("./icons/drinks.svg")
                    },
                    new CategoryDto
                    {
                        Id = "2",
                        ParentId = "",
                        Name = "Fashion",
                        IconData = MockHelpers.ReadIconData("./icons/fashion.svg")
                    },
                    new CategoryDto
                    {
                        Id = "3",
                        ParentId = "",
                        Name = "Food",
                        IconData = MockHelpers.ReadIconData("./icons/food.svg")
                    },
                    new CategoryDto
                    {
                        Id = "4",
                        ParentId = "",
                        Name = "Fun",
                        IconData = MockHelpers.ReadIconData("./icons/fun.svg")
                    },
                    new CategoryDto
                    {
                        Id = "5",
                        ParentId = "",
                        Name = "Health",
                        IconData = MockHelpers.ReadIconData("./icons/health.svg")
                    },
                    new CategoryDto
                    {
                        Id = "6",
                        ParentId = "",
                        Name = "Services",
                        IconData = MockHelpers.ReadIconData("./icons/services.svg")
                    },
                    new CategoryDto
                    {
                        Id = "7",
                        ParentId = "",
                        Name = "Travel",
                        IconData = MockHelpers.ReadIconData("./icons/travel.svg")
                    },
                    new CategoryDto
                    {
                        Id = "8",
                        ParentId = "3",
                        Name = "Grocery",
                    },
                    new CategoryDto
                    {
                        Id = "9",
                        ParentId = "3",
                        Name = "Fast Food",
                    },
                    new CategoryDto
                    {
                        Id = "10",
                        ParentId = "3",
                        Name = "Candy",
                    },
                    new CategoryDto
                    {
                        Id = "11",
                        ParentId = "3",
                        Name = "Dessert",
                    },
                    new CategoryDto
                    {
                        Id = "12",
                        ParentId = "3",
                        Name = "Coffee shop",
                    },
                    new CategoryDto
                    {
                        Id = "13",
                        ParentId = "3",
                        Name = "Bakeries",
                    },
                    new CategoryDto
                    {
                        Id = "14",
                        ParentId = "3",
                        Name = "other",
                    },
                    // Cars
                    new CategoryDto
                    {
                        Id = "15",
                        ParentId = "0",
                        Name = "Race Cars",
                    },
                    new CategoryDto
                    {
                        Id = "16",
                        ParentId = "0",
                        Name = "Oldtimers",
                    },
                    new CategoryDto
                    {
                        Id = "17",
                        ParentId = "0",
                        Name = "Race Cars",
                    },
                    new CategoryDto
                    {
                        Id = "18",
                        ParentId = "0",
                        Name = "Car Tech",
                    },
                    // Drinks
                    new CategoryDto
                    {
                        Id = "19",
                        ParentId = "1",
                        Name = "Coffee",
                    },
                    new CategoryDto
                    {
                        Id = "20",
                        ParentId = "1",
                        Name = "Cocktails",
                    },
                    new CategoryDto
                    {
                        Id = "21",
                        ParentId = "1",
                        Name = "Smoothies",
                    },

                    // Fashion
                    new CategoryDto
                    {
                        Id = "22",
                        ParentId = "2",
                        Name = "Beauty",
                    },
                    new CategoryDto
                    {
                        Id = "23",
                        ParentId = "2",
                        Name = "Models",
                    },
                    new CategoryDto
                    {
                        Id = "24",
                        ParentId = "2",
                        Name = "Shops",
                    },

                    // Fun
                    new CategoryDto
                    {
                        Id = "25",
                        ParentId = "4",
                        Name = "Clubs",
                    },
                    new CategoryDto
                    {
                        Id = "26",
                        ParentId = "4",
                        Name = "Movies",
                    },
                    new CategoryDto
                    {
                        Id = "27",
                        ParentId = "4",
                        Name = "Comics",
                    },

                    // Health
                    new CategoryDto
                    {
                        Id = "28",
                        ParentId = "5",
                        Name = "Fitness",
                    },
                    new CategoryDto
                    {
                        Id = "29",
                        ParentId = "5",
                        Name = "Gym",
                    },
                    new CategoryDto
                    {
                        Id = "30",
                        ParentId = "5",
                        Name = "Doctors",
                    },
                    //Services
                    new CategoryDto
                    {
                        Id = "31",
                        ParentId = "6",
                        Name = "Finance",
                    },
                    new CategoryDto
                    {
                        Id = "31",
                        ParentId = "6",
                        Name = "Taxes",
                    },
                    new CategoryDto
                    {
                        Id = "32",
                        ParentId = "6",
                        Name = "Insurance",
                    },
                    // Travel
                    new CategoryDto
                    {
                        Id = "33",
                        ParentId = "7",
                        Name = "Asia",
                    },
                    new CategoryDto
                    {
                        Id = "34",
                        ParentId = "7",
                        Name = "Europe",
                    },
                    new CategoryDto
                    {
                        Id = "35",
                        ParentId = "7",
                        Name = "Italy",
                    },

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
                        Name = "Youtube"
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

            users = new List<UserDto>
            {
                new UserDto
                {
                    Id = "1" ,
                    Status = UserDto.Types.Status.Active,
                    Revision = 1,

                    Full = new UserDto.Types.FullDataDto {
                    Type = UserType.Business,
                    ShowLocation = true,
                    AcceptsDirectOffers = true,
                    Name = "Thomas",
                    Avatar = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile.jpg?alt=media&token=85106a2a-f1da-45b3-b78f-2cbc1315c124",
                        LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile_small.png?alt=media&token=450f8980-a0b2-4e12-91d7-40ca73568e06",
                    },
                    AvatarThumbnail = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile_small.png?alt=media&token=450f8980-a0b2-4e12-91d7-40ca73568e06",
                        LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fbusiness_profile_small_lores.png?alt=media&token=8e8dad80-897e-4c00-a1a0-b1c75c9624d7",
                    },
                    CategoryIds = {"0", "1", "2"},
                    Description = "I run a online store for baking utilities",
                    Email = "thomas@burkharts.net",
                    Location= new LocationDto{
                     Name = "Germany",
                     GeoPoint = new GeoPointDto{
                     Latitude= 34.050863,
                     Longitude= -118.272657
                     }
                    }
                    ,
                    IsVerified = true,
                    WebsiteUrl = "www.google.com",
                    }
                },
                new UserDto
                {
                    Id = "2" ,
                    Status = UserDto.Types.Status.Active,
                    Revision = 1,

                    Full = new UserDto.Types.FullDataDto {

                    Name = "Jane Dow",
                    ShowLocation = true,
                    AcceptsDirectOffers = true,
                    Type = UserType.Influencer,
                    MinimalFee = new MoneyDto{CurrencyCode = "USD", Units = 5, Nanos=0 },
                    Avatar = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile.jpeg?alt=media&token=73d4e16d-b4dc-4527-821e-9565cd5f6c01",
                        LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78",
                    },
                    AvatarThumbnail = new ImageDto
                    {
                        Url = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78",
                        LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small_lores.png?alt=media&token=8eb133ed-dd70-4e9e-b2f2-e7be71173a28",
                    },
                    CategoryIds = {"0", "1", "2"},
                    Description = "I run a online store for baking utilities",
                    Email = "thomas@burkharts.net",
                    Location= new LocationDto{
                        Name = "Germany",
                        GeoPoint = new GeoPointDto{
                    Latitude= 34.050863,
                    Longitude= -118.272657
                        }

                }
                    ,
                    IsVerified = false,
                    WebsiteUrl = "www.google.com",
                    SocialMediaAccounts = {
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = "0",
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 1900
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = "1",
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 1000900,
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = "2",
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 2100000
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = "4",
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 900
                        },
                        new SocialMediaAccountDto
                        {
                            SocialNetworkProviderId = "3",
                            ProfileUrl = "https://twitter.com/ThomasBurkhartB",
                            DisplayName = "Thomas Burkhart",
                            Description = "The best online shop for baking",
                            AudienceSize = 900
                        }
                    },
                    }

                },


            };

            offersList = new List<OfferDto>{
                new OfferDto {
                      Id= "1",
                      Revision = 1,
                      Status = OfferDto.Types.Status.Active,
                      StatusReason = OfferDto.Types.StatusReason.Open,
                      Location= new LocationDto{ GeoPoint = new GeoPointDto{ Latitude= 34.032395, Longitude= -118.301019} },
                      Full = new OfferDto.Types.FullDataDto{
                          ProposalStatus = OfferDto.Types.ProposalStatus.AtLeastOne,
                          Created = Timestamp.FromDateTime(DateTime.UtcNow),
                          Start = Timestamp.FromDateTime(new DateTime(2019, 1, 1,0,0,0,DateTimeKind.Utc)),
                          End= Timestamp.FromDateTime(new DateTime(2019, 3, 1,0,0,0,DateTimeKind.Utc)),
                          AcceptancePolicy= OfferDto.Types.AcceptancePolicy.AllowNegotiation,

                          BusinessAccountId= "1",
                          BusinessName= "CarWash Tom",
                          BusinessDescription= "We wash anything",
                          BusinessAvatarThumbnailUrl=
                              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741",
                          Title= "Car Wash",
                          Description=
                              "Our car wash is the best car wash in the universe of car washes. We want more people to get to know our"+
                              "amazing service. "+
                              "Our car wash is the best car wash in the universe of car washes.",
                          CategoryIds= {"0"},
                          MinFollowers=1000,
                          NumberOffered=0,
                          Terms= new DealTermsDto{
                            Deliverable= new DeliverableDto{
                              Description= "Tell people how good our service is",
                              DeliverableTypes= {DeliverableType.Post, DeliverableType.Video },
                              SocialNetworkProviderIds= {
                                "0",
                                "1"
                                },
                            },
                            Reward= new RewardDto{
                              Description= "One free premium car wash",
                              Type= RewardDto.Types.Type.Barter,
                              BarterValue= new MoneyDto{CurrencyCode = "USD", Units = 20, Nanos=0 },
                              CashValue= new MoneyDto{CurrencyCode = "USD", Units = 100, Nanos=0 }
                            },
                          },
                          Images =
                          {
                              new ImageDto
                              {
                                  LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1_lowres.jpg?alt=media&token=cb093556-5af8-4dda-9979-2bc9ef6f42f2",
                                  Url=        "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1.jpg?alt=media&token=af2e4919-a67d-4e48-b7c0-286c2e444f2e",
                              },
                              new ImageDto
                              {
                                  LowResUrl=  "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1_lowres.jpg?alt=media&token=cb093556-5af8-4dda-9979-2bc9ef6f42f2",
                                  Url =       "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2.jpg?alt=media&token=0913cd09-1efc-47d6-a760-cbfe47476b5d"
                              }
                          },

                          Thumbnail = new ImageDto{
                            LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb_lowres.jpg?alt=media&token=6e219c88-d480-4ce5-8d75-b765b35df1f9",
                            Url= "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb.jpg?alt=media&token=a3c145ef-790c-433d-ae11-7ea5c48eeb45",
                          }
                      }
                },
                new OfferDto {
                      Id= "2",
                      Revision = 1,
                      Status = OfferDto.Types.Status.Active,
                      StatusReason = OfferDto.Types.StatusReason.Open,
                      Location= new LocationDto{ GeoPoint = new GeoPointDto{ Latitude= 34.040031, Longitude= -118.257318} },
                      Full = new OfferDto.Types.FullDataDto{
                          ProposalStatus = OfferDto.Types.ProposalStatus.None,
                          Created = Timestamp.FromDateTime(DateTime.UtcNow),
                          Start = Timestamp.FromDateTime(new DateTime (2019, 1, 1,0,0,0,DateTimeKind.Utc)),
                          End= Timestamp.FromDateTime(new DateTime(2019, 3, 1,0,0,0,DateTimeKind.Utc)),
                          AcceptancePolicy= OfferDto.Types.AcceptancePolicy.AutomaticAcceptMatching,

                          BusinessAccountId= "1",
                          BusinessName= "Scent of Asia",
                          BusinessDescription= "Best flavoured teas in town",
                          BusinessAvatarThumbnailUrl=
                              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741",
                          Title= "Spoon Ice Tea",
                          Description=
                              "Free ice tea if you stop by",
                          CategoryIds= {"3",},
                          MinFollowers=500,
                          NumberOffered=100,
                          Terms= new DealTermsDto{
                            Deliverable= new DeliverableDto{
                              Description= "Tell people how good our tea is",
                              DeliverableTypes= {DeliverableType.Post},
                              SocialNetworkProviderIds= {
                                "0",
                                },
                            },
                            Reward= new RewardDto{
                              Description= "One free premium car wash",
                              Type= RewardDto.Types.Type.Barter,
                              BarterValue= new MoneyDto{CurrencyCode = "USD", Units = 5, Nanos=0 },
                              CashValue= new MoneyDto{CurrencyCode = "USD", Units = 0, Nanos=0 },
                            },
                          },
                          Images =
                          {
                              new ImageDto
                              {
                                  LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_lowres.jpg?alt=media&token=3dc3ad04-ed66-4dec-8621-76ac3cbe05ab",
                                  Url=        "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a",
                              },
                              new ImageDto
                              {
                                  LowResUrl=  "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3",
                                  Url =       "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2.jpg?alt=media&token=e4b231d1-a4d3-419b-9c50-8b05fd4ab8d7"
                              }
                          },

                          Thumbnail = new ImageDto{
                            LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb_lowres.jpg?alt=media&token=702a2349-6ef0-45a6-89c7-904dd8950e0a",
                            Url= "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a",
                          }
                      }
                },
                new OfferDto {
                      Id= "3",
                      Revision = 1,
                      Status = OfferDto.Types.Status.Active,
                      StatusReason = OfferDto.Types.StatusReason.Open,
                      Location= new LocationDto{ GeoPoint = new GeoPointDto{ Latitude= 34.040031, Longitude= -118.257318} },
                      Full = new OfferDto.Types.FullDataDto{
                          ProposalStatus = OfferDto.Types.ProposalStatus.None,
                          Created = Timestamp.FromDateTime(DateTime.UtcNow),
                          Start = Timestamp.FromDateTime(new DateTime (2019, 1, 1,0,0,0,DateTimeKind.Utc)),
                          End= Timestamp.FromDateTime(new DateTime(2019, 3, 1,0,0,0,DateTimeKind.Utc)),
                          AcceptancePolicy= OfferDto.Types.AcceptancePolicy.AutomaticAcceptMatching,

                          BusinessAccountId= "1",
                          BusinessName= "Scent of Asia",
                          BusinessDescription= "Best flavoured teas in town",
                          BusinessAvatarThumbnailUrl=
                              "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741",
                          Title= "Spoon Ice Tea",
                          Description=
                              "Free ice tea if you stop by",
                          CategoryIds= {"3"},
                          MinFollowers=500,
                          NumberOffered=100,
                          Terms= new DealTermsDto{
                            Deliverable= new DeliverableDto{
                              Description= "Tell people how good our tea is",
                              DeliverableTypes= {DeliverableType.Post},
                              SocialNetworkProviderIds= {
                                "0",
                                },
                            },
                            Reward= new RewardDto{
                              Description= "One free premium car wash",
                              Type= RewardDto.Types.Type.Barter,
                              BarterValue= new MoneyDto{CurrencyCode = "USD", Units = 5, Nanos=0 },
                              CashValue= new MoneyDto{CurrencyCode = "USD", Units = 0, Nanos=0 },
                            },
                          },
                          Images =
                          {
                              new ImageDto
                              {
                                  LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_lowres.jpg?alt=media&token=3dc3ad04-ed66-4dec-8621-76ac3cbe05ab",
                                  Url=        "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a",
                              },
                              new ImageDto
                              {
                                  LowResUrl=  "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3",
                                  Url =       "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2.jpg?alt=media&token=e4b231d1-a4d3-419b-9c50-8b05fd4ab8d7"
                              }
                          },

                          Thumbnail = new ImageDto{
                            LowResUrl = "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb_lowres.jpg?alt=media&token=702a2349-6ef0-45a6-89c7-904dd8950e0a",
                            Url= "https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a",
                          }
                      }
                }


            };


            foreach (var offer in offersList)
            {
                offers.Add(offer.Id, offer);
            }
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
                if ((updatedUser != null) && (updatedUser.Full.Type == UserType.Influencer))
                {
                    return updatedUser;
                }
                return users[1];
            }
            else if (token == "BUSINESS")

            {
                if ((updatedUser != null) && (updatedUser.Full.Type == UserType.Business))
                {
                    return updatedUser;
                }
                return users[0];
            }
            else
            {
                return users[2];
            }
        }

        public OfferDto GetOffer(String offerId)
        {
            return offers[offerId];
        }

        public OfferDto UpsertOffer(OfferDto offer)
        {
            if (offer.Id == "")
            {
                offer.Id = (++lastOfferId).ToString();
                offer.Revision = 1;
                offers.Add(offer.Id, offer);
            }
            Debug.Assert(offers.ContainsKey(offer.Id));

            var latestRevision = offers[offer.Id].Revision;
            offer.Revision = latestRevision + 1;
            offers[offer.Id] = offer;

            return offer;
        }


        public List<ItemDto> GetOffersAsItems()
        {
            return offers.Values.Select<OfferDto, ItemDto>(x => {
                return new ItemDto
                {
                    Offer =
                   new OfferDto
                   {
                       Id = x.Id,
                       Location = x.Location,
                       Revision = x.Revision,
                       Status = x.Status,
                       StatusReason = x.StatusReason,
                       List = new OfferDto.Types.ListDataDto
                       {
                           BusinessAccountId = x.Full.BusinessAccountId,
                           BusinessAvatarThumbnailUrl = x.Full.BusinessAvatarThumbnailUrl,
                           BusinessDescription = x.Full.BusinessDescription,
                           BusinessName = x.Full.BusinessName,
                           Created = x.Full.Created,
                           Description = x.Full.Description,
                           End = x.Full.End,
                           FeaturedImage = x.Full.Images[0],
                           NumberOffered = x.Full.NumberOffered,
                           NumberRemaining = x.Full.NumberRemaining,
                           ProposalStatus = x.Full.ProposalStatus,
                           Start = x.Full.Start,
                           Terms = x.Full.Terms,
                           Thumbnail = x.Full.Thumbnail,
                           Title = x.Full.Title
                       }
                   }
                };
            }).ToList();
        } 

    }
}
