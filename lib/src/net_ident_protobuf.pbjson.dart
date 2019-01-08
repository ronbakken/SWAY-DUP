///
//  Generated code. Do not modify.
//  source: net_ident_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const NetSessionPayload$json = const {
  '1': 'NetSessionPayload',
  '2': const [
    const {'1': 'session_id', '3': 1, '4': 1, '5': 3, '10': 'sessionId'},
    const {'1': 'cookie', '3': 2, '4': 1, '5': 12, '10': 'cookie'},
    const {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
    const {
      '1': 'client_version',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'clientVersion'
    },
    const {
      '1': 'config_timestamp',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'configTimestamp'
    },
    const {'1': 'config_region', '3': 5, '4': 1, '5': 9, '10': 'configRegion'},
    const {
      '1': 'config_language',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'configLanguage'
    },
  ],
};

const NetSessionOpen$json = const {
  '1': 'NetSessionOpen',
  '2': const [
    const {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
    const {
      '1': 'client_version',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'clientVersion'
    },
  ],
};

const NetSessionCreate$json = const {
  '1': 'NetSessionCreate',
  '2': const [
    const {'1': 'device_token', '3': 1, '4': 1, '5': 12, '10': 'deviceToken'},
    const {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    const {'1': 'device_info', '3': 3, '4': 1, '5': 9, '10': 'deviceInfo'},
    const {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
    const {
      '1': 'client_version',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'clientVersion'
    },
  ],
};

const NetSessionRemove$json = const {
  '1': 'NetSessionRemove',
};

const NetSession$json = const {
  '1': 'NetSession',
  '2': const [
    const {
      '1': 'account',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataAccount',
      '10': 'account'
    },
    const {'1': 'bearer_token', '3': 3, '4': 1, '5': 9, '10': 'bearerToken'},
    const {'1': 'access_token', '3': 4, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};
