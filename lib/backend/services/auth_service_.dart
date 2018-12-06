import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/domain/user.dart';
import 'package:inf/network_generic/multi_account_client.dart';
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
  // must be backed by BehaviourSubject
  Observable<AuthenticationResult> get loginState;

  Observable<User> get currentUser;

  /// Returns the current authenticationstate independent od a state change
  AuthenticationResult getCurrentAuthenticationState();

  Future<List<SocialNetworkProvider>> getAvailableSocialNetworkProviders();

  Future<void> loginAnonymous(AccountType userType);

  Future<void> loginWithSocialNetWork(
      BuildContext
          context, // TODO: Since this function is expecting UI to pop up... Please restructure
      AccountType userType,
      SocialNetworkProvider socialNetwork);


  Observable<User> getPublicProfile(Int64 accountId);    

  Observable<List<LocalAccountData>> get linkedAccounts;
  Future<void> switchToUserAccount(LocalAccountData user);

  Future<void> updateSocialMediaAccount(SocialMediaAccount socialMedia);
  Future<void> updateUser(User user);
  
  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  Future<void> logOut();
}
