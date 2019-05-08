///
//  Generated code. Do not modify.
//  source: reward.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'money.pb.dart' as $3;

import 'reward.pbenum.dart';

export 'reward.pbenum.dart';

class RewardDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RewardDto', package: const $pb.PackageName('api'))
    ..e<RewardDto_Type>(1, 'type', $pb.PbFieldType.OE, RewardDto_Type.barter, RewardDto_Type.valueOf, RewardDto_Type.values)
    ..a<$3.MoneyDto>(2, 'barterValue', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..a<$3.MoneyDto>(3, 'cashValue', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..aOS(4, 'description')
    ..hasRequiredFields = false
  ;

  RewardDto() : super();
  RewardDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RewardDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RewardDto clone() => RewardDto()..mergeFromMessage(this);
  RewardDto copyWith(void Function(RewardDto) updates) => super.copyWith((message) => updates(message as RewardDto));
  $pb.BuilderInfo get info_ => _i;
  static RewardDto create() => RewardDto();
  RewardDto createEmptyInstance() => create();
  static $pb.PbList<RewardDto> createRepeated() => $pb.PbList<RewardDto>();
  static RewardDto getDefault() => _defaultInstance ??= create()..freeze();
  static RewardDto _defaultInstance;

  RewardDto_Type get type => $_getN(0);
  set type(RewardDto_Type v) { setField(1, v); }
  $core.bool hasType() => $_has(0);
  void clearType() => clearField(1);

  $3.MoneyDto get barterValue => $_getN(1);
  set barterValue($3.MoneyDto v) { setField(2, v); }
  $core.bool hasBarterValue() => $_has(1);
  void clearBarterValue() => clearField(2);

  $3.MoneyDto get cashValue => $_getN(2);
  set cashValue($3.MoneyDto v) { setField(3, v); }
  $core.bool hasCashValue() => $_has(2);
  void clearCashValue() => clearField(3);

  $core.String get description => $_getS(3, '');
  set description($core.String v) { $_setString(3, v); }
  $core.bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);
}

