import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/network_generic/multi_account_client.dart';
import 'package:rxdart/rxdart.dart';

import 'package:inf/backend/services/auth_service_.dart';

/// Keep in mind
/// Save latest provider and login and warn user if he tries to signin
/// with a user he has never used before

class AuthenticationServiceMock implements AuthenticationService {
  bool isLoggedIn;
  AccountType userType;
  SocialNetworkProvider provider;
  GlobalAccountStateReason accountState;
  bool isVerified;
  int currentUser;

  List<User> allLinkedAccounts;
  List<SocialNetworkProvider> socialNetWorks;

  AuthenticationServiceMock({
    this.isLoggedIn,
    this.isVerified = true,
    this.accountState = GlobalAccountStateReason.approved,
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
  Future<void> loginAnonymous(AccountType userType) async {
    _loginStateSubject.add(AuthenticationResult(
      state: AuthenticationState.anonymous,
    ));
    this.userType = userType;
  }

  /// Returns the current authenticationstate independent of a state change
  @override
  AuthenticationResult getCurrentAuthenticationState() {
    if (isLoggedIn) {
      return AuthenticationResult(
          state: AuthenticationState.success,
          provider: socialNetWorks[2],
          user: allLinkedAccounts[0]);
    } else {
      return AuthenticationResult(
        state: AuthenticationState.notLoggedIn,
      );
    }
  }

  void login(AccountType userType) async {
    isLoggedIn = true;
    _loginStateSubject.add(AuthenticationResult(
        state: AuthenticationState.waitingForActivation,
        provider: provider,
        user: allLinkedAccounts[0]));
    await Future.delayed(Duration(seconds: 2));
    _loginStateSubject.add(AuthenticationResult(
        state: AuthenticationState.success,
        provider: provider,
        user: userType == AccountType.influencer ? allLinkedAccounts[1] : allLinkedAccounts[0]));
  }

  @override
  Future<List<SocialNetworkProvider>> getAvailableSocialNetworkProviders() {
    return Future.value(socialNetWorks);
  }

  @override
  Future<void> loginWithSocialNetWork(
      BuildContext context, // Since this function is expecting UI to pop up...
      AccountType userType,
      SocialNetworkProvider socialNetwork) {
    // TODO: implement loginWithSocialNetWork
    login(userType);
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
  Observable<List<LocalAccountData>> get linkedAccounts {
    // TODO: implement getAllLinkedAccounts
    return Observable<List<LocalAccountData>>.empty();
  }

  @override
  Future<void> switchToUserAccount(LocalAccountData user) async {
    // TODO: implement switchToUserAccount
  }

  Future<void> loadMockData() async {
    allLinkedAccounts = [
      User(
          id: new Int64(42),
          name: 'Thomas',
          userType: AccountType.business,
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
          accountStateReason: accountState,
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
              channelName: 'Twitter',
              logoData:  (await rootBundle.load('assets/mockdata/social_media_icons/logo_twitter_monochrome.svg'))
                  .buffer
                  .asUint8List(),
                  isVectorLogo: true,
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            )
          ]),
      User(
          id: new Int64(43),
          name: 'Thomas',
          userType: AccountType.influencer,
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
          accountStateReason: accountState,
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
              isActive: true,
              channelName: 'Twitter',
              logoData:  (await rootBundle.load('assets/mockdata/social_media_icons/logo_twitter_monochrome.svg'))
                  .buffer
                  .asUint8List(),
                  isVectorLogo: true,
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            ),
            SocialMediaAccount(
              isActive: false,
              channelName: 'Facebook',
              logoData:  (await rootBundle.load('assets/mockdata/social_media_icons/logo_facebook_monochrome.svg'))
                  .buffer
                  .asUint8List(),
                  isVectorLogo: true,
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            ),
            SocialMediaAccount(
              isActive: true,
              channelName: 'Youtube',
              logoData:  (await rootBundle.load('assets/mockdata/social_media_icons/logo_youtube_monochrome.svg'))
                  .buffer
                  .asUint8List(),
                  isVectorLogo: true,
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            ),
          ]),
    ];
    socialNetWorks = [
      SocialNetworkProvider(
          id: 1,
          canAuthorizeUser: true,
          isVectorLogo: false,
          logoData: (await rootBundle.load('assets/images/logo_instagram.png'))
              .buffer
              .asUint8List(),
          name: 'Instagramm'),
      SocialNetworkProvider(
          id: 2,
          canAuthorizeUser: true,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_facebook.svg'))
              .buffer
              .asUint8List(),
          name: 'Instagramm'),
      SocialNetworkProvider(
          id: 3,
          canAuthorizeUser: true,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_twitter.svg'))
              .buffer
              .asUint8List(),
          name: 'Twitter'),
      SocialNetworkProvider(
          id: 4,
          canAuthorizeUser: true,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_google.svg'))
              .buffer
              .asUint8List(),
          name: 'Google'),
      SocialNetworkProvider(
          id: 5,
          canAuthorizeUser: false,
          isVectorLogo: true,
          logoData: (await rootBundle.load('assets/images/logo_google.svg'))
              .buffer
              .asUint8List(),
          name: 'Youtube'),
    ];
  }

  @override
  Observable<User> getPublicProfile(Int64 accountId) {
    // TODO: implement getPublicProfile
    return null;
  }
}
