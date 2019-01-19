
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class SocialMediaAccount {
  final int id;
  final String displayName;
  final SocialNetworkProvider socialNetWorkProvider;
  final SocialNetworkProviderType type;

  final String profileUrl;
  final String description;
  final String email;
  final String userId;

  final int audienceSize;
  final int postsCount;

  final bool verified;

  final String accessToken;
  final String accessTokenSecret;
  final String refreshToken;

  SocialMediaAccount(
      {this.id,
      this.type,
      this.socialNetWorkProvider,
      this.displayName,
      this.userId,
      this.profileUrl,
      this.description,
      this.email,
      this.audienceSize,
      this.postsCount,
      this.verified,
      this.accessToken,
      this.accessTokenSecret,
      this.refreshToken})
      : assert(id != null);

  SocialMediaAccount copyWith({
    int id,
    SocialNetworkProviderType type,
    SocialNetworkProvider socialNetWorkProvider,
    String displayName,
    String userId,
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
      id: id ?? this.id,
      type: type ?? this.type,
      socialNetWorkProvider: socialNetWorkProvider ?? this.socialNetWorkProvider,
      displayName: displayName ?? this.displayName,
      userId: userId ?? this.userId,
      profileUrl: profileUrl ?? this.profileUrl,
      description: description ?? this.description,
      email: email ?? this.email,
      audienceSize: audienceSize ?? this.audienceSize,
      postsCount: postsCount ?? this.postsCount,
      accessToken: accessToken ?? this.accessToken,
      accessTokenSecret: accessTokenSecret ?? this.accessTokenSecret,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  static SocialMediaAccount fromDto(SocialMediaAccountDto dto) {
    return SocialMediaAccount(
      id: dto.id,
      type: dto.type,
      socialNetWorkProvider: backend.get<ConfigService>().getSocialNetworkProviderById(
            dto.socialNetworkProviderId,
          ),
      displayName: dto.displayName,
      userId: dto.userId,
      profileUrl: dto.profileUrl,
      description: dto.description,
      email: dto.email,
      audienceSize: dto.audienceSize,
      postsCount: dto.postsCount,
      accessToken: dto.accessToken,
      accessTokenSecret: dto.accessTokenSecret,
      refreshToken: dto.refreshToken,
    );
  }
}
