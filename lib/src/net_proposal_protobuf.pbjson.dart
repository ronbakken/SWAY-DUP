///
//  Generated code. Do not modify.
//  source: net_proposal_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const NetLoadProposalsReq$json = const {
  '1': 'NetLoadProposalsReq',
  '2': const [
    const {'1': 'offerId', '3': 4, '4': 1, '5': 3, '10': 'offerId'},
    const {'1': 'before', '3': 1, '4': 1, '5': 3, '10': 'before'},
    const {'1': 'after', '3': 2, '4': 1, '5': 3, '10': 'after'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 3, '10': 'limit'},
  ],
};

const NetLoadProposalReq$json = const {
  '1': 'NetLoadProposalReq',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
  ],
};

const NetLoadProposalChatsReq$json = const {
  '1': 'NetLoadProposalChatsReq',
  '2': const [
    const {'1': 'proposalId', '3': 5, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'before', '3': 1, '4': 1, '5': 3, '10': 'before'},
    const {'1': 'after', '3': 2, '4': 1, '5': 3, '10': 'after'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 3, '10': 'limit'},
  ],
};

const NetChatPlain$json = const {
  '1': 'NetChatPlain',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {
      '1': 'sessionGhostId',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'text', '3': 6, '4': 1, '5': 9, '10': 'text'},
  ],
};

const NetChatHaggle$json = const {
  '1': 'NetChatHaggle',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {
      '1': 'sessionGhostId',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'deliverables', '3': 3, '4': 1, '5': 9, '10': 'deliverables'},
    const {'1': 'reward', '3': 4, '4': 1, '5': 9, '10': 'reward'},
    const {'1': 'remarks', '3': 2, '4': 1, '5': 9, '10': 'remarks'},
  ],
};

const NetChatImageKey$json = const {
  '1': 'NetChatImageKey',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {
      '1': 'sessionGhostId',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'imageKey', '3': 5, '4': 1, '5': 9, '10': 'imageKey'},
  ],
};

const NetProposalWantDealReq$json = const {
  '1': 'NetProposalWantDealReq',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'haggleChatId', '3': 2, '4': 1, '5': 3, '10': 'haggleChatId'},
  ],
};

const NetProposalRejectReq$json = const {
  '1': 'NetProposalRejectReq',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

const NetProposalReportReq$json = const {
  '1': 'NetProposalReportReq',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

const NetProposalCompletionReq$json = const {
  '1': 'NetProposalCompletionReq',
  '2': const [
    const {'1': 'proposalId', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'delivered', '3': 2, '4': 1, '5': 8, '10': 'delivered'},
    const {'1': 'rewarded', '3': 3, '4': 1, '5': 8, '10': 'rewarded'},
    const {'1': 'rating', '3': 4, '4': 1, '5': 5, '10': 'rating'},
    const {'1': 'dispute', '3': 5, '4': 1, '5': 8, '10': 'dispute'},
    const {
      '1': 'disputeDescription',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'disputeDescription'
    },
  ],
};

const NetProposalCommonRes$json = const {
  '1': 'NetProposalCommonRes',
  '2': const [
    const {
      '1': 'updateProposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataProposal',
      '10': 'updateProposal'
    },
    const {
      '1': 'newChats',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.inf_common.DataProposalChat',
      '10': 'newChats'
    },
  ],
};
