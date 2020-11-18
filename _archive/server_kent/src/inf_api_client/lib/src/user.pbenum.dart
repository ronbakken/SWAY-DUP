///
//  Generated code. Do not modify.
//  source: user.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class UserType extends $pb.ProtobufEnum {
  static const UserType unknownType = UserType._(0, 'unknownType');
  static const UserType influencer = UserType._(1, 'influencer');
  static const UserType business = UserType._(2, 'business');
  static const UserType support = UserType._(3, 'support');
  static const UserType admin = UserType._(4, 'admin');

  static const $core.List<UserType> values = <UserType> [
    unknownType,
    influencer,
    business,
    support,
    admin,
  ];

  static final $core.Map<$core.int, UserType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserType valueOf($core.int value) => _byValue[value];

  const UserType._($core.int v, $core.String n) : super(v, n);
}

class UserDto_Status extends $pb.ProtobufEnum {
  static const UserDto_Status unknown = UserDto_Status._(0, 'unknown');
  static const UserDto_Status disabled = UserDto_Status._(1, 'disabled');
  static const UserDto_Status active = UserDto_Status._(2, 'active');
  static const UserDto_Status waitingForActivation = UserDto_Status._(3, 'waitingForActivation');
  static const UserDto_Status waitingForApproval = UserDto_Status._(4, 'waitingForApproval');
  static const UserDto_Status rejected = UserDto_Status._(5, 'rejected');

  static const $core.List<UserDto_Status> values = <UserDto_Status> [
    unknown,
    disabled,
    active,
    waitingForActivation,
    waitingForApproval,
    rejected,
  ];

  static final $core.Map<$core.int, UserDto_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserDto_Status valueOf($core.int value) => _byValue[value];

  const UserDto_Status._($core.int v, $core.String n) : super(v, n);
}

