
import 'package:inf/backend/services/auth_service_.dart';
import 'package:inf/domain_objects/user.dart';
import 'package:rxdart/rxdart.dart';



class AuthenticationServiceImplementation implements AuthenticationService {

  @override
  Observable<AuthenticationResult> get loginState => null;

  Future<AuthenticationResult> getCurrentAuthenticationState()
  {
    throw Exception('Not imnplemented');
  }
  
  Future<void> loginWithGoogle(UserType userType)
  {
    throw Exception('Not imnplemented');
  }
  Future<void> loginWithFacebook(UserType userType)
  {
    throw Exception('Not imnplemented');
  }

  Future<void> loginWithTwitter(UserType userType)
  {
    throw Exception('Not imnplemented');
  }

  Future<void> loginWithInstagram(UserType userType)
  {
    throw Exception('Not imnplemented');
  }


  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);


  Future<void> logOut()
  {
    throw Exception('Not imnplemented');
  }


}
