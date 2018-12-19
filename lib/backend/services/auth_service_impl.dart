import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/network_generic/multi_account_client.dart';
import 'package:inf/network_streaming/network_streaming.dart';
import 'package:inf/ui/widgets/oauth_scaffold.dart';
import 'package:inf_common/inf_common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:location/location.dart' as location;

// User wrapper boilerplate
User userFromAccount(DataAccount account) {
  return new User(
    id: account.accountId,
    name: account.name,
    description: account.description,
    avatarThumbnailLowRes: kTransparentImage,
    avatarThumbnailUrl: account.avatarUrl,
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
    logoColoredData: kTransparentImage,
    canBeUsedAsFilter: true,
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
      <StreamSubscription<dynamic>>[];

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
    if (networkStreaming.api.account.accountId != 0) {
      _wantsAnonymous = false;
    }
    _authenticationResults.add(getCurrentAuthenticationState());
  }

  void _accountsChanged(Change<LocalAccountData> change) {
    _linkedAccounts.add(networkStreaming.multiAccount.accounts);
  }

  void dispose() {
    _authenticationResults.close();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  @override
  AuthenticationResult getCurrentAuthenticationState() {
    DataAccount account = networkStreaming.api.account;
    AuthenticationState state = AuthenticationState.notLoggedIn;
    if (account.sessionId == 0) {
      state = AuthenticationState.connecting;
    } else if (account.accountId != 0) {
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
        .switchAccount(user.domain, user.accountId);
    // State will immediately change to notLoggedIn, then attempt to connect
  }

  @override
  Future<void> loginAnonymous(AccountType userType) async {
    _authenticationResults.add(getCurrentAuthenticationState());
  }



  @override
  Future<void> loginWithSocialNetWork(
      BuildContext context, // Since this function is expecting UI to pop up...
      AccountType accountType,
      SocialNetworkProvider socialNetwork) async {
    networkStreaming.api.setAccountType(accountType);
    int providerId = socialNetwork.id;
    ConfigOAuthProvider oauthProvider =
        networkStreaming.config.oauthProviders[providerId];
    NetOAuthConnection connection = await oauthConnect(
      context,
      oauthProvider: oauthProvider,
      onOAuthGetParams: () async {
        return networkStreaming.api.getOAuthUrls(providerId);
      },
      onOAuthGetSecrets: null,
      onOAuthCallbackResult: (String callbackQuery) async {
        return networkStreaming.api.connectOAuth(providerId, callbackQuery);
      },
    );
    if (connection != null && connection.socialMedia.canSignUp) {
      // This app automatically signs up, without allowing multiple social media to be selected...
      Map<String, double> coordinate = await location.Location().getLocation;
      await networkStreaming.api
          .createAccount(coordinate['latitude'], coordinate['longitude']);
    }
    if (connection == null) {
      throw new Exception("Failed to connect.");
    }
  }

  @override
  Observable<User> getPublicProfile(Int64 accountId) {
    // TODO
    throw new Exception("Not Implemented yet");
  }



  @override
  // TODO: implement currentUser
  Observable<User> get currentUser => null;

  @override
  Future<void> updateSocialMediaAccount(SocialMediaAccount socialMedia) {
    // TODO: implement updateSocialMediaAccount
    return null;
  }

  @override
  Future<void> updateUser(User user) {
    // TODO: implement updateUser
    return null;
  }

  @override
  Future<void> init() {
    // TODO: implement init
    return null;
  }
}

/* end of file */
