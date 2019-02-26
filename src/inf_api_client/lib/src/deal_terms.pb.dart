///
//  Generated code. Do not modify.
//  source: deal_terms.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'deliverable.pb.dart' as $2;
import 'reward.pb.dart' as $3;

class DealTermsDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DealTermsDto', package: const $pb.PackageName('api'))
    ..a<$2.DeliverableDto>(1, 'deliverable', $pb.PbFieldType.OM, $2.DeliverableDto.getDefault, $2.DeliverableDto.create)
    ..a<$3.RewardDto>(2, 'reward', $pb.PbFieldType.OM, $3.RewardDto.getDefault, $3.RewardDto.create)
    ..hasRequiredFields = false
  ;

  DealTermsDto() : super();
  DealTermsDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DealTermsDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DealTermsDto clone() => new DealTermsDto()..mergeFromMessage(this);
  DealTermsDto copyWith(void Function(DealTermsDto) updates) => super.copyWith((message) => updates(message as DealTermsDto));
  $pb.BuilderInfo get info_ => _i;
  static DealTermsDto create() => new DealTermsDto();
  DealTermsDto createEmptyInstance() => create();
  static $pb.PbList<DealTermsDto> createRepeated() => new $pb.PbList<DealTermsDto>();
  static DealTermsDto getDefault() => _defaultInstance ??= create()..freeze();
  static DealTermsDto _defaultInstance;
  static void $checkItem(DealTermsDto v) {
    if (v is! DealTermsDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $2.DeliverableDto get deliverable => $_getN(0);
  set deliverable($2.DeliverableDto v) { setField(1, v); }
  bool hasDeliverable() => $_has(0);
  void clearDeliverable() => clearField(1);

  $3.RewardDto get reward => $_getN(1);
  set reward($3.RewardDto v) { setField(2, v); }
  bool hasReward() => $_has(1);
  void clearReward() => clearField(2);
}

