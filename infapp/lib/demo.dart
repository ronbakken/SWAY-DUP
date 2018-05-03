import 'package:flutter/material.dart';

import 'influencer_dashboard.dart' show InfluencerDashboard;
import 'offer_view.dart' show OfferView;

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'INF UI Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new DemoHomePage(),
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
      drawer: new Drawer(
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
              child: new Row(children: [ new Text('Influencer Dashboard') ] ),
              onPressed: () { setState(() { Navigator.of(context).pop(); _body = new InfluencerDashboard(); }); },
            ),
            new FlatButton(
              child: new Row(children: [ new Text('Offer View') ] ),
              onPressed: () { setState(() { Navigator.of(context).pop(); _body = new OfferView(); }); },
            ),
          ],
        )
      ),
      body: _body,
    );
  }
}
