
import 'package:inf/domain/user.dart';
import 'package:rxdart/rxdart.dart';


/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin 
/// with a user he has never used before


enum AuthenticationProvider { google, facebook, instagram, twitter, emailPassword }


enum AuthenticationState {
  success,
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
  
  /// Even if the user is not logged in he has to select a user type at app startup
  /// so that the backend only shows thje correct data.
  Future<void> setUserType(UserType userType);

  Future<void> loginWithGoogle();
  Future<void> loginWithFacebook();
  Future<void> loginWithTwitter();
  Future<void> loginWithInstagram();

  Future<List<User>> getAllLinkedAccounts();
  Future<void> switchToUserAccount();

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);


  Future<void> logOut();

}
