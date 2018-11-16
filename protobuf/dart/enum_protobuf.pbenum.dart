///
//  Generated code. Do not modify.
//  source: enum_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class OAuthMechanism extends $pb.ProtobufEnum {
  static const OAuthMechanism none = const OAuthMechanism._(0, 'OAM_NONE');
  static const OAuthMechanism oauth1 =
      const OAuthMechanism._(1, 'OAM_OAUTH1');
  static const OAuthMechanism oauth2 =
      const OAuthMechanism._(2, 'OAM_OAUTH2');

  static const List<OAuthMechanism> values = const <OAuthMechanism>[
    none,
    oauth1,
    oauth2,
  ];

  static final Map<int, OAuthMechanism> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OAuthMechanism valueOf(int value) => _byValue[value];
  static void $checkItem(OAuthMechanism v) {
    if (v is! OAuthMechanism) $pb.checkItemFailed(v, 'OAuthMechanism');
  }

  const OAuthMechanism._(int v, String n) : super(v, n);
}

class OAuthProviderIds extends $pb.ProtobufEnum {
  static const OAuthProviderIds none =
      const OAuthProviderIds._(0, 'OAP_NONE');
  static const OAuthProviderIds twitter =
      const OAuthProviderIds._(1, 'OAP_TWITTER');
  static const OAuthProviderIds facebook =
      const OAuthProviderIds._(2, 'OAP_FACEBOOK');

  static const List<OAuthProviderIds> values = const <OAuthProviderIds>[
    none,
    twitter,
    facebook,
  ];

  static final Map<int, OAuthProviderIds> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OAuthProviderIds valueOf(int value) => _byValue[value];
  static void $checkItem(OAuthProviderIds v) {
    if (v is! OAuthProviderIds) $pb.checkItemFailed(v, 'OAuthProviderIds');
  }

  const OAuthProviderIds._(int v, String n) : super(v, n);
}

class AccountType extends $pb.ProtobufEnum {
  static const AccountType unknown = const AccountType._(0, 'AT_UNKNOWN');
  static const AccountType influencer =
      const AccountType._(1, 'AT_INFLUENCER');
  static const AccountType business = const AccountType._(2, 'AT_BUSINESS');
  static const AccountType support = const AccountType._(3, 'AT_SUPPORT');

  static const List<AccountType> values = const <AccountType>[
    unknown,
    influencer,
    business,
    support,
  ];

  static final Map<int, AccountType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static AccountType valueOf(int value) => _byValue[value];
  static void $checkItem(AccountType v) {
    if (v is! AccountType) $pb.checkItemFailed(v, 'AccountType');
  }

  const AccountType._(int v, String n) : super(v, n);
}

class GlobalAccountState extends $pb.ProtobufEnum {
  static const GlobalAccountState initialize =
      const GlobalAccountState._(0, 'GAS_INITIALIZE');
  static const GlobalAccountState blocked =
      const GlobalAccountState._(1, 'GAS_BLOCKED');
  static const GlobalAccountState readOnly =
      const GlobalAccountState._(2, 'GAS_READ_ONLY');
  static const GlobalAccountState readWrite =
      const GlobalAccountState._(3, 'GAS_READ_WRITE');
  static const GlobalAccountState debug =
      const GlobalAccountState._(4, 'GAS_DEBUG');
  static const GlobalAccountState support =
      const GlobalAccountState._(5, 'GAS_SUPPORT');
  static const GlobalAccountState manager =
      const GlobalAccountState._(6, 'GAS_MANAGER');
  static const GlobalAccountState god =
      const GlobalAccountState._(7, 'GAS_GOD');

  static const List<GlobalAccountState> values = const <GlobalAccountState>[
    initialize,
    blocked,
    readOnly,
    readWrite,
    debug,
    support,
    manager,
    god,
  ];

  static final Map<int, GlobalAccountState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static GlobalAccountState valueOf(int value) => _byValue[value];
  static void $checkItem(GlobalAccountState v) {
    if (v is! GlobalAccountState) $pb.checkItemFailed(v, 'GlobalAccountState');
  }

  const GlobalAccountState._(int v, String n) : super(v, n);
}

class GlobalAccountStateReason extends $pb.ProtobufEnum {
  static const GlobalAccountStateReason newAccount =
      const GlobalAccountStateReason._(0, 'GASR_NEW_ACCOUNT');
  static const GlobalAccountStateReason accountBanned =
      const GlobalAccountStateReason._(1, 'GASR_ACCOUNT_BANNED');
  static const GlobalAccountStateReason createDenied =
      const GlobalAccountStateReason._(2, 'GASR_CREATE_DENIED');
  static const GlobalAccountStateReason approved =
      const GlobalAccountStateReason._(3, 'GASR_APPROVED');
  static const GlobalAccountStateReason demoApproved =
      const GlobalAccountStateReason._(4, 'GASR_DEMO_APPROVED');
  static const GlobalAccountStateReason pending =
      const GlobalAccountStateReason._(5, 'GASR_PENDING');
  static const GlobalAccountStateReason requireInfo =
      const GlobalAccountStateReason._(6, 'GASR_REQUIRE_INFO');

  static const List<GlobalAccountStateReason> values =
      const <GlobalAccountStateReason>[
    newAccount,
    accountBanned,
    createDenied,
    approved,
    demoApproved,
    pending,
    requireInfo,
  ];

  static final Map<int, GlobalAccountStateReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static GlobalAccountStateReason valueOf(int value) => _byValue[value];
  static void $checkItem(GlobalAccountStateReason v) {
    if (v is! GlobalAccountStateReason)
      $pb.checkItemFailed(v, 'GlobalAccountStateReason');
  }

  const GlobalAccountStateReason._(int v, String n) : super(v, n);
}

class NotificationFlags extends $pb.ProtobufEnum {
  static const NotificationFlags accountState =
      const NotificationFlags._(0, 'NF_ACCOUNT_STATE');
  static const NotificationFlags makeAnOfferHint =
      const NotificationFlags._(1, 'NF_MAKE_AN_OFFER_HINT');
  static const NotificationFlags unreadMessages =
      const NotificationFlags._(2, 'NF_UNREAD_MESSAGES');
  static const NotificationFlags supportRequest =
      const NotificationFlags._(3, 'NF_SUPPORT_REQUEST');
  static const NotificationFlags onboarding =
      const NotificationFlags._(4, 'NF_ONBOARDING');

  static const List<NotificationFlags> values = const <NotificationFlags>[
    accountState,
    makeAnOfferHint,
    unreadMessages,
    supportRequest,
    onboarding,
  ];

  static final Map<int, NotificationFlags> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static NotificationFlags valueOf(int value) => _byValue[value];
  static void $checkItem(NotificationFlags v) {
    if (v is! NotificationFlags) $pb.checkItemFailed(v, 'NotificationFlags');
  }

  const NotificationFlags._(int v, String n) : super(v, n);
}

class OfferState extends $pb.ProtobufEnum {
  static const OfferState draft = const OfferState._(0, 'OS_DRAFT');
  static const OfferState open = const OfferState._(1, 'OS_OPEN');
  static const OfferState closed = const OfferState._(2, 'OS_CLOSED');

  static const List<OfferState> values = const <OfferState>[
    draft,
    open,
    closed,
  ];

  static final Map<int, OfferState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OfferState valueOf(int value) => _byValue[value];
  static void $checkItem(OfferState v) {
    if (v is! OfferState) $pb.checkItemFailed(v, 'OfferState');
  }

  const OfferState._(int v, String n) : super(v, n);
}

class OfferStateReason extends $pb.ProtobufEnum {
  static const OfferStateReason newOffer =
      const OfferStateReason._(0, 'OSR_NEW_OFFER');
  static const OfferStateReason userClosed =
      const OfferStateReason._(1, 'OSR_USER_CLOSED');
  static const OfferStateReason tosViolation =
      const OfferStateReason._(2, 'OSR_TOS_VIOLATION');
  static const OfferStateReason completed =
      const OfferStateReason._(3, 'OSR_COMPLETED');

  static const List<OfferStateReason> values = const <OfferStateReason>[
    newOffer,
    userClosed,
    tosViolation,
    completed,
  ];

  static final Map<int, OfferStateReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OfferStateReason valueOf(int value) => _byValue[value];
  static void $checkItem(OfferStateReason v) {
    if (v is! OfferStateReason) $pb.checkItemFailed(v, 'OfferStateReason');
  }

  const OfferStateReason._(int v, String n) : super(v, n);
}

class ProposalChatType extends $pb.ProtobufEnum {
  static const ProposalChatType plain =
      const ProposalChatType._(0, 'PCT_PLAIN');
  static const ProposalChatType terms =
      const ProposalChatType._(1, 'PCT_TERMS');
  static const ProposalChatType imageKey =
      const ProposalChatType._(2, 'PCT_IMAGE_KEY');
  static const ProposalChatType marker =
      const ProposalChatType._(3, 'PCT_MARKER');

  static const List<ProposalChatType> values = const <ProposalChatType>[
    plain,
    terms,
    imageKey,
    marker,
  ];

  static final Map<int, ProposalChatType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ProposalChatType valueOf(int value) => _byValue[value];
  static void $checkItem(ProposalChatType v) {
    if (v is! ProposalChatType) $pb.checkItemFailed(v, 'ProposalChatType');
  }

  const ProposalChatType._(int v, String n) : super(v, n);
}

class ProposalState extends $pb.ProtobufEnum {
  static const ProposalState proposing =
      const ProposalState._(0, 'PS_PROPOSING');
  static const ProposalState negotiating =
      const ProposalState._(1, 'PS_NEGOTIATING');
  static const ProposalState deal = const ProposalState._(2, 'PS_DEAL');
  static const ProposalState rejected =
      const ProposalState._(3, 'PS_REJECTED');
  static const ProposalState dispute =
      const ProposalState._(4, 'PS_DISPUTE');
  static const ProposalState resolved =
      const ProposalState._(5, 'PS_RESOLVED');
  static const ProposalState complete =
      const ProposalState._(6, 'PS_COMPLETE');

  static const List<ProposalState> values = const <ProposalState>[
    proposing,
    negotiating,
    deal,
    rejected,
    dispute,
    resolved,
    complete,
  ];

  static final Map<int, ProposalState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ProposalState valueOf(int value) => _byValue[value];
  static void $checkItem(ProposalState v) {
    if (v is! ProposalState) $pb.checkItemFailed(v, 'ProposalState');
  }

  const ProposalState._(int v, String n) : super(v, n);
}

class ProposalChatMarker extends $pb.ProtobufEnum {
  static const ProposalChatMarker applied =
      const ProposalChatMarker._(0, 'PCM_APPLIED');
  static const ProposalChatMarker wantDeal =
      const ProposalChatMarker._(1, 'PCM_WANT_DEAL');
  static const ProposalChatMarker dealMade =
      const ProposalChatMarker._(2, 'PCM_DEAL_MADE');
  static const ProposalChatMarker rejected =
      const ProposalChatMarker._(3, 'PCM_REJECTED');
  static const ProposalChatMarker markedComplete =
      const ProposalChatMarker._(4, 'PCM_MARKED_COMPLETE');
  static const ProposalChatMarker complete =
      const ProposalChatMarker._(5, 'PCM_COMPLETE');
  static const ProposalChatMarker markedDispute =
      const ProposalChatMarker._(6, 'PCM_MARKED_DISPUTE');
  static const ProposalChatMarker resolved =
      const ProposalChatMarker._(7, 'PCM_RESOLVED');
  static const ProposalChatMarker messageDropped =
      const ProposalChatMarker._(8, 'PCM_MESSAGE_DROPPED');
  static const ProposalChatMarker direct =
      const ProposalChatMarker._(9, 'PCM_DIRECT');
  static const ProposalChatMarker wantNegotiate =
      const ProposalChatMarker._(10, 'PCM_WANT_NEGOTIATE');

  static const List<ProposalChatMarker> values = const <ProposalChatMarker>[
    applied,
    wantDeal,
    dealMade,
    rejected,
    markedComplete,
    complete,
    markedDispute,
    resolved,
    messageDropped,
    direct,
    wantNegotiate,
  ];

  static final Map<int, ProposalChatMarker> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ProposalChatMarker valueOf(int value) => _byValue[value];
  static void $checkItem(ProposalChatMarker v) {
    if (v is! ProposalChatMarker) $pb.checkItemFailed(v, 'ProposalChatMarker');
  }

  const ProposalChatMarker._(int v, String n) : super(v, n);
}
