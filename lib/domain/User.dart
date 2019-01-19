import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/socialmedia_account.dart';
import 'package:inf_api_client/inf_api_client.dart';

class User {
  final int id;
  final bool verified;
  final AccountState accountState;
  final UserType userType;
  final String name;
  final String description;
  final String email;
  final String websiteUrl;
  final bool acceptsDirectOffers;
  final bool showLocation;
  final int accountCompletionInPercent;
  final Location location;
  final String avatarThumbnailUrl;
  final Uint8List avatarThumbnailLowRes;
  final String avatarUrl;
  final Uint8List avatarLowRes;
  final List<Category> categories;
  final int minimalFee;
  final List<SocialMediaAccount> socialMediaAccounts;

  String get locationAsString => location.name;

  User({
    this.id,
    this.verified,
    this.accountState,
    this.userType,
    this.name,
    this.description,
    this.email,
    this.websiteUrl,
    this.acceptsDirectOffers,
    this.showLocation,
    this.accountCompletionInPercent,
    this.location,
    this.avatarThumbnailUrl,
    this.avatarThumbnailLowRes,
    this.avatarUrl,
    this.avatarLowRes,
    this.categories,
    this.minimalFee,
    this.socialMediaAccounts,
  });

  User copyWith({
    int id,
    bool verified,
    AccountState accountState,
    UserType userType,
    String name,
    String description,
    String email,
    String websiteUrl,
    bool acceptsDirectOffers,
    bool showLocation,
    int accountCompletionInPercent,
    Location location,
    String avatarThumbnailUrl,
    Uint8List avatarThumbnailLowRes,
    String avatarUrl,
    Uint8List avatarLowRes,
    List<Category> categories,
    int minimalFee,
    List<SocialMediaAccount> socialMediaAccounts,
  }) {
    return User(
      id: id ?? this.id,
      verified: verified ?? this.verified,
      accountState: accountState ?? this.accountState,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      acceptsDirectOffers: acceptsDirectOffers ?? this.acceptsDirectOffers,
      showLocation: showLocation ?? this.showLocation,
      accountCompletionInPercent: accountCompletionInPercent ?? this.accountCompletionInPercent,
      location: location ?? this.location,
      avatarThumbnailUrl: avatarThumbnailUrl ?? this.avatarThumbnailUrl,
      avatarThumbnailLowRes: avatarThumbnailLowRes ?? this.avatarThumbnailLowRes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarLowRes: avatarLowRes ?? this.avatarLowRes,
      categories: categories ?? this.categories,
      minimalFee: minimalFee ?? this.minimalFee,
      socialMediaAccounts: socialMediaAccounts ?? this.socialMediaAccounts,
    );
  }

  static User fromDto(UserDto dto) {
    return User(
      id: dto.id,
      verified: dto.verified,
      accountState: dto.accountState,
      userType: dto.userType,
      name: dto.name,
      description: dto.description,
      email: dto.email,
      websiteUrl: dto.websiteUrl,
      acceptsDirectOffers: dto.acceptsDirectOffers,
      showLocation: dto.showLocation,
      accountCompletionInPercent: dto.accountCompletionInPercent,
      location: Location(dto.location),
      avatarThumbnailUrl: dto.avatarThumbnailUrl,
      avatarThumbnailLowRes: dto.avatarThumbnailLowRes,
      avatarUrl: dto.avatarUrl,
      avatarLowRes: dto.avatarLowRes,
      categories: backend.get<ConfigService>().getCategoriesFromIds(dto.categoriesIds),
      minimalFee: dto.minimalFee,
      socialMediaAccounts:
          dto.socialMediaAccounts.map<SocialMediaAccount>((dto) => SocialMediaAccount.fromDto(dto)).toList(),
    );
  }
}
