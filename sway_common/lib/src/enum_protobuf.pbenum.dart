///
//  Generated code. Do not modify.
//  source: enum_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class OAuthMechanism extends $pb.ProtobufEnum {
  static const OAuthMechanism none = OAuthMechanism._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OAM_NONE');
  static const OAuthMechanism oauth1 = OAuthMechanism._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OAM_OAUTH1');
  static const OAuthMechanism oauth2 = OAuthMechanism._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OAM_OAUTH2');

  static const $core.List<OAuthMechanism> values = <OAuthMechanism>[
    none,
    oauth1,
    oauth2,
  ];

  static final $core.Map<$core.int, OAuthMechanism> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OAuthMechanism valueOf($core.int value) => _byValue[value];

  const OAuthMechanism._($core.int v, $core.String n) : super(v, n);
}

class OAuthProviderIds extends $pb.ProtobufEnum {
  static const OAuthProviderIds none = OAuthProviderIds._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OAP_NONE');
  static const OAuthProviderIds twitter = OAuthProviderIds._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OAP_TWITTER');
  static const OAuthProviderIds facebook = OAuthProviderIds._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OAP_FACEBOOK');

  static const $core.List<OAuthProviderIds> values = <OAuthProviderIds>[
    none,
    twitter,
    facebook,
  ];

  static final $core.Map<$core.int, OAuthProviderIds> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OAuthProviderIds valueOf($core.int value) => _byValue[value];

  const OAuthProviderIds._($core.int v, $core.String n) : super(v, n);
}

class AccountType extends $pb.ProtobufEnum {
  static const AccountType unknown = AccountType._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'AT_UNKNOWN');
  static const AccountType influencer = AccountType._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'AT_INFLUENCER');
  static const AccountType business = AccountType._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'AT_BUSINESS');
  static const AccountType support = AccountType._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'AT_SUPPORT');

  static const $core.List<AccountType> values = <AccountType>[
    unknown,
    influencer,
    business,
    support,
  ];

  static final $core.Map<$core.int, AccountType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static AccountType valueOf($core.int value) => _byValue[value];

  const AccountType._($core.int v, $core.String n) : super(v, n);
}

class GlobalAccountState extends $pb.ProtobufEnum {
  static const GlobalAccountState initialize = GlobalAccountState._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_INITIALIZE');
  static const GlobalAccountState blocked = GlobalAccountState._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_BLOCKED');
  static const GlobalAccountState pending = GlobalAccountState._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_PENDING');
  static const GlobalAccountState readOnly = GlobalAccountState._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_READ_ONLY');
  static const GlobalAccountState readWrite = GlobalAccountState._(
      4,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_READ_WRITE');
  static const GlobalAccountState debug = GlobalAccountState._(
      5,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_DEBUG');
  static const GlobalAccountState support = GlobalAccountState._(
      6,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_SUPPORT');
  static const GlobalAccountState manager = GlobalAccountState._(
      7,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_MANAGER');
  static const GlobalAccountState god = GlobalAccountState._(
      8,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GAS_GOD');

  static const $core.List<GlobalAccountState> values = <GlobalAccountState>[
    initialize,
    blocked,
    pending,
    readOnly,
    readWrite,
    debug,
    support,
    manager,
    god,
  ];

  static final $core.Map<$core.int, GlobalAccountState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static GlobalAccountState valueOf($core.int value) => _byValue[value];

  const GlobalAccountState._($core.int v, $core.String n) : super(v, n);
}

class GlobalAccountStateReason extends $pb.ProtobufEnum {
  static const GlobalAccountStateReason newAccount = GlobalAccountStateReason._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GASR_NEW_ACCOUNT');
  static const GlobalAccountStateReason accountBanned =
      GlobalAccountStateReason._(
          1,
          const $core.bool.fromEnvironment('protobuf.omit_enum_names')
              ? ''
              : 'GASR_ACCOUNT_BANNED');
  static const GlobalAccountStateReason createDenied =
      GlobalAccountStateReason._(
          2,
          const $core.bool.fromEnvironment('protobuf.omit_enum_names')
              ? ''
              : 'GASR_CREATE_DENIED');
  static const GlobalAccountStateReason approved = GlobalAccountStateReason._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GASR_APPROVED');
  static const GlobalAccountStateReason demoApproved =
      GlobalAccountStateReason._(
          4,
          const $core.bool.fromEnvironment('protobuf.omit_enum_names')
              ? ''
              : 'GASR_DEMO_APPROVED');
  static const GlobalAccountStateReason pending = GlobalAccountStateReason._(
      5,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'GASR_PENDING');
  static const GlobalAccountStateReason requireInfo =
      GlobalAccountStateReason._(
          6,
          const $core.bool.fromEnvironment('protobuf.omit_enum_names')
              ? ''
              : 'GASR_REQUIRE_INFO');

  static const $core.List<GlobalAccountStateReason> values =
      <GlobalAccountStateReason>[
    newAccount,
    accountBanned,
    createDenied,
    approved,
    demoApproved,
    pending,
    requireInfo,
  ];

  static final $core.Map<$core.int, GlobalAccountStateReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static GlobalAccountStateReason valueOf($core.int value) => _byValue[value];

  const GlobalAccountStateReason._($core.int v, $core.String n) : super(v, n);
}

class AccountLevel extends $pb.ProtobufEnum {
  static const AccountLevel free = AccountLevel._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'AL_FREE');
  static const AccountLevel premium = AccountLevel._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'AL_PREMIUM');
  static const AccountLevel pro = AccountLevel._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'AL_PRO');

  static const $core.List<AccountLevel> values = <AccountLevel>[
    free,
    premium,
    pro,
  ];

  static final $core.Map<$core.int, AccountLevel> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static AccountLevel valueOf($core.int value) => _byValue[value];

  const AccountLevel._($core.int v, $core.String n) : super(v, n);
}

class NotificationFlags extends $pb.ProtobufEnum {
  static const NotificationFlags accountState = NotificationFlags._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'NF_ACCOUNT_STATE');
  static const NotificationFlags makeAnOfferHint = NotificationFlags._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'NF_MAKE_AN_OFFER_HINT');
  static const NotificationFlags unreadMessages = NotificationFlags._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'NF_UNREAD_MESSAGES');
  static const NotificationFlags supportRequest = NotificationFlags._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'NF_SUPPORT_REQUEST');
  static const NotificationFlags onboarding = NotificationFlags._(
      4,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'NF_ONBOARDING');

  static const $core.List<NotificationFlags> values = <NotificationFlags>[
    accountState,
    makeAnOfferHint,
    unreadMessages,
    supportRequest,
    onboarding,
  ];

  static final $core.Map<$core.int, NotificationFlags> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static NotificationFlags valueOf($core.int value) => _byValue[value];

  const NotificationFlags._($core.int v, $core.String n) : super(v, n);
}

class OfferState extends $pb.ProtobufEnum {
  static const OfferState draft = OfferState._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OS_DRAFT');
  static const OfferState scheduled = OfferState._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OS_SCHEDULED');
  static const OfferState open = OfferState._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OS_OPEN');
  static const OfferState closed = OfferState._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OS_CLOSED');

  static const $core.List<OfferState> values = <OfferState>[
    draft,
    scheduled,
    open,
    closed,
  ];

  static final $core.Map<$core.int, OfferState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OfferState valueOf($core.int value) => _byValue[value];

  const OfferState._($core.int v, $core.String n) : super(v, n);
}

class OfferStateReason extends $pb.ProtobufEnum {
  static const OfferStateReason newOffer = OfferStateReason._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OSR_NEW_OFFER');
  static const OfferStateReason userClosed = OfferStateReason._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OSR_USER_CLOSED');
  static const OfferStateReason tosViolation = OfferStateReason._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OSR_TOS_VIOLATION');
  static const OfferStateReason completed = OfferStateReason._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'OSR_COMPLETED');

  static const $core.List<OfferStateReason> values = <OfferStateReason>[
    newOffer,
    userClosed,
    tosViolation,
    completed,
  ];

  static final $core.Map<$core.int, OfferStateReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static OfferStateReason valueOf($core.int value) => _byValue[value];

  const OfferStateReason._($core.int v, $core.String n) : super(v, n);
}

class ProposalChatType extends $pb.ProtobufEnum {
  static const ProposalChatType plain = ProposalChatType._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCT_PLAIN');
  static const ProposalChatType negotiate = ProposalChatType._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCT_NEGOTIATE');
  static const ProposalChatType imageKey = ProposalChatType._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCT_IMAGE_KEY');
  static const ProposalChatType marker = ProposalChatType._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCT_MARKER');

  static const $core.List<ProposalChatType> values = <ProposalChatType>[
    plain,
    negotiate,
    imageKey,
    marker,
  ];

  static final $core.Map<$core.int, ProposalChatType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ProposalChatType valueOf($core.int value) => _byValue[value];

  const ProposalChatType._($core.int v, $core.String n) : super(v, n);
}

class ProposalState extends $pb.ProtobufEnum {
  static const ProposalState proposing = ProposalState._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PS_PROPOSING');
  static const ProposalState negotiating = ProposalState._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PS_NEGOTIATING');
  static const ProposalState deal = ProposalState._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PS_DEAL');
  static const ProposalState rejected = ProposalState._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PS_REJECTED');
  static const ProposalState dispute = ProposalState._(
      4,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PS_DISPUTE');
  static const ProposalState resolved = ProposalState._(
      5,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PS_RESOLVED');
  static const ProposalState complete = ProposalState._(
      6,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PS_COMPLETE');

  static const $core.List<ProposalState> values = <ProposalState>[
    proposing,
    negotiating,
    deal,
    rejected,
    dispute,
    resolved,
    complete,
  ];

  static final $core.Map<$core.int, ProposalState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ProposalState valueOf($core.int value) => _byValue[value];

  const ProposalState._($core.int v, $core.String n) : super(v, n);
}

class ProposalChatMarker extends $pb.ProtobufEnum {
  static const ProposalChatMarker applied = ProposalChatMarker._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_APPLIED');
  static const ProposalChatMarker wantDeal = ProposalChatMarker._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_WANT_DEAL');
  static const ProposalChatMarker dealMade = ProposalChatMarker._(
      2,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_DEAL_MADE');
  static const ProposalChatMarker rejected = ProposalChatMarker._(
      3,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_REJECTED');
  static const ProposalChatMarker markedComplete = ProposalChatMarker._(
      4,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_MARKED_COMPLETE');
  static const ProposalChatMarker complete = ProposalChatMarker._(
      5,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_COMPLETE');
  static const ProposalChatMarker markedDispute = ProposalChatMarker._(
      6,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_MARKED_DISPUTE');
  static const ProposalChatMarker resolved = ProposalChatMarker._(
      7,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_RESOLVED');
  static const ProposalChatMarker messageDropped = ProposalChatMarker._(
      8,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_MESSAGE_DROPPED');
  static const ProposalChatMarker direct = ProposalChatMarker._(
      9,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_DIRECT');
  static const ProposalChatMarker wantNegotiate = ProposalChatMarker._(
      10,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PCM_WANT_NEGOTIATE');

  static const $core.List<ProposalChatMarker> values = <ProposalChatMarker>[
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

  static final $core.Map<$core.int, ProposalChatMarker> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ProposalChatMarker valueOf($core.int value) => _byValue[value];

  const ProposalChatMarker._($core.int v, $core.String n) : super(v, n);
}

class PromoCode extends $pb.ProtobufEnum {
  static const PromoCode unknown = PromoCode._(
      0,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PC_UNKNOWN');
  static const PromoCode activateAccount = PromoCode._(
      1,
      const $core.bool.fromEnvironment('protobuf.omit_enum_names')
          ? ''
          : 'PC_ACTIVATE_ACCOUNT');

  static const $core.List<PromoCode> values = <PromoCode>[
    unknown,
    activateAccount,
  ];

  static final $core.Map<$core.int, PromoCode> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static PromoCode valueOf($core.int value) => _byValue[value];

  const PromoCode._($core.int v, $core.String n) : super(v, n);
}
