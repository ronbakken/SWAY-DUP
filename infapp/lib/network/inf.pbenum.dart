///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class OAuthMechanism extends ProtobufEnum {
  static const OAuthMechanism OAM_NONE = const OAuthMechanism._(0, 'OAM_NONE');
  static const OAuthMechanism OAM_OAUTH1 =
      const OAuthMechanism._(1, 'OAM_OAUTH1');
  static const OAuthMechanism OAM_OAUTH2 =
      const OAuthMechanism._(2, 'OAM_OAUTH2');

  static const List<OAuthMechanism> values = const <OAuthMechanism>[
    OAM_NONE,
    OAM_OAUTH1,
    OAM_OAUTH2,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static OAuthMechanism valueOf(int value) => _byValue[value] as OAuthMechanism;
  static void $checkItem(OAuthMechanism v) {
    if (v is! OAuthMechanism) checkItemFailed(v, 'OAuthMechanism');
  }

  const OAuthMechanism._(int v, String n) : super(v, n);
}

class OAuthProviderIds extends ProtobufEnum {
  static const OAuthProviderIds OAP_NONE =
      const OAuthProviderIds._(0, 'OAP_NONE');
  static const OAuthProviderIds OAP_TWITTER =
      const OAuthProviderIds._(1, 'OAP_TWITTER');
  static const OAuthProviderIds OAP_FACEBOOK =
      const OAuthProviderIds._(2, 'OAP_FACEBOOK');

  static const List<OAuthProviderIds> values = const <OAuthProviderIds>[
    OAP_NONE,
    OAP_TWITTER,
    OAP_FACEBOOK,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static OAuthProviderIds valueOf(int value) =>
      _byValue[value] as OAuthProviderIds;
  static void $checkItem(OAuthProviderIds v) {
    if (v is! OAuthProviderIds) checkItemFailed(v, 'OAuthProviderIds');
  }

  const OAuthProviderIds._(int v, String n) : super(v, n);
}

class AccountType extends ProtobufEnum {
  static const AccountType AT_UNKNOWN = const AccountType._(0, 'AT_UNKNOWN');
  static const AccountType AT_INFLUENCER =
      const AccountType._(1, 'AT_INFLUENCER');
  static const AccountType AT_BUSINESS = const AccountType._(2, 'AT_BUSINESS');
  static const AccountType AT_SUPPORT = const AccountType._(3, 'AT_SUPPORT');

  static const List<AccountType> values = const <AccountType>[
    AT_UNKNOWN,
    AT_INFLUENCER,
    AT_BUSINESS,
    AT_SUPPORT,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static AccountType valueOf(int value) => _byValue[value] as AccountType;
  static void $checkItem(AccountType v) {
    if (v is! AccountType) checkItemFailed(v, 'AccountType');
  }

  const AccountType._(int v, String n) : super(v, n);
}

class GlobalAccountState extends ProtobufEnum {
  static const GlobalAccountState GAS_INITIALIZE =
      const GlobalAccountState._(0, 'GAS_INITIALIZE');
  static const GlobalAccountState GAS_BLOCKED =
      const GlobalAccountState._(1, 'GAS_BLOCKED');
  static const GlobalAccountState GAS_READ_ONLY =
      const GlobalAccountState._(2, 'GAS_READ_ONLY');
  static const GlobalAccountState GAS_READ_WRITE =
      const GlobalAccountState._(3, 'GAS_READ_WRITE');
  static const GlobalAccountState GAS_DEBUG =
      const GlobalAccountState._(4, 'GAS_DEBUG');
  static const GlobalAccountState GAS_SUPPORT =
      const GlobalAccountState._(5, 'GAS_SUPPORT');
  static const GlobalAccountState GAS_MANAGER =
      const GlobalAccountState._(6, 'GAS_MANAGER');
  static const GlobalAccountState GAS_GOD =
      const GlobalAccountState._(7, 'GAS_GOD');

  static const List<GlobalAccountState> values = const <GlobalAccountState>[
    GAS_INITIALIZE,
    GAS_BLOCKED,
    GAS_READ_ONLY,
    GAS_READ_WRITE,
    GAS_DEBUG,
    GAS_SUPPORT,
    GAS_MANAGER,
    GAS_GOD,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static GlobalAccountState valueOf(int value) =>
      _byValue[value] as GlobalAccountState;
  static void $checkItem(GlobalAccountState v) {
    if (v is! GlobalAccountState) checkItemFailed(v, 'GlobalAccountState');
  }

  const GlobalAccountState._(int v, String n) : super(v, n);
}

class GlobalAccountStateReason extends ProtobufEnum {
  static const GlobalAccountStateReason GASR_NEW_ACCOUNT =
      const GlobalAccountStateReason._(0, 'GASR_NEW_ACCOUNT');
  static const GlobalAccountStateReason GASR_ACCOUNT_BANNED =
      const GlobalAccountStateReason._(1, 'GASR_ACCOUNT_BANNED');
  static const GlobalAccountStateReason GASR_CREATE_DENIED =
      const GlobalAccountStateReason._(2, 'GASR_CREATE_DENIED');
  static const GlobalAccountStateReason GASR_APPROVED =
      const GlobalAccountStateReason._(3, 'GASR_APPROVED');
  static const GlobalAccountStateReason GASR_DEMO_APPROVED =
      const GlobalAccountStateReason._(4, 'GASR_DEMO_APPROVED');
  static const GlobalAccountStateReason GASR_PENDING =
      const GlobalAccountStateReason._(5, 'GASR_PENDING');
  static const GlobalAccountStateReason GASR_REQUIRE_INFO =
      const GlobalAccountStateReason._(6, 'GASR_REQUIRE_INFO');

  static const List<GlobalAccountStateReason> values =
      const <GlobalAccountStateReason>[
    GASR_NEW_ACCOUNT,
    GASR_ACCOUNT_BANNED,
    GASR_CREATE_DENIED,
    GASR_APPROVED,
    GASR_DEMO_APPROVED,
    GASR_PENDING,
    GASR_REQUIRE_INFO,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static GlobalAccountStateReason valueOf(int value) =>
      _byValue[value] as GlobalAccountStateReason;
  static void $checkItem(GlobalAccountStateReason v) {
    if (v is! GlobalAccountStateReason)
      checkItemFailed(v, 'GlobalAccountStateReason');
  }

  const GlobalAccountStateReason._(int v, String n) : super(v, n);
}

class NotificationFlags extends ProtobufEnum {
  static const NotificationFlags NF_ACCOUNT_STATE =
      const NotificationFlags._(0, 'NF_ACCOUNT_STATE');
  static const NotificationFlags NF_MAKE_AN_OFFER_FAB =
      const NotificationFlags._(1, 'NF_MAKE_AN_OFFER_FAB');
  static const NotificationFlags NF_UNREAD_MESSAGES =
      const NotificationFlags._(2, 'NF_UNREAD_MESSAGES');
  static const NotificationFlags NF_CS_REQUEST =
      const NotificationFlags._(3, 'NF_CS_REQUEST');

  static const List<NotificationFlags> values = const <NotificationFlags>[
    NF_ACCOUNT_STATE,
    NF_MAKE_AN_OFFER_FAB,
    NF_UNREAD_MESSAGES,
    NF_CS_REQUEST,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static NotificationFlags valueOf(int value) =>
      _byValue[value] as NotificationFlags;
  static void $checkItem(NotificationFlags v) {
    if (v is! NotificationFlags) checkItemFailed(v, 'NotificationFlags');
  }

  const NotificationFlags._(int v, String n) : super(v, n);
}

class BusinessOfferState extends ProtobufEnum {
  static const BusinessOfferState BOS_DRAFT =
      const BusinessOfferState._(0, 'BOS_DRAFT');
  static const BusinessOfferState BOS_OPEN =
      const BusinessOfferState._(1, 'BOS_OPEN');
  static const BusinessOfferState BOS_ACTIVE =
      const BusinessOfferState._(2, 'BOS_ACTIVE');
  static const BusinessOfferState BOS_CLOSED =
      const BusinessOfferState._(3, 'BOS_CLOSED');

  static const List<BusinessOfferState> values = const <BusinessOfferState>[
    BOS_DRAFT,
    BOS_OPEN,
    BOS_ACTIVE,
    BOS_CLOSED,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static BusinessOfferState valueOf(int value) =>
      _byValue[value] as BusinessOfferState;
  static void $checkItem(BusinessOfferState v) {
    if (v is! BusinessOfferState) checkItemFailed(v, 'BusinessOfferState');
  }

  const BusinessOfferState._(int v, String n) : super(v, n);
}

class BusinessOfferStateReason extends ProtobufEnum {
  static const BusinessOfferStateReason BOSR_NEW_OFFER =
      const BusinessOfferStateReason._(0, 'BOSR_NEW_OFFER');
  static const BusinessOfferStateReason BOSR_USER_CLOSED =
      const BusinessOfferStateReason._(1, 'BOSR_USER_CLOSED');
  static const BusinessOfferStateReason BOSR_TOS_VIOLATION =
      const BusinessOfferStateReason._(2, 'BOSR_TOS_VIOLATION');
  static const BusinessOfferStateReason BOSR_COMPLETED =
      const BusinessOfferStateReason._(3, 'BOSR_COMPLETED');

  static const List<BusinessOfferStateReason> values =
      const <BusinessOfferStateReason>[
    BOSR_NEW_OFFER,
    BOSR_USER_CLOSED,
    BOSR_TOS_VIOLATION,
    BOSR_COMPLETED,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static BusinessOfferStateReason valueOf(int value) =>
      _byValue[value] as BusinessOfferStateReason;
  static void $checkItem(BusinessOfferStateReason v) {
    if (v is! BusinessOfferStateReason)
      checkItemFailed(v, 'BusinessOfferStateReason');
  }

  const BusinessOfferStateReason._(int v, String n) : super(v, n);
}

class ApplicantChatType extends ProtobufEnum {
  static const ApplicantChatType ACT_PLAIN =
      const ApplicantChatType._(0, 'ACT_PLAIN');
  static const ApplicantChatType ACT_HAGGLE =
      const ApplicantChatType._(1, 'ACT_HAGGLE');
  static const ApplicantChatType ACT_IMAGE_KEY =
      const ApplicantChatType._(2, 'ACT_IMAGE_KEY');

  static const List<ApplicantChatType> values = const <ApplicantChatType>[
    ACT_PLAIN,
    ACT_HAGGLE,
    ACT_IMAGE_KEY,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static ApplicantChatType valueOf(int value) =>
      _byValue[value] as ApplicantChatType;
  static void $checkItem(ApplicantChatType v) {
    if (v is! ApplicantChatType) checkItemFailed(v, 'ApplicantChatType');
  }

  const ApplicantChatType._(int v, String n) : super(v, n);
}

class ApplicantState extends ProtobufEnum {
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

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static ApplicantState valueOf(int value) => _byValue[value] as ApplicantState;
  static void $checkItem(ApplicantState v) {
    if (v is! ApplicantState) checkItemFailed(v, 'ApplicantState');
  }

  const ApplicantState._(int v, String n) : super(v, n);
}

class ApplicantChatMarker extends ProtobufEnum {
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

  static const List<ApplicantChatMarker> values = const <ApplicantChatMarker>[
    ACM_APPLIED,
    ACM_WANT_DEAL,
    ACM_DEAL_MADE,
    ACM_REJECTED,
    ACM_MARKED_COMPLETE,
    ACM_COMPLETE,
    ACM_MARKED_DISPUTE,
    ACM_RESOLVED,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static ApplicantChatMarker valueOf(int value) =>
      _byValue[value] as ApplicantChatMarker;
  static void $checkItem(ApplicantChatMarker v) {
    if (v is! ApplicantChatMarker) checkItemFailed(v, 'ApplicantChatMarker');
  }

  const ApplicantChatMarker._(int v, String n) : super(v, n);
}
