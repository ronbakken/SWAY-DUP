///
//  Generated code. Do not modify.
//  source: inf_system.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class AliveMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('AliveMessage', package: const $pb.PackageName('api'))
    ..hasRequiredFields = false
  ;

  AliveMessage() : super();
  AliveMessage.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AliveMessage.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AliveMessage clone() => new AliveMessage()..mergeFromMessage(this);
  AliveMessage copyWith(void Function(AliveMessage) updates) => super.copyWith((message) => updates(message as AliveMessage));
  $pb.BuilderInfo get info_ => _i;
  static AliveMessage create() => new AliveMessage();
  AliveMessage createEmptyInstance() => create();
  static $pb.PbList<AliveMessage> createRepeated() => new $pb.PbList<AliveMessage>();
  static AliveMessage getDefault() => _defaultInstance ??= create()..freeze();
  static AliveMessage _defaultInstance;
  static void $checkItem(AliveMessage v) {
    if (v is! AliveMessage) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

