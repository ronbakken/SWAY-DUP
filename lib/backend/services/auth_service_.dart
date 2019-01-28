import 'package:inf/domain/domain.dart';
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

  User get currentUser;
  Observable<User> get currentUserUpdates;

  Future<void> sendLoginEmail(UserType userType, String email);

  Future<bool> loginUserWithToken();

  Future<GetInvitationCodeStatusResponse_InvitationCodeStatus> checkInvitationCode(String code);

  Future<void> updateUser(User user);

  Future<void> logOut();
}
