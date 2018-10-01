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

const NotificationFlags$json = const {
  '1': 'NotificationFlags',
  '2': const [
    const {'1': 'NF_ACCOUNT_STATE', '2': 0},
    const {'1': 'NF_MAKE_AN_OFFER_FAB', '2': 1},
    const {'1': 'NF_UNREAD_MESSAGES', '2': 2},
    const {'1': 'NF_CS_REQUEST', '2': 3},
  ],
};

const BusinessOfferState$json = const {
  '1': 'BusinessOfferState',
  '2': const [
    const {'1': 'BOS_DRAFT', '2': 0},
    const {'1': 'BOS_OPEN', '2': 1},
    const {'1': 'BOS_ACTIVE', '2': 2},
    const {'1': 'BOS_CLOSED', '2': 3},
  ],
};

const BusinessOfferStateReason$json = const {
  '1': 'BusinessOfferStateReason',
  '2': const [
    const {'1': 'BOSR_NEW_OFFER', '2': 0},
    const {'1': 'BOSR_USER_CLOSED', '2': 1},
    const {'1': 'BOSR_TOS_VIOLATION', '2': 2},
    const {'1': 'BOSR_COMPLETED', '2': 3},
  ],
};

const ApplicantChatType$json = const {
  '1': 'ApplicantChatType',
  '2': const [
    const {'1': 'ACT_PLAIN', '2': 0},
    const {'1': 'ACT_HAGGLE', '2': 1},
    const {'1': 'ACT_IMAGE_KEY', '2': 2},
    const {'1': 'ACT_MARKER', '2': 3},
  ],
};

const ApplicantState$json = const {
  '1': 'ApplicantState',
  '2': const [
    const {'1': 'AS_HAGGLING', '2': 0},
    const {'1': 'AS_DEAL', '2': 1},
    const {'1': 'AS_REJECTED', '2': 2},
    const {'1': 'AS_COMPLETE', '2': 3},
    const {'1': 'AS_DISPUTE', '2': 4},
    const {'1': 'AS_RESOLVED', '2': 5},
  ],
};

const ApplicantChatMarker$json = const {
  '1': 'ApplicantChatMarker',
  '2': const [
    const {'1': 'ACM_APPLIED', '2': 0},
    const {'1': 'ACM_WANT_DEAL', '2': 1},
    const {'1': 'ACM_DEAL_MADE', '2': 2},
    const {'1': 'ACM_REJECTED', '2': 3},
    const {'1': 'ACM_MARKED_COMPLETE', '2': 4},
    const {'1': 'ACM_COMPLETE', '2': 5},
    const {'1': 'ACM_MARKED_DISPUTE', '2': 6},
    const {'1': 'ACM_RESOLVED', '2': 7},
    const {'1': 'ACM_MESSAGE_DROPPED', '2': 8},
  ],
};
