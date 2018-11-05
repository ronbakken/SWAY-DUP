import 'package:flutter/services.dart' show rootBundle;
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/location.dart';
import 'package:rxdart/rxdart.dart';

import 'package:inf/backend/services/auth_service_.dart';

/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin
/// with a user he has never used before

class AuthenticationServiceMock implements AuthenticationService {
  bool isLoggedIn;
  UserType userType;
  AuthenticationProvider provider;
  AccountState accountState;
  bool isVerified;
  int currentUser;

  List<User> allLinkedAccounts;

  AuthenticationServiceMock({
    this.isLoggedIn,
    this.isVerified = true,
    this.accountState = AccountState.approved,
    this.currentUser = 0,
  }) {
    loadMockData().then((_) {
      if (isLoggedIn) {
        _loginStateSubject.add(new AuthenticationResult(
            AuthenticationState.success,
            provider: AuthenticationProvider.twitter,
            user: allLinkedAccounts[currentUser]));
      } else {
        _loginStateSubject.add(new AuthenticationResult(
          AuthenticationState.notLoggedIn,
        ));
      }
    });
  }

  @override
  Observable<AuthenticationResult> get loginState => _loginStateSubject;

  BehaviorSubject<AuthenticationResult> _loginStateSubject =
      new BehaviorSubject<AuthenticationResult>();

  @override
  Future<void> loginAnonymous(UserType userType) async {
    _loginStateSubject.add(new AuthenticationResult(AuthenticationState.anonymous,));
    this.userType = userType;
  }

  /// Returns the current authenticationstate independent od a state change
  @override
  Future<AuthenticationResult> getCurrentAuthenticationState() {
    if (isLoggedIn) {
      return Future.value(new AuthenticationResult(AuthenticationState.success,
          provider: AuthenticationProvider.twitter,
          user: allLinkedAccounts[0]));
    } else {
      return Future.value(new AuthenticationResult(
        AuthenticationState.notLoggedIn,
      ));
    }
  }

  @override
  Future<void> loginWithGoogle(UserType userType) async {
    provider = AuthenticationProvider.google;
    login();
    return Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Future<void> loginWithFacebook(UserType userType) async {
    provider = AuthenticationProvider.facebook;
    login();
    return Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Future<void> loginWithTwitter(UserType userType) async {
    provider = AuthenticationProvider.twitter;
    login();
    return Future.delayed(Duration(milliseconds: 100));
  }

  @override
  Future<void> loginWithInstagram(UserType userType) async {
    provider = AuthenticationProvider.instagram;
    login();
    return Future.delayed(Duration(milliseconds: 100));
  }

  void login() async {
    isLoggedIn = true;
    _loginStateSubject.add(new AuthenticationResult(AuthenticationState.waitingForActivation,
        provider: provider, user: allLinkedAccounts[0]));
    await Future.delayed(Duration(seconds: 2));
    _loginStateSubject.add(new AuthenticationResult(AuthenticationState.success,
        provider: provider, user: allLinkedAccounts[0]));
  }

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  Future<void> logOut() async {
    isLoggedIn = false;
    _loginStateSubject.add(new AuthenticationResult(
      AuthenticationState.notLoggedIn,
    ));
  }

  @override
  Future<List<User>> getAllLinkedAccounts() {
    // TODO: implement getAllLinkedAccounts
  }

  @override
  Future<void> switchToUserAccount() {
    // TODO: implement switchToUserAccount
  }

  Future<void> loadMockData() async {
    allLinkedAccounts = [
      User(
          id: 42,
          name: 'Thomas',
          userType: UserType.business,
          avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile.jpg?alt=media&token=87b8bfea-2353-47bd-815c-0618efebe3f1',
          avatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          avatarThumbnailLowRes: (await rootBundle
                  .load('assets/mockdata/profile_thumbnail_lowres.jpg'))
              .buffer
              .asUint8List(),
          avatarLowRes:
              (await rootBundle.load('assets/mockdata/profile_lowres.jpg'))
                  .buffer
                  .asUint8List(),
          accountState: accountState,
          categories: [
            Category(
                id: 1,
                name: 'Food',
                description: 'All about Fashion',
                parentId: 0)
          ],
          description: 'I run a online store for baking utilities',
          email: 'thomas@burkharts.net',
          locationAsString: 'Germany',
          location: new Location(
            id: 1,
            latitude: 34.050863,
            longitude: -118.272657,
            activeOfferCount: 0,
          ),
          verified: isVerified,
          websiteUrl: 'www.google.com',
          socialMediaAccounts: [
            new SocialMediaAccount(
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            )
          ]),
      User(
          id: 42,
          name: 'Thomas',
          userType: UserType.influcencer,
          avatarUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile.jpg?alt=media&token=87b8bfea-2353-47bd-815c-0618efebe3f1',
          avatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          avatarThumbnailLowRes: (await rootBundle
                  .load('assets/mockdata/profile_thumbnail_lowres.jpg'))
              .buffer
              .asUint8List(),
          avatarLowRes:
              (await rootBundle.load('assets/mockdata/profile_lowres.jpg'))
                  .buffer
                  .asUint8List(),
          accountState: accountState,
          categories: [
            Category(
                id: 1,
                name: 'Food',
                description: 'All about Fashion',
                parentId: 0)
          ],
          description: 'I run a online store for baking utilities',
          email: 'thomas@burkharts.net',
          locationAsString: 'Germany',
          location: new Location(
            id: 1,
            latitude: 34.050863,
            longitude: -118.272657,
            activeOfferCount: 0,
          ),
          verified: isVerified,
          websiteUrl: 'www.google.com',
          socialMediaAccounts: [
            new SocialMediaAccount(
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            )
          ]),    ];
  }
}
