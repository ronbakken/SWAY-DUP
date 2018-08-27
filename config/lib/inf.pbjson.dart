///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

const OAuthMechanism$json = const {
  '1': 'OAuthMechanism',
  '2': const [
    const {'1': 'OAM_NONE', '2': 0},
    const {'1': 'OAM_OAUTH1', '2': 1},
    const {'1': 'OAM_OAUTH2', '2': 2},
  ],
};

const OAuthProviderIds$json = const {
  '1': 'OAuthProviderIds',
  '2': const [
    const {'1': 'OAP_NONE', '2': 0},
    const {'1': 'OAP_TWITTER', '2': 1},
    const {'1': 'OAP_FACEBOOK', '2': 2},
  ],
};

const AccountType$json = const {
  '1': 'AccountType',
  '2': const [
    const {'1': 'AT_UNKNOWN', '2': 0},
    const {'1': 'AT_INFLUENCER', '2': 1},
    const {'1': 'AT_BUSINESS', '2': 2},
    const {'1': 'AT_SUPPORT', '2': 3},
  ],
};

const GlobalAccountState$json = const {
  '1': 'GlobalAccountState',
  '2': const [
    const {'1': 'GAS_INITIALIZE', '2': 0},
    const {'1': 'GAS_BLOCKED', '2': 1},
    const {'1': 'GAS_READ_ONLY', '2': 2},
    const {'1': 'GAS_READ_WRITE', '2': 3},
    const {'1': 'GAS_DEBUG', '2': 4},
    const {'1': 'GAS_SUPPORT', '2': 5},
    const {'1': 'GAS_MANAGER', '2': 6},
    const {'1': 'GAS_GOD', '2': 7},
  ],
};

const GlobalAccountStateReason$json = const {
  '1': 'GlobalAccountStateReason',
  '2': const [
    const {'1': 'GASR_NEW_ACCOUNT', '2': 0},
    const {'1': 'GASR_ACCOUNT_BANNED', '2': 1},
    const {'1': 'GASR_CREATE_DENIED', '2': 2},
    const {'1': 'GASR_APPROVED', '2': 3},
    const {'1': 'GASR_DEMO_APPROVED', '2': 4},
    const {'1': 'GASR_PENDING', '2': 5},
    const {'1': 'GASR_REQUIRE_INFO', '2': 6},
  ],
};

const NotificationFlags$json = const {
  '1': 'NotificationFlags',
  '2': const [
    const {'1': 'NF_ACCOUNT_STATE', '2': 0},
    const {'1': 'NF_MAKE_AN_OFFER_FAB', '2': 1},
    const {'1': 'NF_UNREAD_MESSAGES', '2': 2},
    const {'1': 'NF_CS_REQUEST', '2': 3},
  ],
};

const BusinessOfferState$json = const {
  '1': 'BusinessOfferState',
  '2': const [
    const {'1': 'BOS_DRAFT', '2': 0},
    const {'1': 'BOS_OPEN', '2': 1},
    const {'1': 'BOS_ACTIVE', '2': 2},
    const {'1': 'BOS_CLOSED', '2': 3},
  ],
};

const BusinessOfferStateReason$json = const {
  '1': 'BusinessOfferStateReason',
  '2': const [
    const {'1': 'BOSR_NEW_OFFER', '2': 0},
    const {'1': 'BOSR_USER_CLOSED', '2': 1},
    const {'1': 'BOSR_TOS_VIOLATION', '2': 2},
    const {'1': 'BOSR_COMPLETED', '2': 3},
  ],
};

const ConfigSubCategories$json = const {
  '1': 'ConfigSubCategories',
  '2': const [
    const {'1': 'labels', '3': 1, '4': 3, '5': 9, '10': 'labels'},
  ],
};

const ConfigCategories$json = const {
  '1': 'ConfigCategories',
  '2': const [
    const {
      '1': 'sub',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.inf.ConfigSubCategories',
      '10': 'sub'
    },
  ],
};

const ConfigOAuthProvider$json = const {
  '1': 'ConfigOAuthProvider',
  '2': const [
    const {'1': 'visible', '3': 1, '4': 1, '5': 8, '10': 'visible'},
    const {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    const {
      '1': 'fontAwesomeBrand',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'fontAwesomeBrand'
    },
    const {
      '1': 'mechanism',
      '3': 15,
      '4': 1,
      '5': 14,
      '6': '.inf.OAuthMechanism',
      '10': 'mechanism'
    },
    const {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'callbackUrl', '3': 9, '4': 1, '5': 9, '10': 'callbackUrl'},
    const {
      '1': 'requestTokenUrl',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'requestTokenUrl'
    },
    const {
      '1': 'authenticateUrl',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'authenticateUrl'
    },
    const {
      '1': 'accessTokenUrl',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'accessTokenUrl'
    },
    const {'1': 'consumerKey', '3': 10, '4': 1, '5': 9, '10': 'consumerKey'},
    const {
      '1': 'consumerSecret',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'consumerSecret'
    },
    const {'1': 'authUrl', '3': 7, '4': 1, '5': 9, '10': 'authUrl'},
    const {'1': 'authQuery', '3': 8, '4': 1, '5': 9, '10': 'authQuery'},
    const {'1': 'clientId', '3': 12, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'clientSecret', '3': 17, '4': 1, '5': 9, '10': 'clientSecret'},
    const {
      '1': 'whitelistHosts',
      '3': 18,
      '4': 3,
      '5': 9,
      '10': 'whitelistHosts'
    },
  ],
};

const ConfigOAuthProviders$json = const {
  '1': 'ConfigOAuthProviders',
  '2': const [
    const {
      '1': 'all',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.inf.ConfigOAuthProvider',
      '10': 'all'
    },
  ],
};

const ConfigServices$json = const {
  '1': 'ConfigServices',
  '2': const [
    const {'1': 'apiHosts', '3': 8, '4': 3, '5': 9, '10': 'apiHosts'},
    const {'1': 'configUrl', '3': 9, '4': 1, '5': 9, '10': 'configUrl'},
    const {
      '1': 'termsOfServiceUrl',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'termsOfServiceUrl'
    },
    const {
      '1': 'privacyPolicyUrl',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'privacyPolicyUrl'
    },
    const {'1': 'mapboxApi', '3': 1, '4': 1, '5': 9, '10': 'mapboxApi'},
    const {
      '1': 'mapboxUrlTemplate',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'mapboxUrlTemplate'
    },
    const {'1': 'mapboxToken', '3': 3, '4': 1, '5': 9, '10': 'mapboxToken'},
    const {'1': 'spacesRegion', '3': 4, '4': 1, '5': 9, '10': 'spacesRegion'},
    const {'1': 'spacesKey', '3': 5, '4': 1, '5': 9, '10': 'spacesKey'},
    const {'1': 'spacesSecret', '3': 6, '4': 1, '5': 9, '10': 'spacesSecret'},
    const {'1': 'spacesBucket', '3': 7, '4': 1, '5': 9, '10': 'spacesBucket'},
    const {
      '1': 'cloudinaryUrl',
      '3': 19,
      '4': 1,
      '5': 9,
      '10': 'cloudinaryUrl'
    },
    const {
      '1': 'cloudinaryThumbnailUrl',
      '3': 20,
      '4': 1,
      '5': 9,
      '10': 'cloudinaryThumbnailUrl'
    },
    const {
      '1': 'cloudinaryCoverUrl',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'cloudinaryCoverUrl'
    },
    const {'1': 'ipstackApi', '3': 13, '4': 1, '5': 9, '10': 'ipstackApi'},
    const {'1': 'ipstackKey', '3': 12, '4': 1, '5': 9, '10': 'ipstackKey'},
    const {'1': 'mariadbHost', '3': 14, '4': 1, '5': 9, '10': 'mariadbHost'},
    const {'1': 'mariadbPort', '3': 15, '4': 1, '5': 5, '10': 'mariadbPort'},
    const {'1': 'mariadbUser', '3': 16, '4': 1, '5': 9, '10': 'mariadbUser'},
    const {
      '1': 'mariadbPassword',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'mariadbPassword'
    },
    const {
      '1': 'mariadbDatabase',
      '3': 18,
      '4': 1,
      '5': 9,
      '10': 'mariadbDatabase'
    },
  ],
};

const ConfigData$json = const {
  '1': 'ConfigData',
  '2': const [
    const {'1': 'clientVersion', '3': 1, '4': 1, '5': 5, '10': 'clientVersion'},
    const {'1': 'timestamp', '3': 5, '4': 1, '5': 3, '10': 'timestamp'},
    const {
      '1': 'categories',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.inf.ConfigCategories',
      '10': 'categories'
    },
    const {
      '1': 'oauthProviders',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.inf.ConfigOAuthProviders',
      '10': 'oauthProviders'
    },
    const {
      '1': 'services',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.inf.ConfigServices',
      '10': 'services'
    },
  ],
};

const CategoryId$json = const {
  '1': 'CategoryId',
  '2': const [
    const {'1': 'main', '3': 1, '4': 1, '5': 5, '10': 'main'},
    const {'1': 'sub', '3': 2, '4': 1, '5': 5, '10': 'sub'},
  ],
};

const DataSocialMedia$json = const {
  '1': 'DataSocialMedia',
  '2': const [
    const {'1': 'connected', '3': 1, '4': 1, '5': 8, '10': 'connected'},
    const {'1': 'expired', '3': 15, '4': 1, '5': 8, '10': 'expired'},
    const {'1': 'screenName', '3': 4, '4': 1, '5': 9, '10': 'screenName'},
    const {'1': 'displayName', '3': 5, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'avatarUrl', '3': 14, '4': 1, '5': 9, '10': 'avatarUrl'},
    const {'1': 'profileUrl', '3': 13, '4': 1, '5': 9, '10': 'profileUrl'},
    const {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'location', '3': 7, '4': 1, '5': 9, '10': 'location'},
    const {'1': 'url', '3': 8, '4': 1, '5': 9, '10': 'url'},
    const {'1': 'email', '3': 12, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'friendsCount', '3': 9, '4': 1, '5': 5, '10': 'friendsCount'},
    const {
      '1': 'followersCount',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'followersCount'
    },
    const {
      '1': 'followingCount',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'followingCount'
    },
    const {'1': 'postsCount', '3': 10, '4': 1, '5': 5, '10': 'postsCount'},
    const {'1': 'verified', '3': 11, '4': 1, '5': 8, '10': 'verified'},
  ],
};

const DataOAuthCredentials$json = const {
  '1': 'DataOAuthCredentials',
  '2': const [
    const {'1': 'userId', '3': 4, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'tokenSecret', '3': 2, '4': 1, '5': 9, '10': 'tokenSecret'},
    const {'1': 'tokenExpires', '3': 3, '4': 1, '5': 5, '10': 'tokenExpires'},
  ],
};

const DataBusinessOffer$json = const {
  '1': 'DataBusinessOffer',
  '2': const [
    const {'1': 'offerId', '3': 1, '4': 1, '5': 5, '10': 'offerId'},
    const {'1': 'accountId', '3': 2, '4': 1, '5': 5, '10': 'accountId'},
    const {'1': 'locationId', '3': 3, '4': 1, '5': 5, '10': 'locationId'},
    const {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'thumbnailUrl', '3': 6, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    const {'1': 'deliverables', '3': 7, '4': 1, '5': 9, '10': 'deliverables'},
    const {'1': 'reward', '3': 8, '4': 1, '5': 9, '10': 'reward'},
    const {'1': 'location', '3': 9, '4': 1, '5': 9, '10': 'location'},
    const {'1': 'coverUrls', '3': 10, '4': 3, '5': 9, '10': 'coverUrls'},
    const {
      '1': 'categories',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.inf.CategoryId',
      '10': 'categories'
    },
    const {
      '1': 'state',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.inf.BusinessOfferState',
      '10': 'state'
    },
    const {
      '1': 'stateReason',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.inf.BusinessOfferStateReason',
      '10': 'stateReason'
    },
    const {
      '1': 'applicantsNew',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'applicantsNew'
    },
    const {
      '1': 'applicantsAccepted',
      '3': 15,
      '4': 1,
      '5': 5,
      '10': 'applicantsAccepted'
    },
    const {
      '1': 'applicantsCompleted',
      '3': 16,
      '4': 1,
      '5': 5,
      '10': 'applicantsCompleted'
    },
    const {
      '1': 'applicantsRefused',
      '3': 17,
      '4': 1,
      '5': 5,
      '10': 'applicantsRefused'
    },
  ],
};

const DataLocation$json = const {
  '1': 'DataLocation',
  '2': const [
    const {'1': 'locationId', '3': 1, '4': 1, '5': 5, '10': 'locationId'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'avatarUrl', '3': 6, '4': 1, '5': 9, '10': 'avatarUrl'},
    const {'1': 'approximate', '3': 7, '4': 1, '5': 9, '10': 'approximate'},
    const {'1': 'detail', '3': 8, '4': 1, '5': 9, '10': 'detail'},
    const {'1': 'postcode', '3': 9, '4': 1, '5': 9, '10': 'postcode'},
    const {'1': 'regionCode', '3': 10, '4': 1, '5': 9, '10': 'regionCode'},
    const {'1': 'countryCode', '3': 11, '4': 1, '5': 9, '10': 'countryCode'},
    const {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    const {'1': 'longitude', '3': 5, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

const DataApplicant$json = const {
  '1': 'DataApplicant',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'offerId', '3': 2, '4': 1, '5': 5, '10': 'offerId'},
    const {'1': 'accountId', '3': 3, '4': 1, '5': 5, '10': 'accountId'},
  ],
};

const DataChat$json = const {
  '1': 'DataChat',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'sequenceId', '3': 2, '4': 1, '5': 5, '10': 'sequenceId'},
    const {'1': 'keyId', '3': 3, '4': 1, '5': 5, '10': 'keyId'},
    const {'1': 'outgoing', '3': 4, '4': 1, '5': 8, '10': 'outgoing'},
    const {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
  ],
};

const DataAccountState$json = const {
  '1': 'DataAccountState',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 5, '10': 'deviceId'},
    const {'1': 'accountId', '3': 2, '4': 1, '5': 5, '10': 'accountId'},
    const {
      '1': 'accountType',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.inf.AccountType',
      '10': 'accountType'
    },
    const {
      '1': 'globalAccountState',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.inf.GlobalAccountState',
      '10': 'globalAccountState'
    },
    const {
      '1': 'globalAccountStateReason',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.inf.GlobalAccountStateReason',
      '10': 'globalAccountStateReason'
    },
    const {
      '1': 'notificationFlags',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.inf.NotificationFlags',
      '10': 'notificationFlags'
    },
  ],
};

const DataAccountSummary$json = const {
  '1': 'DataAccountSummary',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
    const {
      '1': 'avatarThumbnailUrl',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'avatarThumbnailUrl'
    },
  ],
};

const DataAccountDetail$json = const {
  '1': 'DataAccountDetail',
  '2': const [
    const {
      '1': 'categories',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.inf.CategoryId',
      '10': 'categories'
    },
    const {
      '1': 'socialMedia',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.inf.DataSocialMedia',
      '10': 'socialMedia'
    },
    const {
      '1': 'avatarCoverUrl',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'avatarCoverUrl'
    },
    const {'1': 'url', '3': 6, '4': 1, '5': 9, '10': 'url'},
    const {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    const {'1': 'longitude', '3': 5, '4': 1, '5': 1, '10': 'longitude'},
    const {'1': 'locationId', '3': 8, '4': 1, '5': 5, '10': 'locationId'},
  ],
};

const DataAccount$json = const {
  '1': 'DataAccount',
  '2': const [
    const {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.DataAccountState',
      '10': 'state'
    },
    const {
      '1': 'summary',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.inf.DataAccountSummary',
      '10': 'summary'
    },
    const {
      '1': 'detail',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.inf.DataAccountDetail',
      '10': 'detail'
    },
  ],
};

const NetDeviceAuthCreateReq$json = const {
  '1': 'NetDeviceAuthCreateReq',
  '2': const [
    const {'1': 'aesKey', '3': 1, '4': 1, '5': 12, '10': 'aesKey'},
    const {
      '1': 'commonDeviceId',
      '3': 4,
      '4': 1,
      '5': 12,
      '10': 'commonDeviceId'
    },
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'info', '3': 3, '4': 1, '5': 9, '10': 'info'},
  ],
};

const NetDeviceAuthChallengeReq$json = const {
  '1': 'NetDeviceAuthChallengeReq',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 5, '10': 'deviceId'},
  ],
};

const NetDeviceAuthChallengeResReq$json = const {
  '1': 'NetDeviceAuthChallengeResReq',
  '2': const [
    const {'1': 'challenge', '3': 1, '4': 1, '5': 12, '10': 'challenge'},
  ],
};

const NetDeviceAuthSignatureResReq$json = const {
  '1': 'NetDeviceAuthSignatureResReq',
  '2': const [
    const {'1': 'signature', '3': 1, '4': 1, '5': 12, '10': 'signature'},
  ],
};

const NetDeviceAuthState$json = const {
  '1': 'NetDeviceAuthState',
  '2': const [
    const {
      '1': 'data',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.inf.DataAccount',
      '10': 'data'
    },
  ],
};

const NetSetAccountType$json = const {
  '1': 'NetSetAccountType',
  '2': const [
    const {
      '1': 'accountType',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.inf.AccountType',
      '10': 'accountType'
    },
  ],
};

const NetOAuthUrlReq$json = const {
  '1': 'NetOAuthUrlReq',
  '2': const [
    const {'1': 'oauthProvider', '3': 1, '4': 1, '5': 5, '10': 'oauthProvider'},
  ],
};

const NetOAuthUrlRes$json = const {
  '1': 'NetOAuthUrlRes',
  '2': const [
    const {'1': 'authUrl', '3': 1, '4': 1, '5': 9, '10': 'authUrl'},
    const {'1': 'callbackUrl', '3': 2, '4': 1, '5': 9, '10': 'callbackUrl'},
  ],
};

const NetOAuthConnectReq$json = const {
  '1': 'NetOAuthConnectReq',
  '2': const [
    const {'1': 'oauthProvider', '3': 1, '4': 1, '5': 5, '10': 'oauthProvider'},
    const {'1': 'callbackQuery', '3': 2, '4': 1, '5': 9, '10': 'callbackQuery'},
  ],
};

const NetOAuthConnectRes$json = const {
  '1': 'NetOAuthConnectRes',
  '2': const [
    const {
      '1': 'socialMedia',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.DataSocialMedia',
      '10': 'socialMedia'
    },
  ],
};

const NetAccountCreateReq$json = const {
  '1': 'NetAccountCreateReq',
  '2': const [
    const {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    const {'1': 'longitude', '3': 3, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

const NetUploadImageReq$json = const {
  '1': 'NetUploadImageReq',
  '2': const [
    const {'1': 'fileName', '3': 1, '4': 1, '5': 9, '10': 'fileName'},
    const {'1': 'contentLength', '3': 2, '4': 1, '5': 5, '10': 'contentLength'},
    const {'1': 'contentType', '3': 4, '4': 1, '5': 9, '10': 'contentType'},
    const {
      '1': 'contentSha256',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'contentSha256'
    },
  ],
};

const NetUploadImageRes$json = const {
  '1': 'NetUploadImageRes',
  '2': const [
    const {'1': 'requestMethod', '3': 1, '4': 1, '5': 9, '10': 'requestMethod'},
    const {'1': 'requestUrl', '3': 2, '4': 1, '5': 9, '10': 'requestUrl'},
    const {'1': 'fileExists', '3': 9, '4': 1, '5': 8, '10': 'fileExists'},
    const {'1': 'uploadKey', '3': 10, '4': 1, '5': 9, '10': 'uploadKey'},
    const {'1': 'coverUrl', '3': 11, '4': 1, '5': 9, '10': 'coverUrl'},
    const {'1': 'thumbnailUrl', '3': 12, '4': 1, '5': 9, '10': 'thumbnailUrl'},
  ],
};

const NetSetProfile$json = const {
  '1': 'NetSetProfile',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'avatarKey', '3': 4, '4': 1, '5': 9, '10': 'avatarKey'},
    const {'1': 'url', '3': 6, '4': 1, '5': 9, '10': 'url'},
    const {
      '1': 'categories',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.inf.CategoryId',
      '10': 'categories'
    },
    const {'1': 'latitude', '3': 14, '4': 1, '5': 1, '10': 'latitude'},
    const {'1': 'longitude', '3': 15, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

const NetCreateOfferReq$json = const {
  '1': 'NetCreateOfferReq',
  '2': const [
    const {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'imageKeys', '3': 2, '4': 3, '5': 9, '10': 'imageKeys'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'deliverables', '3': 4, '4': 1, '5': 9, '10': 'deliverables'},
    const {'1': 'reward', '3': 5, '4': 1, '5': 9, '10': 'reward'},
    const {'1': 'locationId', '3': 6, '4': 1, '5': 5, '10': 'locationId'},
  ],
};

const NetLoadOffers$json = const {
  '1': 'NetLoadOffers',
  '2': const [
    const {'1': 'before', '3': 1, '4': 1, '5': 5, '10': 'before'},
    const {'1': 'after', '3': 2, '4': 1, '5': 5, '10': 'after'},
  ],
};
