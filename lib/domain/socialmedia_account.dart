import 'dart:typed_data';

class SocialMediaAccount {
  final int id;
  final bool isActive;
  final String channelName;
  final String displayName;
  final Uint8List logoData;
  final bool isVectorLogo;

  /* Further info. May have null values. Most data isn't always shared. */
  /// Url to the actual social media profile
  final String avatarUrl;
  final Uint8List avatarLowRes;
  final String profileUrl;
  final String description;
  final String location;
  final String url;
  final String email;

  /* Use the largest of either friendsCount or followersCount for boasting. */
  final int friendsCount;
  final int followersCount;
  final int followingCount;

  final int postsCount;

  final bool verified;

  SocialMediaAccount({
    this.id,
    this.isActive,
    this.channelName,
    this.displayName,
    this.logoData,
    this.isVectorLogo,
    this.avatarUrl,
    this.avatarLowRes,
    this.profileUrl,
    this.description,
    this.location,
    this.url,
    this.email,
    this.friendsCount,
    this.followersCount,
    this.followingCount,
    this.postsCount,
    this.verified,
  }):assert(id != null);

  SocialMediaAccount copyWith({
    int id,
    bool isActive,
    String channelName,
    String displayName,
    Uint8List logoData,
    bool isVectorLogo,
    String avatarUrl,
    Uint8List avatarLowRes,
    String profileUrl,
    String description,
    String location,
    String url,
    String email,
    int friendsCount,
    int followersCount,
    int followingCount,
    int postsCount,
    bool verified,
  }) {
    return SocialMediaAccount(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      channelName: channelName ?? this.channelName,
      displayName: displayName ?? this.displayName,
      logoData: logoData ?? this.logoData,
      isVectorLogo: isVectorLogo ?? this.isVectorLogo,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarLowRes: avatarLowRes ?? this.avatarLowRes,
      profileUrl: profileUrl ?? this.profileUrl,
      description: description ?? this.description,
      location: location ?? this.location,
      url: url ?? this.url,
      email: email ?? this.email,
      friendsCount: friendsCount ?? this.friendsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      verified: verified ?? this.verified,
    );
  }
}
