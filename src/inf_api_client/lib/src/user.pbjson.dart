///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const UserType$json = const {
  '1': 'UserType',
  '2': const [
    const {'1': 'influencer', '2': 0},
    const {'1': 'business', '2': 1},
    const {'1': 'support', '2': 2},
    const {'1': 'admin', '2': 3},
  ],
};

const AccountState$json = const {
  '1': 'AccountState',
  '2': const [
    const {'1': 'unknown', '2': 0},
    const {'1': 'disabled', '2': 1},
    const {'1': 'active', '2': 2},
    const {'1': 'waitingForActivation', '2': 3},
    const {'1': 'waitingForApproval', '2': 4},
    const {'1': 'rejected', '2': 5},
  ],
};

const UserDto$json = const {
  '1': 'UserDto',
  '2': const [
    const {'1': 'verified', '3': 2, '4': 1, '5': 8, '10': 'verified'},
    const {'1': 'accountState', '3': 3, '4': 1, '5': 14, '6': '.api.AccountState', '10': 'accountState'},
    const {'1': 'userType', '3': 4, '4': 1, '5': 14, '6': '.api.UserType', '10': 'userType'},
    const {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'email', '3': 7, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'websiteUrl', '3': 8, '4': 1, '5': 9, '10': 'websiteUrl'},
    const {'1': 'acceptsDirectOffers', '3': 9, '4': 1, '5': 8, '10': 'acceptsDirectOffers'},
    const {'1': 'showLocation', '3': 10, '4': 1, '5': 8, '10': 'showLocation'},
    const {'1': 'accountCompletionInPercent', '3': 11, '4': 1, '5': 5, '10': 'accountCompletionInPercent'},
    const {'1': 'locationAsString', '3': 12, '4': 1, '5': 9, '10': 'locationAsString'},
    const {'1': 'location', '3': 13, '4': 1, '5': 11, '6': '.api.LocationDto', '10': 'location'},
    const {'1': 'avatarThumbnailUrl', '3': 14, '4': 1, '5': 9, '10': 'avatarThumbnailUrl'},
    const {'1': 'avatarThumbnailLowRes', '3': 15, '4': 1, '5': 12, '10': 'avatarThumbnailLowRes'},
    const {'1': 'avatarUrl', '3': 16, '4': 1, '5': 9, '10': 'avatarUrl'},
    const {'1': 'avatarLowRes', '3': 17, '4': 1, '5': 12, '10': 'avatarLowRes'},
    const {'1': 'categoryIds', '3': 18, '4': 3, '5': 5, '10': 'categoryIds'},
    const {'1': 'minimalFee', '3': 19, '4': 1, '5': 5, '10': 'minimalFee'},
    const {'1': 'socialMediaAccounts', '3': 26, '4': 3, '5': 11, '6': '.api.SocialMediaAccountDto', '10': 'socialMediaAccounts'},
  ],
};

