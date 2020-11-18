///
//  Generated code. Do not modify.
//  source: money.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class MoneyDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MoneyDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'currencyCode')
    ..a<$core.int>(2, 'units', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'nanos', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  MoneyDto() : super();
  MoneyDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MoneyDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MoneyDto clone() => MoneyDto()..mergeFromMessage(this);
  MoneyDto copyWith(void Function(MoneyDto) updates) => super.copyWith((message) => updates(message as MoneyDto));
  $pb.BuilderInfo get info_ => _i;
  static MoneyDto create() => MoneyDto();
  MoneyDto createEmptyInstance() => create();
  static $pb.PbList<MoneyDto> createRepeated() => $pb.PbList<MoneyDto>();
  static MoneyDto getDefault() => _defaultInstance ??= create()..freeze();
  static MoneyDto _defaultInstance;

  $core.String get currencyCode => $_getS(0, '');
  set currencyCode($core.String v) { $_setString(0, v); }
  $core.bool hasCurrencyCode() => $_has(0);
  void clearCurrencyCode() => clearField(1);

  $core.int get units => $_get(1, 0);
  set units($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasUnits() => $_has(1);
  void clearUnits() => clearField(2);

  $core.int get nanos => $_get(2, 0);
  set nanos($core.int v) { $_setSignedInt32(2, v); }
  $core.bool hasNanos() => $_has(2);
  void clearNanos() => clearField(3);
}

