import 'package:flutter/material.dart';

import '../network/config_manager.dart' show ConfigManager;
import '../onboarding_selection.dart' show OnboardingSelection;
import '../onboarding_social.dart' show OnboardingSocial;
// import '../influencer_dashboard.dart' show InfluencerDashboard;
import '../offer_view.dart' show OfferView;
import '../offer_create.dart' show OfferCreate;
import '../dashboard_business.dart' show DashboardBusiness;
import '../profile_view.dart' show ProfileView;

import '../network/inf.pb.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({
    Key key,
    this.startupConfig
  }) : super(key: key);

  final ConfigData startupConfig;

  @override
  Widget build(BuildContext context) {
    return new ConfigManager(
      startupConfig: startupConfig,
      child: new MaterialApp(
        title: '*** INF UI Demo ***',
        theme: new ThemeData(
          brightness: Brightness.dark, // This makes things dark!
          primarySwatch: Colors.blueGrey, // This is just defaults, no need to change!
          disabledColor: Colors.white12, // Dark fix
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
        ).copyWith(
          // Generate these values on https://material.io/color/!
          primaryColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
          primaryColorLight: new Color.fromARGB(0xff, 0x80, 0x94, 0x86),
          primaryColorDark: new Color.fromARGB(0xff, 0x2a, 0x3c, 0x30),
          buttonColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
          // Double the value of primaryColor // Generate A200 on http://mcg.mbitson.com/!
          accentColor: new Color.fromARGB(0xff, 0xa8, 0xcd, 0xb3), // 52FF88,
          // Grayscale of primaryColor
          unselectedWidgetColor: new Color.fromARGB(0xff, 0x5D, 0x5D, 0x5D),
        ),
        home: new DemoHomePage(), // new OnboardingSelection(onInfluencer: () { }, onBusiness: () { }), // 
      ),
    );
  }
}

class MeepMeep extends StatelessWidget { // stateless widget is just a widget that follows whatever configuration it's given
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          new Text('Vrooom!')
        ],
      ),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('***INF UI Demo***'),
      ),
      body: new ListView(
        children: <Widget>[
          ///
          /// The Portion for the On boarding UI
          ///
          new Divider(),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ new Text('Onboarding UI', style: Theme.of(context).textTheme.subhead), ]
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Onboarding Selection') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new OnboardingSelection(
                      onInfluencer: () {
                        /*scaffold.showSnackBar(new SnackBar(
                          content: new Text("You're an influencer!"),
                        )); */
                      },
                      onBusiness: () {
                        /* scaffold.showSnackBar(new SnackBar(
                          content: new Text("You're a business!"),
                        )); */
                      },
                    );
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Onboarding Social') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new OnboardingSocial(
                      accountType: AccountType.AT_BUSINESS,
                      oauthProviders: ConfigManager.of(context).oauthProviders.all,
                    );
                  },
                )
              );
            },
          ),
          ///
          /// The Portion for the Business UI
          ///
          new Divider(),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ new Text('Business UI', style: Theme.of(context).textTheme.subhead), ]
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Business Dashboard') ] ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new DashboardBusiness();
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('View Business Profile (Self)') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new ProfileView(
                      self: true,
                      profileName: 'Big Kahuna Burger',
                      profileLocation: "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
                      profileDescription: "This is the tasty burger worth dying for",
                    );
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Edit Business Profile (Self)') ] ),
            /*onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new BusinessProfile();
                  },
                )
              );
            },*/
          ),
          new FlatButton(
            child: new Row(children: [ new Text('View Influencer Profile') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new ProfileView(
                      self: false,
                      profileName: 'John Doe',
                      profileLocation: 'San Francisco, California',
                      profileDescription: "Hi! My name is John. I'm a creative geek and love fast food. I also dig Pokemons",
                    );
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Offer Create') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new OfferCreate();
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Offer Edit') ] ),
            onPressed: null,
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Applicant Chat') ] ),
            onPressed: null,
          ),
          ///
          /// The Portion for the Influencer UI
          ///
          new Divider(),
          new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ new Text('Influencer UI', style: Theme.of(context).textTheme.subhead), ]
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Influencer Dashboard') ] ),
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
            child: new Row(children: [ new Text('View Influencer Profile (Self)') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new ProfileView(
                      self: true,
                      profileName: 'John Doe',
                      profileLocation: 'San Francisco, California',
                      profileDescription: "Hi! My name is John. I'm a creative geek and love fast food. I also dig Pokemons",
                    );
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Edit Influencer Profile (Self)') ] ),
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
            child: new Row(children: [ new Text('Offer View') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new OfferView();
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('View Business Profile') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new ProfileView(
                      self: false,
                      profileName: 'Big Kahuna Burger',
                      profileLocation: "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
                      profileDescription: "This is the tasty burger worth dying for",
                    );
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Business Chat') ] ),
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