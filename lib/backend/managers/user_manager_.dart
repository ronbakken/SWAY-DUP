
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain/user.dart';
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

  User  currentUser;

  /// BehaviorSubject
  Observable<AuthenticationResult> get logInStateChanged; 

  // User Commands
  // RxCommand<LogInData, void> logInUserCommand;
  // RxCommand<User, void> updateUserCommand;
  // RxCommand<User, void> createUserByEmailCommand;
}
