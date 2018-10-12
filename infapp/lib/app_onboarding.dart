/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import 'protobuf/inf_protobuf.dart';
import 'network/config_manager.dart';
import 'network/network_manager.dart';

import 'widgets/oauth_scaffold.dart';
import 'onboarding_selection.dart';
import 'onboarding_social.dart';

// Onboarding sequence
class AppOnboarding extends StatefulWidget {
  const AppOnboarding({
    Key key,
  }) : super(key: key);

  @override
  _AppOnboardingState createState() => new _AppOnboardingState();
}

class _AppOnboardingState extends State<AppOnboarding> {
  NetworkInterface _network;
  StreamSubscription<NotificationNavigateApplicant>
      _notificationNavigateApplicantSubscription;

  @override
  void initState() {
    super.initState();
    if (unhandledNotificationNavigateApplicant != null) {
      NotificationNavigateApplicant notification =
          unhandledNotificationNavigateApplicant;
      unhandledNotificationNavigateApplicant = null;
      onNotificationNavigateApplicant(notification);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NetworkInterface network = NetworkManager.of(context);
    if (network != _network) {
      _network = network;
      /*if (_notificationNavigateApplicantSubscription != null) {
        _notificationNavigateApplicantSubscription.cancel();
        _notificationNavigateApplicantSubscription = null;
      }*/
      _notificationNavigateApplicantSubscription = network
          .notificationNavigateApplicantListen(onNotificationNavigateApplicant);
    }
    // _config = ConfigManager.of(context);
  }

  @override
  void dispose() {
    /*if (_notificationNavigateApplicantSubscription != null) {
      _notificationNavigateApplicantSubscription.cancel();
      _notificationNavigateApplicantSubscription = null;
    }*/
    super.dispose();
  }

  void onNotificationNavigateApplicant(
      NotificationNavigateApplicant notification) {
    // TODO: Swap domain and account if necessary
    unhandledNotificationNavigateApplicant = notification;
  }

  void navigateToOAuth(BuildContext context, int oauthProvider) {
    Navigator.push(
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      new MaterialPageRoute(
        builder: (context) {
          ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          assert(config != null);
          assert(network != null);
          return new OAuthScaffold(
            onOAuthGetParams: () {
              return network.getOAuthUrls(oauthProvider);
            },
            onOAuthCallbackResult: (String callbackQuery) {
              return network.connectOAuth(oauthProvider, callbackQuery);
            },
            whitelistHosts:
                config.oauthProviders.all[oauthProvider].whitelistHosts,
          );
        },
      ),
    );
  }

  void navigateToSocial(BuildContext context) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(
      builder: (context) {
        ConfigData config = ConfigManager.of(context);
        NetworkInterface network = NetworkManager.of(context);
        NavigatorState navigator = Navigator.of(context);
        if (network.account.state.accountId != 0) {
          // Need to implement cleaner navigation
          () async {
            await null;
            navigator.popUntil(ModalRoute.withName(Navigator.defaultRouteName));
          }();
        }
        bool canSignUp = (network.account.state.accountId == 0) &&
            network.account.detail.socialMedia.any(
                (DataSocialMedia data) => (data.connected && !data.expired));
        assert(config != null);
        assert(network != null);
        return new OnboardingSocial(
          accountType: network.account.state.accountType,
          oauthProviders: config.oauthProviders.all,
          oauthState: network.account.detail.socialMedia,
          termsOfServiceUrl: config.services.termsOfServiceUrl,
          privacyPolicyUrl: config.services.privacyPolicyUrl,
          onOAuthSelected: (network.connected == NetworkConnectionState.Ready)
              ? (int oauthProvider) {
                  navigateToOAuth(context, oauthProvider);
                }
              : null,
          onSignUp:
              canSignUp && (network.connected == NetworkConnectionState.Ready)
                  ? () async {
                      // Get user position
                      Position position;
                      NavigatorState navigator = Navigator.of(context);
                      try {
                        position = await Geolocator()
                            .getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
                      } catch (ex) {
                        print(ex); // Or fail to give permissions
                        // PlatformException(PERMISSION_DENIED, Access to location data denied, null)
                      }
                      // Create account
                      bool success = false;
                      try {
                        await network.createAccount(
                            position?.latitude, position?.longitude);
                        success = true;
                      } catch (ex) {
                        print(ex);
                      }
                      if (success) {
                        //while (navigator.canPop()) {
                        //  navigator.pop();
                        //}
                      } else if (this.mounted) {
                        // Failed to sign up
                        await showDialog<Null>(
                          context: this.context,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: new Text('Sign Up Failed'),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text('An error has occured.'),
                                    new Text('Please try again later.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [new Text('Ok'.toUpperCase())],
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  : null,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return new OnboardingSelection(
      onInfluencer: network.connected == NetworkConnectionState.Ready
          ? () {
              network.setAccountType(AccountType.AT_INFLUENCER);
              navigateToSocial(context);
            }
          : null,
      onBusiness: network.connected == NetworkConnectionState.Ready
          ? () {
              network.setAccountType(AccountType.AT_BUSINESS);
              navigateToSocial(context);
            }
          : null,
    );
  }
}

/* end of file */
