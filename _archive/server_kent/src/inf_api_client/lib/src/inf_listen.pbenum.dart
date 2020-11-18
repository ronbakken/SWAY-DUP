///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class SingleItemFilterDto_Type extends $pb.ProtobufEnum {
  static const SingleItemFilterDto_Type offer = SingleItemFilterDto_Type._(0, 'offer');
  static const SingleItemFilterDto_Type user = SingleItemFilterDto_Type._(1, 'user');
  static const SingleItemFilterDto_Type conversation = SingleItemFilterDto_Type._(2, 'conversation');
  static const SingleItemFilterDto_Type message = SingleItemFilterDto_Type._(3, 'message');

  static const $core.List<SingleItemFilterDto_Type> values = <SingleItemFilterDto_Type> [
    offer,
    user,
    conversation,
    message,
  ];

  static final $core.Map<$core.int, SingleItemFilterDto_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SingleItemFilterDto_Type valueOf($core.int value) => _byValue[value];

  const SingleItemFilterDto_Type._($core.int v, $core.String n) : super(v, n);
}

class ListenRequest_Action extends $pb.ProtobufEnum {
  static const ListenRequest_Action register = ListenRequest_Action._(0, 'register');
  static const ListenRequest_Action deregister = ListenRequest_Action._(1, 'deregister');

  static const $core.List<ListenRequest_Action> values = <ListenRequest_Action> [
    register,
    deregister,
  ];

  static final $core.Map<$core.int, ListenRequest_Action> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ListenRequest_Action valueOf($core.int value) => _byValue[value];

  const ListenRequest_Action._($core.int v, $core.String n) : super(v, n);
}

