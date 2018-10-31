
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain_objects/user.dart';
import 'package:rxdart/rxdart.dart';

/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin 
/// with a user he has never used before




class AuthenticationServiceMock implements AuthenticationService {

  @override
  Observable<AuthenticationResult> get loginState => _loginStateSubject;

  BehaviorSubject<AuthenticationResult> _loginStateSubject = new BehaviorSubject<AuthenticationResult>();

  /// Returns the current authenticationstate independent od a state change
  @override  
  Future<AuthenticationResult> getCurrentAuthenticationState()
  {

  }
  
  @override
  Future<void> loginWithGoogle(UserType userType)
  {

  }

  @override
  Future<void> loginWithFacebook(UserType userType)
  {

  }

  @override
  Future<void> loginWithTwitter(UserType userType)
  {

  }

  @override
  Future<void> loginWithInstagram(UserType userType)
  {

  }

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);


  Future<void> logOut()
  {

  }

}
