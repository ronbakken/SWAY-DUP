///
//  Generated code. Do not modify.
//  source: enums.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class AccountType extends $pb.ProtobufEnum {
  static const AccountType AT_UNKNOWN = const AccountType._(0, 'AT_UNKNOWN');
  static const AccountType AT_INFLUENCER = const AccountType._(1, 'AT_INFLUENCER');
  static const AccountType AT_BUSINESS = const AccountType._(2, 'AT_BUSINESS');
  static const AccountType AT_SUPPORT = const AccountType._(3, 'AT_SUPPORT');

  static const List<AccountType> values = const <AccountType> [
    AT_UNKNOWN,
    AT_INFLUENCER,
    AT_BUSINESS,
    AT_SUPPORT,
  ];

  static final Map<int, AccountType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AccountType valueOf(int value) => _byValue[value];
  static void $checkItem(AccountType v) {
    if (v is! AccountType) $pb.checkItemFailed(v, 'AccountType');
  }

  const AccountType._(int v, String n) : super(v, n);
}

class GlobalAccountState extends $pb.ProtobufEnum {
  static const GlobalAccountState GAS_INITIALIZE = const GlobalAccountState._(0, 'GAS_INITIALIZE');
  static const GlobalAccountState GAS_BLOCKED = const GlobalAccountState._(1, 'GAS_BLOCKED');
  static const GlobalAccountState GAS_READ_ONLY = const GlobalAccountState._(2, 'GAS_READ_ONLY');
  static const GlobalAccountState GAS_READ_WRITE = const GlobalAccountState._(3, 'GAS_READ_WRITE');
  static const GlobalAccountState GAS_DEBUG = const GlobalAccountState._(4, 'GAS_DEBUG');
  static const GlobalAccountState GAS_SUPPORT = const GlobalAccountState._(5, 'GAS_SUPPORT');
  static const GlobalAccountState GAS_MANAGER = const GlobalAccountState._(6, 'GAS_MANAGER');
  static const GlobalAccountState GAS_GOD = const GlobalAccountState._(7, 'GAS_GOD');

  static const List<GlobalAccountState> values = const <GlobalAccountState> [
    GAS_INITIALIZE,
    GAS_BLOCKED,
    GAS_READ_ONLY,
    GAS_READ_WRITE,
    GAS_DEBUG,
    GAS_SUPPORT,
    GAS_MANAGER,
    GAS_GOD,
  ];

  static final Map<int, GlobalAccountState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GlobalAccountState valueOf(int value) => _byValue[value];
  static void $checkItem(GlobalAccountState v) {
    if (v is! GlobalAccountState) $pb.checkItemFailed(v, 'GlobalAccountState');
  }

  const GlobalAccountState._(int v, String n) : super(v, n);
}

class GlobalAccountStateReason extends $pb.ProtobufEnum {
  static const GlobalAccountStateReason GASR_NEW_ACCOUNT = const GlobalAccountStateReason._(0, 'GASR_NEW_ACCOUNT');
  static const GlobalAccountStateReason GASR_ACCOUNT_BANNED = const GlobalAccountStateReason._(1, 'GASR_ACCOUNT_BANNED');
  static const GlobalAccountStateReason GASR_CREATE_DENIED = const GlobalAccountStateReason._(2, 'GASR_CREATE_DENIED');
  static const GlobalAccountStateReason GASR_APPROVED = const GlobalAccountStateReason._(3, 'GASR_APPROVED');
  static const GlobalAccountStateReason GASR_DEMO_APPROVED = const GlobalAccountStateReason._(4, 'GASR_DEMO_APPROVED');
  static const GlobalAccountStateReason GASR_PENDING = const GlobalAccountStateReason._(5, 'GASR_PENDING');
  static const GlobalAccountStateReason GASR_REQUIRE_INFO = const GlobalAccountStateReason._(6, 'GASR_REQUIRE_INFO');

  static const List<GlobalAccountStateReason> values = const <GlobalAccountStateReason> [
    GASR_NEW_ACCOUNT,
    GASR_ACCOUNT_BANNED,
    GASR_CREATE_DENIED,
    GASR_APPROVED,
    GASR_DEMO_APPROVED,
    GASR_PENDING,
    GASR_REQUIRE_INFO,
  ];

  static final Map<int, GlobalAccountStateReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GlobalAccountStateReason valueOf(int value) => _byValue[value];
  static void $checkItem(GlobalAccountStateReason v) {
    if (v is! GlobalAccountStateReason) $pb.checkItemFailed(v, 'GlobalAccountStateReason');
  }

  const GlobalAccountStateReason._(int v, String n) : super(v, n);
}

class AccountLevel extends $pb.ProtobufEnum {
  static const AccountLevel AL_FREE = const AccountLevel._(0, 'AL_FREE');
  static const AccountLevel AL_PREMIUM = const AccountLevel._(1, 'AL_PREMIUM');
  static const AccountLevel AL_PRO = const AccountLevel._(2, 'AL_PRO');

  static const List<AccountLevel> values = const <AccountLevel> [
    AL_FREE,
    AL_PREMIUM,
    AL_PRO,
  ];

  static final Map<int, AccountLevel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AccountLevel valueOf(int value) => _byValue[value];
  static void $checkItem(AccountLevel v) {
    if (v is! AccountLevel) $pb.checkItemFailed(v, 'AccountLevel');
  }

  const AccountLevel._(int v, String n) : super(v, n);
}

class NotificationFlags extends $pb.ProtobufEnum {
  static const NotificationFlags NF_ACCOUNT_STATE = const NotificationFlags._(0, 'NF_ACCOUNT_STATE');
  static const NotificationFlags NF_MAKE_AN_OFFER_HINT = const NotificationFlags._(1, 'NF_MAKE_AN_OFFER_HINT');
  static const NotificationFlags NF_UNREAD_MESSAGES = const NotificationFlags._(2, 'NF_UNREAD_MESSAGES');
  static const NotificationFlags NF_SUPPORT_REQUEST = const NotificationFlags._(3, 'NF_SUPPORT_REQUEST');
  static const NotificationFlags NF_ONBOARDING = const NotificationFlags._(4, 'NF_ONBOARDING');

  static const List<NotificationFlags> values = const <NotificationFlags> [
    NF_ACCOUNT_STATE,
    NF_MAKE_AN_OFFER_HINT,
    NF_UNREAD_MESSAGES,
    NF_SUPPORT_REQUEST,
    NF_ONBOARDING,
  ];

  static final Map<int, NotificationFlags> _byValue = $pb.ProtobufEnum.initByValue(values);
  static NotificationFlags valueOf(int value) => _byValue[value];
  static void $checkItem(NotificationFlags v) {
    if (v is! NotificationFlags) $pb.checkItemFailed(v, 'NotificationFlags');
  }

  const NotificationFlags._(int v, String n) : super(v, n);
}

class OfferState extends $pb.ProtobufEnum {
  static const OfferState OS_DRAFT = const OfferState._(0, 'OS_DRAFT');
  static const OfferState OS_SCHEDULED = const OfferState._(1, 'OS_SCHEDULED');
  static const OfferState OS_OPEN = const OfferState._(2, 'OS_OPEN');
  static const OfferState OS_CLOSED = const OfferState._(3, 'OS_CLOSED');

  static const List<OfferState> values = const <OfferState> [
    OS_DRAFT,
    OS_SCHEDULED,
    OS_OPEN,
    OS_CLOSED,
  ];

  static final Map<int, OfferState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferState valueOf(int value) => _byValue[value];
  static void $checkItem(OfferState v) {
    if (v is! OfferState) $pb.checkItemFailed(v, 'OfferState');
  }

  const OfferState._(int v, String n) : super(v, n);
}

class OfferStateReason extends $pb.ProtobufEnum {
  static const OfferStateReason OSR_NEW_OFFER = const OfferStateReason._(0, 'OSR_NEW_OFFER');
  static const OfferStateReason OSR_USER_CLOSED = const OfferStateReason._(1, 'OSR_USER_CLOSED');
  static const OfferStateReason OSR_TOS_VIOLATION = const OfferStateReason._(2, 'OSR_TOS_VIOLATION');
  static const OfferStateReason OSR_COMPLETED = const OfferStateReason._(3, 'OSR_COMPLETED');

  static const List<OfferStateReason> values = const <OfferStateReason> [
    OSR_NEW_OFFER,
    OSR_USER_CLOSED,
    OSR_TOS_VIOLATION,
    OSR_COMPLETED,
  ];

  static final Map<int, OfferStateReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OfferStateReason valueOf(int value) => _byValue[value];
  static void $checkItem(OfferStateReason v) {
    if (v is! OfferStateReason) $pb.checkItemFailed(v, 'OfferStateReason');
  }

  const OfferStateReason._(int v, String n) : super(v, n);
}

class ProposalChatType extends $pb.ProtobufEnum {
  static const ProposalChatType PCT_PLAIN = const ProposalChatType._(0, 'PCT_PLAIN');
  static const ProposalChatType PCT_NEGOTIATE = const ProposalChatType._(1, 'PCT_NEGOTIATE');
  static const ProposalChatType PCT_IMAGE_KEY = const ProposalChatType._(2, 'PCT_IMAGE_KEY');
  static const ProposalChatType PCT_MARKER = const ProposalChatType._(3, 'PCT_MARKER');

  static const List<ProposalChatType> values = const <ProposalChatType> [
    PCT_PLAIN,
    PCT_NEGOTIATE,
    PCT_IMAGE_KEY,
    PCT_MARKER,
  ];

  static final Map<int, ProposalChatType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ProposalChatType valueOf(int value) => _byValue[value];
  static void $checkItem(ProposalChatType v) {
    if (v is! ProposalChatType) $pb.checkItemFailed(v, 'ProposalChatType');
  }

  const ProposalChatType._(int v, String n) : super(v, n);
}

class ProposalState extends $pb.ProtobufEnum {
  static const ProposalState PS_PROPOSING = const ProposalState._(0, 'PS_PROPOSING');
  static const ProposalState PS_NEGOTIATING = const ProposalState._(1, 'PS_NEGOTIATING');
  static const ProposalState PS_DEAL = const ProposalState._(2, 'PS_DEAL');
  static const ProposalState PS_REJECTED = const ProposalState._(3, 'PS_REJECTED');
  static const ProposalState PS_DISPUTE = const ProposalState._(4, 'PS_DISPUTE');
  static const ProposalState PS_RESOLVED = const ProposalState._(5, 'PS_RESOLVED');
  static const ProposalState PS_COMPLETE = const ProposalState._(6, 'PS_COMPLETE');

  static const List<ProposalState> values = const <ProposalState> [
    PS_PROPOSING,
    PS_NEGOTIATING,
    PS_DEAL,
    PS_REJECTED,
    PS_DISPUTE,
    PS_RESOLVED,
    PS_COMPLETE,
  ];

  static final Map<int, ProposalState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ProposalState valueOf(int value) => _byValue[value];
  static void $checkItem(ProposalState v) {
    if (v is! ProposalState) $pb.checkItemFailed(v, 'ProposalState');
  }

  const ProposalState._(int v, String n) : super(v, n);
}

class ProposalChatMarker extends $pb.ProtobufEnum {
  static const ProposalChatMarker PCM_APPLIED = const ProposalChatMarker._(0, 'PCM_APPLIED');
  static const ProposalChatMarker PCM_WANT_DEAL = const ProposalChatMarker._(1, 'PCM_WANT_DEAL');
  static const ProposalChatMarker PCM_DEAL_MADE = const ProposalChatMarker._(2, 'PCM_DEAL_MADE');
  static const ProposalChatMarker PCM_REJECTED = const ProposalChatMarker._(3, 'PCM_REJECTED');
  static const ProposalChatMarker PCM_MARKED_COMPLETE = const ProposalChatMarker._(4, 'PCM_MARKED_COMPLETE');
  static const ProposalChatMarker PCM_COMPLETE = const ProposalChatMarker._(5, 'PCM_COMPLETE');
  static const ProposalChatMarker PCM_MARKED_DISPUTE = const ProposalChatMarker._(6, 'PCM_MARKED_DISPUTE');
  static const ProposalChatMarker PCM_RESOLVED = const ProposalChatMarker._(7, 'PCM_RESOLVED');
  static const ProposalChatMarker PCM_MESSAGE_DROPPED = const ProposalChatMarker._(8, 'PCM_MESSAGE_DROPPED');
  static const ProposalChatMarker PCM_DIRECT = const ProposalChatMarker._(9, 'PCM_DIRECT');
  static const ProposalChatMarker PCM_WANT_NEGOTIATE = const ProposalChatMarker._(10, 'PCM_WANT_NEGOTIATE');

  static const List<ProposalChatMarker> values = const <ProposalChatMarker> [
    PCM_APPLIED,
    PCM_WANT_DEAL,
    PCM_DEAL_MADE,
    PCM_REJECTED,
    PCM_MARKED_COMPLETE,
    PCM_COMPLETE,
    PCM_MARKED_DISPUTE,
    PCM_RESOLVED,
    PCM_MESSAGE_DROPPED,
    PCM_DIRECT,
    PCM_WANT_NEGOTIATE,
  ];

  static final Map<int, ProposalChatMarker> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ProposalChatMarker valueOf(int value) => _byValue[value];
  static void $checkItem(ProposalChatMarker v) {
    if (v is! ProposalChatMarker) $pb.checkItemFailed(v, 'ProposalChatMarker');
  }

  const ProposalChatMarker._(int v, String n) : super(v, n);
}

