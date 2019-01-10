import 'package:inf/backend/services/auth_service_.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:inf_api_client/inf_api_client.dart';

abstract class UserManager {
  bool isLoggedIn;

  User get currentUser;
  Observable<User> get currentUserUpdates;
  // User Commands
  RxCommand<void, bool> logInUserCommand;
  RxCommand<User, void> updateUserCommand;
  RxCommand<SocialMediaAccount, void> updateSocialMediaAccountCommand;
  // RxCommand<User, void> createUserByEmailCommand;
}



