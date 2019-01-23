import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain/domain.dart';
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
  // RxCommand<User, void> createUserByEmailCommand;

  @override
  RxCommand<void, void> updateUserFromServer;

  @override
  RxCommand<UserUpdateData, void> updateUserCommand;

  UserManagerImplementation() {
    var authenticationService = backend.get<AuthenticationService>();

    logInUserCommand = RxCommand.createAsyncNoParam(authenticationService.loginUserWithToken);

   updateUserCommand = RxCommand.createAsyncNoResult<UserUpdateData>( saveUserData);
  }

  @override
  Observable<User> get currentUserUpdates => backend.get<AuthenticationService>().currentUserUpdates;
}

Future saveUserData(UserUpdateData userData) async
{
  if (userData.profilePicture != null)
  {
    var imageBytes = await userData.profilePicture.readAsBytes();

    var image = decodeImage(imageBytes);
    var smallImage = copyResize(image, 800);
    var profileUrl =  await backend.get<ImageService>().uploadImageFromBytes('profilePicture', encodeJpg(smallImage, quality: 90));
    print(profileUrl);
  }
}
