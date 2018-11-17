import 'package:inf/domain/user.dart';
import 'package:rxdart/rxdart.dart';

/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin
/// with a user he has never used before

enum AuthenticationProvider {
  google,
  facebook,
  instagram,
  twitter,
  emailPassword
}

enum AuthenticationState {
  success,
  waitingForActivation,
  anonymous,
  invalidCredentials,
  canceled,
  error,
  notLoggedIn,
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
  final AuthenticationProvider provider;

  AuthenticationResult(
    this.state, {
    this.user,
    this.provider,
    this.errorMessage,
  });
}

abstract class AuthenticationService {
  Observable<AuthenticationResult> get loginState;

  /// Returns the current authenticationstate independent od a state change
  Future<AuthenticationResult> getCurrentAuthenticationState();

  Future<void> loginAnonymous(UserType userType);

  Future<void> loginWithGoogle(UserType userType);
  Future<void> loginWithFacebook(UserType userType);
  Future<void> loginWithTwitter(UserType userType);
  Future<void> loginWithInstagram(UserType userType);

  Future<List<User>> getAllLinkedAccounts();
  Future<void> switchToUserAccount();

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  Future<void> logOut();
}
