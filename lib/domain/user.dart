import 'dart:typed_data';

import 'package:inf/domain/category.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/socialmedia_account.dart';

enum UserType {
  influcencer,
  business,
  support,
  manager,
}

enum AccountState {
  newAccount, // User is a new account
  banned, // User is disallowed from the service
  createdDenied, // User account creation request was denied. Contact support
  approved, // User account was approved
  demoapproved, // User account was automatically approved for demonstration purpose
  pending, // User account approval is pending
  requiresInfo, // More information is required from the user to approve their account
}

class User {
  final int id;
  final bool verified;
  final AccountState accountState;
  final UserType userType;
  final String name;
  final String description;
  final String email;
  final String websiteUrl;
  final int accountCompletionInPercent;

  final String locationAsString;
  final Location location;
  final String avatarThumbnailUrl;
  final Uint8List avatarThumbnailLowRes;
  final String avatarUrl;
  final Uint8List avatarLowRes;

  final List<Category> categories;

  final List<SocialMediaAccount> socialMediaAccounts;

  bool get profileIsComplete => accountCompletionInPercent == 100;


  User({
    this.id,
    this.verified,
    this.accountState,
    this.userType,
    this.name,
    this.description,
    this.email,
    this.websiteUrl,
    this.accountCompletionInPercent,
    this.locationAsString,
    this.location,
    this.avatarThumbnailUrl,
    this.avatarThumbnailLowRes,
    this.avatarUrl,
    this.avatarLowRes,
    this.categories,
    this.socialMediaAccounts,
  });
}
