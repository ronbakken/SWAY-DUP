///
//  Generated code. Do not modify.
//  source: api_account.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'net_account_protobuf.pbjson.dart' as $2;
import 'data_protobuf.pbjson.dart' as $1;

const ApiAccountServiceBase$json = const {
  '1': 'ApiAccount',
  '2': const [
    const {
      '1': 'SetType',
      '2': '.inf_common.NetSetAccountType',
      '3': '.inf_common.NetAccount',
      '4': const {}
    },
    const {
      '1': 'Create',
      '2': '.inf_common.NetAccountCreate',
      '3': '.inf_common.NetAccount',
      '4': const {}
    },
    const {
      '1': 'ConnectProvider',
      '2': '.inf_common.NetOAuthConnection',
      '3': '.inf_common.NetOAuthConnection',
      '4': const {}
    },
    const {
      '1': 'SetFirebaseToken',
      '2': '.inf_common.NetSetFirebaseToken',
      '3': '.inf_common.NetAccount',
      '4': const {}
    },
  ],
};

const ApiAccountServiceBase$messageJson = const {
  '.inf_common.NetSetAccountType': $2.NetSetAccountType$json,
  '.inf_common.NetAccount': $2.NetAccount$json,
  '.inf_common.DataAccount': $1.DataAccount$json,
  '.inf_common.DataAccount.SocialMediaEntry':
      $1.DataAccount_SocialMediaEntry$json,
  '.inf_common.DataSocialMedia': $1.DataSocialMedia$json,
  '.inf_common.NetAccountCreate': $2.NetAccountCreate$json,
  '.inf_common.NetOAuthConnection': $2.NetOAuthConnection$json,
  '.inf_common.NetSetFirebaseToken': $2.NetSetFirebaseToken$json,
};
