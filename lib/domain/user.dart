import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/socialmedia_account.dart';

import 'package:inf_common/inf_common.dart';
export 'package:inf_common/inf_common.dart';

class User {
  final Int64 id;
  final bool verified;
  final GlobalAccountState accountState;
  final GlobalAccountStateReason accountStateReason;
  final AccountType userType;
  final String name;
  final String description;
  final String email;
  final String websiteUrl;
  final bool acceptsDirectOffers;
  final bool showLocation;
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
    this.accountStateReason,
    this.userType,
    this.name,
    this.description,
    this.email,
    this.websiteUrl,
    this.showLocation,
    this.acceptsDirectOffers,
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

  User copyWith({
    Int64 id,
    bool verified,
    GlobalAccountState accountState,
    GlobalAccountStateReason accountStateReason,
    AccountType userType,
    String name,
    String description,
    String email,
    String websiteUrl,
    bool acceptsDirectOffers,
    bool showLocation,
    int accountCompletionInPercent,
    String locationAsString,
    Location location,
    String avatarThumbnailUrl,
    Uint8List avatarThumbnailLowRes,
    String avatarUrl,
    Uint8List avatarLowRes,
    List<Category> categories,
    List<SocialMediaAccount> socialMediaAccounts,
  }) {
    return User(
      id: id ?? this.id,
      verified: verified ?? this.verified,
      accountState: accountState ?? this.accountState,
      accountStateReason: accountStateReason ?? this.accountStateReason,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      showLocation: showLocation ?? this.showLocation,
      acceptsDirectOffers: acceptsDirectOffers ?? this.acceptsDirectOffers,
      accountCompletionInPercent: accountCompletionInPercent ?? this.accountCompletionInPercent,
      locationAsString: locationAsString ?? this.locationAsString,
      location: location ?? this.location,
      avatarThumbnailUrl: avatarThumbnailUrl ?? this.avatarThumbnailUrl,
      avatarThumbnailLowRes: avatarThumbnailLowRes ?? this.avatarThumbnailLowRes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarLowRes: avatarLowRes ?? this.avatarLowRes,
      categories: categories ?? this.categories,
      socialMediaAccounts: socialMediaAccounts ?? this.socialMediaAccounts,
    );
  }
}
