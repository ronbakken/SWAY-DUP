/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_inheritable/multi_account_selection.dart';
import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_inheritable/network_provider.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/screens/business_offer_list.dart';
import 'package:inf/screens/dashboard_common.dart';
import 'package:inf/screens/debug_account.dart';
import 'package:inf/screens/experiment_files/geocoding_test.dart';
import 'package:inf/screens/location_search.dart';
import 'package:inf/screens/location_selection.dart';
import 'package:inf/screens/offer_create.dart';
import 'package:inf/screens/offer_view.dart';
import 'package:inf/screens/profile_edit.dart';
import 'package:inf/screens/profile_view.dart';
import 'package:inf/screens/search_button.dart';
import 'package:inf/screens/search_page.dart';
import 'package:inf/screens_onboarding/onboarding_selection.dart';
import 'package:inf/screens_onboarding/onboarding_social.dart';
import 'package:inf/utility/page_transition.dart';

class DeveloperMenu extends StatefulWidget {
  final Function() onExitDevelopmentMode;

  const DeveloperMenu({Key key, this.onExitDevelopmentMode}) : super(key: key);

  @override
  _DeveloperMenuState createState() => new _DeveloperMenuState();
}

class _DeveloperMenuState extends State<DeveloperMenu> {
  DataAccount demoAccount = new DataAccount();
  final Random random = new Random();

  List<DataAccount> sampleAccounts = new List<DataAccount>();
  List<DataOffer> sampleOffers = new List<DataOffer>();

  void generateSamples() {
    sampleAccounts.length = 3;
    for (int i = 0; i < sampleAccounts.length; ++i) {
      if (sampleAccounts[i] == null) {
        sampleAccounts[i] = new DataAccount();
      }
    }

    sampleAccounts[1].accountId = new Int64(1);
    sampleAccounts[1].accountType = AccountType.business;
    sampleAccounts[1].globalAccountState = GlobalAccountState.readWrite;
    sampleAccounts[1].name = "Big Kahuna";
    sampleAccounts[1].description =
        "The best burgers in the known universe. As far as we know.";
    sampleAccounts[1].avatarUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg";
    sampleAccounts[1].location =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    // sampleAccounts[1].coverUrls.length = 0;
    // sampleAccounts[1].coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");

    sampleAccounts[2].accountId = new Int64(2);
    sampleAccounts[2].accountType = AccountType.business;
    sampleAccounts[2].globalAccountState = GlobalAccountState.readWrite;
    sampleAccounts[2].name = "Fried Willy";
    sampleAccounts[2].description = "We don't prepare dolphins.";
    sampleAccounts[2].avatarUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg";
    sampleAccounts[2].location =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    // sampleAccounts[2].coverUrls.length = 0;
    // sampleAccounts[2].coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/fries.jpg");
    // sampleAccounts[1].coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg");

    sampleOffers.length = 4;
    for (int i = 0; i < sampleOffers.length; ++i) {
      if (sampleOffers[i] == null) {
        sampleOffers[i] = new DataOffer();
      }
    }

    sampleOffers[1].terms = new DataTerms();
    sampleOffers[1].offerId = new Int64(1);
    sampleOffers[1].senderId = new Int64(1);
    sampleOffers[1].state = OfferState.open;
    sampleOffers[1].stateReason = OfferStateReason.newOffer;
    sampleOffers[1].title = "Finest Burger Weekend";
    sampleOffers[1].description =
        "We'd like to expose the finest foods in our very busy restaurant to a wide audience.";
    sampleOffers[1].thumbnailUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg";
    sampleOffers[1].terms.rewardItemOrServiceDescription = "Free dinner + \$150";
    sampleOffers[1].terms.deliverablesDescription =
        "Posts with photography across social media.";
    sampleOffers[1].locationAddress =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    sampleOffers[1].coverUrls.length = 0;
    sampleOffers[1]
        .coverUrls
        .add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");
    // sampleOffers[1].proposalsNew = 3;
    // sampleOffers[1].proposalsRefused = 1;

    sampleOffers[2].terms = new DataTerms();
    sampleOffers[2].offerId = new Int64(2);
    sampleOffers[2].senderId = new Int64(1);
    sampleOffers[2].state = OfferState.open;
    sampleOffers[2].stateReason = OfferStateReason.newOffer;
    sampleOffers[2].title = "Burger Weekend Fries";
    sampleOffers[2].description =
        "We need some table fillers to make our restaurant look very busy this weekend.";
    sampleOffers[2].thumbnailUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/fries.jpg";
    sampleOffers[2].terms.rewardItemOrServiceDescription = "Free Poke Fries";
    sampleOffers[2].terms.deliverablesDescription =
        "Posts with photography across social media.";
    sampleOffers[2].locationAddress =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    /*sampleOffers[2].proposalsNew = 3;
    sampleOffers[2].proposalsAccepted = 7;
    sampleOffers[2].proposalsRefused = 1;*/

    sampleOffers[3].terms = new DataTerms();
    sampleOffers[3].offerId = new Int64(3);
    sampleOffers[3].senderId = new Int64(2);
    sampleOffers[3].state = OfferState.closed;
    sampleOffers[3].stateReason = OfferStateReason.completed;
    sampleOffers[3].title = "Fishing Season";
    sampleOffers[3].description =
        "Looking to catch more customers during the fishing season.";
    sampleOffers[3].thumbnailUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/rally.jpg";
    sampleOffers[3].terms.rewardItemOrServiceDescription = "Free dinner";
    sampleOffers[3].terms.deliverablesDescription =
        "Posts with photography across social media.";
    sampleOffers[3].locationAddress =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    /*sampleOffers[3].proposalsCompleted = 1;
    sampleOffers[3].proposalsRefused = 17;*/
  }

  void generateSamplesSocial() {
    sampleAccounts[1].socialMedia[1].connected = true;
    sampleAccounts[1].socialMedia[1].followersCount = 986;
    sampleAccounts[1].socialMedia[4].connected = true;
    sampleAccounts[1].socialMedia[4].followersCount = 212;
    sampleAccounts[1].socialMedia[5].connected = true;
    sampleAccounts[1].socialMedia[5].followersCount = 5;
    sampleAccounts[2].socialMedia[2].connected = true;
    sampleAccounts[2].socialMedia[2].friendsCount = 156;
    sampleAccounts[2].socialMedia[3].connected = true;
    sampleAccounts[2].socialMedia[3].followersCount = 5432;
  }

  @override
  void initState() {
    super.initState();
    //demoAccount.socialMedia = new List<SocialMedia>();

    generateSamples();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ConfigData config = ConfigProvider.of(context);
    //demoAccount.detail = new DataAccountDetail();
    assert(config != null);
    for (int i = demoAccount.socialMedia.length;
        i < config.oauthProviders.length;
        ++i) {
      // Add
      demoAccount.socialMedia.add(
          new DataSocialMedia()); // Important: PB lists can only be extended using add
    }
    demoAccount.socialMedia.length =
        config.oauthProviders.length; // Reduce
    for (int j = 0; j < sampleAccounts.length; ++j) {
      for (int i = sampleAccounts[j].socialMedia.length;
          i < config.oauthProviders.length;
          ++i) {
        // Add
        sampleAccounts[j].socialMedia.add(
            new DataSocialMedia()); // Important: PB lists can only be extended using add
      }
      sampleAccounts[j].socialMedia.length =
          config.oauthProviders.length; // Reduce
    }
    generateSamplesSocial();
  }

  @override
  void reassemble() {
    super.reassemble();
    generateSamples();
  }

  @override
  Widget build(BuildContext context) {
    assert(ConfigProvider.of(context) != null);

    List<Widget> accountButtons = new List<Widget>();

    for (LocalAccountData localAccount
        in MultiAccountSelection.of(context).accounts) {
      accountButtons.add(new RaisedButton(
        child: new Column(
          children: [
            new Text("Domain: " + localAccount.domain.toString()),
            new Text("Local Id: " + localAccount.localId.toString()),
            new Text("Session Id: " + localAccount.sessionId.toString()),
            new Text("Account Id: " + localAccount.accountId.toString()),
            new Text("Account Type: " + localAccount.accountType.toString()),
            new Text("Name: " + localAccount.name.toString()),
          ],
        ),
        onPressed: () {
          MultiAccountSelection.of(context)
              .switchAccount(localAccount.domain, localAccount.accountId);
          widget.onExitDevelopmentMode();
        },
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Developer Menu'),
        actions: [
          new SearchButton(onSearchPressed: () {
            transitionPage(
                context,
                new SearchScreen(
                  initialSearchQuery: "Test initial query",
                  onSearchRequest: (String searchQuery) async {
                    // This is just a dummy search that doesn't do anything but return a shuffled list of accounts and add a dummy account
                    await new Future.delayed(new Duration(seconds: 2));
                    DataAccount data = new DataAccount();
                    data.accountId = new Int64(random.nextInt(500) + 10);
                    data.accountType = AccountType.business;
                    data.globalAccountState =
                        GlobalAccountState.readWrite;
                    data.name = "Name: $searchQuery";
                    data.description = "Description: $searchQuery";
                    data.avatarUrl =
                        "https://res.cloudinary.com/inf-marketplace/image/upload/c_fill,g_face:center,h_360,w_360,q_auto/dev/demo/kahuna.jpg";
                    data.location = "Location";
                    // data.coverUrls.length = 0;
                    // data.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");
                    return sampleAccounts.toList()
                      ..removeAt(0)
                      ..shuffle()
                      ..insert(0, data);
                  },
                ));
          })
        ],
      ),
      body: new ListView(
        children: [
          ///
          /// Demo entry
          ///
          new Divider(),
          new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            new Text('Demo', style: Theme.of(context).textTheme.subhead),
          ]),
          /*
          new FlatButton(
            child: new Row(
                children: [new Text('Localhost 1 (Genymotion Emulator)')]),
            onPressed: () {
              // widget.onSetServer("ws://192.168.56.1:8090/api", 1);
              widget.onSetServer("ws://192.168.0.111:8090/api", 1);
            }, // 105 = athena, 167 = air
          ),
          new FlatButton(
            child: new Row(
                children: [new Text('Localhost 2 (Genymotion Emulator)')]),
            onPressed: () {
              // widget.onSetServer("ws://192.168.56.1:8090/api", 2);
              widget.onSetServer("ws://192.168.0.111:8090/api", 1);
            }, // 1&2 = mariadb.devinf.net
          ),
          new FlatButton(
            child: new Row(children: [new Text('Excalibur 1')]),
            onPressed: () {
              widget.onSetServer("wss://excalibur.devinf.net/api", 1);
            }, // 105 = athena, 167 = air
          ),
          new FlatButton(
            child: new Row(children: [new Text('Excalibur 2')]),
            onPressed: () {
              widget.onSetServer("wss://excalibur.devinf.net/api", 2);
            }, // 1&2 = mariadb.devinf.net
          ),
          */
          new FlatButton(
            child: new Row(children: [new Text("Switch server to Excalibur")]),
            onPressed: () {
              NetworkProvider.of(context)
                  .overrideUri("wss://excalibur.devinf.net/api");
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text("Switch server to Ulfberth")]),
            onPressed: () {
              NetworkProvider.of(context)
                  .overrideUri("wss://ulfberth.devinf.net/api");
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text("Switch server to 192.168.56.1")]),
            onPressed: () {
              NetworkProvider.of(context)
                  .overrideUri("ws://192.168.56.1:8090/ep");
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text("Switch server to 192.168.105.2")]),
            onPressed: () {
              NetworkProvider.of(context)
                  .overrideUri("ws://192.168.105.2:8090/ep");
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text("Switch server to 192.168.43.123")]),
            onPressed: () {
              NetworkProvider.of(context)
                  .overrideUri("ws://192.168.167.2:8090/ep");
            },
          ),
          new Column(children: accountButtons),
          new FlatButton(
            child: new Row(children: [new Text('Add Account')]),
            onPressed: () {
              MultiAccountSelection.of(context).addAccount();
              widget.onExitDevelopmentMode();
            },
          ),

          ///
          /// The Portion for the On boarding UI
          ///
          new Divider(),
          new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            new Text('Onboarding UI',
                style: Theme.of(context).textTheme.subhead),
          ]),
          new FlatButton(
            child: new Row(children: [new Text('Onboarding Selection')]),
            onPressed: () {
              transitionPage(
                  context,
                  new OnboardingSelection(
                    onInfluencer: () {
                      demoAccount.accountType = AccountType.influencer;
                      /* Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("You're an influencer!"),
                        )); */ // Tricky: context here is route context, not the scaffold of the onboarding selection
                    },
                    onBusiness: () {
                      demoAccount.accountType = AccountType.business;
                      /* scaffold.showSnackBar(new SnackBar(
                          content: new Text("You're a business!"),
                        )); */
                    },
                  ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('Onboarding Social')]),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  return new StatefulBuilder(
                    builder: (context, setState) {
                      assert(ConfigProvider.of(context) != null);
                      return new OnboardingSocial(
                        accountType: demoAccount.accountType,
                        oauthProviders:
                            ConfigProvider.of(context).oauthProviders,
                        onOAuthSelected: (int oauthProvider) {
                          setState(() {
                            demoAccount.socialMedia[oauthProvider]
                                .connected = true;
                            demoAccount.socialMedia[oauthProvider]
                                .followersCount = random.nextInt(1000000);
                            demoAccount.socialMedia[oauthProvider]
                                .friendsCount = random.nextInt(1000000);
                          });
                        },
                        oauthState: demoAccount
                            .socialMedia, // () { return demoSocialMedia; }(),
                        termsOfServiceUrl: ConfigProvider.of(context)
                            .services
                            .termsOfServiceUrl,
                        privacyPolicyUrl: ConfigProvider.of(context)
                            .services
                            .privacyPolicyUrl,
                        onSignUp: () async {
                          demoAccount.accountId =
                              new Int64(random.nextInt(1000000) + 1);
                          demoAccount.name = "John Smith";
                          demoAccount.description =
                              "I'm here for the food.";
                          demoAccount.avatarUrl =
                              "https://res.cloudinary.com/inf-marketplace/image/upload/c_fill,g_face:center,h_360,w_360,q_auto/dev/demo/friesjpg";
                          demoAccount.avatarUrl =
                              "https://res.cloudinary.com/inf-marketplace/image/upload/c_limit,h_1440,w_1440,q_auto/dev/demo/fries.jpg";
                          // demoAccount.coverUrls.length = 0;
                          // demoAccount.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg");
                          demoAccount.location = "Cardiff, London";
                          demoAccount.globalAccountState =
                              GlobalAccountState.readWrite;
                          demoAccount.globalAccountStateReason =
                              GlobalAccountStateReason.demoApproved;
                          // print("Get pos");
                          try {
                            Position position = await Geolocator()
                                .getLastKnownPosition(
                                    desiredAccuracy: LocationAccuracy.medium);
                            print('test');
                            print(position?.latitude); // May be null
                            print(position?.longitude); // May be null
                          } catch (ex) {
                            print(ex); // Or fail to give permissions
                            // PlatformException(PERMISSION_DENIED, Access to location data denied, null)
                          }
                          await new Future.delayed(new Duration(seconds: 1));
                          print('ok');
                          // () async { await null; Navigator.pop(context); }(); // Trickery to execute after this function
                        },
                      );
                    },
                  );
                },
              ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text("Reset Onboarding")]),
            onPressed: () {
              demoAccount.accountId = new Int64(0);
              demoAccount.accountType = AccountType.unknown;
              demoAccount.name = '';
              demoAccount.description = '';
              demoAccount.avatarUrl = '';
              demoAccount.location = '';
              demoAccount.coverUrls.clear();
              // demoAccount.coverUrls.length = 0;
              demoAccount.globalAccountState =
                  GlobalAccountState.initialize;
              demoAccount.globalAccountStateReason =
                  GlobalAccountStateReason.newAccount;
              for (int i = 0; i < demoAccount.socialMedia.length; ++i) {
                demoAccount.socialMedia[i] = new DataSocialMedia();
              }
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text("Debug Account")]),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  return new DebugAccount(
                    account: demoAccount,
                  );
                },
              ));
            },
          ),

          ///
          /// The Portion for the Business UI
          ///
          new Divider(),
          new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            new Text('Business UI', style: Theme.of(context).textTheme.subhead),
          ]),
          new FlatButton(
            child: new Row(children: [new Text('Business Dashboard')]),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  return new DashboardCommon(
                    account: demoAccount,
                    mapTab: 0,
                    offersTab: 1,
                    proposalsTab: 2,
                    onMakeAnOffer: () {},
                    onNavigateProfile: () {},
                    map: new Text(
                            "/* Map */") /*new NearbyCommon(
                      searchHint: "Find nearby influencers...",
                      searchTooltip: "Search for nearby influencers",
                      onSearchPressed: (TextEditingController searchQuery) {
                        transitionPage(
                            context,
                            new SearchScreen(
                              initialSearchQuery: searchQuery.text,
                              onSearchRequest: (String searchQuery) async {
                                // This is just a dummy search that doesn't do anything
                                await new Future.delayed(
                                    new Duration(seconds: 2));
                                DataAccount data = new DataAccount();
                                data.state = new DataAccountState();
                                data.summary = new DataAccountSummary();
                                data.detail = new DataAccountDetail();
                                data.accountId = random.nextInt(500) + 10;
                                data.accountType =
                                    AccountType.business;
                                data.globalAccountState =
                                    GlobalAccountState.readWrite;
                                data.name = "Name: $searchQuery";
                                data.description =
                                    "Description: $searchQuery";
                                data.avatarThumbnailUrl =
                                    "https://res.cloudinary.com/inf-marketplace/image/upload/c_fill,g_face:center,h_360,w_360,q_auto/dev/demo/kahuna.jpg";
                                data.location = "Location";
                                // data.coverUrls.length = 0;
                                // data.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");
                                return sampleAccounts.toList()
                                  ..removeAt(0)
                                  ..shuffle()
                                  ..insert(0, data);
                              },
                            ));
                      },
                    )*/
                        ,
                    offersCurrent: new OfferList(
                      businessOffers: [
                        sampleOffers[1],
                        sampleOffers[2],
                      ],
                    ),
                    offersHistory: new OfferList(
                      businessOffers: [
                        sampleOffers[3],
                      ],
                    ),
                    /*proposalsApplying: new Text("Sent"),
                    proposalsAccepted: new Text("Accepted"),
                    proposalsHistory: new Text("History"),*/
                  );
                },
              ));
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text('View Business Profile (Self)')]),
            onPressed: () {
              demoAccount.accountType = AccountType.business;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
                    oauthProviders:
                        ConfigProvider.of(context).oauthProviders,
                  ));
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text('Edit Business Profile (Self)')]),
            onPressed: () {
              demoAccount.accountType = AccountType.business;
              transitionPage(
                  context,
                  new ProfileEdit(
                    account: demoAccount,
                  ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('Select Location')]),
            onPressed: () {
              demoAccount.accountType = AccountType.business;
              transitionPage(
                  context,
                  new LocationSelectionScreen(
                    onConfirmPressed: (coordinates) {
                      print(coordinates);
                    },
                    onSearch: (query) async {
                      return showSearch(
                          context: context,
                          delegate: new LocationSearch(),
                          query: query);
                    },
                  ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('Geocode test')]),
            onPressed: () {
              demoAccount.accountType = AccountType.business;
              transitionPage(
                context,
                new GeocodingTestPage(),
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('View Influencer Profile')]),
            onPressed: () {
              demoAccount.accountType = AccountType.influencer;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
                    oauthProviders:
                        ConfigProvider.of(context).oauthProviders,
                  ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('Offer Create')]),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  return new OfferCreate();
                },
              ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('Offer View (Self)')]),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  return new OfferView(
                    businessOffer: sampleOffers[1],
                    businessAccount: demoAccount,
                    account: demoAccount,
                    onSharePressed: () {},
                    onEndPressed: () {},
                    onEditPressed: () {},
                    onProposalsPressed: () {},
                  );
                },
              ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('Offer Edit')]),
            onPressed: null,
          ),
          new FlatButton(
            child: new Row(children: [new Text('Proposal Chat')]),
            onPressed: null,
          ),

          ///
          /// The Portion for the Influencer UI
          ///
          new Divider(),
          new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            new Text('Influencer UI',
                style: Theme.of(context).textTheme.subhead),
          ]),
          new FlatButton(
            child: new Row(children: [new Text('Influencer Dashboard')]),
            /*onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new InfluencerProfile();
                  },
                )
              );
            },*/
          ),
          new FlatButton(
            child:
                new Row(children: [new Text('View Influencer Profile (Self)')]),
            onPressed: () {
              demoAccount.accountType = AccountType.influencer;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
                    oauthProviders:
                        ConfigProvider.of(context).oauthProviders,
                  ));
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text('Edit Influencer Profile (Self)')]),
            /*onPressed: () { 
              demoAccount.accountType = AccountType.influencer;
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new InfluencerProfile();
                  },
                )
              );
            },*/
          ),
          new FlatButton(
            child: new Row(children: [new Text('Offer View')]),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  return new OfferView(
                    businessOffer: sampleOffers[1],
                    businessAccount: sampleAccounts[1],
                    account: demoAccount,
                    onApply: (remarks) {
                      // TODO: ------------------------------------------------------
                    },
                  );
                },
              ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('View Business Profile')]),
            onPressed: () {
              demoAccount.accountType = AccountType.business;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
                    oauthProviders:
                        ConfigProvider.of(context).oauthProviders,
                  ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('Business Chat')]),
            /*onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new InfluencerProfile();
                  },
                )
              );
            },*/
          ),
          new Divider(),
        ],
      ),
    );
  }
}

/* end of file */
