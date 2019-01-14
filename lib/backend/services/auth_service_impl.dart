import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf_api_client/inf_api_client.dart';

import 'package:rxdart/rxdart.dart';

class AuthenticationServiceImplementation implements AuthenticationService {
  AuthenticationServiceImplementation({this.userTestToken});

  @override
  User get currentUser => _currentUser;
  User _currentUser;

  /// if this is set it will be used to login instead of a stored token
  final String userTestToken;

  @override
  Observable<User> get currentUserUpdates => currentUserUpdatesSubject;

  BehaviorSubject<User> currentUserUpdatesSubject = BehaviorSubject<User>();

  @override
  Future<bool> loginUserWithToken() async {
    if (userTestToken != null) {
      var tokenMessage = RefreshTokenMessage()..refreshToken = userTestToken;
      var authResult = await backend.get<InfApiClientsService>().authClient.login(tokenMessage);
      if (authResult.authorizationToken.isNotEmpty) {
        _currentUser = authResult.userData;
        currentUserUpdatesSubject.add(_currentUser);
        return true;
      } else {
        return false;
      }
    } else {
      // TODO read last stored token from secure storage
      // till then we return false
      return false;
    }
  }

  @override
  Future<void> logOut() async {
    // TODO: Destroy this session server-side.
    // networkStreaming.multiAccount.removeAccount();
    // State will immediately change to notLoggedIn
  }

  // @override
  // Future<void> switchToUserAccount(LocalAccountData user) async {
  //   // networkStreaming.multiAccount
  //   //     .switchAccount(user.domain, user.accountId);
  //   // State will immediately change to notLoggedIn, then attempt to connect
  // }

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

  @override
  Future<void> updateSocialMediaAccount(SocialMediaAccount socialMedia) {
    // TODO: implement updateSocialMediaAccount
    return null;
  }

  @override
  Observable<SocialMediaAccounts> getSocialMediaAccounts(int userId) {
    return Observable(
      backend
          .get<InfApiClientsService>()
          .authClient
          .getSocialMediaAccountsForUser(SocialMediaRequest()..userId = userId),
    );
  }
}
