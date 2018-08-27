import 'dart:async';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../business_offer_list.dart';
import '../network/inf.pb.dart';
import '../network/config_manager.dart' show ConfigManager;
import '../network/network_manager.dart';

import '../app_switch.dart';
import '../onboarding_selection.dart' show OnboardingSelection;
import '../onboarding_social.dart' show OnboardingSocial;
import '../page_transition.dart';
import '../offer_view.dart' show OfferView;
import '../offer_create.dart' show OfferCreate;
import '../dashboard_business.dart' show DashboardBusiness;
import '../nearby_influencers.dart';
import '../profile/profile_view.dart' show ProfileView;
import '../profile/profile_edit.dart' show ProfileEdit;
import '../search/search_button.dart';
import '../search/search_page.dart';
import '../debug_account.dart';

class DemoApp extends StatefulWidget {
  const DemoApp({Key key, this.startupConfig}) : super(key: key);

  final ConfigData startupConfig;

  @override
  _DemoAppState createState() => new _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  String overrideUri =
      ''; // "ws://192.168.105.2:9090/ws" (empty string disables connect, null uses config)
  int localAccountId = 0; // 1

  void setServer(String uri, int localAccountId) {
    setState(() {
      this.overrideUri = uri;
      this.localAccountId = localAccountId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set base colors
    ThemeData theme = new ThemeData(
      brightness: Brightness.dark, // This makes things dark!
      primarySwatch:
          Colors.blueGrey, // This is just defaults, no need to change!
      disabledColor: Colors.white12, // Dark fix
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
    );
    // Adjust colors
    theme = theme.copyWith(
      // Generate these values on https://material.io/color/!
      primaryColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
      primaryColorLight: new Color.fromARGB(0xff, 0x80, 0x94, 0x86),
      primaryColorDark: new Color.fromARGB(0xff, 0x2a, 0x3c, 0x30),
      buttonColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
      // Double the value of primaryColor // Generate A200 on http://mcg.mbitson.com/!
      accentColor: new Color.fromARGB(0xff, 0xa8, 0xcd, 0xb3), // 52FF88,
      // Grayscale of primaryColor
      unselectedWidgetColor: new Color.fromARGB(0xff, 0x5D, 0x5D, 0x5D),
    );
    // Adjust widget themes
    theme = theme.copyWith(
      buttonTheme: theme.buttonTheme.copyWith(
        shape: new StadiumBorder(),
      ),
    );
    return new ConfigManager(
      key: new Key('InfDemo.ConfigManager'),
      startupConfig: widget.startupConfig,
      child: new NetworkManager(
        key: new Key('InfDemo.NetworkManager'),
        overrideUri: overrideUri, // Uri of server to connect with
        localAccountId: localAccountId,
        // overrideUri: "ws://localhost:9090/ws",
        child: new MaterialApp(
          title: '*** INF UI Demo ***',
          /*builder: (BuildContext context, Widget child) {
            
          },*/
          // debugShowMaterialGrid: true,
          theme: theme,
          home: localAccountId != 0
              ? new AppSwitch()
              : new DemoHomePage(
                  onSetServer:
                      setServer), // new OnboardingSelection(onInfluencer: () { }, onBusiness: () { }), //
        ),
      ),
    );
  }
}

class MeepMeep extends StatelessWidget {
  // stateless widget is just a widget that follows whatever configuration it's given
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [new Text('Vrooom!')],
      ),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({Key key, this.onSetServer}) : super(key: key);

  final Function onSetServer;

  @override
  _DemoHomePageState createState() => new _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  DataAccount demoAccount = new DataAccount();
  final Random random = new Random();

  List<DataAccount> sampleAccounts = new List<DataAccount>();
  List<DataBusinessOffer> sampleBusinessOffers = new List<DataBusinessOffer>();

  void generateSamples() {
    sampleAccounts.length = 3;
    for (int i = 0; i < sampleAccounts.length; ++i) {
      if (sampleAccounts[i] == null) {
        sampleAccounts[i] = new DataAccount();
        sampleAccounts[i].state = new DataAccountState();
        sampleAccounts[i].summary = new DataAccountSummary();
        sampleAccounts[i].detail = new DataAccountDetail();
      }
    }

    sampleAccounts[1].state.accountId = 1;
    sampleAccounts[1].state.accountType = AccountType.AT_BUSINESS;
    sampleAccounts[1].state.globalAccountState =
        GlobalAccountState.GAS_READ_WRITE;
    sampleAccounts[1].summary.name = "Big Kahuna";
    sampleAccounts[1].summary.description =
        "The best burgers in the known universe. As far as we know.";
    sampleAccounts[1].summary.avatarThumbnailUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg";
    sampleAccounts[1].summary.location =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    // sampleAccounts[1].detail.coverUrls.length = 0;
    // sampleAccounts[1].detail.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");

    sampleAccounts[2].state.accountId = 2;
    sampleAccounts[2].state.accountType = AccountType.AT_BUSINESS;
    sampleAccounts[2].state.globalAccountState =
        GlobalAccountState.GAS_READ_WRITE;
    sampleAccounts[2].summary.name = "Fried Willy";
    sampleAccounts[2].summary.description = "We don't prepare dolphins.";
    sampleAccounts[2].summary.avatarThumbnailUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg";
    sampleAccounts[2].summary.location =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    // sampleAccounts[2].detail.coverUrls.length = 0;
    // sampleAccounts[2].detail.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/fries.jpg");
    // sampleAccounts[1].detail.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg");

    sampleBusinessOffers.length = 4;
    for (int i = 0; i < sampleBusinessOffers.length; ++i) {
      if (sampleBusinessOffers[i] == null) {
        sampleBusinessOffers[i] = new DataBusinessOffer();
      }
    }

    sampleBusinessOffers[1].offerId = new Int64(1);
    sampleBusinessOffers[1].accountId = 1;
    sampleBusinessOffers[1].state = BusinessOfferState.BOS_OPEN;
    sampleBusinessOffers[1].stateReason =
        BusinessOfferStateReason.BOSR_NEW_OFFER;
    sampleBusinessOffers[1].title = "Finest Burger Weekend";
    sampleBusinessOffers[1].description =
        "We'd like to expose the finest foods in our very busy restaurant to a wide audience.";
    sampleBusinessOffers[1].avatarUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg";
    sampleBusinessOffers[1].reward = "Free dinner + \$150";
    sampleBusinessOffers[1].deliverables =
        "Posts with photography across social media.";
    sampleBusinessOffers[1].location =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    sampleBusinessOffers[1].coverUrls.length = 0;
    sampleBusinessOffers[1]
        .coverUrls
        .add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");
    sampleBusinessOffers[1].applicantsNew = 3;
    sampleBusinessOffers[1].applicantsRefused = 1;

    sampleBusinessOffers[2].offerId = new Int64(2);
    sampleBusinessOffers[2].accountId = 1;
    sampleBusinessOffers[2].state = BusinessOfferState.BOS_OPEN;
    sampleBusinessOffers[2].stateReason =
        BusinessOfferStateReason.BOSR_NEW_OFFER;
    sampleBusinessOffers[2].title = "Burger Weekend Fries";
    sampleBusinessOffers[2].description =
        "We need some table fillers to make our restaurant look very busy this weekend.";
    sampleBusinessOffers[2].avatarUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/fries.jpg";
    sampleBusinessOffers[2].reward = "Free Poke Fries";
    sampleBusinessOffers[2].deliverables =
        "Posts with photography across social media.";
    sampleBusinessOffers[2].location =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    sampleBusinessOffers[2].applicantsNew = 3;
    sampleBusinessOffers[2].applicantsAccepted = 7;
    sampleBusinessOffers[2].applicantsRefused = 1;

    sampleBusinessOffers[3].offerId = new Int64(3);
    sampleBusinessOffers[3].accountId = 2;
    sampleBusinessOffers[3].state = BusinessOfferState.BOS_CLOSED;
    sampleBusinessOffers[3].stateReason =
        BusinessOfferStateReason.BOSR_COMPLETED;
    sampleBusinessOffers[3].title = "Fishing Season";
    sampleBusinessOffers[3].description =
        "Looking to catch more customers during the fishing season.";
    sampleBusinessOffers[3].avatarUrl =
        "https://inf-dev.nyc3.digitaloceanspaces.com/demo/rally.jpg";
    sampleBusinessOffers[3].reward = "Free dinner";
    sampleBusinessOffers[3].deliverables =
        "Posts with photography across social media.";
    sampleBusinessOffers[3].location =
        "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024";
    sampleBusinessOffers[3].applicantsCompleted = 1;
    sampleBusinessOffers[3].applicantsRefused = 17;
  }

  void generateSamplesSocial() {
    sampleAccounts[1].detail.socialMedia[1].connected = true;
    sampleAccounts[1].detail.socialMedia[1].followersCount = 986;
    sampleAccounts[1].detail.socialMedia[4].connected = true;
    sampleAccounts[1].detail.socialMedia[4].followersCount = 212;
    sampleAccounts[1].detail.socialMedia[5].connected = true;
    sampleAccounts[1].detail.socialMedia[5].followersCount = 5;
    sampleAccounts[2].detail.socialMedia[2].connected = true;
    sampleAccounts[2].detail.socialMedia[2].friendsCount = 156;
    sampleAccounts[2].detail.socialMedia[3].connected = true;
    sampleAccounts[2].detail.socialMedia[3].followersCount = 5432;
  }

  @override
  void initState() {
    super.initState();
    //demoAccount.detail.socialMedia = new List<SocialMedia>();

    demoAccount.state = new DataAccountState();
    demoAccount.summary = new DataAccountSummary();
    demoAccount.detail =
        new DataAccountDetail(); // Important: Need to initialize fields, or they are read only

    generateSamples();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ConfigData config = ConfigManager.of(context);
    //demoAccount.detail = new DataAccountDetail();
    assert(config != null);
    for (int i = demoAccount.detail.socialMedia.length;
        i < config.oauthProviders.all.length;
        ++i) {
      // Add
      demoAccount.detail.socialMedia.add(
          new DataSocialMedia()); // Important: PB lists can only be extended using add
    }
    demoAccount.detail.socialMedia.length =
        config.oauthProviders.all.length; // Reduce
    for (int j = 0; j < sampleAccounts.length; ++j) {
      for (int i = sampleAccounts[j].detail.socialMedia.length;
          i < config.oauthProviders.all.length;
          ++i) {
        // Add
        sampleAccounts[j].detail.socialMedia.add(
            new DataSocialMedia()); // Important: PB lists can only be extended using add
      }
      sampleAccounts[j].detail.socialMedia.length =
          config.oauthProviders.all.length; // Reduce
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
    assert(ConfigManager.of(context) != null);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('***INF UI Demo***'),
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
                    data.state = new DataAccountState();
                    data.summary = new DataAccountSummary();
                    data.detail = new DataAccountDetail();
                    data.state.accountId = random.nextInt(500) + 10;
                    data.state.accountType = AccountType.AT_BUSINESS;
                    data.state.globalAccountState =
                        GlobalAccountState.GAS_READ_WRITE;
                    data.summary.name = "Name: $searchQuery";
                    data.summary.description = "Description: $searchQuery";
                    data.summary.avatarThumbnailUrl =
                        "https://res.cloudinary.com/inf-marketplace/image/upload/c_fill,g_face:center,h_360,w_360,q_auto/dev/demo/kahuna.jpg";
                    data.summary.location = "Location";
                    // data.detail.coverUrls.length = 0;
                    // data.detail.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");
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
          new FlatButton(
            child: new Row(
                children: [new Text('Localhost 1 (Genymotion Emulator)')]),
            onPressed: () {
              widget.onSetServer("ws://192.168.56.1:8090/api", 1);
            }, // 105 = athena, 167 = air
          ),
          new FlatButton(
            child: new Row(
                children: [new Text('Localhost 2 (Genymotion Emulator)')]),
            onPressed: () {
              widget.onSetServer("ws://192.168.56.1:8090/api", 2);
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
                      demoAccount.state.accountType = AccountType.AT_INFLUENCER;
                      /* Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("You're an influencer!"),
                        )); */ // Tricky: context here is route context, not the scaffold of the onboarding selection
                    },
                    onBusiness: () {
                      demoAccount.state.accountType = AccountType.AT_BUSINESS;
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
                      assert(ConfigManager.of(context) != null);
                      return new OnboardingSocial(
                        accountType: demoAccount.state.accountType,
                        oauthProviders:
                            ConfigManager.of(context).oauthProviders.all,
                        onOAuthSelected: (int oauthProvider) {
                          setState(() {
                            demoAccount.detail.socialMedia[oauthProvider]
                                .connected = true;
                            demoAccount.detail.socialMedia[oauthProvider]
                                .followersCount = random.nextInt(1000000);
                            demoAccount.detail.socialMedia[oauthProvider]
                                .friendsCount = random.nextInt(1000000);
                          });
                        },
                        oauthState: demoAccount.detail
                            .socialMedia, // () { return demoSocialMedia; }(),
                        termsOfServiceUrl: ConfigManager.of(context)
                            .services
                            .termsOfServiceUrl,
                        privacyPolicyUrl:
                            ConfigManager.of(context).services.privacyPolicyUrl,
                        onSignUp: () async {
                          demoAccount.state.accountId =
                              random.nextInt(1000000) + 1;
                          demoAccount.summary.name = "John Smith";
                          demoAccount.summary.description =
                              "I'm here for the food.";
                          demoAccount.summary.avatarThumbnailUrl =
                              "https://res.cloudinary.com/inf-marketplace/image/upload/c_fill,g_face:center,h_360,w_360,q_auto/dev/demo/friesjpg";
                          demoAccount.detail.avatarCoverUrl =
                              "https://res.cloudinary.com/inf-marketplace/image/upload/c_limit,h_1440,w_1440,q_auto/dev/demo/fries.jpg";
                          // demoAccount.detail.coverUrls.length = 0;
                          // demoAccount.detail.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg");
                          demoAccount.summary.location = "Cardiff, London";
                          demoAccount.state.globalAccountState =
                              GlobalAccountState.GAS_READ_WRITE;
                          demoAccount.state.globalAccountStateReason =
                              GlobalAccountStateReason.GASR_DEMO_APPROVED;
                          // print("Get pos");
                          try {
                            Position position = await Geolocator()
                                .getLastKnownPosition(LocationAccuracy.medium);
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
              demoAccount.state.accountId = 0;
              demoAccount.state.accountType = AccountType.AT_UNKNOWN;
              demoAccount.summary.name = '';
              demoAccount.summary.description = '';
              demoAccount.summary.avatarThumbnailUrl = '';
              demoAccount.summary.location = '';
              demoAccount.detail.avatarCoverUrl = '';
              // demoAccount.detail.coverUrls.length = 0;
              demoAccount.state.globalAccountState =
                  GlobalAccountState.GAS_INITIALIZE;
              demoAccount.state.globalAccountStateReason =
                  GlobalAccountStateReason.GASR_NEW_ACCOUNT;
              for (int i = 0; i < demoAccount.detail.socialMedia.length; ++i) {
                demoAccount.detail.socialMedia[i] = new DataSocialMedia();
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
                  return new DashboardBusiness(
                    account: demoAccount,
                    onMakeAnOffer: () {},
                    onNavigateProfile: () {},
                    map: new NearbyInfluencers(
                      onSearchPressed: (String searchQuery) {
                        transitionPage(
                            context,
                            new SearchScreen(
                              initialSearchQuery: searchQuery,
                              onSearchRequest: (String searchQuery) async {
                                // This is just a dummy search that doesn't do anything
                                await new Future.delayed(
                                    new Duration(seconds: 2));
                                DataAccount data = new DataAccount();
                                data.state = new DataAccountState();
                                data.summary = new DataAccountSummary();
                                data.detail = new DataAccountDetail();
                                data.state.accountId = random.nextInt(500) + 10;
                                data.state.accountType =
                                    AccountType.AT_BUSINESS;
                                data.state.globalAccountState =
                                    GlobalAccountState.GAS_READ_WRITE;
                                data.summary.name = "Name: $searchQuery";
                                data.summary.description =
                                    "Description: $searchQuery";
                                data.summary.avatarThumbnailUrl =
                                    "https://res.cloudinary.com/inf-marketplace/image/upload/c_fill,g_face:center,h_360,w_360,q_auto/dev/demo/kahuna.jpg";
                                data.summary.location = "Location";
                                // data.detail.coverUrls.length = 0;
                                // data.detail.coverUrls.add("https://inf-dev.nyc3.digitaloceanspaces.com/demo/burger.jpg");
                                return sampleAccounts.toList()
                                  ..removeAt(0)
                                  ..shuffle()
                                  ..insert(0, data);
                              },
                            ));
                      },
                    ),
                    offersCurrent: new BusinessOfferList(
                      businessOffers: [
                        sampleBusinessOffers[1],
                        sampleBusinessOffers[2],
                      ],
                    ),
                    offersHistory: new BusinessOfferList(
                      businessOffers: [
                        sampleBusinessOffers[3],
                      ],
                    ),
                    applicantsApplying: new Text("Applying"),
                    applicantsAccepted: new Text("Accepted"),
                    applicantsHistory: new Text("History"),
                  );
                },
              ));
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text('View Business Profile (Self)')]),
            onPressed: () {
              demoAccount.state.accountType = AccountType.AT_BUSINESS;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
                  ));
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text('Edit Business Profile (Self)')]),
            onPressed: () {
              demoAccount.state.accountType = AccountType.AT_BUSINESS;
              transitionPage(
                  context,
                  new ProfileEdit(
                    account: demoAccount,
                  ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('View Influencer Profile')]),
            onPressed: () {
              demoAccount.state.accountType = AccountType.AT_INFLUENCER;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
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
                    businessOffer: sampleBusinessOffers[1],
                    businessAccount: demoAccount,
                    account: demoAccount,
                    onSharePressed: () {},
                    onEndPressed: () {},
                    onEditPressed: () {},
                    onApplicantsPressed: () {},
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
            child: new Row(children: [new Text('Applicant Chat')]),
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
              demoAccount.state.accountType = AccountType.AT_INFLUENCER;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
                  ));
            },
          ),
          new FlatButton(
            child:
                new Row(children: [new Text('Edit Influencer Profile (Self)')]),
            /*onPressed: () { 
              demoAccount.accountType = AccountType.AT_INFLUENCER;
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
                    businessOffer: sampleBusinessOffers[1],
                    businessAccount: sampleAccounts[1],
                    account: demoAccount,
                  );
                },
              ));
            },
          ),
          new FlatButton(
            child: new Row(children: [new Text('View Business Profile')]),
            onPressed: () {
              demoAccount.state.accountType = AccountType.AT_BUSINESS;
              transitionPage(
                  context,
                  new ProfileView(
                    account: demoAccount,
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
