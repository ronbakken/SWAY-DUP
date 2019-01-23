import 'dart:io';

import 'package:inf/domain/domain.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';


class UserUpdateData
{
  final User user;
  final File profilePicture;

  UserUpdateData({this.user, this.profilePicture});
}


abstract class UserManager {
  bool isLoggedIn;

  User get currentUser;
  Observable<User> get currentUserUpdates;

  // User Commands
  RxCommand<void, bool> logInUserCommand;

  // Updates the user's data on the server
  RxCommand<UserUpdateData, void> updateUserCommand;

  // Updates the underlying Subject of currentUserUpdates from the server
  RxCommand<void, void> updateUserFromServer;
}
