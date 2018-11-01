
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain/user.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';



class UserManagerImplementation implements UserManager
{
  bool isLoggedIn;

  User get currentUser => null;

  Observable<AuthenticationResult> get logInStateChanged => backend<AuthenticationService>().loginState; 

  // User Commands
  // RxCommand<LogInData, void> logInUserCommand;
  // RxCommand<User, void> updateUserCommand;
  // RxCommand<User, void> createUserByEmailCommand;
}
