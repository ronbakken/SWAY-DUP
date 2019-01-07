import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';
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
  // RxCommand<User, void> createUserByEmailCommand;

  @override
  RxCommand<SocialMediaAccount, void> updateSocialMediaAccountCommand;

  @override
  RxCommand<User, void> updateUserCommand;

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

    updateSocialMediaAccountCommand = RxCommand.createAsyncNoResult<SocialMediaAccount>(
        (account) => backend.get<AuthenticationService>().updateSocialMediaAccount(account));

    updateUserCommand = RxCommand.createAsyncNoResult<User>(
        (user) => backend.get<AuthenticationService>().updateUser(user));

  }

  @override
  Observable<User> get currentUserUpdates => backend.get<AuthenticationService>().currentUser;
}
