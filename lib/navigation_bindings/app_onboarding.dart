/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inf/ui/welcome/welcome_page.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_inheritable/network_provider.dart';

import 'package:inf/widgets/oauth_scaffold.dart';
import 'package:inf/screens_onboarding/onboarding_selection.dart';
import 'package:inf/screens_onboarding/onboarding_social.dart';

// Onboarding sequence
class AppOnboarding extends StatefulWidget {
  const AppOnboarding({
    Key key,
  }) : super(key: key);

  @override
  _AppOnboardingState createState() => _AppOnboardingState();
}

class _AppOnboardingState extends State<AppOnboarding> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateToOAuth(BuildContext context, int oauthProvider) {
    Navigator.push<MaterialPageRoute>(
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      MaterialPageRoute(
        builder: (context) {
          ConfigData config = ConfigProvider.of(context);
          final ApiClient network = NetworkProvider.of(context);
          assert(config != null);
          assert(network != null);
          return OAuthScaffold(
            onOAuthGetParams: () {
              return network.getOAuthUrls(oauthProvider);
            },
            onOAuthCallbackResult: (String callbackQuery) {
              return network.connectOAuth(oauthProvider, callbackQuery);
            },
            whitelistHosts: config.oauthProviders[oauthProvider].whitelistHosts,
          );
        },
      ),
    );
  }

  void navigateToSocial(BuildContext context) {
    Navigator.push<MaterialPageRoute>(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, MaterialPageRoute(
      builder: (context) {
        ConfigData config = ConfigProvider.of(context);
        final ApiClient network = NetworkProvider.of(context);
        // NavigatorState navigator = Navigator.of(context);
        /*if (network.account.accountId != 0) {
          // Need to implement cleaner navigation
          () async {
            await null; // Pop after
            navigator.popUntil(ModalRoute.withName(Navigator.defaultRouteName));
          }();
        }*/
        // TODO: Fix network delay on accountId update, change message structure
        bool canSignUp = (network.account.accountId == 0) &&
            network.account.socialMedia.values.any(
                (DataSocialMedia data) => data.canSignUp);
        assert(config != null);
        assert(network != null);
        return OnboardingSocial(
          accountType: network.account.accountType,
          oauthProviders: config.oauthProviders,
          oauthState: network.account.socialMedia,
          termsOfServiceUrl: config.services.termsOfServiceUrl,
          privacyPolicyUrl: config.services.privacyPolicyUrl,
          onOAuthSelected: (network.connected == NetworkConnectionState.ready)
              ? (int oauthProvider) {
                  navigateToOAuth(context, oauthProvider);
                }
              : null,
          onSignUp:
              canSignUp && (network.connected == NetworkConnectionState.ready)
                  ? () async {
                      // Get user position
                      Position position;
                      // NavigatorState navigator = Navigator.of(context);
                      try {
                        position = await Geolocator().getLastKnownPosition(
                            desiredAccuracy: LocationAccuracy.medium);
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
                            return AlertDialog(
                              title: Text('Sign Up Failed'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('An error has occured.'),
                                    Text('Please try again later.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('Ok'.toUpperCase())],
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
    ConfigData config = ConfigProvider.of(context);
    final ApiClient network = NetworkProvider.of(context);
    assert(network != null);
    return WelcomePage(
      // OnboardingSelection(
      onInfluencer: network.connected == NetworkConnectionState.ready
          ? () {
              network.setAccountType(AccountType.influencer);
              navigateToSocial(context);
            }
          : null,
      onBusiness: network.connected == NetworkConnectionState.ready
          ? () {
              network.setAccountType(AccountType.business);
              navigateToSocial(context);
            }
          : null,
      welcomeImageUrls: config.content.welcomeImageUrls,
    );
  }
}

/* end of file */
