import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain/user.dart';
import 'package:rxdart/rxdart.dart';

class UserManagerImplementation implements UserManager {
  @override
  bool isLoggedIn = false;

  @override
  User currentUser;

  @override
  Observable<AuthenticationResult> get logInStateChanged => backend.get<AuthenticationService>().loginState;

  // User Commands
  // RxCommand<LogInData, void> logInUserCommand;
  // RxCommand<User, void> updateUserCommand;
  // RxCommand<User, void> createUserByEmailCommand;

  UserManagerImplementation() {
    logInStateChanged.listen((state) {
      if (state.state == AuthenticationState.success) {
        currentUser = state.user;
        isLoggedIn = true;
      } else {
        currentUser = null;
        isLoggedIn = false;
      }
    });
  }
}
