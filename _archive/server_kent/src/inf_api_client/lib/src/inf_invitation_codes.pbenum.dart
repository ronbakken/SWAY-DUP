///
//  Generated code. Do not modify.
//  source: inf_invitation_codes.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class GetInvitationCodeStatusResponse_InvitationCodeStatus extends $pb.ProtobufEnum {
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus DOES_NOT_EXIST = GetInvitationCodeStatusResponse_InvitationCodeStatus._(0, 'DOES_NOT_EXIST');
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus PENDING_USE = GetInvitationCodeStatusResponse_InvitationCodeStatus._(1, 'PENDING_USE');
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus USED = GetInvitationCodeStatusResponse_InvitationCodeStatus._(2, 'USED');
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus EXPIRED = GetInvitationCodeStatusResponse_InvitationCodeStatus._(3, 'EXPIRED');

  static const $core.List<GetInvitationCodeStatusResponse_InvitationCodeStatus> values = <GetInvitationCodeStatusResponse_InvitationCodeStatus> [
    DOES_NOT_EXIST,
    PENDING_USE,
    USED,
    EXPIRED,
  ];

  static final $core.Map<$core.int, GetInvitationCodeStatusResponse_InvitationCodeStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GetInvitationCodeStatusResponse_InvitationCodeStatus valueOf($core.int value) => _byValue[value];

  const GetInvitationCodeStatusResponse_InvitationCodeStatus._($core.int v, $core.String n) : super(v, n);
}

