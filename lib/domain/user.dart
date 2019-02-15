import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/socialmedia_account.dart';
import 'package:inf_api_client/inf_api_client.dart';

class User {
  final String id;
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
    String id,
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
      location: Location.fromDto(dto.location),
      avatarThumbnailUrl: dto.avatarThumbnail.url,
      avatarThumbnailLowRes: Uint8List.fromList(dto.avatarThumbnail.lowResData),
      avatarUrl: dto.avatar.url,
      avatarLowRes: Uint8List.fromList(dto.avatar.lowResData),
      categories: backend.get<ConfigService>().getCategoriesFromIds(dto.categoryIds),
      minimalFee: dto.minimalFee,
      socialMediaAccounts:
          dto.socialMediaAccounts.map<SocialMediaAccount>((dto) => SocialMediaAccount.fromDto(dto)).toList(),
    );
  }

  UserDto toDto() {
    var avatarThumbnailDto = ImageDto()
      ..url = avatarThumbnailUrl
      ..lowResData = avatarThumbnailLowRes;
    var avatarDto = ImageDto()
      ..url = avatarUrl
      ..lowResData = avatarLowRes;

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
<<<<<<< HEAD:lib/domain/User.dart
      ..id = id ?? ""
=======
      ..id = id
>>>>>>> Minor cleanup during create user account bug resolution.:lib/domain/user.dart
      ..verified = verified ?? false
      ..accountState = accountState
      ..userType = userType
      ..name = name
      ..description = description
      ..email = email
      ..acceptsDirectOffers = acceptsDirectOffers ?? false
      ..location = location.toDto()
      ..showLocation = showLocation ?? false
      ..accountCompletionInPercent = accountCompletionInPercent ?? -1
      ..avatarThumbnail = avatarThumbnailDto
      ..avatar = avatarDto
      ..categoryIds.addAll(categories.map<int>((c) => c.id))
      ..minimalFee = minimalFee ?? 0
      ..websiteUrl = websiteUrl ?? ''
      ..socialMediaAccounts.addAll(socialMediaAccounts.map<SocialMediaAccountDto>((a) => a.toDto()));


      return dto;
  }
}
