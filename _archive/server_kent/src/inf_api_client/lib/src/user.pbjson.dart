///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

const UserType$json = const {
  '1': 'UserType',
  '2': const [
    const {'1': 'unknownType', '2': 0},
    const {'1': 'influencer', '2': 1},
    const {'1': 'business', '2': 2},
    const {'1': 'support', '2': 3},
    const {'1': 'admin', '2': 4},
  ],
};

const UserDto$json = const {
  '1': 'UserDto',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'revision', '3': 2, '4': 1, '5': 13, '10': 'revision'},
    const {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.api.UserDto.Status', '10': 'status'},
    const {'1': 'handle', '3': 4, '4': 1, '5': 11, '6': '.api.UserDto.HandleDataDto', '9': 0, '10': 'handle'},
    const {'1': 'list', '3': 5, '4': 1, '5': 11, '6': '.api.UserDto.ListDataDto', '9': 0, '10': 'list'},
    const {'1': 'full', '3': 6, '4': 1, '5': 11, '6': '.api.UserDto.FullDataDto', '9': 0, '10': 'full'},
  ],
  '3': const [UserDto_HandleDataDto$json, UserDto_ListDataDto$json, UserDto_FullDataDto$json],
  '4': const [UserDto_Status$json],
  '8': const [
    const {'1': 'data'},
  ],
};

const UserDto_HandleDataDto$json = const {
  '1': 'HandleDataDto',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'avatarThumbnail', '3': 2, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'avatarThumbnail'},
  ],
};

const UserDto_ListDataDto$json = const {
  '1': 'ListDataDto',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.api.UserType', '10': 'type'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'showLocation', '3': 8, '4': 1, '5': 8, '10': 'showLocation'},
    const {'1': 'location', '3': 10, '4': 1, '5': 11, '6': '.api.LocationDto', '10': 'location'},
    const {'1': 'avatar', '3': 11, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'avatar'},
    const {'1': 'avatarThumbnail', '3': 12, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'avatarThumbnail'},
    const {'1': 'categoryIds', '3': 13, '4': 3, '5': 9, '10': 'categoryIds'},
    const {'1': 'socialMediaProviderIds', '3': 14, '4': 3, '5': 9, '10': 'socialMediaProviderIds'},
  ],
};

const UserDto_FullDataDto$json = const {
  '1': 'FullDataDto',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.api.UserType', '10': 'type'},
    const {'1': 'isVerified', '3': 3, '4': 1, '5': 8, '10': 'isVerified'},
    const {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'email', '3': 5, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'websiteUrl', '3': 6, '4': 1, '5': 9, '10': 'websiteUrl'},
    const {'1': 'acceptsDirectOffers', '3': 7, '4': 1, '5': 8, '10': 'acceptsDirectOffers'},
    const {'1': 'showLocation', '3': 8, '4': 1, '5': 8, '10': 'showLocation'},
    const {'1': 'accountCompletionInPercent', '3': 9, '4': 1, '5': 5, '10': 'accountCompletionInPercent'},
    const {'1': 'location', '3': 10, '4': 1, '5': 11, '6': '.api.LocationDto', '10': 'location'},
    const {'1': 'locationsOfInfluence', '3': 17, '4': 3, '5': 11, '6': '.api.LocationDto', '10': 'locationsOfInfluence'},
    const {'1': 'avatar', '3': 11, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'avatar'},
    const {'1': 'avatarThumbnail', '3': 12, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'avatarThumbnail'},
    const {'1': 'categoryIds', '3': 13, '4': 3, '5': 9, '10': 'categoryIds'},
    const {'1': 'minimalFee', '3': 14, '4': 1, '5': 11, '6': '.api.MoneyDto', '10': 'minimalFee'},
    const {'1': 'socialMediaAccounts', '3': 15, '4': 3, '5': 11, '6': '.api.SocialMediaAccountDto', '10': 'socialMediaAccounts'},
    const {'1': 'registrationTokens', '3': 16, '4': 3, '5': 9, '10': 'registrationTokens'},
  ],
};

const UserDto_Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'unknown', '2': 0},
    const {'1': 'disabled', '2': 1},
    const {'1': 'active', '2': 2},
    const {'1': 'waitingForActivation', '2': 3},
    const {'1': 'waitingForApproval', '2': 4},
    const {'1': 'rejected', '2': 5},
  ],
};

