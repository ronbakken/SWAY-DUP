///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class AccountType extends ProtobufEnum {
  static const AccountType AT_UNKNOWN = const AccountType._(0, 'AT_UNKNOWN');
  static const AccountType AT_INFLUENCER = const AccountType._(1, 'AT_INFLUENCER');
  static const AccountType AT_BUSINESS = const AccountType._(2, 'AT_BUSINESS');

  static const List<AccountType> values = const <AccountType> [
    AT_UNKNOWN,
    AT_INFLUENCER,
    AT_BUSINESS,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static AccountType valueOf(int value) => _byValue[value] as AccountType;
  static void $checkItem(AccountType v) {
    if (v is! AccountType) checkItemFailed(v, 'AccountType');
  }

  const AccountType._(int v, String n) : super(v, n);
}

class GlobalAccountState extends ProtobufEnum {
  static const GlobalAccountState GAS_INITIALIZE = const GlobalAccountState._(0, 'GAS_INITIALIZE');
  static const GlobalAccountState GAS_BLOCKED = const GlobalAccountState._(1, 'GAS_BLOCKED');
  static const GlobalAccountState GAS_READ_ONLY = const GlobalAccountState._(2, 'GAS_READ_ONLY');
  static const GlobalAccountState GAS_READ_WRITE = const GlobalAccountState._(3, 'GAS_READ_WRITE');
  static const GlobalAccountState GAS_MODERATOR = const GlobalAccountState._(4, 'GAS_MODERATOR');
  static const GlobalAccountState GAS_ADMIN = const GlobalAccountState._(5, 'GAS_ADMIN');
  static const GlobalAccountState GAS_GOD = const GlobalAccountState._(6, 'GAS_GOD');

  static const List<GlobalAccountState> values = const <GlobalAccountState> [
    GAS_INITIALIZE,
    GAS_BLOCKED,
    GAS_READ_ONLY,
    GAS_READ_WRITE,
    GAS_MODERATOR,
    GAS_ADMIN,
    GAS_GOD,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static GlobalAccountState valueOf(int value) => _byValue[value] as GlobalAccountState;
  static void $checkItem(GlobalAccountState v) {
    if (v is! GlobalAccountState) checkItemFailed(v, 'GlobalAccountState');
  }

  const GlobalAccountState._(int v, String n) : super(v, n);
}

class GlobalAccountStateReason extends ProtobufEnum {
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

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static GlobalAccountStateReason valueOf(int value) => _byValue[value] as GlobalAccountStateReason;
  static void $checkItem(GlobalAccountStateReason v) {
    if (v is! GlobalAccountStateReason) checkItemFailed(v, 'GlobalAccountStateReason');
  }

  const GlobalAccountStateReason._(int v, String n) : super(v, n);
}

class NetMessageType extends ProtobufEnum {
  static const NetMessageType NMT_UNKNOWN = const NetMessageType._(0, 'NMT_UNKNOWN');
  static const NetMessageType NMT_CLIENT_IDENTIFY = const NetMessageType._(1, 'NMT_CLIENT_IDENTIFY');

  static const List<NetMessageType> values = const <NetMessageType> [
    NMT_UNKNOWN,
    NMT_CLIENT_IDENTIFY,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static NetMessageType valueOf(int value) => _byValue[value] as NetMessageType;
  static void $checkItem(NetMessageType v) {
    if (v is! NetMessageType) checkItemFailed(v, 'NetMessageType');
  }

  const NetMessageType._(int v, String n) : super(v, n);
}

