import 'dart:typed_data';

import 'package:inf/domain/social_network_provider.dart';

class SocialMediaAccount {
  final int id;
  final bool isActive;
  final String displayName;
  final SocialNetworkProvider socialNetWorkProvider;

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
    this.socialNetWorkProvider, 
    this.isActive,
    this.displayName,
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
    SocialNetworkProvider socialNetWorkProvider,
    String displayName,
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
      displayName: displayName ?? this.displayName,
      socialNetWorkProvider: socialNetWorkProvider ?? this.socialNetWorkProvider,
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
