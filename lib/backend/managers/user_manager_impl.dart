import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:image/image.dart';

class UserManagerImplementation implements UserManager {
  @override
  bool isLoggedIn = true;

  @override
  User get currentUser => backend.get<AuthenticationService>().currentUser;

  @override
  RxCommand<void, bool> logInUserCommand;
  @override
  RxCommand<LoginEmailInfo, void> sendLoginEmailCommand;

  @override
  RxCommand<void, void> updateUserFromServer;

  @override
  RxCommand<UserUpdateData, void> updateUserCommand;

  UserManagerImplementation() {
    var authenticationService = backend.get<AuthenticationService>();

    logInUserCommand = RxCommand.createAsyncNoParam(authenticationService.loginUserWithToken);

    sendLoginEmailCommand = RxCommand.createAsyncNoResult(sendLoginEmail);

    updateUserCommand = RxCommand.createAsyncNoResult<UserUpdateData>(updateUserData);
  }

  @override
  Observable<User> get currentUserUpdates => backend.get<AuthenticationService>().currentUserUpdates;
}

Future<void> sendLoginEmail(LoginEmailInfo loginInfo) async {
  // Check if a new user tries to signup with an invitationcode
  if (loginInfo.invitationCode != null) {
    var status = await backend.get<AuthenticationService>().checkInvitationCode(loginInfo.invitationCode);
    if (status != GetInvitationCodeStatusResponse_InvitationCodeStatus.PENDING_USE) {
      throw InvalidInvitationCodeException(status);
    }
  }
  await backend.get<AuthenticationService>().sendLoginEmail(loginInfo.userType, loginInfo.email);
}

Future<void> updateUserData(UserUpdateData userData) async {
  User userToSend;

  // if an image file is provided create all needed resolutions
  // and upload them
  if (userData.profilePicture != null) {
    var imageBytes = await userData.profilePicture.readAsBytes();

    var image = decodeImage(imageBytes);
    var profileIMage = copyResize(image, 800);
    var profileLores = copyResize(profileIMage, 100);
    var thumbNail = copyResize(profileIMage, 100);
    var thumbNailLores = copyResize(thumbNail, 20);

    var profileUrl = await backend
        .get<ImageService>()
        .uploadImageFromBytes('profilePicture.jpg', encodeJpg(profileIMage, quality: 90));
    var thumbNailUrl = await backend
        .get<ImageService>()
        .uploadImageFromBytes('profileThumbnail.jpg', encodeJpg(thumbNail, quality: 90));
    userToSend = userData.user.copyWith(
      avatarUrl: profileUrl,
      avatarLowRes: encodeJpg(profileLores),
      avatarThumbnailUrl: thumbNailUrl,
      avatarThumbnailLowRes: encodeJpg(thumbNailLores),
    );

    imageCache.clear();
  } else {
    userToSend = userData.user;
  }

  await backend.get<AuthenticationService>().updateUser(userToSend);
}
