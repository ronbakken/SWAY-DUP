import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/location.dart';
import 'package:rxdart/rxdart.dart';

import 'package:inf/backend/services/auth_service_.dart';

class SocialNetworkProviderMock extends SocialNetworkProvider {
  SocialNetworkProviderMock({
    int id,
    bool canAuthorizeUser,
    String name,
    Uint8List logoData,
    bool isVectorLogo,
  }) : super(id, canAuthorizeUser, name, logoData, isVectorLogo);
}

/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin
/// with a user he has never used before

class AuthenticationServiceMock implements AuthenticationService {
  bool isLoggedIn;
  UserType userType;
  SocialNetworkProvider provider;
  AccountState accountState;
  bool isVerified;
  int currentUser;

  List<User> allLinkedAccounts;
  List<SocialNetworkProviderMock> socialNetWorks;

  AuthenticationServiceMock({
    this.isLoggedIn,
    this.isVerified = true,
    this.accountState = AccountState.approved,
    this.currentUser = 0,
  }) {
    loadMockData().then((_) {
      if (isLoggedIn) {
        _loginStateSubject.add(AuthenticationResult(
            state: AuthenticationState.success,
            provider: socialNetWorks[2],
            user: allLinkedAccounts[currentUser]));
      } else {
        _loginStateSubject.add(AuthenticationResult(
          state: AuthenticationState.notLoggedIn,
        ));
      }
    });
  }

  @override
  Observable<AuthenticationResult> get loginState => _loginStateSubject;

  final _loginStateSubject = BehaviorSubject<AuthenticationResult>();

  @override
  Future<void> loginAnonymous(UserType userType) async {
    _loginStateSubject.add(AuthenticationResult(
      state: AuthenticationState.anonymous,
    ));
    this.userType = userType;
  }

  /// Returns the current authenticationstate independent of a state change
  @override
  Future<AuthenticationResult> getCurrentAuthenticationState() {
    if (isLoggedIn) {
      return Future.value(AuthenticationResult(
          state: AuthenticationState.success,
          provider: socialNetWorks[2],
          user: allLinkedAccounts[0]));
    } else {
      return Future.value(AuthenticationResult(
        state: AuthenticationState.notLoggedIn,
      ));
    }
  }

  void login() async {
    isLoggedIn = true;
    _loginStateSubject.add(AuthenticationResult(
        state: AuthenticationState.waitingForActivation,
        provider: provider,
        user: allLinkedAccounts[0]));
    await Future.delayed(Duration(seconds: 2));
    _loginStateSubject.add(AuthenticationResult(
        state: AuthenticationState.success,
        provider: provider,
        user: allLinkedAccounts[0]));
  }

  @override
  Future<List<SocialNetworkProvider>> getAvailableSocialNetworkProviders() {
    return Future.value(socialNetWorks);
  }

  @override
  Future<void> loginWithSocialNetWork(
      UserType userType, SocialNetworkProvider socialNetwork) {
    // TODO: implement loginWithSocialNetWork
    return null;
  }

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  @override
  Future<void> logOut() async {
    isLoggedIn = false;
    _loginStateSubject.add(AuthenticationResult(
      state: AuthenticationState.notLoggedIn,
    ));
  }

  @override
  Future<List<User>> getAllLinkedAccounts() async {
    // TODO: implement getAllLinkedAccounts
    return null;
  }

  @override
  Future<void> switchToUserAccount(User user) async {
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
          location: Location(
            id: 1,
            latitude: 34.050863,
            longitude: -118.272657,
            activeOfferCount: 0,
          ),
          verified: isVerified,
          websiteUrl: 'www.google.com',
          socialMediaAccounts: [
            SocialMediaAccount(
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            )
          ]),
      User(
          id: 43,
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
          location: Location(
            id: 1,
            latitude: 34.050863,
            longitude: -118.272657,
            activeOfferCount: 0,
          ),
          verified: isVerified,
          websiteUrl: 'www.google.com',
          socialMediaAccounts: [
            SocialMediaAccount(
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            )
          ]),
    ];
    socialNetWorks = [
      SocialNetworkProviderMock(
          id: 1,
          canAuthorizeUser: true,
          isVectorLogo: false,
          logoData: (await rootBundle.load('assets/images/logo_instagram.png'))
              .buffer
              .asUint8List(),
          name: 'Instagramm'),
      SocialNetworkProviderMock(
          id: 2,
          canAuthorizeUser: true,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_facebook.svg'))
              .buffer
              .asUint8List(),
          name: 'Instagramm'),
      SocialNetworkProviderMock(
          id: 3,
          canAuthorizeUser: true,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_twitter.svg'))
              .buffer
              .asUint8List(),
          name: 'Twitter'),
      SocialNetworkProviderMock(
          id: 4,
          canAuthorizeUser: true,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_google.svg'))
              .buffer
              .asUint8List(),
          name: 'Google'),
      SocialNetworkProviderMock(
          id: 5,
          canAuthorizeUser: false,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_google.svg'))
              .buffer
              .asUint8List(),
          name: 'Youtube'),
    ];
  }
}
