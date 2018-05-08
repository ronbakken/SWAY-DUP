import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AccountType {
  Influencer,
  Business
}

class OnboardingSocial extends StatelessWidget {
  const OnboardingSocial({
    Key key,
    @required this.accountType,
    @required this.onTwitter,
  }) : super(key: key);

  final AccountType accountType;  
  final VoidCallback onTwitter;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Image(
          image: new AssetImage('assets/logo_appbar.png')
        ),
        centerTitle: true,
      ),
      body: new ListView(
        children: [
          new Container(
            margin: new EdgeInsets.all(8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Container(
                  margin: new EdgeInsets.all(8.0),
                  child: new Text(
                    accountType == AccountType.Influencer ? "You are now an influencer!" : "You are now a business!",
                    style: Theme.of(context).textTheme.display1,
                    textAlign: TextAlign.center,
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                  child: new Text(
                    "Which social media accounts would you like to connect with?",
                    style: Theme.of(context).textTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                ),
                new Column(
                  children: [
                    new Container(
                      margin: new EdgeInsets.all(8.0),
                      child: new RaisedButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("Twitter".toUpperCase())
                          ]
                        ),
                        onPressed: onTwitter,
                      )
                    ),
                    new Container(
                      margin: new EdgeInsets.all(8.0),
                      child: new RaisedButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("Facebook".toUpperCase())
                          ]
                        ),
                      )
                    ),
                    new Container(
                      margin: new EdgeInsets.all(8.0),
                      child: new RaisedButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("Instagram".toUpperCase())
                          ]
                        ),
                      )
                    ),
                    new Container(
                      margin: new EdgeInsets.all(8.0),
                      child: new RaisedButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("Google".toUpperCase())
                          ]
                        ),
                      )
                    ),
                    new Container(
                      margin: new EdgeInsets.all(8.0),
                      child: new RaisedButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("Twitch".toUpperCase())
                          ]
                        ),
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
