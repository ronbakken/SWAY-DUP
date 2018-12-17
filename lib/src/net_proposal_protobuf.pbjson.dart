///
//  Generated code. Do not modify.
//  source: net_proposal_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const NetProposal$json = const {
  '1': 'NetProposal',
  '2': const [
    const {
      '1': 'proposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataProposal',
      '10': 'proposal'
    },
    const {
      '1': 'chats',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.inf_common.DataProposalChat',
      '10': 'chats'
    },
  ],
};

const NetProposalChat$json = const {
  '1': 'NetProposalChat',
  '2': const [
    const {
      '1': 'chat',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataProposalChat',
      '10': 'chat'
    },
  ],
};

const NetApplyProposal$json = const {
  '1': 'NetApplyProposal',
  '2': const [
    const {'1': 'offer_id', '3': 1, '4': 1, '5': 3, '10': 'offerId'},
    const {
      '1': 'session_ghost_id',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'remarks', '3': 2, '4': 1, '5': 9, '10': 'remarks'},
    const {
      '1': 'terms',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataTerms',
      '10': 'terms'
    },
  ],
};

const NetDirectProposal$json = const {
  '1': 'NetDirectProposal',
  '2': const [
    const {
      '1': 'session_ghost_id',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'remarks', '3': 2, '4': 1, '5': 9, '10': 'remarks'},
    const {
      '1': 'offer',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataOffer',
      '10': 'offer'
    },
  ],
};

const NetListProposals$json = const {
  '1': 'NetListProposals',
  '2': const [
    const {'1': 'offer_id', '3': 4, '4': 1, '5': 3, '10': 'offerId'},
  ],
};

const NetGetProposal$json = const {
  '1': 'NetGetProposal',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
  ],
};

const NetProposalWantDeal$json = const {
  '1': 'NetProposalWantDeal',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'terms_chat_id', '3': 2, '4': 1, '5': 3, '10': 'termsChatId'},
  ],
};

const NetProposalNegotiate$json = const {
  '1': 'NetProposalNegotiate',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
  ],
};

const NetProposalReject$json = const {
  '1': 'NetProposalReject',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

const NetProposalReport$json = const {
  '1': 'NetProposalReport',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

const NetProposalDispute$json = const {
  '1': 'NetProposalDispute',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'delivered', '3': 2, '4': 1, '5': 8, '10': 'delivered'},
    const {'1': 'rewarded', '3': 3, '4': 1, '5': 8, '10': 'rewarded'},
    const {
      '1': 'dispute_description',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'disputeDescription'
    },
  ],
};

const NetProposalCompletion$json = const {
  '1': 'NetProposalCompletion',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {'1': 'rating', '3': 4, '4': 1, '5': 5, '10': 'rating'},
  ],
};

const NetListChats$json = const {
  '1': 'NetListChats',
  '2': const [
    const {'1': 'proposal_id', '3': 5, '4': 1, '5': 3, '10': 'proposalId'},
  ],
};

const NetChatPlain$json = const {
  '1': 'NetChatPlain',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {
      '1': 'session_ghost_id',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'text', '3': 6, '4': 1, '5': 9, '10': 'text'},
  ],
};

const NetChatNegotiate$json = const {
  '1': 'NetChatNegotiate',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {
      '1': 'session_ghost_id',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'remarks', '3': 2, '4': 1, '5': 9, '10': 'remarks'},
    const {
      '1': 'terms',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataTerms',
      '10': 'terms'
    },
  ],
};

const NetChatImageKey$json = const {
  '1': 'NetChatImageKey',
  '2': const [
    const {'1': 'proposal_id', '3': 1, '4': 1, '5': 3, '10': 'proposalId'},
    const {
      '1': 'session_ghost_id',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'image_key', '3': 5, '4': 1, '5': 9, '10': 'imageKey'},
  ],
};
