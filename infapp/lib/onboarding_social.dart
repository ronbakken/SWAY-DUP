import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'oauth/flutter_auth.dart' as oauth;
import 'oauth/config.dart' as oauth;
import 'oauth/oauth.dart' as oauth;
import 'oauth/token.dart' as oauth;

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'oauth_scaffold_presets.dart';

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
                        onPressed: () async {
                          /*
                          print("OAuth");
                          final oauth.OAuth flutterOAuth = new oauth.FlutterOAuth(new oauth.Config(
                            "https://api.twitter.com/oauth/authorize",
                            "https://api.twitter.com/oauth/request_token",
                            "dJBat7EvZlqUuC7qsl9Gi0Kk1",
                            "gwJSX2xyqOic8VLoPHu8zncfh1xogwWKBWrroVoNfwM4X70n0m",
                            "https://no-break.space",
                            "code"));
                          print("Let's go!");
                          oauth.Token token = await flutterOAuth.performAuthorization();
                          String accessToken = token.accessToken;
                          print(accessToken);
                          onTwitter();
                          */
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) {
                                return new OAuthScaffoldTwitter(
                                  appBar: new AppBar(
                                    title: new Image(
                                      image: new AssetImage('assets/logo_appbar.png')
                                    ),
                                    centerTitle: true,
                                  ),
                                  onSuccess: (token, verifier) {
                                    print("Success: ");
                                    print(token);
                                    print(verifier);
                                  },
                                );
                              },
                            )
                          );
                        },
                      ),
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
