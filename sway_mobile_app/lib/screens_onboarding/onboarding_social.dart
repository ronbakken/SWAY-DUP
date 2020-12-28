/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:inf_common/inf_common.dart';
import 'package:sway_mobile_app/widgets/progress_dialog.dart';

import 'package:sway_mobile_app/widgets/network_status.dart';

class OnboardingSocial extends StatelessWidget {
  const OnboardingSocial({
    Key key,
    @required this.accountType,
    @required this.oauthProviders,
    @required this.oauthState,
    @required this.termsOfServiceUrl,
    @required this.privacyPolicyUrl,
    @required this.onOAuthSelected,
    @required this.onSignUp,
  }) : super(key: key);

  final AccountType accountType;
  final List<ConfigOAuthProvider> oauthProviders;
  final Map<int, DataSocialMedia> oauthState;

  final String termsOfServiceUrl;
  final String privacyPolicyUrl;

  final void Function(int oauthProvider) onOAuthSelected;
  final Future<void> Function() onSignUp;

  @override
  Widget build(BuildContext context) {
    List<Widget> oauthButtons = List<Widget>();
    print("OAuth Providers: " + oauthProviders.length.toString());
    int nbButtons = oauthProviders.length;
    bool connected = false;
    for (int i = 0; i < nbButtons; ++i) {
      ConfigOAuthProvider cfg = oauthProviders[i];
      if (cfg.visible &&
          cfg.canAlwaysAuthenticate &&
          cfg.canConnect &&
          cfg.mechanism != OAuthMechanism.none) {
        if (oauthState[i]?.connected == true) {
          connected = true;
        }
        Widget r =
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(IconData(cfg.fontAwesomeBrand,
              fontFamily: 'FontAwesomeBrands',
              fontPackage: 'font_awesome_flutter')),
          Text(cfg.label.toUpperCase()),
          Icon((oauthState[i]?.connected == true && !oauthState[i].expired)
              ? FontAwesomeIcons.checkCircle
              : FontAwesomeIcons.signInAlt),
        ]);
        Widget w = Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: oauthState[i]?.connected == true
              ? FlatButton(
                  // shape: new StadiumBorder(),
                  child: r,
                  onPressed: null,
                )
              : RaisedButton(
                  // shape: new StadiumBorder(),
                  child: r,
                  onPressed: (onOAuthSelected != null)
                      ? () {
                          onOAuthSelected(i);
                        }
                      : null,
                ),
        );
        oauthButtons.add(w);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Image(image: AssetImage('assets/logo_appbar.png')),
        centerTitle: true,
      ),
      bottomSheet: NetworkStatus.buildOptional(context),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Text(
                    accountType == AccountType.influencer
                        ? "You are now an influencer!"
                        : "You are now in business!",
                    style: Theme.of(context).textTheme.display1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Text(
                    "Which social media accounts would you like to connect with?",
                    style: Theme.of(context).textTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  children: oauthButtons,
                ),
                Container(
                    margin: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Sign up".toUpperCase()),
                            ],
                          ),
                          onPressed: connected && onSignUp != null
                              ? () {
                                  _showSignUpDialog(context);
                                }
                              : null,
                        )
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Required to show ToS etc before we commit any personal information to the database
  void _showSignUpDialog(BuildContext context) async {
    bool accepted = false;
    await showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('INF Marketplace LLC'),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "By signing up to our service you confirm that you have read and agree to our ",
                  ),
                  TextSpan(
                    text: "Terms of Service",
                    // style: new TextStyle(color: Colors.blue),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Theme.of(context).accentColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch(termsOfServiceUrl);
                      },
                  ),
                  TextSpan(
                    text: " and ",
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    // style: new TextStyle(color: Colors.blue),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Theme.of(context).accentColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch(privacyPolicyUrl);
                      },
                  ),
                  TextSpan(
                    text: ".",
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Back".toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("I agree".toUpperCase()),
              onPressed: () {
                accepted = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    if (!accepted) {
      return;
    }
    // Show progress dialog
    final dynamic progressDialog = showProgressDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator()),
                Text("Signing up..."),
              ],
            ),
          );
        });
    // Wait for the sign up process to complete
    await onSignUp();
    closeProgressDialog(progressDialog);
  }
}

/* end of file */
