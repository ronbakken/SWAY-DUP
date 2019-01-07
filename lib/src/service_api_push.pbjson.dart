///
//  Generated code. Do not modify.
//  source: service_api_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'net_push_protobuf.pbjson.dart' as $5;
import 'net_account_protobuf.pbjson.dart' as $2;
import 'data_protobuf.pbjson.dart' as $1;
import 'net_offer_protobuf.pbjson.dart' as $3;
import 'net_proposal_protobuf.pbjson.dart' as $4;

const ApiPushServiceBase$json = const {
  '1': 'ApiPush',
  '2': const [
    const {
      '1': 'Listen',
      '2': '.inf_common.NetListen',
      '3': '.inf_common.NetPush',
      '4': const {},
      '6': true
    },
  ],
};

const ApiPushServiceBase$messageJson = const {
  '.inf_common.NetListen': $5.NetListen$json,
  '.inf_common.NetPush': $5.NetPush$json,
  '.inf_common.NetAccount': $2.NetAccount$json,
  '.inf_common.DataAccount': $1.DataAccount$json,
  '.inf_common.DataAccount.SocialMediaEntry':
      $1.DataAccount_SocialMediaEntry$json,
  '.inf_common.DataSocialMedia': $1.DataSocialMedia$json,
  '.inf_common.NetOffer': $3.NetOffer$json,
  '.inf_common.DataOffer': $1.DataOffer$json,
  '.inf_common.DataTerms': $1.DataTerms$json,
  '.inf_common.NetProposal': $4.NetProposal$json,
  '.inf_common.DataProposal': $1.DataProposal$json,
  '.inf_common.DataProposalChat': $1.DataProposalChat$json,
  '.inf_common.NetProposalChat': $4.NetProposalChat$json,
};
