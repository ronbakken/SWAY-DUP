import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationServiceImplementation implements AuthenticationService {
  AuthenticationServiceImplementation({this.userTestToken});

  @override
  CallOptions callOptions;
  String refreshToken;
  StoredUserProfiles userProfiles;

  @override
  User get currentUser => _currentUser;
  User _currentUser;

  /// if this is set it will be used to login instead of a stored token
  final String userTestToken;

  @override
  Observable<User> get currentUserUpdates => currentUserUpdatesSubject;

  BehaviorSubject<User> currentUserUpdatesSubject = BehaviorSubject<User>();

  @override
  Future<bool> loginUserWithRefreshToken() async {
    try {
      refreshToken = await readRefreshToken();

      /// just when using the mock implmentation
      if (userTestToken != null) {
        refreshToken = userTestToken;
      }

      if (refreshToken != null) {
        var tokenMessage = LoginWithRefreshTokenRequest()..refreshToken = refreshToken;
        var authResult = await backend.get<InfApiClientsService>().authClient.loginWithRefreshToken(tokenMessage);
        if (authResult.accessToken.isNotEmpty) {
          updateAccessToken(authResult.accessToken);
          _currentUser = User.fromDto(authResult.user);
          currentUserUpdatesSubject.add(_currentUser);
          return true;
        }
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> loginUserWithLoginToken(String loginToken) async {
    var authResult = await backend.get<InfApiClientsService>().authClient.loginWithLoginToken(
          LoginWithLoginTokenRequest()..loginToken = loginToken,
        );
    refreshToken = authResult.refreshToken;

    if (authResult.refreshToken.isNotEmpty) {
      _currentUser = User.fromDto(authResult.user);

      /// store reecived token in secure storage
      /// We only store it for an active user
      /// new user store the token after sucessfull activation
      if (authResult.user.status == UserDto_Status.active) {
        await storeRefreshToken(refreshToken, _currentUser);
      }

      var tokenMessage = LoginWithRefreshTokenRequest()..refreshToken = authResult.refreshToken;
      var accessTokenResult = await backend.get<InfApiClientsService>().authClient.loginWithRefreshToken(tokenMessage);
      updateAccessToken(accessTokenResult.accessToken);

      currentUserUpdatesSubject.add(_currentUser);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> logOut() async {
    //await backend.get<InfApiClientsService>().authClient.logout(LogoutRequest(), options: callOptions);
    await deleteRefreshToken();
  }

  @override
  Future<void> updateUser(User user) async {
    var dto = user.toDto();
    var response = await backend
        .get<InfApiClientsService>()
        .usersClient
        .updateUser(UpdateUserRequest()..user = dto, options: callOptions);
    if (response != null) {
      _currentUser = User.fromDto(response.user);
      currentUserUpdatesSubject.add(_currentUser);
    }
  }

  @override
  Future<GetInvitationCodeStatusResponse_InvitationCodeStatus> checkInvitationCode(String code) async {
    var result = await backend
        .get<InfApiClientsService>()
        .invitationCodeClient
        .getInvitationCodeStatus(GetInvitationCodeStatusRequest()..invitationCode = code);
    return result.status;
  }

  @override
  Future<void> sendLoginEmail(UserType userType, String email, String invitationCode) async {
    await backend.get<InfApiClientsService>().authClient.sendLoginEmail(SendLoginEmailRequest()
      ..email = email
      ..userType = userType
      ..invitationCode = invitationCode);
  }

  @override
  Future<void> activateUser(User user, String loginToken) async {
    assert(refreshToken != null);
    var response = await backend.get<InfApiClientsService>().authClient.activateUser(
        ActivateUserRequest()
          ..user = user.toDto()
          ..loginToken = loginToken,
        options: callOptions);
    if (response.user != null) {
      _currentUser = User.fromDto(response.user);
      await storeRefreshToken(refreshToken, _currentUser);
      currentUserUpdatesSubject.add(_currentUser);
    }
  }

  void updateAccessToken(String token) {
    callOptions = CallOptions(metadata: {'Authorization': 'Bearer $token'});
  }

  Future<void> storeRefreshToken(String token, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userProfiles == null) {
      userProfiles = StoredUserProfiles(
        lastUsedProfileIndex: 0,
        profiles: [
          StoredUserProfile(
            refreshToken: token,
            userName: user.name,
            avatarUrl: user.avatarThumbnail.imageUrl,
          ),
        ],
      );
    } else {
      userProfiles.profiles[userProfiles.lastUsedProfileIndex].refreshToken = token;
    }

    var asJson = userProfiles.toJson();
    await prefs.setString('userProfiles', asJson);
  }

  Future<String> readRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString('userProfiles');
    if (jsonString == null) {
      return null;
    }
    userProfiles = StoredUserProfiles.fromJson(jsonString);
    return userProfiles.profiles[userProfiles.lastUsedProfileIndex].refreshToken;
  }

  Future<void> deleteRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userProfiles');
  }
}
