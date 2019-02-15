import 'dart:convert';
import 'package:inf/backend/backend.dart';
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

  AuthenticationException(this.message);

  @override
  String toString() {
    return message;
  }
}

class LoginToken {
  final UserType userType;
  final AccountState accountState;
  final String token;
  final String email;

  LoginToken._({this.userType, this.accountState, this.token, this.email});

  static LoginToken fromJwt(String jwt) {
    var parts = jwt.split('.');
    if (parts.length != 3) {
      throw AuthenticationException('Invalid LoginToken');
    }
    var payload = parts[1];

    switch (payload.length % 4) {
      case 0:
        break;
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
      default:
        throw const FormatException('Base64url Encoding: invalid length');
    }

    var decoded = utf8.decode(base64Url.decode(payload));
    var asMap = json.decode(decoded);

    var userStatus = asMap['userStatus'];
    var userTypeAsString = asMap['aud'];
    var email = asMap['email'];

    AccountState accountState;
    switch (userStatus) {
      case 'WaitingForActivation':
        accountState = AccountState.waitingForActivation;
        break;
      case 'Active':
        accountState = AccountState.active;
        break;
      case 'WaitingForApproval':
        accountState = AccountState.waitingForApproval;
        break;
      case 'Disabled':
        accountState = AccountState.disabled;
        break;
      case 'Rejected':
        accountState = AccountState.rejected;
        break;
      default:
        throw AuthenticationException('Invalid account status in logintoken: $userStatus');
    }
    UserType userType;
    switch (userTypeAsString) {
      case 'Business':
        userType = UserType.business;
        break;
      case 'Influencer':
        userType = UserType.influencer;
        break;
      default:
        assert(false, 'Unknown UserType');
    }

    return LoginToken._(userType: userType, accountState: accountState, token: jwt, email: email);
  }
}

abstract class AuthenticationService {
  User get currentUser;

  CallOptions callOptions;

  Observable<User> get currentUserUpdates;

  Future<void> sendLoginEmail(UserType userType, String email, String invitationCode);

  Future<bool> loginUserWithRefreshToken();

  Future<bool> loginUserWithLoginToken(String loginToken);

  Future<void> createNewUser(User user, String loginToken, String deviceId);

  Future<GetInvitationCodeStatusResponse_InvitationCodeStatus> checkInvitationCode(String code);

  Future<void> updateUser(User user);

  Future<void> logOut();
}
