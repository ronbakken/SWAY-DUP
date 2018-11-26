import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/network_generic/multi_account_client.dart';
import 'package:inf/network_streaming/network_streaming.dart';
import 'package:inf_common/inf_common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:location/location.dart' as location;

// User wrapper boilerplate
User userFromAccount(DataAccount account) {
  return new User(
    id: account.state.accountId,
    name: account.summary.name,
    description: account.summary.description,
    avatarThumbnailLowRes: kTransparentImage,
    avatarThumbnailUrl: account.summary.avatarThumbnailUrl,
    // etc
  );
}

// Social wrapper boilerplate
SocialMediaAccount socialFromSocial(
    int providerId, DataSocialMedia socialMedia) {
  return new SocialMediaAccount(
    id: providerId,
    description: socialMedia.description,
    followersCount: socialMedia.followersCount,
    friendsCount: socialMedia.friendsCount,
    // etc
  );
}

// Provider wrapper boilerplate
SocialNetworkProvider providerFromProvider(
    int providerId, ConfigOAuthProvider oauthProvider) {
  return new SocialNetworkProvider(
    id: providerId,
    canAuthorizeUser:
        oauthProvider.canConnect && oauthProvider.canAlwaysAuthenticate,
    name: oauthProvider.label,
    logoData: kTransparentImage,
    isVectorLogo: false,
  );
}

// Authentication wrapper boilerplate
class AuthenticationServiceImplementation implements AuthenticationService {
  bool _wantsAnonymous;

  @override
  Observable<AuthenticationResult> loginState;
  final StreamController<AuthenticationResult> _authenticationResults =
      new StreamController<AuthenticationResult>();

  @override
  Observable<List<LocalAccountData>> linkedAccounts;
  final StreamController<List<LocalAccountData>> _linkedAccounts =
      new StreamController<List<LocalAccountData>>();

  final NetworkStreaming networkStreaming;
  final List<StreamSubscription<dynamic>> _subscriptions =
      new List<StreamSubscription<dynamic>>();

  AuthenticationServiceImplementation(this.networkStreaming) {
    loginState =
        new Observable<AuthenticationResult>(_authenticationResults.stream);
    _subscriptions
        .add(networkStreaming.api.commonChanged.listen(_commonChanged));
    _commonChanged(null);

    linkedAccounts =
        new Observable<List<LocalAccountData>>(_linkedAccounts.stream);
    _subscriptions.add(networkStreaming.multiAccount.onAccountsChanged
        .listen(_accountsChanged));
    _accountsChanged(null);
  }

  void _commonChanged(void _) {
    if (networkStreaming.api.account.state.accountId != 0) {
      _wantsAnonymous = false;
    }
    _authenticationResults.add(getCurrentAuthenticationState());
  }

  void _accountsChanged(Change<LocalAccountData> change) {
    _linkedAccounts.add(networkStreaming.multiAccount.accounts);
  }

  void dispose() {
    _authenticationResults.close();
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
  }

  @override
  AuthenticationResult getCurrentAuthenticationState() {
    DataAccount account = networkStreaming.api.account;
    AuthenticationState state = AuthenticationState.notLoggedIn;
    if (account.state.sessionId == 0) {
      state = AuthenticationState.connecting;
    } else if (account.state.accountId != 0) {
      state = AuthenticationState.success;
    } else if (_wantsAnonymous) {
      state = AuthenticationState.anonymous;
    }
    return new AuthenticationResult(
      state: state,
      user: userFromAccount(networkStreaming.api.account),
    );
  }

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  @override
  Future<void> logOut() async {
    // TODO: Destroy this session server-side.
    networkStreaming.multiAccount.removeAccount();
    // State will immediately change to notLoggedIn
  }

  @override
  Future<void> switchToUserAccount(LocalAccountData user) async {
    networkStreaming.multiAccount
        .switchAccount(user.environment, user.accountId);
    // State will immediately change to notLoggedIn, then attempt to connect
  }

  @override
  Future<void> loginAnonymous(AccountType userType) async {
    _authenticationResults.add(getCurrentAuthenticationState());
  }

  @override
  Future<List<SocialNetworkProvider>>
      getAvailableSocialNetworkProviders() async {
    List<SocialNetworkProvider> result = <SocialNetworkProvider>[];
    List<ConfigOAuthProvider> oauthProviders =
        networkStreaming.config.oauthProviders.all;
    for (int providerId = 0; providerId < oauthProviders.length; ++providerId) {
      ConfigOAuthProvider oauthProvider = oauthProviders[providerId];
      if (oauthProvider.canConnect || oauthProvider.showInProfile) {
        result.add(providerFromProvider(providerId, oauthProvider));
      }
    }
    return result;
  }

  @override
  Future<void> loginWithSocialNetWork(
      BuildContext context, // Since this function is expecting UI to pop up...
      AccountType accountType,
      SocialNetworkProvider socialNetwork) async {
    networkStreaming.api.setAccountType(accountType);
    int providerId = socialNetwork.id;
    ConfigOAuthProvider oauthProvider =
        networkStreaming.config.oauthProviders.all[providerId];
    bool connectionAttempted = false;
    NetOAuthConnection connection;
    if (!connectionAttempted &&
        oauthProvider.whitelistHosts.contains('facebook.com')) {
      // Attempt to use Facebook plugin
    }
    if (!connectionAttempted &&
        oauthProvider.whitelistHosts.contains('twitter.com')) {
      // Attempt to use Twitter plugin
    }
    if (!connectionAttempted) {
      // Attempt to use generic OAuth
    }
    if (connection != null && connection.socialMedia.canSignUp) {
      Map<String, double> coordinate = await location.Location().getLocation;
      await networkStreaming.api.createAccount(coordinate['latitude'], coordinate['longitude']);
    }
    if (connection == null) {
      throw new Exception("Failed to connect.");
    }
  }
}

/* end of file */
