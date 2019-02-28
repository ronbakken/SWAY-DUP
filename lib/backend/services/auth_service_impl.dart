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
  LoginProfiles loginProfiles;

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
      await loadLoginProfiles();
      refreshToken = getLastUsedRefreshToken();

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
    await loadLoginProfiles();
    refreshToken = authResult.refreshToken;

    if (authResult.refreshToken.isNotEmpty) {
      _currentUser = User.fromDto(authResult.user);

      /// store reecived token in secure storage
      /// We only store it for an active user
      /// new user store the token after sucessfull activation
      if (authResult.user.status == UserDto_Status.active) {
        await storeLoginProfile(refreshToken, _currentUser);
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
    loginProfiles.lastUsedProfileEmail = '';
    await saveLoginProfiles();
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
      await updateLoginProfile(_currentUser);
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
      await storeLoginProfile(refreshToken, _currentUser);
      currentUserUpdatesSubject.add(_currentUser);
    }
  }

  void updateAccessToken(String token) {
    callOptions = CallOptions(metadata: {'Authorization': 'Bearer $token'});
  }

  Future<void> storeLoginProfile(String token, User user) async {
    if (loginProfiles == null) {
      loginProfiles = LoginProfiles(
        lastUsedProfileEmail: user.email,
        profiles: {
          user.email: LoginProfile(
            refreshToken: token,
            userName: user.name,
            email: user.email,
            avatarUrl: user.avatarThumbnail.imageUrl,
          ),
        },
      );
    } else {
      var profile = loginProfiles.profiles[user.email];
      if (profile != null) {
        profile.refreshToken = token;
      } else {
        loginProfiles.profiles[user.email] = LoginProfile(
          refreshToken: token,
          userName: user.name,
          email: user.email,
          avatarUrl: user.avatarThumbnail.imageUrl,
        );
      }
      loginProfiles.lastUsedProfileEmail = user.email;
    }

    await saveLoginProfiles();
  }

  String getLastUsedRefreshToken() {
    if (loginProfiles == null || loginProfiles.lastUsedProfileEmail.isEmpty) {
      return null;
    }
    return loginProfiles.profiles[loginProfiles.lastUsedProfileEmail].refreshToken;
  }

  Future<void> loadLoginProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonString = prefs.getString('userProfiles');
    if (jsonString == null) {
      loginProfiles = null;
      return;
    }
    loginProfiles = LoginProfiles.fromJson(jsonString);
  }

  Future<void> saveLoginProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var asJson = loginProfiles.toJson();
    await prefs.setString('userProfiles', asJson);
  }

  Future<void> deleteLoginProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userProfiles');
  }

  @override
  List<LoginProfile> getLoginProfiles() => loginProfiles.profiles.values.toList(growable: false);

  @override
  Future<void> switchUser(LoginProfile newProfile) async {
    loginProfiles.lastUsedProfileEmail = newProfile.email;
    await saveLoginProfiles();
    await loginUserWithRefreshToken();

  }

  @override
  Future<void> updateLoginProfile(User user) async
  {
    if (loginProfiles.profiles.containsKey(user.email))
    {
      // Update stored user data
      loginProfiles.profiles[user.email].userName =user.name;
      loginProfiles.profiles[user.email].avatarUrl =user.avatarThumbnail.imageUrl;
      await saveLoginProfiles();

    }
  } 

}
