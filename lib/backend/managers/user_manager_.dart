import 'package:inf/domain/domain.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserManager {
  bool isLoggedIn;

  User get currentUser;
  Observable<User> get currentUserUpdates;

  // User Commands
  RxCommand<void, bool> logInUserCommand;
  RxCommand<User, void> saveUserCommand;

  // Updates the underlying Subject of currentUserUpdates from the server
  RxCommand<void, void> updateUser;
}
