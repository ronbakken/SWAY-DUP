///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class UserType extends $pb.ProtobufEnum {
  static const UserType unknownUserType = const UserType._(0, 'unknownUserType');
  static const UserType influencer = const UserType._(1, 'influencer');
  static const UserType business = const UserType._(2, 'business');
  static const UserType support = const UserType._(3, 'support');
  static const UserType admin = const UserType._(4, 'admin');

  static const List<UserType> values = const <UserType> [
    unknownUserType,
    influencer,
    business,
    support,
    admin,
  ];

  static final Map<int, UserType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserType valueOf(int value) => _byValue[value];
  static void $checkItem(UserType v) {
    if (v is! UserType) $pb.checkItemFailed(v, 'UserType');
  }

  const UserType._(int v, String n) : super(v, n);
}

class AccountState extends $pb.ProtobufEnum {
  static const AccountState unknown = const AccountState._(0, 'unknown');
  static const AccountState disabled = const AccountState._(1, 'disabled');
  static const AccountState active = const AccountState._(2, 'active');
  static const AccountState waitingForActivation = const AccountState._(3, 'waitingForActivation');
  static const AccountState waitingForApproval = const AccountState._(4, 'waitingForApproval');
  static const AccountState rejected = const AccountState._(5, 'rejected');

  static const List<AccountState> values = const <AccountState> [
    unknown,
    disabled,
    active,
    waitingForActivation,
    waitingForApproval,
    rejected,
  ];

  static final Map<int, AccountState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AccountState valueOf(int value) => _byValue[value];
  static void $checkItem(AccountState v) {
    if (v is! AccountState) $pb.checkItemFailed(v, 'AccountState');
  }

  const AccountState._(int v, String n) : super(v, n);
}

