/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:sway_mobile_app/network_inheritable/cross_account_navigation.dart';
import 'package:sway_mobile_app/network_inheritable/multi_account_selection.dart';
import 'package:sway_mobile_app/network_inheritable/config_provider.dart';
import 'package:sway_mobile_app/network_inheritable/api_provider.dart';
import 'package:sway_mobile_app/widgets/oauth_scaffold.dart';
import 'package:sway_mobile_app/widgets/progress_dialog.dart';
import 'package:inf_common/inf_common.dart';
import 'package:sway_mobile_app/screens/account_switch.dart';
import 'package:sway_mobile_app/screens/debug_account.dart';
import 'package:sway_mobile_app/screens/haggle_view.dart';
import 'package:sway_mobile_app/screens/profile_view.dart';
import 'package:sway_mobile_app/screens/proposal_list.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart' as file;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:logging/logging.dart';

abstract class AppBaseState<T extends StatefulWidget> extends State<T> {
  void navigateToSwitchAccount() {
    Navigator.push<void>(context, MaterialPageRoute<void>(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      ConfigData config = ConfigProvider.of(context);
      // ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      MultiAccountClient selection = MultiAccountSelection.of(context);
      return AccountSwitch(
        domain: config.services.domain,
        accounts: selection.accounts,
        onAddAccount: () {
          selection.addAccount();
        },
        onSwitchAccount: (LocalAccountData localAccount) {
          selection.switchAccount(localAccount.domain, localAccount.accountId);
        },
      );
    }));
  }

  Future<void> navigateToOAuth(BuildContext context, int providerId) async {
    final ConfigData config = ConfigProvider.of(context);
    final Api api = ApiProvider.of(context);
    final ConfigOAuthProvider provider = config.oauthProviders[providerId];
    bool connectionAttempted = false;
    if (!connectionAttempted && providerId == OAuthProviderIds.facebook.value) {
      // Attempt to use Facebook plugin
      // TODO: Must ensure the following match the client id in server config
      // - facebook_app_id
      // - fb_login_protocol_scheme
      // - FacebookAppID
      // - CFBundleURLSchemes
      connectionAttempted = await wrapProgressAndError<bool>(
        context: context,
        progressBuilder:
            genericProgressBuilder(message: 'Waiting for Facebook...'),
        errorBuilder: genericMessageBuilder(title: 'Failed Connection'),
        task: () async {
          // TODO: Plugin doesn't work well for multi account login...
          // When the returned account already exists in a local account of the same type,
          // perhaps have the UI offer to select a different social media account
          final NetOAuthUrl url = await api.getOAuthUrls(providerId);
          final Uri uri = Uri.parse(url.authUrl);
          final Map<String, String> query = uri.queryParameters;
          // Logger('Inf.AppBase').info('OAuth Query: $query');
          final List<String> scope = query['scope']?.split(' ') ?? <String>[];
          // Logger('Inf.AppBase').info('OAuth Scope: $scope');
          final String clientId = query['client_id'];
          final FacebookLogin facebookLogin = FacebookLogin();
          facebookLogin.loginBehavior = FacebookLoginBehavior.nativeOnly;
          // TODO: Match clientId with plugin here when possible (checked on the server already)
          //if (clientId.isEmpty)
          //  return false;
          final FacebookLoginResult result =
              await facebookLogin.logInWithReadPermissions(scope);
          switch (result.status) {
            case FacebookLoginStatus.cancelledByUser:
              return true;
            case FacebookLoginStatus.error:
              Logger('Inf.AppBase')
                  .info('Facebook Error: ${result.errorMessage}');
              return false;
            case FacebookLoginStatus.loggedIn:
              // Logger('Inf.AppBase').info('Facebook Token: ${result.accessToken.token}');
              await api.connectOAuth(providerId,
                  'access_token=${Uri.encodeQueryComponent(result.accessToken.token)}');
              return true;
          }
        },
      );
    }
    if (!connectionAttempted && providerId == OAuthProviderIds.twitter.value) {
      // Attempt to use Twitter plugin
      connectionAttempted = await wrapProgressAndError<bool>(
        context: context,
        progressBuilder:
            genericProgressBuilder(message: 'Waiting for Twitter...'),
        errorBuilder: genericMessageBuilder(title: 'Failed Connection'),
        task: () async {
          // TODO: Plugin doesn't work well for multi account login...
          // When the returned account already exists in a local account of the same type,
          // perhaps have the UI offer to select a different social media account
          // Twitter Kit is 100% in violoation of the OAuth1.1 spec.
          // Secrets should not be pulled client side.
          // The plugin should be using the temporary token that is generated by the server.
          // Oh well.
          final NetOAuthSecrets secrets = await api.getOAuthSecrets(providerId);
          if (secrets.consumerKey.isEmpty || secrets.consumerSecret.isEmpty)
            return false; // Go with fallback if server doesn't provide this anymore.
          final TwitterLogin twitterLogin = TwitterLogin(
            consumerKey: secrets.consumerKey,
            consumerSecret: secrets.consumerSecret,
          );
          // TODO: Only use this piece of shit when Twitter is installed
          // twitterLogin.loginBehavior = TwitterLoginBehavior.nativeOnly;
          // TODO: Match consumerKey with plugin here when possible (checked on the server already)
          //if (clientId.isEmpty)
          //  return false;
          final TwitterLoginResult result = await twitterLogin.authorize();
          switch (result.status) {
            case TwitterLoginStatus.cancelledByUser:
              return true;
            case TwitterLoginStatus.error:
              Logger('Inf.AppBase')
                  .info('Twitter Error: ${result.errorMessage}');
              return true; // TODO: This returns error instead of cancelledByUser...
            case TwitterLoginStatus.loggedIn:
              // Logger('Inf.AppBase').info('Facebook Token: ${result.accessToken.token}');
              await api.connectOAuth(
                  providerId,
                  'oauth_token=${Uri.encodeQueryComponent(result.session.token)}'
                  '&oauth_token_secret=${Uri.encodeQueryComponent(result.session.secret)}');
              return true;
          }
        },
      );
    }
    if (!connectionAttempted) {
      // Attempt to use generic OAuth
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
            final ConfigData config = ConfigProvider.of(context);
            final Api api = ApiProvider.of(context);
            final ConfigOAuthProvider provider =
                config.oauthProviders[providerId];
            return OAuthScaffold(
              onOAuthGetParams: () {
                return api.getOAuthUrls(providerId);
              },
              onOAuthCallbackResult: (String callbackQuery) {
                return api.connectOAuth(providerId, callbackQuery);
              },
              whitelistHosts: provider.whitelistHosts,
            );
          },
        ),
      );
    }
  }
}

/* end of file */
