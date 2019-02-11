///
//  Generated code. Do not modify.
//  source: optional.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class OptionalString extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OptionalString', package: const $pb.PackageName('api'))
    ..aOS(1, 'value')
    ..hasRequiredFields = false
  ;

  OptionalString() : super();
  OptionalString.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OptionalString.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OptionalString clone() => new OptionalString()..mergeFromMessage(this);
  OptionalString copyWith(void Function(OptionalString) updates) => super.copyWith((message) => updates(message as OptionalString));
  $pb.BuilderInfo get info_ => _i;
  static OptionalString create() => new OptionalString();
  OptionalString createEmptyInstance() => create();
  static $pb.PbList<OptionalString> createRepeated() => new $pb.PbList<OptionalString>();
  static OptionalString getDefault() => _defaultInstance ??= create()..freeze();
  static OptionalString _defaultInstance;
  static void $checkItem(OptionalString v) {
    if (v is! OptionalString) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get value => $_getS(0, '');
  set value(String v) { $_setString(0, v); }
  bool hasValue() => $_has(0);
  void clearValue() => clearField(1);
}

