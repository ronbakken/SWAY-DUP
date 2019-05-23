import 'dart:async';

import 'package:grpc/grpc.dart' show StatusCode;
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

import 'package:rxdart/rxdart.dart';
import 'package:sentry/sentry.dart' as sentry;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationServiceImplementation implements AuthenticationService {
  AuthenticationServiceImplementation({this.userTestToken});

  String _pushToken;
  String _authToken;
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
  FutureOr<void> metadataProvider(Map<String, String> metadata, String uri) async {
    metadata['Authorization'] = 'Bearer $_authToken';
  }

  @override
  Future<bool> loginUserWithRefreshToken() async {
    try {
      await loadLoginProfiles();
      refreshToken = getLastUsedRefreshToken();

      /// just when using the mock implementation
      if (userTestToken != null) {
        refreshToken = userTestToken;
      }

      if (refreshToken != null) {
        var tokenMessage = LoginWithRefreshTokenRequest()..refreshToken = refreshToken;
        var authResult = await backend<InfApiClientsService>().authClient.loginWithRefreshToken(tokenMessage);
        if (authResult.accessToken.isNotEmpty) {
          _authToken = authResult.accessToken;
          _currentUser = User.fromDto(authResult.user);
          currentUserUpdatesSubject.add(_currentUser);
          //await addPushTokenToUser(); // FIXME should not be commented.. but fails with error
          return true;
        }
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<void> refreshAccessToken() async {
    var response = await backend
        .get<InfApiClientsService>()
        .authClient
        .getAccessToken(GetAccessTokenRequest()..refreshToken = refreshToken);
    if (response != null) {
      _authToken = response.accessToken;
      print('Updated Access Token');
    } else {
      await backend<ErrorReporter>().logEvent(
        'refreshAccessToken failed',
        sentry.SeverityLevel.fatal,
        {'username': currentUser.email, 'refreshtoken': refreshToken},
      );
    }
  }

  @override
  Future<bool> loginUserWithLoginToken(String loginToken) async {
    var authResult = await backend<InfApiClientsService>().authClient.loginWithLoginToken(
          LoginWithLoginTokenRequest()..loginToken = loginToken,
        );
    await loadLoginProfiles();
    refreshToken = authResult.refreshToken;

    if (authResult.refreshToken.isNotEmpty) {
      _currentUser = User.fromDto(authResult.user);

      /// store received token in secure storage
      /// We only store it for an active user
      /// new user store the token after successful activation
      if (authResult.user.status == UserDto_Status.active) {
        await storeLoginProfile(refreshToken, _currentUser);
      }

      var tokenMessage = LoginWithRefreshTokenRequest()..refreshToken = authResult.refreshToken;
      var accessTokenResult = await backend<InfApiClientsService>().authClient.loginWithRefreshToken(tokenMessage);
      _authToken = accessTokenResult.accessToken;

      currentUserUpdatesSubject.add(_currentUser);
      await addPushTokenToUser();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> logOut() async {
    //await backend<InfApiClientsService>().authClient.logout(LogoutRequest(), options: callOptions);
    loginProfiles.lastUsedProfileEmail = '';
    await removePushTokenFromUser();
    await saveLoginProfiles();
  }

  @override
  Future<void> updateUser(User user) async {
    var dto = user.toDto();
    UpdateUserResponse response;
    try {
      response = await backend
          .get<InfApiClientsService>()
          .usersClient
          .updateUser(UpdateUserRequest()..user = dto);
    } on GrpcError catch (e) {
      if (e.code == StatusCode.permissionDenied) // permission denied
      {
        // retry with new access token
        await backend<AuthenticationService>().refreshAccessToken();
        response = await backend
            .get<InfApiClientsService>()
            .usersClient
            .updateUser(UpdateUserRequest()..user = dto);
      } else {
        await backend<ErrorReporter>().logException(e, message: 'updateUser');
        print(e);
        rethrow;
      }
    }
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
    await backend<InfApiClientsService>().authClient.sendLoginEmail(SendLoginEmailRequest()
      ..email = email
      ..userType = userType
      ..invitationCode = invitationCode);
  }

  @override
  Future<void> activateUser(User user, String loginToken) async {
    assert(refreshToken != null);
    ActivateUserResponse response;
    try {
      response = await backend<InfApiClientsService>().authClient.activateUser(
          ActivateUserRequest()
            ..user = user.toDto()
            ..loginToken = loginToken);
    } on GrpcError catch (e) {
      if (e.code == 7) // permission denied
      {
        // retry with new access token
        await backend<AuthenticationService>().refreshAccessToken();
        response = await backend<InfApiClientsService>().authClient.activateUser(
            ActivateUserRequest()
              ..user = user.toDto()
              ..loginToken = loginToken);
      } else {
        await backend<ErrorReporter>().logException(e, message: 'activateUser');
        rethrow;
      }
    }
    if (response.user != null) {
      _currentUser = User.fromDto(response.user);
      await storeLoginProfile(refreshToken, _currentUser);
      currentUserUpdatesSubject.add(_currentUser);
      await addPushTokenToUser();
    }
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
    /*
    loginProfiles = LoginProfiles(
        lastUsedProfileEmail: "kent.boogaart@gmail.com",
        profiles: {
          "kent.boogaart@gmail.com": LoginProfile(
            refreshToken: "eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwidHlwIjoiSldUIn0.Ta0eNWlOUUq8YLinBMPRRqvXyF1XVhkV5SmC9lMeRLiKXETxpPCks97jziUAuGvI_00TD01cozTZGt8cZgyEPGJKICIqgH9b.EG8heP0QYMxa4nm8lChBDw.v_nFg3njhjI6cY6T8HjSFYQDg0GdJyHIOtzvcMY9vRCq0Va99J_a1Sq07eGbUBUeK5j4fnlXPl3ZcuJ5ZSzzIZK4fpTN1vVooVCujHx7YQDtU4EMUx6VRZVziDZtphIXvatoVrK-b6aCGkKb3gpX3jVUHtXX88pAX_rgRcST6UbdfXX4aaoBKGRzzd6zVyqYGHS-TRhMi9CrDUVkpCMdYzST0cWCBINHt8VLbpAR14wy15tbs0IAgwKXbpa-mWnjhrzXJGWPznZy4rfoSbGe8h_Au7Id1yV39E13hzb8Ol3gmCZYFIEBTSn3JhKfCGSZUTKbkltX3774Q4gXe1tN-mi_VQIOnz4PsABqE0dEOYObyTdf9qWHWMN6O94Af0rigoODIVvTFBo4zGMBmFiBHx1pOBupO0qGaVWXbo5R5PM.DS83W_ixIkBOCNAtBGEBKb4JlCd0bci9LJox_QBmObI",
            userName: "Kent Boogaart",
            email: "kent.boogaart@gmail.com",
            avatarUrl: "https://forums.auscelebs.net/acnet-images/99325/ella-hooper-867087.jpg",
          ),
        });
    */
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
    await removePushTokenFromUser();
    await saveLoginProfiles();
    await loginUserWithRefreshToken();
  }

  @override
  Future<void> updateLoginProfile(User user) async {
    if (loginProfiles.profiles.containsKey(user.email)) {
      // Update stored user data
      loginProfiles.profiles[user.email].userName = user.name;
      loginProfiles.profiles[user.email].avatarUrl = user.avatarThumbnail.imageUrl;
      await saveLoginProfiles();
    }
  }

  @override
  Future<void> updatePushToken(String token) async {
    _pushToken = token;
    await addPushTokenToUser();
  }

  Future<void> addPushTokenToUser() async {
    final user = currentUser;
    if(user != null && _pushToken != null){
      final tokens = Set.of(user.registrationTokens)..add(_pushToken);
      await updateUser(user.copyWith(registrationTokens: tokens));
    }
  }

  Future<void> removePushTokenFromUser() async {
    final user = currentUser;
    if(user != null && _pushToken != null){
      final tokens = Set.of(user.registrationTokens)..remove(_pushToken);
      await updateUser(user.copyWith(registrationTokens: tokens));
    }
  }
}
