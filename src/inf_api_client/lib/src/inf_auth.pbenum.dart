///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class InvitationCodeStates extends $pb.ProtobufEnum {
  static const InvitationCodeStates valid = const InvitationCodeStates._(0, 'valid');
  static const InvitationCodeStates invalid = const InvitationCodeStates._(1, 'invalid');
  static const InvitationCodeStates expired = const InvitationCodeStates._(2, 'expired');

  static const List<InvitationCodeStates> values = const <InvitationCodeStates> [
    valid,
    invalid,
    expired,
  ];

  static final Map<int, InvitationCodeStates> _byValue = $pb.ProtobufEnum.initByValue(values);
  static InvitationCodeStates valueOf(int value) => _byValue[value];
  static void $checkItem(InvitationCodeStates v) {
    if (v is! InvitationCodeStates) $pb.checkItemFailed(v, 'InvitationCodeStates');
  }

  const InvitationCodeStates._(int v, String n) : super(v, n);
}

