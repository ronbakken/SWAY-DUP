///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class SingleItemFilterDto_Type extends $pb.ProtobufEnum {
  static const SingleItemFilterDto_Type offer = const SingleItemFilterDto_Type._(0, 'offer');
  static const SingleItemFilterDto_Type user = const SingleItemFilterDto_Type._(1, 'user');
  static const SingleItemFilterDto_Type conversation = const SingleItemFilterDto_Type._(2, 'conversation');
  static const SingleItemFilterDto_Type message = const SingleItemFilterDto_Type._(3, 'message');

  static const List<SingleItemFilterDto_Type> values = const <SingleItemFilterDto_Type> [
    offer,
    user,
    conversation,
    message,
  ];

  static final Map<int, SingleItemFilterDto_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SingleItemFilterDto_Type valueOf(int value) => _byValue[value];
  static void $checkItem(SingleItemFilterDto_Type v) {
    if (v is! SingleItemFilterDto_Type) $pb.checkItemFailed(v, 'SingleItemFilterDto_Type');
  }

  const SingleItemFilterDto_Type._(int v, String n) : super(v, n);
}

class ListenRequest_Action extends $pb.ProtobufEnum {
  static const ListenRequest_Action register = const ListenRequest_Action._(0, 'register');
  static const ListenRequest_Action deregister = const ListenRequest_Action._(1, 'deregister');

  static const List<ListenRequest_Action> values = const <ListenRequest_Action> [
    register,
    deregister,
  ];

  static final Map<int, ListenRequest_Action> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ListenRequest_Action valueOf(int value) => _byValue[value];
  static void $checkItem(ListenRequest_Action v) {
    if (v is! ListenRequest_Action) $pb.checkItemFailed(v, 'ListenRequest_Action');
  }

  const ListenRequest_Action._(int v, String n) : super(v, n);
}

