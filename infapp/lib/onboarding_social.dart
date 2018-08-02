import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'network/config_manager.dart';
import 'network/inf.pb.dart';

typedef void OAuthSelection(int oauthProvider);

class OnboardingSocial extends StatelessWidget {
  const OnboardingSocial({
    Key key,
    @required this.accountType,
    @required this.oauthProviders,
    @required this.oauthState,
    @required this.onOAuthSelected,
    @required this.onSignUp,
  }) : super(key: key);

  final AccountType accountType; 
  final List<ConfigOAuthProvider> oauthProviders;
  final List<DataSocialMedia> oauthState;

  final OAuthSelection onOAuthSelected;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    assert(ConfigManager.of(context) != null);
    List<Widget> oauthButtons = new List<Widget>();
    print("OAuth Providers: " + oauthProviders.length.toString());
    int nbButtons = oauthProviders.length < oauthState.length ? oauthProviders.length : oauthState.length;
    bool connected = false;
    for (int i = 0; i < nbButtons; ++i) {
      ConfigOAuthProvider cfg = oauthProviders[i];
      if (cfg.visible && cfg.mechanism != OAuthMechanism.OAM_NONE) {
        if (oauthState[i].connected) {
          connected = true;
        }
        Widget r = new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Icon(new IconData(cfg.fontAwesomeBrand, fontFamily: 'FontAwesomeBrands', fontPackage: 'font_awesome_flutter')),
            new Text(cfg.label.toUpperCase()),
            new Icon(oauthState[i].connected ? FontAwesomeIcons.checkCircle : FontAwesomeIcons.signInAlt),
          ]
        );
        Widget w = new Container(
          margin: new EdgeInsets.all(8.0),
          child: (oauthState[i].connected 
            ? new FlatButton(
              shape: new StadiumBorder(),
              child: r,
              onPressed: null,
            ) : new RaisedButton(
              shape: new StadiumBorder(),
              child: r,
              onPressed: (cfg.enabled && onOAuthSelected != null) ? () { onOAuthSelected(i); } : null,
            )
          ),
        );
        oauthButtons.add(w);
      }
    }
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
                    accountType == AccountType.AT_INFLUENCER ? "You are now an influencer!" : "You are now in business!",
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
                  children: oauthButtons,
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      new RaisedButton(
                        shape: new StadiumBorder(),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("Sign up".toUpperCase()),
                          ],
                        ),
                        onPressed: connected ? onSignUp : null,
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
