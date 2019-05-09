///
//  Generated code. Do not modify.
//  source: deliverable.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'deliverable.pbenum.dart';

export 'deliverable.pbenum.dart';

class DeliverableIconDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeliverableIconDto', package: const $pb.PackageName('api'))
    ..a<$core.int>(1, 'id', $pb.PbFieldType.O3)
    ..e<DeliverableType>(2, 'deliverableType', $pb.PbFieldType.OE, DeliverableType.post, DeliverableType.valueOf, DeliverableType.values)
    ..a<$core.List<$core.int>>(3, 'iconData', $pb.PbFieldType.OY)
    ..aOS(4, 'name')
    ..hasRequiredFields = false
  ;

  DeliverableIconDto() : super();
  DeliverableIconDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeliverableIconDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeliverableIconDto clone() => DeliverableIconDto()..mergeFromMessage(this);
  DeliverableIconDto copyWith(void Function(DeliverableIconDto) updates) => super.copyWith((message) => updates(message as DeliverableIconDto));
  $pb.BuilderInfo get info_ => _i;
  static DeliverableIconDto create() => DeliverableIconDto();
  DeliverableIconDto createEmptyInstance() => create();
  static $pb.PbList<DeliverableIconDto> createRepeated() => $pb.PbList<DeliverableIconDto>();
  static DeliverableIconDto getDefault() => _defaultInstance ??= create()..freeze();
  static DeliverableIconDto _defaultInstance;

  $core.int get id => $_get(0, 0);
  set id($core.int v) { $_setSignedInt32(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  DeliverableType get deliverableType => $_getN(1);
  set deliverableType(DeliverableType v) { setField(2, v); }
  $core.bool hasDeliverableType() => $_has(1);
  void clearDeliverableType() => clearField(2);

  $core.List<$core.int> get iconData => $_getN(2);
  set iconData($core.List<$core.int> v) { $_setBytes(2, v); }
  $core.bool hasIconData() => $_has(2);
  void clearIconData() => clearField(3);

  $core.String get name => $_getS(3, '');
  set name($core.String v) { $_setString(3, v); }
  $core.bool hasName() => $_has(3);
  void clearName() => clearField(4);
}

class DeliverableDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeliverableDto', package: const $pb.PackageName('api'))
    ..a<$core.int>(1, 'id', $pb.PbFieldType.O3)
    ..pc<DeliverableType>(2, 'deliverableTypes', $pb.PbFieldType.PE, null, DeliverableType.valueOf, DeliverableType.values)
    ..pPS(3, 'socialNetworkProviderIds')
    ..aOS(4, 'description')
    ..hasRequiredFields = false
  ;

  DeliverableDto() : super();
  DeliverableDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeliverableDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeliverableDto clone() => DeliverableDto()..mergeFromMessage(this);
  DeliverableDto copyWith(void Function(DeliverableDto) updates) => super.copyWith((message) => updates(message as DeliverableDto));
  $pb.BuilderInfo get info_ => _i;
  static DeliverableDto create() => DeliverableDto();
  DeliverableDto createEmptyInstance() => create();
  static $pb.PbList<DeliverableDto> createRepeated() => $pb.PbList<DeliverableDto>();
  static DeliverableDto getDefault() => _defaultInstance ??= create()..freeze();
  static DeliverableDto _defaultInstance;

  $core.int get id => $_get(0, 0);
  set id($core.int v) { $_setSignedInt32(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.List<DeliverableType> get deliverableTypes => $_getList(1);

  $core.List<$core.String> get socialNetworkProviderIds => $_getList(2);

  $core.String get description => $_getS(3, '');
  set description($core.String v) { $_setString(3, v); }
  $core.bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);
}

