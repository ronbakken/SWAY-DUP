import 'package:flutter/material.dart';

import 'onboarding_selection.dart' show OnboardingSelection;
import 'onboarding_social.dart' show OnboardingSocial, AccountType;
import 'influencer_dashboard.dart' show InfluencerDashboard;
import 'offer_view.dart' show OfferView;

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'INF UI Demo',
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
      children: <Widget>[ new Text( 'Vrooom!' )],
      ),
    );
  }
}
/*
class MagicScaffold extends StatelessWidget {
  const MagicScaffold({
    Key key,
    this.appBar,
    this.drawer,
    this.body,
    this.appBarGradient: true,
  }) : super(key: key);

  final AppBar appBar;
  final SliverAppBar sliverAppBar;
  final Widget drawer;
  final Widget body;

  /// Adds a gradient below the [appBar] when it is transparent
  final bool appBarGradient;

  @override
  Widget build(BuildContext context) {
    if (appBar.backgroundColor != null && appBar.backgroundColor.alpha < 255) {
      return new Scaffold(
        drawer: drawer,
        body: new Stack(
          children: <Widget>[
            body,
            new Column(children: <Widget>[
              appBar
            ]) ,
          ],
        ),
      );
    } else {
      return new Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: body,
      );
    }
  }
}
*/
class DemoHomePage extends StatefulWidget { // stateful widget is basically a widget with private data
  @override
  _DemoHomePageState createState() => new _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  Widget _body = new Center(
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          'Pick a demo!',
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('INF UI Demo!'),
      ),
      drawer: new Builder(
        builder: (BuildContext context) {
          ScaffoldState scaffold = Scaffold.of(context);
          return new Drawer(
            child: new ListView(
              children: <Widget>[
                new FlatButton(
                  child: new Row(
                    children: [
                      new Text('Meep meep')
                    ],
                  ),
                  onPressed: () { setState(() { Navigator.of(context).pop(); _body = new MeepMeep(); }); },
                ),
                new FlatButton(
                  child: new Row(children: [ new Text('Onboarding Selection') ] ),
                  onPressed: () { setState(() { Navigator.of(context).pop(); _body = new OnboardingSelection(
                    onInfluencer: () {
                      scaffold.showSnackBar(new SnackBar(
                        content: new Text("You're an influencer!"),
                      )); 
                    },
                    onBusiness: () {
                      scaffold.showSnackBar(new SnackBar(
                        content: new Text("You're a business!"),
                      )); 
                    },
                  ); }); },
                ),
                new FlatButton(
                  child: new Row(children: [ new Text('Onboarding Social') ] ),
                  onPressed: () { setState(() { Navigator.of(context).pop(); _body = new OnboardingSocial(
                    accountType: AccountType.Influencer,
                    onTwitter: () {
                      scaffold.showSnackBar(new SnackBar(
                        content: new Text("You're a twat!"),
                      )); 
                    },
                  ); }); },
                ),
                new FlatButton(
                  child: new Row(children: [ new Text('Influencer Dashboard') ] ),
                  onPressed: () { setState(() { Navigator.of(context).pop(); _body = new InfluencerDashboard(); }); },
                ),
                new FlatButton(
                  child: new Row(children: [ new Text('Offer View') ] ),
                  onPressed: () { setState(() { Navigator.of(context).pop(); _body = new OfferView(); }); },
                ),
              ],
            ),
          );
        }
      ),
      body: _body,
    );
  }
}
