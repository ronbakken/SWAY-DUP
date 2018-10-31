
import 'dart:typed_data';

import 'package:inf/domain_objects/category.dart';
import 'package:inf/domain_objects/location.dart';
import 'package:inf/domain_objects/socialmedia_account.dart';

enum UserType {
  influcencer,
  business,
  support,
  manager,
}

enum AccountState
{
  newAccount, // User is a new account
  banned, // User is disallowed from the service
  createdDenied, // User account creation request was denied. Contact support
  approved, // User account was approved
  demoapproved, // User account was automatically approved for demonstration purpose
  pending, // User account approval is pending
  requiresInfo, // More information is required from the user to approve their account
}
class User
{   int id;
    bool verified;
    AccountState accountState;
    UserType userType;
    String name;
    String description;
    String email;
    String websiteUrl;

    String creditCard;

    String locationAsString;
    Location location;
    String avatarThumbnailUrl;
    Uint8List avatarThumbnailLowRes;
    String avatarUrl;
    Uint8List avatarLowRes;

    List<Category> categories;  

    List<SocialMediaAccount> socialMediaAccounts;

}