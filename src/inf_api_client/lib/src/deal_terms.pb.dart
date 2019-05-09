///
//  Generated code. Do not modify.
//  source: deal_terms.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'deliverable.pb.dart' as $8;
import 'reward.pb.dart' as $9;

class DealTermsDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DealTermsDto', package: const $pb.PackageName('api'))
    ..a<$8.DeliverableDto>(1, 'deliverable', $pb.PbFieldType.OM, $8.DeliverableDto.getDefault, $8.DeliverableDto.create)
    ..a<$9.RewardDto>(2, 'reward', $pb.PbFieldType.OM, $9.RewardDto.getDefault, $9.RewardDto.create)
    ..hasRequiredFields = false
  ;

  DealTermsDto() : super();
  DealTermsDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DealTermsDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DealTermsDto clone() => DealTermsDto()..mergeFromMessage(this);
  DealTermsDto copyWith(void Function(DealTermsDto) updates) => super.copyWith((message) => updates(message as DealTermsDto));
  $pb.BuilderInfo get info_ => _i;
  static DealTermsDto create() => DealTermsDto();
  DealTermsDto createEmptyInstance() => create();
  static $pb.PbList<DealTermsDto> createRepeated() => $pb.PbList<DealTermsDto>();
  static DealTermsDto getDefault() => _defaultInstance ??= create()..freeze();
  static DealTermsDto _defaultInstance;

  $8.DeliverableDto get deliverable => $_getN(0);
  set deliverable($8.DeliverableDto v) { setField(1, v); }
  $core.bool hasDeliverable() => $_has(0);
  void clearDeliverable() => clearField(1);

  $9.RewardDto get reward => $_getN(1);
  set reward($9.RewardDto v) { setField(2, v); }
  $core.bool hasReward() => $_has(1);
  void clearReward() => clearField(2);
}

