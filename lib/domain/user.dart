import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/socialmedia_account.dart';
import 'package:inf_api_client/inf_api_client.dart';

class User {
  final String id;
  final bool verified;
  final UserDto_Status accountState;
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
  final String avatarThumbnailLowResUrl;
  final String avatarUrl;
  final String avatarLowResUrl;
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
    this.avatarThumbnailLowResUrl,
    this.avatarUrl,
    this.avatarLowResUrl,
    this.categories,
    this.minimalFee,
    this.socialMediaAccounts,
  });

  User copyWith({
    String id,
    bool verified,
    UserDto_Status accountState,
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
    String avatarThumbnailLowResUrl,
    String avatarUrl,
    String avatarLowResUrl,
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
      avatarThumbnailLowResUrl: avatarThumbnailLowResUrl ?? this.avatarThumbnailLowResUrl,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarLowResUrl: avatarLowResUrl ?? this.avatarLowResUrl,
      categories: categories ?? this.categories,
      minimalFee: minimalFee ?? this.minimalFee,
      socialMediaAccounts: socialMediaAccounts ?? this.socialMediaAccounts,
    );
  }

  static User fromDto(UserDto dto) {
    return User(
      id: dto.id,
      accountState: dto.status,
      verified: dto.full.isVerified,
      userType: dto.full.type,
      name: dto.full.name,
      description: dto.full.description,
      email: dto.full.email,
      websiteUrl: dto.full.websiteUrl,
      acceptsDirectOffers: dto.full.acceptsDirectOffers,
      showLocation: dto.full.showLocation,
      accountCompletionInPercent: dto.full.accountCompletionInPercent,
      location: Location.fromDto(dto.full.location),
      avatarThumbnailUrl: dto.full.avatarThumbnail.url,
      avatarThumbnailLowResUrl: dto.full.avatarThumbnail.lowResUrl,
      avatarUrl: dto.full.avatar.url,
      avatarLowResUrl: dto.full.avatar.lowResUrl,
      categories: backend.get<ConfigService>().getCategoriesFromIds(dto.full.categoryIds),
      minimalFee: dto.full.minimalFee,
      socialMediaAccounts:
          dto.full.socialMediaAccounts.map<SocialMediaAccount>((dto) => SocialMediaAccount.fromDto(dto)).toList(),
    );
  }

  UserDto toDto() {
    var avatarThumbnailDto = ImageDto()
      ..url = avatarThumbnailUrl
      ..lowResUrl = avatarThumbnailLowResUrl;
    var avatarDto = ImageDto()
      ..url = avatarUrl
      ..lowResUrl = avatarLowResUrl;

    assert(accountState != null);
    assert(userType != null);
    assert(name != null);
    assert(description != null);
    assert(email != null);
    assert(location != null);
    assert(avatarThumbnailDto != null);
    assert(avatarDto != null);
    assert(categories != null);
    assert(socialMediaAccounts != null);

    var dto = UserDto()
      ..id = id ?? ""
        ..status = accountState
      ..full = (UserDto_FullDataDto()
        ..isVerified = verified ?? false
        ..type = userType
        ..name = name
        ..description = description
        ..email = email
        ..acceptsDirectOffers = acceptsDirectOffers ?? false
        ..location = location.toDto()
        ..showLocation = showLocation ?? false
        ..accountCompletionInPercent = accountCompletionInPercent ?? -1
        ..avatarThumbnail = avatarThumbnailDto
        ..avatar = avatarDto
        ..categoryIds.addAll(categories.map<String>((c) => c.id))
        ..minimalFee = minimalFee ?? 0
        ..websiteUrl = websiteUrl ?? ''
        ..socialMediaAccounts.addAll(
          socialMediaAccounts.map<SocialMediaAccountDto>((a) => a.toDto()),
        ));

    return dto;
  }
}
