///
//  Generated code. Do not modify.
//  source: inf_system.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class AliveMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AliveMessage', package: const $pb.PackageName('api'))
    ..hasRequiredFields = false
  ;

  AliveMessage() : super();
  AliveMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AliveMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AliveMessage clone() => AliveMessage()..mergeFromMessage(this);
  AliveMessage copyWith(void Function(AliveMessage) updates) => super.copyWith((message) => updates(message as AliveMessage));
  $pb.BuilderInfo get info_ => _i;
  static AliveMessage create() => AliveMessage();
  AliveMessage createEmptyInstance() => create();
  static $pb.PbList<AliveMessage> createRepeated() => $pb.PbList<AliveMessage>();
  static AliveMessage getDefault() => _defaultInstance ??= create()..freeze();
  static AliveMessage _defaultInstance;
}

