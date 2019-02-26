///
//  Generated code. Do not modify.
//  source: money.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class MoneyDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MoneyDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'currencyCode')
    ..a<int>(2, 'units', $pb.PbFieldType.O3)
    ..a<int>(3, 'nanos', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  MoneyDto() : super();
  MoneyDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MoneyDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MoneyDto clone() => new MoneyDto()..mergeFromMessage(this);
  MoneyDto copyWith(void Function(MoneyDto) updates) => super.copyWith((message) => updates(message as MoneyDto));
  $pb.BuilderInfo get info_ => _i;
  static MoneyDto create() => new MoneyDto();
  MoneyDto createEmptyInstance() => create();
  static $pb.PbList<MoneyDto> createRepeated() => new $pb.PbList<MoneyDto>();
  static MoneyDto getDefault() => _defaultInstance ??= create()..freeze();
  static MoneyDto _defaultInstance;
  static void $checkItem(MoneyDto v) {
    if (v is! MoneyDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get currencyCode => $_getS(0, '');
  set currencyCode(String v) { $_setString(0, v); }
  bool hasCurrencyCode() => $_has(0);
  void clearCurrencyCode() => clearField(1);

  int get units => $_get(1, 0);
  set units(int v) { $_setSignedInt32(1, v); }
  bool hasUnits() => $_has(1);
  void clearUnits() => clearField(2);

  int get nanos => $_get(2, 0);
  set nanos(int v) { $_setSignedInt32(2, v); }
  bool hasNanos() => $_has(2);
  void clearNanos() => clearField(3);
}

