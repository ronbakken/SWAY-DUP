///
//  Generated code. Do not modify.
//  source: deal_terms.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'deliverable.pb.dart' as $8;
import 'money.pb.dart' as $3;

class DealTermsDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DealTermsDto', package: const $pb.PackageName('api'))
    ..a<$8.DeliverableDto>(1, 'deliverable', $pb.PbFieldType.OM, $8.DeliverableDto.getDefault, $8.DeliverableDto.create)
    ..a<$3.MoneyDto>(2, 'cashValue', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..a<$3.MoneyDto>(3, 'serviceValue', $pb.PbFieldType.OM, $3.MoneyDto.getDefault, $3.MoneyDto.create)
    ..aOS(4, 'serviceDescription')
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

  $3.MoneyDto get cashValue => $_getN(1);
  set cashValue($3.MoneyDto v) { setField(2, v); }
  $core.bool hasCashValue() => $_has(1);
  void clearCashValue() => clearField(2);

  $3.MoneyDto get serviceValue => $_getN(2);
  set serviceValue($3.MoneyDto v) { setField(3, v); }
  $core.bool hasServiceValue() => $_has(2);
  void clearServiceValue() => clearField(3);

  $core.String get serviceDescription => $_getS(3, '');
  set serviceDescription($core.String v) { $_setString(3, v); }
  $core.bool hasServiceDescription() => $_has(3);
  void clearServiceDescription() => clearField(4);
}

