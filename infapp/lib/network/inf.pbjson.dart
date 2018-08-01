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
  ],
};

const GlobalAccountState$json = const {
  '1': 'GlobalAccountState',
  '2': const [
    const {'1': 'GAS_INITIALIZE', '2': 0},
    const {'1': 'GAS_BLOCKED', '2': 1},
    const {'1': 'GAS_READ_ONLY', '2': 2},
    const {'1': 'GAS_READ_WRITE', '2': 3},
    const {'1': 'GAS_MODERATOR', '2': 4},
    const {'1': 'GAS_ADMIN', '2': 5},
    const {'1': 'GAS_GOD', '2': 6},
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

const ConfigSubCategories$json = const {
  '1': 'ConfigSubCategories',
  '2': const [
    const {'1': 'labels', '3': 1, '4': 3, '5': 9, '10': 'labels'},
  ],
};

const ConfigCategories$json = const {
  '1': 'ConfigCategories',
  '2': const [
    const {'1': 'sub', '3': 1, '4': 3, '5': 11, '6': '.ConfigSubCategories', '10': 'sub'},
  ],
};

const ConfigOAuthProvider$json = const {
  '1': 'ConfigOAuthProvider',
  '2': const [
    const {'1': 'visible', '3': 1, '4': 1, '5': 8, '10': 'visible'},
    const {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    const {'1': 'fontAwesomeBrand', '3': 14, '4': 1, '5': 5, '10': 'fontAwesomeBrand'},
    const {'1': 'mechanism', '3': 15, '4': 1, '5': 14, '6': '.OAuthMechanism', '10': 'mechanism'},
    const {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'callbackUrl', '3': 9, '4': 1, '5': 9, '10': 'callbackUrl'},
    const {'1': 'requestTokenUrl', '3': 5, '4': 1, '5': 9, '10': 'requestTokenUrl'},
    const {'1': 'authenticateUrl', '3': 6, '4': 1, '5': 9, '10': 'authenticateUrl'},
    const {'1': 'accessTokenUrl', '3': 16, '4': 1, '5': 9, '10': 'accessTokenUrl'},
    const {'1': 'consumerKey', '3': 10, '4': 1, '5': 9, '10': 'consumerKey'},
    const {'1': 'consumerSecret', '3': 11, '4': 1, '5': 9, '10': 'consumerSecret'},
    const {'1': 'authUrl', '3': 7, '4': 1, '5': 9, '10': 'authUrl'},
    const {'1': 'authQuery', '3': 8, '4': 1, '5': 9, '10': 'authQuery'},
    const {'1': 'clientId', '3': 12, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'clientSecret', '3': 17, '4': 1, '5': 9, '10': 'clientSecret'},
    const {'1': 'whitelistHosts', '3': 18, '4': 3, '5': 9, '10': 'whitelistHosts'},
  ],
};

const ConfigOAuthProviders$json = const {
  '1': 'ConfigOAuthProviders',
  '2': const [
    const {'1': 'all', '3': 1, '4': 3, '5': 11, '6': '.ConfigOAuthProvider', '10': 'all'},
  ],
};

const ConfigData$json = const {
  '1': 'ConfigData',
  '2': const [
    const {'1': 'clientVersion', '3': 1, '4': 1, '5': 5, '10': 'clientVersion'},
    const {'1': 'timestamp', '3': 5, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'downloadUrls', '3': 4, '4': 3, '5': 9, '10': 'downloadUrls'},
    const {'1': 'categories', '3': 2, '4': 1, '5': 11, '6': '.ConfigCategories', '10': 'categories'},
    const {'1': 'oauthProviders', '3': 3, '4': 1, '5': 11, '6': '.ConfigOAuthProviders', '10': 'oauthProviders'},
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
    const {'1': 'screenName', '3': 4, '4': 1, '5': 9, '10': 'screenName'},
    const {'1': 'displayName', '3': 5, '4': 1, '5': 9, '10': 'displayName'},
    const {'1': 'avatarUrl', '3': 14, '4': 1, '5': 9, '10': 'avatarUrl'},
    const {'1': 'profileUrl', '3': 13, '4': 1, '5': 9, '10': 'profileUrl'},
    const {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'location', '3': 7, '4': 1, '5': 9, '10': 'location'},
    const {'1': 'url', '3': 8, '4': 1, '5': 9, '10': 'url'},
    const {'1': 'email', '3': 12, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'friendsCount', '3': 9, '4': 1, '5': 5, '10': 'friendsCount'},
    const {'1': 'followersCount', '3': 2, '4': 1, '5': 5, '10': 'followersCount'},
    const {'1': 'followingCount', '3': 3, '4': 1, '5': 5, '10': 'followingCount'},
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

const DataOffer$json = const {
  '1': 'DataOffer',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'business', '3': 2, '4': 1, '5': 11, '6': '.DataAccount', '10': 'business'},
    const {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'imageUrls', '3': 4, '4': 3, '5': 9, '10': 'imageUrls'},
    const {'1': 'categories', '3': 5, '4': 3, '5': 11, '6': '.CategoryId', '10': 'categories'},
    const {'1': 'lat', '3': 6, '4': 1, '5': 1, '10': 'lat'},
    const {'1': 'lng', '3': 7, '4': 1, '5': 1, '10': 'lng'},
    const {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'deliverables', '3': 9, '4': 1, '5': 9, '10': 'deliverables'},
    const {'1': 'reward', '3': 10, '4': 1, '5': 9, '10': 'reward'},
  ],
};

const DataApplicant$json = const {
  '1': 'DataApplicant',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'offer', '3': 2, '4': 1, '5': 11, '6': '.DataOffer', '10': 'offer'},
    const {'1': 'influencer', '3': 3, '4': 1, '5': 11, '6': '.DataAccount', '10': 'influencer'},
  ],
};

const DataChat$json = const {
  '1': 'DataChat',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 3, '10': 'applicantId'},
    const {'1': 'sequenceId', '3': 2, '4': 1, '5': 3, '10': 'sequenceId'},
    const {'1': 'keyId', '3': 3, '4': 1, '5': 3, '10': 'keyId'},
    const {'1': 'outgoing', '3': 4, '4': 1, '5': 8, '10': 'outgoing'},
    const {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
  ],
};

const DataAccountState$json = const {
  '1': 'DataAccountState',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 5, '10': 'deviceId'},
    const {'1': 'accountId', '3': 2, '4': 1, '5': 5, '10': 'accountId'},
    const {'1': 'accountType', '3': 3, '4': 1, '5': 14, '6': '.AccountType', '10': 'accountType'},
    const {'1': 'globalAccountState', '3': 4, '4': 1, '5': 14, '6': '.GlobalAccountState', '10': 'globalAccountState'},
    const {'1': 'globalAccountStateReason', '3': 5, '4': 1, '5': 14, '6': '.GlobalAccountStateReason', '10': 'globalAccountStateReason'},
    const {'1': 'notificationFlags', '3': 6, '4': 1, '5': 14, '6': '.NotificationFlags', '10': 'notificationFlags'},
  ],
};

const DataAccountSummary$json = const {
  '1': 'DataAccountSummary',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
    const {'1': 'avatarUrl', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
  ],
};

const DataAccountDetail$json = const {
  '1': 'DataAccountDetail',
  '2': const [
    const {'1': 'coverUrls', '3': 1, '4': 3, '5': 9, '10': 'coverUrls'},
    const {'1': 'categories', '3': 2, '4': 3, '5': 11, '6': '.CategoryId', '10': 'categories'},
    const {'1': 'socialMedia', '3': 3, '4': 3, '5': 11, '6': '.DataSocialMedia', '10': 'socialMedia'},
  ],
};

const DataAccount$json = const {
  '1': 'DataAccount',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 11, '6': '.DataAccountState', '10': 'state'},
    const {'1': 'summary', '3': 2, '4': 1, '5': 11, '6': '.DataAccountSummary', '10': 'summary'},
    const {'1': 'detail', '3': 3, '4': 1, '5': 11, '6': '.DataAccountDetail', '10': 'detail'},
  ],
};

const NetDeviceAuthCreateReq$json = const {
  '1': 'NetDeviceAuthCreateReq',
  '2': const [
    const {'1': 'aesKey', '3': 1, '4': 1, '5': 12, '10': 'aesKey'},
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
    const {'1': 'accountState', '3': 7, '4': 1, '5': 11, '6': '.DataAccountState', '10': 'accountState'},
    const {'1': 'socialMedia', '3': 6, '4': 3, '5': 11, '6': '.DataSocialMedia', '10': 'socialMedia'},
  ],
};

const NetSetAccountType$json = const {
  '1': 'NetSetAccountType',
  '2': const [
    const {'1': 'accountType', '3': 1, '4': 1, '5': 14, '6': '.AccountType', '10': 'accountType'},
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
    const {'1': 'socialMedia', '3': 1, '4': 1, '5': 11, '6': '.DataSocialMedia', '10': 'socialMedia'},
  ],
};

const NetAccountCreateReq$json = const {
  '1': 'NetAccountCreateReq',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'lat', '3': 2, '4': 1, '5': 2, '10': 'lat'},
    const {'1': 'lng', '3': 3, '4': 1, '5': 2, '10': 'lng'},
  ],
};

const NetReqImageUpload$json = const {
  '1': 'NetReqImageUpload',
  '2': const [
    const {'1': 'fileName', '3': 1, '4': 1, '5': 9, '10': 'fileName'},
    const {'1': 'fileSize', '3': 2, '4': 1, '5': 5, '10': 'fileSize'},
    const {'1': 'sha256', '3': 3, '4': 1, '5': 9, '10': 'sha256'},
  ],
};

const NetResImageUpload$json = const {
  '1': 'NetResImageUpload',
  '2': const [
    const {'1': 'requestMethod', '3': 1, '4': 1, '5': 9, '10': 'requestMethod'},
    const {'1': 'requestUrl', '3': 2, '4': 1, '5': 9, '10': 'requestUrl'},
    const {'1': 'headerContentType', '3': 3, '4': 1, '5': 9, '10': 'headerContentType'},
    const {'1': 'headerContentLength', '3': 4, '4': 1, '5': 9, '10': 'headerContentLength'},
    const {'1': 'headerHost', '3': 5, '4': 1, '5': 9, '10': 'headerHost'},
    const {'1': 'headerXAmzDate', '3': 6, '4': 1, '5': 9, '10': 'headerXAmzDate'},
    const {'1': 'headerXAmzStorageClass', '3': 7, '4': 1, '5': 9, '10': 'headerXAmzStorageClass'},
    const {'1': 'headerAuthorization', '3': 8, '4': 1, '5': 9, '10': 'headerAuthorization'},
  ],
};

const NetReqCreateOffer$json = const {
  '1': 'NetReqCreateOffer',
  '2': const [
    const {'1': 'offer', '3': 1, '4': 1, '5': 11, '6': '.DataOffer', '10': 'offer'},
    const {'1': 'imageIds', '3': 2, '4': 3, '5': 9, '10': 'imageIds'},
  ],
};

const NetResCreateOffer$json = const {
  '1': 'NetResCreateOffer',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

