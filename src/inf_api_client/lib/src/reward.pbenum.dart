///
//  Generated code. Do not modify.
//  source: reward.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class RewardDto_Type extends $pb.ProtobufEnum {
  static const RewardDto_Type barter = RewardDto_Type._(0, 'barter');
  static const RewardDto_Type cash = RewardDto_Type._(1, 'cash');
  static const RewardDto_Type barterAndCash = RewardDto_Type._(2, 'barterAndCash');

  static const $core.List<RewardDto_Type> values = <RewardDto_Type> [
    barter,
    cash,
    barterAndCash,
  ];

  static final $core.Map<$core.int, RewardDto_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RewardDto_Type valueOf($core.int value) => _byValue[value];

  const RewardDto_Type._($core.int v, $core.String n) : super(v, n);
}

