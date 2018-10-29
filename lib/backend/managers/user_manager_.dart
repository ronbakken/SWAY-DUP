import 'package:inf/backend/services/auth_service.dart';
import 'package:inf/domain_objects/user.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';


class LogInData {
  LogInData({this.provider, this.email, this.password});

  final AuthenticationProvider provider;
  final String email;
  final String password;
}


abstract class UserManager
{
  bool isLoggedIn;

  User get currentUser;

  Observable<AuthenticationResult> get logInStateChanged; 

  // User Commands
  RxCommand<LogInData, void> logInUserCommand;
  RxCommand<User, void> updateUserCommand;
  RxCommand<User, void> createUserByEmailCommand;
}
