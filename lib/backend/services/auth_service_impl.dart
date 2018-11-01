import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';


class AuthenticationServiceImplementation implements AuthenticationService {
  @override
  Observable<AuthenticationResult> get loginState => null;

  Future<AuthenticationResult> getCurrentAuthenticationState() {
    throw Exception('Not imnplemented');
  }

  Future<void> loginWithGoogle() async {
    throw Exception('Not imnplemented');
  }

  Future<void> loginWithFacebook() async {
    throw Exception('Not imnplemented');
  }

  Future<void> loginWithTwitter() async {
    throw Exception('Not imnplemented');
  }

  Future<void> loginWithInstagram() async {
    throw Exception('Not imnplemented');
  }

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  Future<void> logOut() {
    // TODO: implement getAllLinkedAccounts
    throw Exception('Not imnplemented');
  }

  @override
  Future<List<User>> getAllLinkedAccounts() {
    // TODO: implement getAllLinkedAccounts
    throw Exception('Not imnplemented');
  }

  @override
  Future<void> switchToUserAccount() {
    // TODO: implement switchToUserAccount
    throw Exception('Not imnplemented');
  }

  @override
  Future<void> setUserType(UserType userType) {
    // TODO: implement setUserType
    throw Exception('Not imnplemented');
  }
}
