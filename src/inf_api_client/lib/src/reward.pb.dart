///
//  Generated code. Do not modify.
//  source: reward.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'money.pb.dart' as $1;

import 'reward.pbenum.dart';

export 'reward.pbenum.dart';

class RewardDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('RewardDto', package: const $pb.PackageName('api'))
    ..e<RewardDto_Type>(1, 'type', $pb.PbFieldType.OE, RewardDto_Type.barter, RewardDto_Type.valueOf, RewardDto_Type.values)
    ..a<$1.MoneyDto>(2, 'barterValue', $pb.PbFieldType.OM, $1.MoneyDto.getDefault, $1.MoneyDto.create)
    ..a<$1.MoneyDto>(3, 'cashValue', $pb.PbFieldType.OM, $1.MoneyDto.getDefault, $1.MoneyDto.create)
    ..aOS(4, 'description')
    ..hasRequiredFields = false
  ;

  RewardDto() : super();
  RewardDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  RewardDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  RewardDto clone() => new RewardDto()..mergeFromMessage(this);
  RewardDto copyWith(void Function(RewardDto) updates) => super.copyWith((message) => updates(message as RewardDto));
  $pb.BuilderInfo get info_ => _i;
  static RewardDto create() => new RewardDto();
  RewardDto createEmptyInstance() => create();
  static $pb.PbList<RewardDto> createRepeated() => new $pb.PbList<RewardDto>();
  static RewardDto getDefault() => _defaultInstance ??= create()..freeze();
  static RewardDto _defaultInstance;
  static void $checkItem(RewardDto v) {
    if (v is! RewardDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  RewardDto_Type get type => $_getN(0);
  set type(RewardDto_Type v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  $1.MoneyDto get barterValue => $_getN(1);
  set barterValue($1.MoneyDto v) { setField(2, v); }
  bool hasBarterValue() => $_has(1);
  void clearBarterValue() => clearField(2);

  $1.MoneyDto get cashValue => $_getN(2);
  set cashValue($1.MoneyDto v) { setField(3, v); }
  bool hasCashValue() => $_has(2);
  void clearCashValue() => clearField(3);

  String get description => $_getS(3, '');
  set description(String v) { $_setString(3, v); }
  bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);
}

