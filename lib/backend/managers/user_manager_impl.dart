import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class UserManagerImplementation implements UserManager {
  @override
  bool isLoggedIn = true;
  @override
  LoginToken loginToken;

  @override
  User get currentUser => backend.get<AuthenticationService>().currentUser;

  @override
  RxCommand<LoginToken, bool> logInUserCommand;
  @override
  RxCommand<LoginEmailInfo, void> sendLoginEmailCommand;

  @override
  RxCommand<void, void> updateUserFromServer;

  @override
  RxCommand<UserUpdateData, void> updateUserCommand;

  @override
  RxCommand<void, void> logOutUserCommand;

  UserManagerImplementation() {
    logInUserCommand = RxCommand.createAsync(loginUser);

    sendLoginEmailCommand = RxCommand.createAsyncNoResult(sendLoginEmail);

    updateUserCommand = RxCommand.createAsyncNoResult<UserUpdateData>(updateUserData);

    logOutUserCommand = RxCommand.createAsyncNoParamNoResult(backend.get<AuthenticationService>().logOut,
        emitsLastValueToNewSubscriptions: true);
  }

  @override
  Observable<User> get currentUserUpdates => backend.get<AuthenticationService>().currentUserUpdates;

  Future<void> sendLoginEmail(LoginEmailInfo loginInfo) async {
    // Check if a new user tries to signup with an invitationcode
    if (loginInfo.invitationCode != null && loginInfo.invitationCode.isNotEmpty) {
      var status = await backend.get<AuthenticationService>().checkInvitationCode(loginInfo.invitationCode);
      if (status != GetInvitationCodeStatusResponse_InvitationCodeStatus.PENDING_USE) {
        throw InvalidInvitationCodeException(status);
      }
    }
    await backend
        .get<AuthenticationService>()
        .sendLoginEmail(loginInfo.userType, loginInfo.email, loginInfo.invitationCode);
  }

  Future<void> updateUserData(UserUpdateData userData) async {
    User userToSend;

    // if an image file is provided create all needed resolutions
    // and upload them
    if (userData.profilePicture != null) {
      var imageReference = userData.user.avatarImage.copyWith(imageFile: userData.profilePicture);

      // var image = decodeImage(imageBytes);
      // var profileImage = copyResize(image, 800);
      // var profileLowRes = copyResize(profileImage, 100);
      // var thumbNail = copyResize(profileImage, 100);
      // var thumbNailLowRes = copyResize(thumbNail, 20);


      var avatarImage = await backend
          .get<ImageService>()
          .uploadImageReference(fileNameTrunc: 'profilePicture',
          imageReference: imageReference,
          imageWidth: 800,
          lowResWidth: 100);     
      var thumbnailImage = await backend
          .get<ImageService>()
          .uploadImageReference(fileNameTrunc: 'profileThumbnail',
          imageReference: imageReference,
          imageWidth: 100,
          lowResWidth: 20);     

      userToSend = userData.user.copyWith(
        avatarImage: avatarImage,
        avatarThumbnail: thumbnailImage,
      );
    } else {
      userToSend = userData.user;
    }
    if (userData.user.accountState == UserDto_Status.waitingForActivation) {
      await backend.get<AuthenticationService>().activateUser(
            userToSend.copyWith(
              email: loginToken.email,
              // TODO add categories
              categories: [],
            ),
            loginToken.token,
          );
    } else {
      await backend.get<AuthenticationService>().updateUser(userToSend);
    }
  }

  Future<bool> loginUser(LoginToken token) async {
    loginToken = token;
    var authenticationService = backend.get<AuthenticationService>();
    if (token == null) {
      // Try to login with stored refresh token
      return await authenticationService.loginUserWithRefreshToken();
    } else {
      print(token);
      return await authenticationService.loginUserWithLoginToken(token.token);
    }
  }
}
