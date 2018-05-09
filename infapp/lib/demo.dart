import 'package:flutter/material.dart';

import 'onboarding_selection.dart' show OnboardingSelection;
import 'onboarding_social.dart' show OnboardingSocial, AccountType;
import 'influencer_dashboard.dart' show InfluencerDashboard;
import 'offer_view.dart' show OfferView;
import 'offer_create.dart' show OfferCreate;

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '*** INF UI Demo ***',
      theme: new ThemeData(
        brightness: Brightness.dark, // This makes things dark!
        primarySwatch: Colors.blueGrey, // This is just defaults, no need to change!
      ).copyWith(
        // Generate these values on https://material.io/color/!
        primaryColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        primaryColorLight: new Color.fromARGB(0xff, 0x80, 0x94, 0x86),
        primaryColorDark: new Color.fromARGB(0xff, 0x2a, 0x3c, 0x30),
        buttonColor: new Color.fromARGB(0xff, 0x53, 0x66, 0x59),
        // Generate A200 on http://mcg.mbitson.com/!
        accentColor: new Color.fromARGB(0xff, 0x52, 0xFF, 0x88), // 52FF88
      ),
      home: new DemoHomePage(), // new OnboardingSelection(onInfluencer: () { }, onBusiness: () { }), // 
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
          new FlatButton(
            child: new Row( children: [ new Text('Meep meep') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new MeepMeep();
                  },
                )
              );
            },
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
          new RaisedButton(
            child: new Row(children: [ new Text('Onboarding Social') ] ),
            onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new OnboardingSocial(
                      accountType: AccountType.Influencer,
                      onTwitter: () {
                        /*scaffold.showSnackBar(new SnackBar(
                          content: new Text("You're a twat!"),
                        )); */
                      },
                    );
                  },
                )
              );
            },
          ),
          new FlatButton(
            child: new Row(children: [ new Text('Influencer Dashboard') ] ),
            /*onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new InfluencerDashboard();
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
            child: new Row(children: [ new Text('Influencer Profile') ] ),
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
            child: new Row(children: [ new Text('Business Profile') ] ),
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
            child: new Row(children: [ new Text('Applicant View') ] ),
            /*onPressed: () { 
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) {
                    return new ApplicantView();
                  },
                )
              );
            },*/
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
        ],
      ),
    );
  }
}
