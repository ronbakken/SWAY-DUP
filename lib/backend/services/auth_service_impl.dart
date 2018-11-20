import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationServiceImplementation implements AuthenticationService {
  @override
  Observable<AuthenticationResult> get loginState => null;

  @override
  Future<AuthenticationResult> getCurrentAuthenticationState() {
    throw Exception('Not imnplemented');
  }



  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  @override
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
  Future<void> switchToUserAccount(User user) {
    // TODO: implement switchToUserAccount
    throw Exception('Not imnplemented');
  }

  @override
  Future<void> loginAnonymous(UserType userType) {
    // TODO: implement setUserType
    throw Exception('Not imnplemented');
  }

  @override
  Future<List<SocialNetworkProvider>> getAvailableSocialNetworkProviders() {
    // TODO: implement getAvailableSocialNetworkProviders
    throw Exception('Not imnplemented');
  }

  @override
  Future<void> loginWithSocialNetWork(UserType userType, SocialNetworkProvider socialNetwork) {
    // TODO: implement loginWithSocialNetWork
    throw Exception('Not imnplemented');
  }
}
