import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

import 'package:rxdart/rxdart.dart';

class AuthenticationServiceImplementation implements AuthenticationService {
  AuthenticationServiceImplementation({this.userTestToken});

  @override
  CallOptions callOptions;

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
      final secureStorage = new FlutterSecureStorage();
      var refreshToken = await secureStorage.read(key: 'refresh_token');

      /// just when using the mock implmentation
      if (userTestToken != null) {
        refreshToken = userTestToken;
      }

      if (refreshToken != null) {
        var tokenMessage = LoginWithRefreshTokenRequest()..refreshToken = refreshToken;
        var authResult = await backend.get<InfApiClientsService>().authClient.loginWithRefreshToken(tokenMessage);
        if (authResult.accessToken.isNotEmpty) {
          updateAccessToken(authResult.accessToken);
          _currentUser = User.fromDto(authResult.userData);
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

    if (authResult.refreshToken.isNotEmpty) {
      /// store reecived token in secure storage
      final secureStorage = new FlutterSecureStorage();
      await secureStorage.write(key: 'refresh_token', value: authResult.refreshToken);

      var tokenMessage = LoginWithRefreshTokenRequest()..refreshToken = authResult.refreshToken;
      var accessTokenResult = await backend.get<InfApiClientsService>().authClient.loginWithRefreshToken(tokenMessage);
      updateAccessToken(accessTokenResult.accessToken);

      if (authResult.userData.accountState == AccountState.active) {
        _currentUser = User.fromDto(authResult.userData);
        currentUserUpdatesSubject.add(_currentUser);
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> logOut() async {
    //await backend.get<InfApiClientsService>().authClient.logout(LogoutRequest(), options: callOptions);
    final secureStorage = new FlutterSecureStorage();
    await secureStorage.delete(key: 'refresh_token');
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
    var response = await backend.get<InfApiClientsService>().authClient.activateUser(
          ActivateUserRequest()
            ..userData = user.toDto()
            ..loginToken = loginToken,
        );
    if (response.refreshToken.isNotEmpty) {
      var tokenMessage = LoginWithRefreshTokenRequest()..refreshToken = response.refreshToken;
      var accessTokenResult = await backend.get<InfApiClientsService>().authClient.loginWithRefreshToken(tokenMessage);
      updateAccessToken(accessTokenResult.accessToken);

      _currentUser = User.fromDto(response.userData);
      currentUserUpdatesSubject.add(_currentUser);
    }
  }

  void updateAccessToken(String token) {
    callOptions = CallOptions(metadata: {'Authorization': 'Bearer $token'});
  }
}
