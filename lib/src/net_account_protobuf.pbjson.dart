///
//  Generated code. Do not modify.
//  source: net_account_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const NetAccount$json = const {
  '1': 'NetAccount',
  '2': const [
    const {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataAccount',
      '10': 'account'
    },
  ],
};

const NetSetAccountType$json = const {
  '1': 'NetSetAccountType',
  '2': const [
    const {
      '1': 'account_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.inf_common.AccountType',
      '10': 'accountType'
    },
  ],
};

const NetSetFirebaseToken$json = const {
  '1': 'NetSetFirebaseToken',
  '2': const [
    const {
      '1': 'firebase_token',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'firebaseToken'
    },
    const {
      '1': 'old_firebase_token',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'oldFirebaseToken'
    },
  ],
};

const NetOAuthGetUrl$json = const {
  '1': 'NetOAuthGetUrl',
  '2': const [
    const {
      '1': 'oauth_provider',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'oauthProvider'
    },
  ],
};

const NetOAuthUrl$json = const {
  '1': 'NetOAuthUrl',
  '2': const [
    const {'1': 'auth_url', '3': 1, '4': 1, '5': 9, '10': 'authUrl'},
    const {'1': 'callback_url', '3': 2, '4': 1, '5': 9, '10': 'callbackUrl'},
  ],
};

const NetOAuthGetSecrets$json = const {
  '1': 'NetOAuthGetSecrets',
  '2': const [
    const {
      '1': 'oauth_provider',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'oauthProvider'
    },
  ],
};

const NetOAuthSecrets$json = const {
  '1': 'NetOAuthSecrets',
  '2': const [
    const {'1': 'consumer_key', '3': 10, '4': 1, '5': 9, '10': 'consumerKey'},
    const {
      '1': 'consumer_secret',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'consumerSecret'
    },
    const {'1': 'client_id', '3': 12, '4': 1, '5': 9, '10': 'clientId'},
  ],
};

const NetOAuthConnect$json = const {
  '1': 'NetOAuthConnect',
  '2': const [
    const {
      '1': 'oauth_provider',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'oauthProvider'
    },
    const {
      '1': 'callback_query',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'callbackQuery'
    },
  ],
};

const NetOAuthConnection$json = const {
  '1': 'NetOAuthConnection',
  '2': const [
    const {
      '1': 'social_media',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataSocialMedia',
      '10': 'socialMedia'
    },
    const {'1': 'access_token', '3': 4, '4': 1, '5': 9, '10': 'accessToken'},
    const {
      '1': 'account',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataAccount',
      '10': 'account'
    },
  ],
};

const NetAccountCreate$json = const {
  '1': 'NetAccountCreate',
  '2': const [
    const {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    const {'1': 'longitude', '3': 3, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

const NetAccountApplyPromo$json = const {
  '1': 'NetAccountApplyPromo',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

const NetAccountPromo$json = const {
  '1': 'NetAccountPromo',
  '2': const [
    const {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataAccount',
      '10': 'account'
    },
    const {
      '1': 'type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.inf_common.PromoCode',
      '10': 'type'
    },
    const {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    const {'1': 'expired', '3': 2, '4': 1, '5': 8, '10': 'expired'},
    const {'1': 'used', '3': 3, '4': 1, '5': 8, '10': 'used'},
    const {'1': 'applied', '3': 4, '4': 1, '5': 8, '10': 'applied'},
  ],
};
