import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:inf/domain/user.dart';
import 'package:inf/network_generic/multi_account_client.dart';
import 'package:rxdart/rxdart.dart';

/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin
/// with a user he has never used before

class SocialNetworkProvider {
  final int id;
  final bool canAuthorizeUser;
  final String name;
  final Uint8List logoData;
  final bool isVectorLogo;

  SocialNetworkProvider({
    this.id,
    this.canAuthorizeUser,
    this.name,
    this.logoData,
    this.isVectorLogo,
  });
}

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
  // must be backed by BehaviourSubject
  Observable<AuthenticationResult> get loginState;

  /// Returns the current authenticationstate independent od a state change
  AuthenticationResult getCurrentAuthenticationState();

  Future<List<SocialNetworkProvider>> getAvailableSocialNetworkProviders();

  Future<void> loginAnonymous(AccountType userType);

  Future<void> loginWithSocialNetWork(
      BuildContext
          context, // TODO: Since this function is expecting UI to pop up... Please restructure
      AccountType userType,
      SocialNetworkProvider socialNetwork);

  Observable<List<LocalAccountData>> get linkedAccounts;
  Future<void> switchToUserAccount(LocalAccountData user);

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  Future<void> logOut();
}
