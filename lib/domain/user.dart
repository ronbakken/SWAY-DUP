import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/money.dart';
import 'package:inf/domain/socialmedia_account.dart';
import 'package:inf_api_client/inf_api_client.dart';

class User {
  final String id;
  final bool verified;
  final int revision;
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
  final ImageReference avatarThumbnail;
  final ImageReference avatarImage;
  final List<Category> categories;
  final Money minimalFee;
  final List<SocialMediaAccount> socialMediaAccounts;
  final Set<String> registrationTokens;

  String get locationAsString => location.name;

  User({
    this.id = '',
    this.revision = 0,
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
    this.avatarThumbnail,
    this.avatarImage,
    this.categories,
    this.minimalFee,
    this.socialMediaAccounts,
    this.registrationTokens,
  });

  User copyWith({
    String id,
    bool verified,
    int revision,
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
    ImageReference avatarThumbnail,
    ImageReference avatarImage,
    List<Category> categories,
    Money minimalFee,
    List<SocialMediaAccount> socialMediaAccounts,
    Set<String> registrationTokens,
  }) {
    return User(
      id: id ?? this.id,
      revision: revision ?? this.revision,
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
      avatarThumbnail: avatarThumbnail ?? this.avatarThumbnail,
      avatarImage: avatarImage ?? this.avatarImage,
      categories: categories ?? this.categories,
      minimalFee: minimalFee ?? this.minimalFee,
      socialMediaAccounts: socialMediaAccounts ?? this.socialMediaAccounts,
      registrationTokens: registrationTokens ?? this.registrationTokens,
    );
  }

  static User fromDto(UserDto dto) {
    return User(
      id: dto.id,
      revision: dto.revision,
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
      avatarThumbnail: ImageReference.fromImageDto(dto.full.avatarThumbnail),
      avatarImage: ImageReference.fromImageDto(dto.full.avatar),
      categories: backend<ConfigService>().getCategoriesFromIds(dto.full.categoryIds),
      minimalFee: Money.fromDto(dto.full.minimalFee),
      socialMediaAccounts:
          dto.full.socialMediaAccounts.map<SocialMediaAccount>((dto) => SocialMediaAccount.fromDto(dto)).toList(),
      registrationTokens: Set.from(dto.full.registrationTokens.where((token) => token != null)),
    );
  }

  UserDto toDto() {
    assert(accountState != null);
    assert(userType != null);
    assert(name != null);
    assert(description != null);
    assert(email != null);
    assert(location != null);
    assert(avatarThumbnail != null);
    assert(avatarImage != null);
    assert(categories != null);
    assert(socialMediaAccounts != null);
    assert(registrationTokens != null);

    var dto = UserDto()
      ..id = id ?? ""
      ..status = accountState
      ..revision = revision
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
        ..avatarThumbnail = avatarThumbnail.toDto()
        ..avatar = avatarImage.toDto()
        ..categoryIds.addAll(categories.map<String>((c) => c.id))
        ..minimalFee = minimalFee.toDto() ?? Money.fromInt(0)
        ..websiteUrl = websiteUrl ?? ''
        ..socialMediaAccounts.addAll(
          socialMediaAccounts.map<SocialMediaAccountDto>((a) => a.toDto()),
        )
        ..registrationTokens.addAll(registrationTokens));

    return dto;
  }
}
