///
//  Generated code. Do not modify.
//  source: enum_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const OAuthMechanism$json = const {
  '1': 'OAuthMechanism',
  '2': const [
    const {'1': 'OAM_NONE', '2': 0},
    const {'1': 'OAM_OAUTH1', '2': 1},
    const {'1': 'OAM_OAUTH2', '2': 2},
  ],
};

const OAuthProviderIds$json = const {
  '1': 'OAuthProviderIds',
  '2': const [
    const {'1': 'OAP_NONE', '2': 0},
    const {'1': 'OAP_TWITTER', '2': 1},
    const {'1': 'OAP_FACEBOOK', '2': 2},
  ],
};

const AccountType$json = const {
  '1': 'AccountType',
  '2': const [
    const {'1': 'AT_UNKNOWN', '2': 0},
    const {'1': 'AT_INFLUENCER', '2': 1},
    const {'1': 'AT_BUSINESS', '2': 2},
    const {'1': 'AT_SUPPORT', '2': 3},
  ],
};

const GlobalAccountState$json = const {
  '1': 'GlobalAccountState',
  '2': const [
    const {'1': 'GAS_INITIALIZE', '2': 0},
    const {'1': 'GAS_BLOCKED', '2': 1},
    const {'1': 'GAS_READ_ONLY', '2': 2},
    const {'1': 'GAS_READ_WRITE', '2': 3},
    const {'1': 'GAS_DEBUG', '2': 4},
    const {'1': 'GAS_SUPPORT', '2': 5},
    const {'1': 'GAS_MANAGER', '2': 6},
    const {'1': 'GAS_GOD', '2': 7},
  ],
};

const GlobalAccountStateReason$json = const {
  '1': 'GlobalAccountStateReason',
  '2': const [
    const {'1': 'GASR_NEW_ACCOUNT', '2': 0},
    const {'1': 'GASR_ACCOUNT_BANNED', '2': 1},
    const {'1': 'GASR_CREATE_DENIED', '2': 2},
    const {'1': 'GASR_APPROVED', '2': 3},
    const {'1': 'GASR_DEMO_APPROVED', '2': 4},
    const {'1': 'GASR_PENDING', '2': 5},
    const {'1': 'GASR_REQUIRE_INFO', '2': 6},
  ],
};

const AccountLevel$json = const {
  '1': 'AccountLevel',
  '2': const [
    const {'1': 'AL_FREE', '2': 0},
    const {'1': 'AL_PREMIUM', '2': 1},
    const {'1': 'AL_PRO', '2': 2},
  ],
};

const NotificationFlags$json = const {
  '1': 'NotificationFlags',
  '2': const [
    const {'1': 'NF_ACCOUNT_STATE', '2': 0},
    const {'1': 'NF_MAKE_AN_OFFER_HINT', '2': 1},
    const {'1': 'NF_UNREAD_MESSAGES', '2': 2},
    const {'1': 'NF_SUPPORT_REQUEST', '2': 3},
    const {'1': 'NF_ONBOARDING', '2': 4},
  ],
};

const OfferState$json = const {
  '1': 'OfferState',
  '2': const [
    const {'1': 'OS_DRAFT', '2': 0},
    const {'1': 'OS_OPEN', '2': 1},
    const {'1': 'OS_CLOSED', '2': 2},
  ],
};

const OfferStateReason$json = const {
  '1': 'OfferStateReason',
  '2': const [
    const {'1': 'OSR_NEW_OFFER', '2': 0},
    const {'1': 'OSR_USER_CLOSED', '2': 1},
    const {'1': 'OSR_TOS_VIOLATION', '2': 2},
    const {'1': 'OSR_COMPLETED', '2': 3},
  ],
};

const ProposalChatType$json = const {
  '1': 'ProposalChatType',
  '2': const [
    const {'1': 'PCT_PLAIN', '2': 0},
    const {'1': 'PCT_TERMS', '2': 1},
    const {'1': 'PCT_IMAGE_KEY', '2': 2},
    const {'1': 'PCT_MARKER', '2': 3},
  ],
};

const ProposalState$json = const {
  '1': 'ProposalState',
  '2': const [
    const {'1': 'PS_PROPOSING', '2': 0},
    const {'1': 'PS_NEGOTIATING', '2': 1},
    const {'1': 'PS_DEAL', '2': 2},
    const {'1': 'PS_REJECTED', '2': 3},
    const {'1': 'PS_DISPUTE', '2': 4},
    const {'1': 'PS_RESOLVED', '2': 5},
    const {'1': 'PS_COMPLETE', '2': 6},
  ],
};

const ProposalChatMarker$json = const {
  '1': 'ProposalChatMarker',
  '2': const [
    const {'1': 'PCM_APPLIED', '2': 0},
    const {'1': 'PCM_WANT_DEAL', '2': 1},
    const {'1': 'PCM_DEAL_MADE', '2': 2},
    const {'1': 'PCM_REJECTED', '2': 3},
    const {'1': 'PCM_MARKED_COMPLETE', '2': 4},
    const {'1': 'PCM_COMPLETE', '2': 5},
    const {'1': 'PCM_MARKED_DISPUTE', '2': 6},
    const {'1': 'PCM_RESOLVED', '2': 7},
    const {'1': 'PCM_MESSAGE_DROPPED', '2': 8},
    const {'1': 'PCM_DIRECT', '2': 9},
    const {'1': 'PCM_WANT_NEGOTIATE', '2': 10},
  ],
};
