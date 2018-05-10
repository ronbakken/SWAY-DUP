///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf_pbenum;

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class NetMessageType extends ProtobufEnum {
  static const NetMessageType UNKNOWN = const NetMessageType._(0, 'UNKNOWN');
  static const NetMessageType CLIENT_IDENTIFY = const NetMessageType._(1, 'CLIENT_IDENTIFY');

  static const List<NetMessageType> values = const <NetMessageType> [
    UNKNOWN,
    CLIENT_IDENTIFY,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static NetMessageType valueOf(int value) => _byValue[value] as NetMessageType;
  static void $checkItem(NetMessageType v) {
    if (v is! NetMessageType) checkItemFailed(v, 'NetMessageType');
  }

  const NetMessageType._(int v, String n) : super(v, n);
}

