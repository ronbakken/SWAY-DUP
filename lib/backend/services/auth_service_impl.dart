import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf_api_client/inf_api_client.dart';

import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart' as location;


// Authentication wrapper boilerplate
class AuthenticationServiceImplementation implements AuthenticationService {
  @override
  User get currentUser => _currentUser;
  User _currentUser;
 
  @override
  Observable<User> get currentUserUpdates => currentUserUpdatesObservable;

  BehaviorSubject<User> currentUserUpdatesObservable = BehaviorSubject<User>();

 @override
  Future<bool> loginUserWithToken() {
    // TODO: implement LoginUserWithToken
    return null;
  }

  @override
  Future<void> logOut() async {
    // TODO: Destroy this session server-side.
    // networkStreaming.multiAccount.removeAccount();
    // State will immediately change to notLoggedIn
  }

  // @override
  // Future<void> switchToUserAccount(LocalAccountData user) async {
  //   // networkStreaming.multiAccount
  //   //     .switchAccount(user.domain, user.accountId);
  //   // State will immediately change to notLoggedIn, then attempt to connect
  // }


  @override
  Future<void> updateUser(User user) {
    // TODO: implement updateUser
    return null;
  }

  @override
  Future<void> init() {
    // TODO: implement init
    return null;
  }

  @override
  Future<void> updateSocialMediaAccount(SocialMediaAccount socialMedia) {
    // TODO: implement updateSocialMediaAccount
    return null;
  }


}
