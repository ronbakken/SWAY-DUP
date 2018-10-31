///
//  Generated code. Do not modify.
//  source: net_get_service.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'net_get_protobuf.pbjson.dart' as $2;
import 'data_protobuf.pbjson.dart' as $1;

const NetGetService$json = const {
  '1': 'NetGetService',
  '2': const [
    const {
      '1': 'getAccount',
      '2': '.inf.NetGetAccountReq',
      '3': '.inf.NetGetAccountRes'
    },
    const {
      '1': 'getOffer',
      '2': '.inf.NetGetOfferReq',
      '3': '.inf.NetGetOfferRes'
    },
    const {
      '1': 'getProposal',
      '2': '.inf.NetGetApplicantReq',
      '3': '.inf.NetGetApplicantRes'
    },
  ],
};

const NetGetService$messageJson = const {
  '.inf.NetGetAccountReq': $2.NetGetAccountReq$json,
  '.inf.NetGetAccountRes': $2.NetGetAccountRes$json,
  '.inf.DataAccount': $1.DataAccount$json,
  '.inf.DataAccountState': $1.DataAccountState$json,
  '.inf.DataAccountSummary': $1.DataAccountSummary$json,
  '.inf.DataAccountDetail': $1.DataAccountDetail$json,
  '.inf.DataSocialMedia': $1.DataSocialMedia$json,
  '.inf.NetGetOfferReq': $2.NetGetOfferReq$json,
  '.inf.NetGetOfferRes': $2.NetGetOfferRes$json,
  '.inf.DataBusinessOffer': $1.DataBusinessOffer$json,
  '.inf.NetGetApplicantReq': $2.NetGetApplicantReq$json,
  '.inf.NetGetApplicantRes': $2.NetGetApplicantRes$json,
  '.inf.DataApplicant': $1.DataApplicant$json,
};
