import 'dart:io';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';


/// Get's thrown from [sendLoginEmailCommand] if the passed invitation code was wrong.
class InvalidInvitationCodeException implements Exception {
  GetInvitationCodeStatusResponse_InvitationCodeStatus status;

  InvalidInvitationCodeException(this.status,);

  @override
  String toString() {
    return status.toString();
  }
}


class UserUpdateData
{
  final User user;
  /// if [profilePicture] != null calling the updateUserCommand will automatically create all needed
  /// resolutions and upload them to the cloud storage
  final File profilePicture;

  UserUpdateData({this.user, this.profilePicture});
}


class LoginEmailInfo
{
   final String email;
   final UserType userType;
   final String invitationCode;


  LoginEmailInfo({this.email, this.userType, this.invitationCode});  
}



abstract class UserManager {
  bool isLoggedIn;
  LoginToken loginToken;

  User get currentUser;
  Observable<User> get currentUserUpdates;


  // If a token is passed as parameter it will be treated as a login-token to aquire a longtime token
  RxCommand<LoginToken, bool> logInUserCommand;

  RxCommand<LoginEmailInfo, void> sendLoginEmailCommand;

  // Updates the user's data on the server
  RxCommand<UserUpdateData, void> updateUserCommand;

  // Updates the underlying Subject of currentUserUpdates from the server
  RxCommand<void, void> updateUserFromServer;
}
