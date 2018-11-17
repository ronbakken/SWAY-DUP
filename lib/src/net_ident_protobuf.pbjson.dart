///
//  Generated code. Do not modify.
//  source: net_ident_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

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
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 3, '10': 'sessionId'},
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
      '6': '.inf_common.DataAccount',
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
      '6': '.inf_common.AccountType',
      '10': 'accountType'
    },
  ],
};

const NetSetFirebaseToken$json = const {
  '1': 'NetSetFirebaseToken',
  '2': const [
    const {'1': 'firebaseToken', '3': 1, '4': 1, '5': 9, '10': 'firebaseToken'},
    const {
      '1': 'oldFirebaseToken',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'oldFirebaseToken'
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
      '6': '.inf_common.DataSocialMedia',
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
