/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sway_mobile_app/app_composition/app_base.dart';
import 'package:sway_mobile_app/network_inheritable/multi_account_selection.dart';
// import 'package:sway_mobile_app/screens/account_switch.dart';
import 'package:sway_mobile_app/ui/welcome/welcome_page.dart';

import 'package:sway_common/inf_common.dart';
import 'package:sway_mobile_app/network_inheritable/config_provider.dart';
import 'package:sway_mobile_app/network_inheritable/api_provider.dart';

// import 'package:sway_mobile_app/widgets/oauth_scaffold.dart';
// import 'package:sway_mobile_app/screens_onboarding/onboarding_selection.dart';
import 'package:sway_mobile_app/screens_onboarding/onboarding_social.dart';

// Onboarding sequence
class AppOnboarding extends StatefulWidget {
  const AppOnboarding({
    Key key,
  }) : super(key: key);

  @override
  _AppOnboardingState createState() => _AppOnboardingState();
}

class _AppOnboardingState extends AppBaseState<AppOnboarding> {
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

  /*
  void navigateToOAuth(BuildContext context, int oauthProvider) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final ConfigData config = ConfigProvider.of(context);
          final Api api = ApiProvider.of(context);
          assert(config != null);
          assert(api != null);
          return OAuthScaffold(
            onOAuthGetParams: () {
              return api.getOAuthUrls(oauthProvider);
            },
            onOAuthCallbackResult: (String callbackQuery) {
              return api.connectOAuth(oauthProvider, callbackQuery);
            },
            whitelistHosts: config.oauthProviders[oauthProvider].whitelistHosts,
          );
        },
      ),
    );
  }
  */

  void navigateToSocial() {
    Navigator.push<void>(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, MaterialPageRoute<void>(
      builder: (context) {
        final ConfigData config = ConfigProvider.of(context);
        final Api network = ApiProvider.of(context);
        // NavigatorState navigator = Navigator.of(context);
        /*if (network.account.accountId != 0) {
          // Need to implement cleaner navigation
          () async {
            await null; // Pop after
            navigator.popUntil(ModalRoute.withName(Navigator.defaultRouteName));
          }();
        }*/
        // TODO: Fix network delay on accountId update, change message structure
        /*bool canSignUp = (network.account.accountId == 0) &&
            network.account.socialMedia.values
                .any((DataSocialMedia data) => data.canSignUp);*/ // TODO: Fix serverside
        final bool canSignUp = (network.account.accountId == 0) &&
            network.account.socialMedia.values
                .any((DataSocialMedia data) => data.connected);
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
                              title: const Text('Sign Up Failed'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const Text('An error has occured.'),
                                    const Text('Please try again later.'),
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
    final ConfigData config = ConfigProvider.of(context);
    final Api network = ApiProvider.of(context);
    final MultiAccountClient selection = MultiAccountSelection.of(context);
    final bool hasExistingAccounts = selection.accounts.any(
        (LocalAccountData localAccount) =>
            localAccount.accountId != Int64.ZERO);
    assert(network != null);
    return WelcomePage(
      onInfluencer: network.connected == NetworkConnectionState.ready
          ? () {
              network.setAccountType(AccountType.influencer);
              navigateToSocial();
            }
          : null,
      onBusiness: network.connected == NetworkConnectionState.ready
          ? () {
              network.setAccountType(AccountType.business);
              navigateToSocial();
            }
          : null,
      onExistingAccount: hasExistingAccounts ? navigateToSwitchAccount : null,
      welcomeImageUrls: config.content.welcomeImageUrls,
    );
  }
}

/* end of file */
