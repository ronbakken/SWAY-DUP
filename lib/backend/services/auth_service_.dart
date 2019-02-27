import 'dart:async';
import 'dart:convert';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

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

abstract class AuthenticationService {
  User get currentUser;

  CallOptions callOptions;

  Observable<User> get currentUserUpdates;

  Future<void> sendLoginEmail(UserType userType, String email, String invitationCode);

  Future<bool> loginUserWithRefreshToken();

  Future<bool> loginUserWithLoginToken(String loginToken);

  Future<void> activateUser(User user, String loginToken);

  Future<GetInvitationCodeStatusResponse_InvitationCodeStatus> checkInvitationCode(String code);

  Future<void> updateUser(User user);

  Future<void> logOut();
}

class LoginToken {
  final UserType userType;
  final UserDto_Status accountState;
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

    UserDto_Status accountState;
    switch (userStatus) {
      case 'WaitingForActivation':
        accountState = UserDto_Status.waitingForActivation;
        break;
      case 'Active':
        accountState = UserDto_Status.active;
        break;
      case 'WaitingForApproval':
        accountState = UserDto_Status.waitingForApproval;
        break;
      case 'Disabled':
        accountState = UserDto_Status.disabled;
        break;
      case 'Rejected':
        accountState = UserDto_Status.rejected;
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

class StoredUserProfile {
  String userName;
  String avatarUrl;
  String refreshToken;

  StoredUserProfile({
    this.userName,
    this.avatarUrl,
    this.refreshToken,
  });

  String toJson() {
    var map = <String, dynamic>{};
    map['userName'] = userName;
    map['avatarUrl'] = avatarUrl;
    map['refreshToken'] = refreshToken;

    return json.encode(map);
  }

  static StoredUserProfile fromJson(String jsonString) {
    var map = json.decode(jsonString);
    return StoredUserProfile(
      userName: map['userName'],
      avatarUrl: map['avatarUrl'],
      refreshToken: map['refreshToken'],
    );
  }
}
class StoredUserProfiles {
  final int lastUsedProfileIndex;
  final List<StoredUserProfile> profiles;

  StoredUserProfiles({this.lastUsedProfileIndex, this.profiles});


  String toJson() {
    var map = <String, dynamic>{};
    map['lastUsesProfileIndex'] = lastUsedProfileIndex;
    map['profiles'] = profiles;

    return json.encode(map);
  }

  static StoredUserProfiles fromJson(String jsonString) {
    var map = json.decode(jsonString);
    return StoredUserProfiles(
      lastUsedProfileIndex: map['lastUsesProfileIndex'],
      profiles: (map['profiles'] as List).map<StoredUserProfile>((s) => StoredUserProfile.fromJson(s)).toList(),
    );
  }
}

