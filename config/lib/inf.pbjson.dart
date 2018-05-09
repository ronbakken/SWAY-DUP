///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf_pbjson;

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

const Config$json = const {
  '1': 'Config',
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

const CategoryIdSet$json = const {
  '1': 'CategoryIdSet',
  '2': const [
    const {'1': 'ids', '3': 1, '4': 3, '5': 11, '6': '.CategoryId', '10': 'ids'},
  ],
};

