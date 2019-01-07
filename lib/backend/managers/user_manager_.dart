import 'package:inf/backend/services/auth_service_.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';
import 'package:inf_api_client/inf_api_client.dart';

class LogInData {
  LogInData({this.provider, this.email, this.password});

  final SocialNetworkProvider provider;
  final String email;
  final String password;
}

abstract class UserManager {
  bool isLoggedIn;

  User currentUser;
  Observable<User> get currentUserUpdates;


  /// BehaviorSubject
  Observable<AuthenticationResult> get logInStateChanged;

  // User Commands
  // RxCommand<LogInData, void> logInUserCommand;
  RxCommand<User, void> updateUserCommand;
  RxCommand<SocialMediaAccount, void> updateSocialMediaAccountCommand;
  // RxCommand<User, void> createUserByEmailCommand;
}



