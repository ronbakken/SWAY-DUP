import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/location.dart';
import 'package:inf/domain/money.dart';
import 'package:inf/domain/socialmedia_account.dart';
import 'package:inf_api_client/inf_api_client.dart';

export 'package:inf_api_client/inf_api_client.dart' show UserDto_Status, UserType;

class User {
  final UserDto_Data dataType;
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

  String get locationAsString => location?.name;

  User({
    this.dataType,
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
    UserDto_Data dataType,
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
      dataType: dataType ?? this.dataType,
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
    final dataType = dto.whichData();
    switch (dataType) {
      case UserDto_Data.handle:
        return User(
          dataType: dataType,
          id: dto.id,
          revision: dto.revision,
          accountState: dto.status,
          name: dto.handle.name,
          avatarThumbnail: ImageReference.fromImageDto(dto.handle.avatarThumbnail),
        );
      case UserDto_Data.list:
        return User(
          dataType: dataType,
          id: dto.id,
          revision: dto.revision,
          accountState: dto.status,
          name: dto.list.name,
          userType: dto.list.type,
          description: dto.list.description,
          showLocation: dto.list.showLocation,
          location: Location.fromDto(dto.list.location),
          avatarImage: ImageReference.fromImageDto(dto.list.avatar),
          avatarThumbnail: ImageReference.fromImageDto(dto.list.avatarThumbnail),
          categories: backend<ConfigService>().getCategoriesFromIds(dto.list.categoryIds),
          // FIXME dto.list.socialMediaProviderIds not used?
        );
      case UserDto_Data.full:
        return User(
          dataType: dataType,
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
          socialMediaAccounts: dto.full.socialMediaAccounts
              .map<SocialMediaAccount>(
                (dto) => SocialMediaAccount.fromDto(dto),
              )
              .toList(),
          registrationTokens: Set.from(dto.full.registrationTokens.where((token) => token != null)),
        );
      default:
        throw StateError('User ${dto.id} invalid data.');
    }
  }

  UserDto toDto() {
    final dto = UserDto()
      ..id = id ?? ""
      ..status = accountState
      ..revision = revision;
    switch (dataType) {
      case UserDto_Data.handle:
        dto.handle = UserDto_HandleDataDto()
          ..name = name
          ..avatarThumbnail = avatarThumbnail.toImageDto();
        break;
      case UserDto_Data.list:
        dto.list = UserDto_ListDataDto()
          ..name = name
          ..type = userType
          ..description = description
          ..showLocation = showLocation
          ..location = location.toDto()
          ..avatar = avatarImage.toImageDto()
          ..avatarThumbnail = avatarThumbnail.toImageDto()
          ..categoryIds.addAll(categories.map<String>((c) => c.id))
          ..socialMediaProviderIds.addAll(
            socialMediaAccounts.map<String>((account) => account.socialNetWorkProvider.id),
          );
        break;
      case UserDto_Data.full:
      default:
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
        dto.full = (UserDto_FullDataDto()
          ..isVerified = verified ?? false
          ..type = userType
          ..name = name
          ..description = description
          ..email = email
          ..acceptsDirectOffers = acceptsDirectOffers ?? false
          ..location = location.toDto()
          ..showLocation = showLocation ?? false
          ..accountCompletionInPercent = accountCompletionInPercent ?? -1
          ..avatarThumbnail = avatarThumbnail.toImageDto()
          ..avatar = avatarImage.toImageDto()
          ..categoryIds.addAll(categories.map<String>((c) => c.id))
          ..minimalFee = minimalFee.toDto() ?? Money.zero
          ..websiteUrl = websiteUrl ?? ''
          ..socialMediaAccounts.addAll(
            socialMediaAccounts.map<SocialMediaAccountDto>((a) => a.toDto()),
          )
          ..registrationTokens.addAll(registrationTokens));
        break;
    }
    return dto;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is User &&
        runtimeType == other.runtimeType &&
        id == other.id;

  @override
  int get hashCode => id.hashCode;
}
