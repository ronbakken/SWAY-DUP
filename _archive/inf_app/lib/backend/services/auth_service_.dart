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

  FutureOr<void> metadataProvider(Map<String, String> metadata, String uri);

  Observable<User> get currentUserUpdates;

  Future<void> sendLoginEmail(UserType userType, String email, String invitationCode);

  Future<bool> loginUserWithRefreshToken();

  Future<bool> loginUserWithLoginToken(String loginToken);

  Future<void> activateUser(User user, String loginToken);

  Future<GetInvitationCodeStatusResponse_InvitationCodeStatus> checkInvitationCode(String code);

  Future<void> updateUser(User user);

  Future<void> logOut();

  List<LoginProfile> getLoginProfiles();

  Future<void> switchUser(LoginProfile newProfile); 
  
  Future<void> updateLoginProfile(User user); 

  Future<void> refreshAccessToken();

  Future<void> updatePushToken(String token);
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

class LoginProfile {
  String userName;
  String email;
  String avatarUrl;
  String refreshToken;

  LoginProfile({
    this.userName,
    this.email,
    this.avatarUrl,
    this.refreshToken,
  });

  String toJson() {
    var map = <String, dynamic>{};
    map['userName'] = userName;
    map['email'] = email;
    map['avatarUrl'] = avatarUrl;
    map['refreshToken'] = refreshToken;

    return json.encode(map);
  }

  static LoginProfile fromJson(String jsonString) {
    var map = json.decode(jsonString);
    return LoginProfile(
      userName: map['userName'],
      avatarUrl: map['avatarUrl'],
      email: map['email'],
      refreshToken: map['refreshToken'],
    );
  }
}
class LoginProfiles {
  String lastUsedProfileEmail;
  Map<String,LoginProfile> profiles;

  LoginProfiles({this.lastUsedProfileEmail, this.profiles});


  String toJson() {
    var map = <String, dynamic>{};
    map['lastUsesProfileEmail'] = lastUsedProfileEmail;
    map['profiles'] = profiles;

    return json.encode(map);
  }

  static LoginProfiles fromJson(String jsonString) {
    var map = json.decode(jsonString);
    return LoginProfiles(
      lastUsedProfileEmail: map['lastUsesProfileEmail'],
      profiles: (map['profiles'] as Map).map<String,LoginProfile>((k,s) => MapEntry(k,LoginProfile.fromJson(s))),
    );
  }
}

