///
//  Generated code. Do not modify.
//  source: net_applicants_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const NetLoadApplicantsReq$json = const {
  '1': 'NetLoadApplicantsReq',
  '2': const [
    const {'1': 'offerId', '3': 4, '4': 1, '5': 5, '10': 'offerId'},
    const {'1': 'before', '3': 1, '4': 1, '5': 5, '10': 'before'},
    const {'1': 'after', '3': 2, '4': 1, '5': 5, '10': 'after'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

const NetLoadApplicantReq$json = const {
  '1': 'NetLoadApplicantReq',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
  ],
};

const NetLoadApplicantChatsReq$json = const {
  '1': 'NetLoadApplicantChatsReq',
  '2': const [
    const {'1': 'applicantId', '3': 5, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'before', '3': 1, '4': 1, '5': 5, '10': 'before'},
    const {'1': 'after', '3': 2, '4': 1, '5': 5, '10': 'after'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

const NetChatPlain$json = const {
  '1': 'NetChatPlain',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'deviceGhostId', '3': 8, '4': 1, '5': 5, '10': 'deviceGhostId'},
    const {'1': 'text', '3': 6, '4': 1, '5': 9, '10': 'text'},
  ],
};

const NetChatHaggle$json = const {
  '1': 'NetChatHaggle',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'deviceGhostId', '3': 8, '4': 1, '5': 5, '10': 'deviceGhostId'},
    const {'1': 'deliverables', '3': 3, '4': 1, '5': 9, '10': 'deliverables'},
    const {'1': 'reward', '3': 4, '4': 1, '5': 9, '10': 'reward'},
    const {'1': 'remarks', '3': 2, '4': 1, '5': 9, '10': 'remarks'},
  ],
};

const NetChatImageKey$json = const {
  '1': 'NetChatImageKey',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'deviceGhostId', '3': 8, '4': 1, '5': 5, '10': 'deviceGhostId'},
    const {'1': 'imageKey', '3': 5, '4': 1, '5': 9, '10': 'imageKey'},
  ],
};

const NetApplicantWantDealReq$json = const {
  '1': 'NetApplicantWantDealReq',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'haggleChatId', '3': 2, '4': 1, '5': 3, '10': 'haggleChatId'},
  ],
};

const NetApplicantRejectReq$json = const {
  '1': 'NetApplicantRejectReq',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

const NetApplicantReportReq$json = const {
  '1': 'NetApplicantReportReq',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
    const {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

const NetApplicantCompletionReq$json = const {
  '1': 'NetApplicantCompletionReq',
  '2': const [
    const {'1': 'applicantId', '3': 1, '4': 1, '5': 5, '10': 'applicantId'},
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

const NetApplicantCommonRes$json = const {
  '1': 'NetApplicantCommonRes',
  '2': const [
    const {
      '1': 'updateApplicant',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.DataApplicant',
      '10': 'updateApplicant'
    },
    const {
      '1': 'newChats',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.inf.DataApplicantChat',
      '10': 'newChats'
    },
  ],
};
