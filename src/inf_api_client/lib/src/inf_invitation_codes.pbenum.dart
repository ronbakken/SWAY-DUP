///
//  Generated code. Do not modify.
//  source: inf_invitation_codes.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class GetInvitationCodeStatusResponse_InvitationCodeStatus extends $pb.ProtobufEnum {
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus DOES_NOT_EXIST = const GetInvitationCodeStatusResponse_InvitationCodeStatus._(0, 'DOES_NOT_EXIST');
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus PENDING_USE = const GetInvitationCodeStatusResponse_InvitationCodeStatus._(1, 'PENDING_USE');
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus USED = const GetInvitationCodeStatusResponse_InvitationCodeStatus._(2, 'USED');
  static const GetInvitationCodeStatusResponse_InvitationCodeStatus EXPIRED = const GetInvitationCodeStatusResponse_InvitationCodeStatus._(3, 'EXPIRED');

  static const List<GetInvitationCodeStatusResponse_InvitationCodeStatus> values = const <GetInvitationCodeStatusResponse_InvitationCodeStatus> [
    DOES_NOT_EXIST,
    PENDING_USE,
    USED,
    EXPIRED,
  ];

  static final Map<int, GetInvitationCodeStatusResponse_InvitationCodeStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GetInvitationCodeStatusResponse_InvitationCodeStatus valueOf(int value) => _byValue[value];
  static void $checkItem(GetInvitationCodeStatusResponse_InvitationCodeStatus v) {
    if (v is! GetInvitationCodeStatusResponse_InvitationCodeStatus) $pb.checkItemFailed(v, 'GetInvitationCodeStatusResponse_InvitationCodeStatus');
  }

  const GetInvitationCodeStatusResponse_InvitationCodeStatus._(int v, String n) : super(v, n);
}

