import 'package:inf/backend/backend.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class SocialMediaAccount {
  final String displayName;
  final SocialNetworkProvider socialNetWorkProvider;

  final String profileUrl;
  final String description;
  final String email;
  final String userId;
  final String pageId;

  final int audienceSize;
  final int postCount;

  final bool verified;

  final String accessToken;
  final String accessTokenSecret;
  final String refreshToken;

  SocialMediaAccount(
      {this.socialNetWorkProvider,
      this.displayName,
      this.userId,
      this.pageId,
      this.profileUrl,
      this.description,
      this.email,
      this.audienceSize,
      this.postCount,
      this.verified,
      this.accessToken,
      this.accessTokenSecret,
      this.refreshToken});

  SocialMediaAccount copyWith({
    int id,
    SocialNetworkProviderType type,
    SocialNetworkProvider socialNetWorkProvider,
    String displayName,
    String userId,
    String pageId,
    String profileUrl,
    String description,
    String email,
    int audienceSize,
    int postsCount,
    bool verified,
    String accessToken,
    String accessTokenSecret,
    String refreshToken,
  }) {
    return SocialMediaAccount(
      socialNetWorkProvider: socialNetWorkProvider ?? this.socialNetWorkProvider,
      displayName: displayName ?? this.displayName,
      userId: userId ?? this.userId,
      pageId: pageId ?? this.pageId,
      profileUrl: profileUrl ?? this.profileUrl,
      description: description ?? this.description,
      email: email ?? this.email,
      audienceSize: audienceSize ?? this.audienceSize,
      postCount: postsCount ?? this.postCount,
      accessToken: accessToken ?? this.accessToken,
      accessTokenSecret: accessTokenSecret ?? this.accessTokenSecret,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  static SocialMediaAccount fromDto(SocialMediaAccountDto dto) {
    return SocialMediaAccount(
      socialNetWorkProvider: backend.get<ConfigService>().getSocialNetworkProviderById(
            dto.socialNetworkProviderId,
          ),
      displayName: dto.displayName,
      userId: dto.userId,
      pageId: dto.pageId,
      profileUrl: dto.profileUrl,
      description: dto.description,
      email: dto.email,
      audienceSize: dto.audienceSize,
      postCount: dto.postCount,
      accessToken: dto.accessToken,
      accessTokenSecret: dto.accessTokenSecret,
      refreshToken: dto.refreshToken,
    );
  }

  SocialMediaAccountDto toDto() {
    assert(userId != null);
    assert(profileUrl != null);
    assert(socialNetWorkProvider != null);
    var dto = SocialMediaAccountDto()
      ..displayName = displayName ?? ''
      ..profileUrl = profileUrl
      ..userId = userId;

    if (pageId != null) {
      dto.pageId = pageId;
    }
    if (description != null) {
      dto.description = description;
    }
    if (email != null) {
      dto.email = email;
    }
    if (audienceSize != null) {
      dto.audienceSize = audienceSize;
    }
    if (postCount != null) {
      dto.postCount = postCount;
    }
    if (accessToken != null) {
      dto.accessToken = accessToken;
    }
    if (accessTokenSecret != null) {
      dto.accessTokenSecret = accessTokenSecret;
    }
    if (refreshToken != null) {
      dto.refreshToken = refreshToken;
    }

    dto.socialNetworkProviderId = socialNetWorkProvider.id;

    return dto;
  }

  String audienceSizeAsString() {
    if (audienceSize < 0) {
      return 'NA';
    }
    if (audienceSize < 1100) {
      return audienceSize.toString();
    }
    if (audienceSize < 1100000) {
      double doubleCount = audienceSize / 1000;
      return '${doubleCount.toStringAsFixed(1)}k';
    } else {
      double doubleCount = audienceSize / 1000000;
      return '${doubleCount.toStringAsFixed(1)}m';
    }
  }
}
