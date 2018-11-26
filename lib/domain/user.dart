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
