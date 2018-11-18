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
  static const NotificationFlags NF_MAKE_AN_OFFER_FAB =
      const NotificationFlags._(1, 'NF_MAKE_AN_OFFER_FAB');
  static const NotificationFlags unreadMessages =
      const NotificationFlags._(2, 'NF_UNREAD_MESSAGES');
  static const NotificationFlags NF_CS_REQUEST =
      const NotificationFlags._(3, 'NF_CS_REQUEST');

  static const List<NotificationFlags> values = const <NotificationFlags>[
    accountState,
    NF_MAKE_AN_OFFER_FAB,
    unreadMessages,
    NF_CS_REQUEST,
  ];

  static final Map<int, NotificationFlags> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static NotificationFlags valueOf(int value) => _byValue[value];
  static void $checkItem(NotificationFlags v) {
    if (v is! NotificationFlags) $pb.checkItemFailed(v, 'NotificationFlags');
  }

  const NotificationFlags._(int v, String n) : super(v, n);
}

class BusinessOfferState extends $pb.ProtobufEnum {
  static const BusinessOfferState Bdraft =
      const BusinessOfferState._(0, 'Bdraft');
  static const BusinessOfferState Bopen =
      const BusinessOfferState._(1, 'Bopen');
  static const BusinessOfferState BOS_ACTIVE =
      const BusinessOfferState._(2, 'BOS_ACTIVE');
  static const BusinessOfferState Bclosed =
      const BusinessOfferState._(3, 'Bclosed');

  static const List<BusinessOfferState> values = const <BusinessOfferState>[
    Bdraft,
    Bopen,
    BOS_ACTIVE,
    Bclosed,
  ];

  static final Map<int, BusinessOfferState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static BusinessOfferState valueOf(int value) => _byValue[value];
  static void $checkItem(BusinessOfferState v) {
    if (v is! BusinessOfferState) $pb.checkItemFailed(v, 'BusinessOfferState');
  }

  const BusinessOfferState._(int v, String n) : super(v, n);
}

class BusinessOfferStateReason extends $pb.ProtobufEnum {
  static const BusinessOfferStateReason BnewOffer =
      const BusinessOfferStateReason._(0, 'BnewOffer');
  static const BusinessOfferStateReason BuserClosed =
      const BusinessOfferStateReason._(1, 'BuserClosed');
  static const BusinessOfferStateReason BtosViolation =
      const BusinessOfferStateReason._(2, 'BtosViolation');
  static const BusinessOfferStateReason Bcompleted =
      const BusinessOfferStateReason._(3, 'Bcompleted');

  static const List<BusinessOfferStateReason> values =
      const <BusinessOfferStateReason>[
    BnewOffer,
    BuserClosed,
    BtosViolation,
    Bcompleted,
  ];

  static final Map<int, BusinessOfferStateReason> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static BusinessOfferStateReason valueOf(int value) => _byValue[value];
  static void $checkItem(BusinessOfferStateReason v) {
    if (v is! BusinessOfferStateReason)
      $pb.checkItemFailed(v, 'BusinessOfferStateReason');
  }

  const BusinessOfferStateReason._(int v, String n) : super(v, n);
}

class ApplicantChatType extends $pb.ProtobufEnum {
  static const ApplicantChatType ACT_PLAIN =
      const ApplicantChatType._(0, 'ACT_PLAIN');
  static const ApplicantChatType ACT_HAGGLE =
      const ApplicantChatType._(1, 'ACT_HAGGLE');
  static const ApplicantChatType ACT_IMAGE_KEY =
      const ApplicantChatType._(2, 'ACT_IMAGE_KEY');
  static const ApplicantChatType ACT_MARKER =
      const ApplicantChatType._(3, 'ACT_MARKER');

  static const List<ApplicantChatType> values = const <ApplicantChatType>[
    ACT_PLAIN,
    ACT_HAGGLE,
    ACT_IMAGE_KEY,
    ACT_MARKER,
  ];

  static final Map<int, ApplicantChatType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ApplicantChatType valueOf(int value) => _byValue[value];
  static void $checkItem(ApplicantChatType v) {
    if (v is! ApplicantChatType) $pb.checkItemFailed(v, 'ApplicantChatType');
  }

  const ApplicantChatType._(int v, String n) : super(v, n);
}

class ApplicantState extends $pb.ProtobufEnum {
  static const ApplicantState AS_HAGGLING =
      const ApplicantState._(0, 'AS_HAGGLING');
  static const ApplicantState AS_DEAL = const ApplicantState._(1, 'AS_DEAL');
  static const ApplicantState AS_REJECTED =
      const ApplicantState._(2, 'AS_REJECTED');
  static const ApplicantState AS_COMPLETE =
      const ApplicantState._(3, 'AS_COMPLETE');
  static const ApplicantState AS_DISPUTE =
      const ApplicantState._(4, 'AS_DISPUTE');
  static const ApplicantState AS_RESOLVED =
      const ApplicantState._(5, 'AS_RESOLVED');

  static const List<ApplicantState> values = const <ApplicantState>[
    AS_HAGGLING,
    AS_DEAL,
    AS_REJECTED,
    AS_COMPLETE,
    AS_DISPUTE,
    AS_RESOLVED,
  ];

  static final Map<int, ApplicantState> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ApplicantState valueOf(int value) => _byValue[value];
  static void $checkItem(ApplicantState v) {
    if (v is! ApplicantState) $pb.checkItemFailed(v, 'ApplicantState');
  }

  const ApplicantState._(int v, String n) : super(v, n);
}

class ApplicantChatMarker extends $pb.ProtobufEnum {
  static const ApplicantChatMarker ACM_APPLIED =
      const ApplicantChatMarker._(0, 'ACM_APPLIED');
  static const ApplicantChatMarker ACM_WANT_DEAL =
      const ApplicantChatMarker._(1, 'ACM_WANT_DEAL');
  static const ApplicantChatMarker ACM_DEAL_MADE =
      const ApplicantChatMarker._(2, 'ACM_DEAL_MADE');
  static const ApplicantChatMarker ACM_REJECTED =
      const ApplicantChatMarker._(3, 'ACM_REJECTED');
  static const ApplicantChatMarker ACM_MARKED_COMPLETE =
      const ApplicantChatMarker._(4, 'ACM_MARKED_COMPLETE');
  static const ApplicantChatMarker ACM_COMPLETE =
      const ApplicantChatMarker._(5, 'ACM_COMPLETE');
  static const ApplicantChatMarker ACM_MARKED_DISPUTE =
      const ApplicantChatMarker._(6, 'ACM_MARKED_DISPUTE');
  static const ApplicantChatMarker ACM_RESOLVED =
      const ApplicantChatMarker._(7, 'ACM_RESOLVED');
  static const ApplicantChatMarker ACM_MESSAGE_DROPPED =
      const ApplicantChatMarker._(8, 'ACM_MESSAGE_DROPPED');

  static const List<ApplicantChatMarker> values = const <ApplicantChatMarker>[
    ACM_APPLIED,
    ACM_WANT_DEAL,
    ACM_DEAL_MADE,
    ACM_REJECTED,
    ACM_MARKED_COMPLETE,
    ACM_COMPLETE,
    ACM_MARKED_DISPUTE,
    ACM_RESOLVED,
    ACM_MESSAGE_DROPPED,
  ];

  static final Map<int, ApplicantChatMarker> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ApplicantChatMarker valueOf(int value) => _byValue[value];
  static void $checkItem(ApplicantChatMarker v) {
    if (v is! ApplicantChatMarker)
      $pb.checkItemFailed(v, 'ApplicantChatMarker');
  }

  const ApplicantChatMarker._(int v, String n) : super(v, n);
}
