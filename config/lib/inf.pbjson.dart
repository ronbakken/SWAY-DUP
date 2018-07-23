///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

const NetMessageType$json = const {
  '1': 'NetMessageType',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'CLIENT_IDENTIFY', '2': 1},
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
    const {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'requestTokenUrl', '3': 5, '4': 1, '5': 9, '10': 'requestTokenUrl'},
    const {'1': 'authenticateUrl', '3': 6, '4': 1, '5': 9, '10': 'authenticateUrl'},
    const {'1': 'authUrl', '3': 7, '4': 1, '5': 9, '10': 'authUrl'},
    const {'1': 'authQuery', '3': 8, '4': 1, '5': 9, '10': 'authQuery'},
    const {'1': 'callbackUrl', '3': 9, '4': 1, '5': 9, '10': 'callbackUrl'},
    const {'1': 'consumerKey', '3': 10, '4': 1, '5': 9, '10': 'consumerKey'},
    const {'1': 'consumerSecret', '3': 11, '4': 1, '5': 9, '10': 'consumerSecret'},
    const {'1': 'clientId', '3': 12, '4': 1, '5': 9, '10': 'clientId'},
    const {'1': 'native', '3': 13, '4': 1, '5': 9, '10': 'native'},
  ],
};

const ConfigOAuthProviders$json = const {
  '1': 'ConfigOAuthProviders',
  '2': const [
    const {'1': 'all', '3': 1, '4': 3, '5': 11, '6': '.ConfigOAuthProvider', '10': 'all'},
    const {'1': 'key', '3': 2, '4': 1, '5': 9, '10': 'key'},
  ],
};

const ConfigData$json = const {
  '1': 'ConfigData',
  '2': const [
    const {'1': 'clientVersion', '3': 1, '4': 1, '5': 5, '10': 'clientVersion'},
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

const DataInfluencer$json = const {
  '1': 'DataInfluencer',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
    const {'1': 'avatarUrl', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
    const {'1': 'categories', '3': 5, '4': 3, '5': 11, '6': '.CategoryId', '10': 'categories'},
    const {'1': 'lat', '3': 6, '4': 1, '5': 1, '10': 'lat'},
    const {'1': 'lng', '3': 7, '4': 1, '5': 1, '10': 'lng'},
  ],
};

const DataBusiness$json = const {
  '1': 'DataBusiness',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
    const {'1': 'avatarUrl', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
    const {'1': 'categories', '3': 5, '4': 3, '5': 11, '6': '.CategoryId', '10': 'categories'},
    const {'1': 'lat', '3': 6, '4': 1, '5': 1, '10': 'lat'},
    const {'1': 'lng', '3': 7, '4': 1, '5': 1, '10': 'lng'},
  ],
};

const DataOffer$json = const {
  '1': 'DataOffer',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'business', '3': 2, '4': 1, '5': 11, '6': '.DataBusiness', '10': 'business'},
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
    const {'1': 'influencer', '3': 3, '4': 1, '5': 11, '6': '.DataInfluencer', '10': 'influencer'},
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

const NetResRejected$json = const {
  '1': 'NetResRejected',
  '2': const [
    const {'1': 'rejectReason', '3': 1, '4': 1, '5': 9, '10': 'rejectReason'},
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

