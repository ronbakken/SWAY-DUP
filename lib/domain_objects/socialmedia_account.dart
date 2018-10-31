import 'dart:typed_data';

class SocialMediaAccount {
  /// JAN: What does this mean?
  /// Social media is connected to the account
  bool connected;

  String displayName;
  
  /* Further info. May have null values. Most data isn't always shared. */
  /// Url to the actual social media profile
  String avatarUrl;
  Uint8List avatarLowRes;
  String profileUrl;
  String description;
  String location;
  String url;
  String email;
  
  /* Use the largest of either friendsCount or followersCount for boasting. */
  int friendsCount;
  int followersCount;
  int followingCount;
  
  int postsCount;
  
  bool verified;
}