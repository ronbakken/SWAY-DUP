import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin
/// with a user he has never used before

enum AuthenticationState {
  connecting,
  notLoggedIn,
  anonymous,
  success,

  // ?
  waitingForActivation,
  invalidCredentials,
  canceled,
  error,
  switchingAccounts
}

class AuthenticationException implements Exception {
  final String message;
  final int code;

  AuthenticationException(this.message, this.code);

  @override
  String toString() {
    return message;
  }
}

class AuthenticationResult {
  final AuthenticationState state;
  final String errorMessage;
  final User user;
  final SocialNetworkProvider provider;
  final bool loginWithEmailPassword;

  AuthenticationResult({
    this.state,
    this.loginWithEmailPassword,
    this.user,
    this.provider,
    this.errorMessage,
  });
}

abstract class AuthenticationService {
  Future<void> init();

  User get currentUser;
  Observable<User> get currentUserUpdates;

  Future<bool> loginUserWithToken();

  // Observable<List<LocalAccountData>> get linkedAccounts;
  // Future<void> switchToUserAccount(LocalAccountData user);

  Future<void> updateSocialMediaAccount(SocialMediaAccount socialMedia);
  Future<void> updateUser(User user);

  Observable<SocialMediaAccounts> getSocialMediaAccounts();

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  Future<void> logOut();
}
