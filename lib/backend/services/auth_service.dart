
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
  mandatoryUserDataNotComplete
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
  final String userId;
  final String userPhotoUrl;
  final AuthenticationProvider provider;

  // final User partialUserData;

  AuthenticationResult(
    this.state, {
    this.userId,
    this.userPhotoUrl,
   // this.partialUserData,
    this.provider,
    this.errorMessage,
  });
}

abstract class AuthenticationService {

  Future<AuthenticationResult> checkCurrentUserLogin();
  
  Future<void> loginWithGoogle();
  Future<void> loginWithFacebook();
  Future<void> loginWithTwitter();
  Future<void> loginWithInstagram();

  Future<void> loginWithEmailPassword(String email, String password);

  Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  Future<void> sendPasswordResetMessage(String email);

  Stream<AuthenticationResult> get loginState;

  Future<void> logOut();

  // used to query data from the social provider
  //Future<User> getUserDataFromProvider(AuthenticationResult authResult);
}
