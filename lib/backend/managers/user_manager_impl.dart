import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class UserManagerImplementation implements UserManager {
  @override
  bool isLoggedIn = true;

  @override
  User get currentUser => backend.get<AuthenticationService>().currentUser;

  @override
  RxCommand<void, bool> logInUserCommand;
  // RxCommand<User, void> createUserByEmailCommand;

  @override
  RxCommand<void, void> updateUser;

  @override
  RxCommand<User, void> saveUserCommand;

  UserManagerImplementation() {
    var authenticationService = backend.get<AuthenticationService>();

    logInUserCommand = RxCommand.createAsyncNoParam(authenticationService.loginUserWithToken);

    saveUserCommand = RxCommand.createAsyncNoResult<User>((user) => authenticationService.updateUser(user));
  }

  @override
  Observable<User> get currentUserUpdates => backend.get<AuthenticationService>().currentUserUpdates;
}
