import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/location.dart';
import 'package:inf_api_client/inf_api_client.dart';

import 'package:rxdart/rxdart.dart';

import 'package:inf/backend/services/auth_service_.dart';

class AuthenticationServiceMock implements AuthenticationService {
  bool isLoggedIn;
  UserType userType;
  SocialNetworkProvider provider;
  AccountState accountState;
  bool isVerified;
  int currentUserIndex;

  @override
  Observable<User> get currentUserUpdates => _currentUserUpdatesSubject;

  final BehaviorSubject<User> _currentUserUpdatesSubject = BehaviorSubject<User>();

  @override
  User get currentUser => _currentUser;
  User _currentUser;

  List<User> allLinkedAccounts;

  AuthenticationServiceMock({
    this.isLoggedIn,
    this.isVerified = true,
    this.accountState = AccountState.active,
    this.currentUserIndex = 0,
  });

  @override
  Future<void> init() async {
    await loadMockData();
  }

  @override
  Future<bool> loginUserWithToken() async {
    if (isLoggedIn) {
      _currentUser = allLinkedAccounts[currentUserIndex];
      _currentUserUpdatesSubject.add(_currentUser);
      return true;
    }
    return false;
  }

  /// After V1.0
  // Future<void> loginWithEmailPassword(String email, String password);

  // Future<AuthenticationResult> createNewUserByEmailPassword(String email, String password);

  // Future<void> sendPasswordResetMessage(String email);

  @override
  Future<void> logOut() async {
    isLoggedIn = false;
    _currentUser = null;
  }

  // @override
  // Observable<List<LocalAccountData>> get linkedAccounts {
  //   // TODO: implement getAllLinkedAccounts
  //   return Observable<List<LocalAccountData>>.empty();
  // }

  // @override
  // Future<void> switchToUserAccount(LocalAccountData user) async {
  //   // TODO: implement switchToUserAccount
  // }

  Future<void> loadMockData() async {
    allLinkedAccounts = [
      User()
        ..id = 42
        ..showLocation = true
        ..acceptsDirectOffers = true
        ..name = 'Thomas'
        ..userType = UserType.business
        ..avatarUrl =
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile.jpg?alt=media&token=87b8bfea-2353-47bd-815c-0618efebe3f1'
        ..avatarThumbnailUrl =
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741'
        ..avatarThumbnailLowRes =
            (await rootBundle.load('assets/mockdata/profile_thumbnail_lowres.jpg')).buffer.asUint8List()
        ..avatarLowRes = (await rootBundle.load('assets/mockdata/profile_lowres.jpg')).buffer.asUint8List()
        ..accountState = accountState
        ..categoriesIds.addAll([1, 2, 3])
        ..description = 'I run a online store for baking utilities'
        ..email = 'thomas@burkharts.net'
        ..locationAsString = 'Germany'
        // ..location: Location(
        //   id: 1
        //   latitude: 34.050863
        //   longitude: -118.272657
        //   activeOfferCount: 0
        // )
        ..verified = isVerified
        ..websiteUrl = 'www.google.com'
        ..socialMediaAccountIds.addAll([1]),
      User()
        ..id = 43
        ..name = 'Thomas'
        ..showLocation = true
        ..acceptsDirectOffers = true
        ..userType = UserType.influencer
        ..avatarUrl =
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile.jpg?alt=media&token=87b8bfea-2353-47bd-815c-0618efebe3f1'
        ..avatarThumbnailUrl =
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741'
        ..avatarThumbnailLowRes =
            (await rootBundle.load('assets/mockdata/profile_thumbnail_lowres.jpg')).buffer.asUint8List()
        ..avatarLowRes = (await rootBundle.load('assets/mockdata/profile_lowres.jpg')).buffer.asUint8List()
        ..accountState = accountState
        ..categoriesIds.addAll([1, 2, 3])
        ..description = 'I run a online store for baking utilities'
        ..email = 'thomas@burkharts.net'
        ..locationAsString = 'Germany'
        // ..location= Location(
        //   id= 1..
        //   latitude= 34.050863..
        //   longitude= -118.272657..
        //   activeOfferCount= 0..
        // )..
        ..verified = isVerified
        ..websiteUrl = 'www.google.com'
        ..socialMediaAccountIds.addAll([2,3,4,5]),
    ];
  }



  @override
  Future<void> updateSocialMediaAccount(SocialMediaAccount socialMedia) async {
    // TODO
    // var socialMediaAccounts = _currentUser.socialMediaAccounts;
    // var updatedAccounts = <SocialMediaAccount>[];
    // for (var account in socialMediaAccounts) {
    //   if (account.id == socialMedia.id) {
    //     updatedAccounts.add(socialMedia);
    //   } else {
    //     updatedAccounts.add(account);
    //   }
    //   _currentUser =
    //       _currentUser.copyWith(socialMediaAccounts: updatedAccounts);
    //   _currentUserSubject.add(_currentUser);
    // }
  }

  @override
  Future<void> updateUser(User user) async {
    _currentUserUpdatesSubject.add(user);
    _currentUser = user;
  }

  @override
  Observable<SocialMediaAccounts> getSocialMediaAccounts() {
      var socialMediaAccounts = <SocialMediaAccount> [
          SocialMediaAccount()
            ..id = 1
            ..isActive = true
            ..socialNetworkProviderId = 0
            ..url = 'https=//twitter.com/ThomasBurkhartB'
            ..displayName = 'Thomas Burkhart'
            ..description = 'The best online shop for baking'
            ..followersCount = 900,
          SocialMediaAccount()
            ..id = 2
            ..isActive = true
            ..socialNetworkProviderId = 0
            ..url = 'https://twitter.com/ThomasBurkhartB'
            ..displayName = 'Thomas Burkhart'
            ..description = 'The best online shop for baking'
            ..followersCount = 900,
          SocialMediaAccount()
            ..id = 3
            ..isActive = false
            ..socialNetworkProviderId = 1
            ..url = 'https://twitter.com/ThomasBurkhartB'
            ..displayName = 'Thomas Burkhart'
            ..description = 'The best online shop for baking'
            ..followersCount = 900,
          SocialMediaAccount()
            ..id = 4
            ..isActive = true
            ..socialNetworkProviderId = 2
            ..url = 'https://twitter.com/ThomasBurkhartB'
            ..displayName = 'Thomas Burkhart'
            ..description = 'The best online shop for baking'
            ..followersCount = 900,
          SocialMediaAccount()
            ..id = 5
            ..isActive = true
            ..socialNetworkProviderId = 4
            ..url = 'https://twitter.com/ThomasBurkhartB'
            ..displayName = 'Thomas Burkhart'
            ..description = 'The best online shop for baking'
            ..followersCount = 900

        ];
      
        var accounts = <SocialMediaAccount>[];
        for(var accountId in _currentUser.socialMediaAccountIds)
        {
            var account = socialMediaAccounts.firstWhere((a)  => a.id == accountId);
            if (account != null)
            {
              accounts.add(account);
            }
        }

        var accountsList = <SocialMediaAccounts>[]
          ..add(SocialMediaAccounts()
          ..accounts.addAll(accounts)
          ..accounts.addAll(accounts)
          );
        return Observable.fromIterable(accountsList);
  }
}
