import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/social_network_provider.dart';
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
  int currentUserIndex;

  final BehaviorSubject<User> _currentUserSubject = BehaviorSubject<User>();

  @override
  Observable<User> get currentUser => _currentUserSubject;
  User _currentUser;

  List<User> allLinkedAccounts;

  AuthenticationServiceMock({
    this.isLoggedIn,
    this.isVerified = true,
    this.accountState = GlobalAccountStateReason.approved,
    this.currentUserIndex = 0,
  });

  @override
  Future<void> init() async {
    await loadMockData();
    if (isLoggedIn) {
      _loginStateSubject.add(AuthenticationResult(
          state: AuthenticationState.success,
          provider: backend.get<ResourceService>().socialNetworkProviders[2],
          user: allLinkedAccounts[currentUserIndex]));
    } else {
      _loginStateSubject.add(AuthenticationResult(
        state: AuthenticationState.notLoggedIn,
      ));
    }

    loginState.listen((state) {
      if (state.state == AuthenticationState.success) {
        _currentUserSubject.add(state.user);
        _currentUser = state.user;
      } else {
        _currentUserSubject.add(null);
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
          provider: backend.get<ResourceService>().socialNetworkProviders[2],
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
        user: userType == AccountType.influencer
            ? allLinkedAccounts[1]
            : allLinkedAccounts[0]));
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
    var socialNetWorks = backend.get<ResourceService>().socialNetworkProviders;
    allLinkedAccounts = [
      User(
          id: new Int64(42),
          showLocation: true,
          acceptsDirectOffers: true,
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
              id: 1,
              isActive: true,
              socialNetWorkProvider: socialNetWorks[0],
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            )
          ]),
      User(
          id: new Int64(43),
          name: 'Thomas',
          showLocation: true,
          acceptsDirectOffers: true,
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
              id: 1,
              isActive: true,
              socialNetWorkProvider: socialNetWorks[0],
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            ),
            SocialMediaAccount(
              id: 2,
              isActive: false,
              socialNetWorkProvider: socialNetWorks[1],
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            ),
            SocialMediaAccount(
              id: 3,
              isActive: true,
              socialNetWorkProvider: socialNetWorks[2],
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            ),
            SocialMediaAccount(
              id: 4,
              isActive: true,
              socialNetWorkProvider: socialNetWorks[4],
              url: 'https://twitter.com/ThomasBurkhartB',
              displayName: 'Thomas Burkhart',
              description: 'The best online shop for baking',
              followersCount: 900,
            ),
          ]),
    ];
  }

  @override
  Observable<User> getPublicProfile(Int64 accountId) {
    // TODO: implement getPublicProfile
    return null;
  }

  @override
  Future<void> updateSocialMediaAccount(SocialMediaAccount socialMedia) async {
    var socialMediaAccounts = _currentUser.socialMediaAccounts;
    var updatedAccounts = <SocialMediaAccount>[];
    for (var account in socialMediaAccounts) {
      if (account.id == socialMedia.id) {
        updatedAccounts.add(socialMedia);
      } else {
        updatedAccounts.add(account);
      }
      _currentUser =
          _currentUser.copyWith(socialMediaAccounts: updatedAccounts);
      _currentUserSubject.add(_currentUser);
    }
  }

  @override
  Future<void> updateUser(User user) async {
    _currentUserSubject.add(user);
  }
}
