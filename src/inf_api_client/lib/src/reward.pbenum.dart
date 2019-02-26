///
//  Generated code. Do not modify.
//  source: reward.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class RewardDto_Type extends $pb.ProtobufEnum {
  static const RewardDto_Type barter = const RewardDto_Type._(0, 'barter');
  static const RewardDto_Type cash = const RewardDto_Type._(1, 'cash');
  static const RewardDto_Type barterAndCash = const RewardDto_Type._(2, 'barterAndCash');

  static const List<RewardDto_Type> values = const <RewardDto_Type> [
    barter,
    cash,
    barterAndCash,
  ];

  static final Map<int, RewardDto_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static RewardDto_Type valueOf(int value) => _byValue[value];
  static void $checkItem(RewardDto_Type v) {
    if (v is! RewardDto_Type) $pb.checkItemFailed(v, 'RewardDto_Type');
  }

  const RewardDto_Type._(int v, String n) : super(v, n);
}

