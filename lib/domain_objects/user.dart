


import 'package:inf/domain_objects/enums.dart';
import 'package:inf/domain_objects/location.dart';
import 'package:inf/domain_objects/socialmedia_account.dart';

class User
{   int id;
    bool verified;
    AccountState accountState;
    UserType userType;
    String name;
    String description;
    String email;

    String creditCard;

    String locationAsString;
    Location location;
    String avatarThumbnailUrl;
    String blurredAvatarThumbnailUrl;
    String avatarHighResUrl;
    String blurredAvatarHighResUrl;

    // Jan
    //bytes categories = 11;
    
    List<SocialMediaAccount> socialMediaAccounts;
    // Jan: ??
    String url;


}