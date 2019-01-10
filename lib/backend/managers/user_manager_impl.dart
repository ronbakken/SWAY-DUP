import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class UserManagerImplementation implements UserManager {
  @override
  bool isLoggedIn = true;

  @override
  User get currentUser => backend.get<AuthenticationService>().currentUser;


  // User Commands
  RxCommand<void, bool> logInUserCommand;
  // RxCommand<User, void> createUserByEmailCommand;

  @override
  RxCommand<SocialMediaAccount, void> updateSocialMediaAccountCommand;

  @override
  RxCommand<User, void> updateUserCommand;

  UserManagerImplementation() {

    logInUserCommand = RxCommand.createAsyncNoParam(backend.get<AuthenticationService>().loginUserWithToken );

    updateSocialMediaAccountCommand = RxCommand.createAsyncNoResult<SocialMediaAccount>(
        (account) => backend.get<AuthenticationService>().updateSocialMediaAccount(account));

    updateUserCommand = RxCommand.createAsyncNoResult<User>(
        (user) => backend.get<AuthenticationService>().updateUser(user));

  }

  @override
  Observable<User> get currentUserUpdates => backend.get<AuthenticationService>().currentUserUpdates;
}
