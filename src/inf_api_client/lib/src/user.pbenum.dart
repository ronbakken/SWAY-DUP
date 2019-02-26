///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class UserType extends $pb.ProtobufEnum {
  static const UserType unknownType = const UserType._(0, 'unknownType');
  static const UserType influencer = const UserType._(1, 'influencer');
  static const UserType business = const UserType._(2, 'business');
  static const UserType support = const UserType._(3, 'support');
  static const UserType admin = const UserType._(4, 'admin');

  static const List<UserType> values = const <UserType> [
    unknownType,
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

class UserDto_Status extends $pb.ProtobufEnum {
  static const UserDto_Status unknown = const UserDto_Status._(0, 'unknown');
  static const UserDto_Status disabled = const UserDto_Status._(1, 'disabled');
  static const UserDto_Status active = const UserDto_Status._(2, 'active');
  static const UserDto_Status waitingForActivation = const UserDto_Status._(3, 'waitingForActivation');
  static const UserDto_Status waitingForApproval = const UserDto_Status._(4, 'waitingForApproval');
  static const UserDto_Status rejected = const UserDto_Status._(5, 'rejected');

  static const List<UserDto_Status> values = const <UserDto_Status> [
    unknown,
    disabled,
    active,
    waitingForActivation,
    waitingForApproval,
    rejected,
  ];

  static final Map<int, UserDto_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserDto_Status valueOf(int value) => _byValue[value];
  static void $checkItem(UserDto_Status v) {
    if (v is! UserDto_Status) $pb.checkItemFailed(v, 'UserDto_Status');
  }

  const UserDto_Status._(int v, String n) : super(v, n);
}

