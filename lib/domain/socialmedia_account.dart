import 'dart:typed_data';



class SocialMediaAccount {
  final String displayName;

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
  });
}
