///
//  Generated code. Do not modify.
//  source: deliverable.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'deliverable.pbenum.dart';

export 'deliverable.pbenum.dart';

class DeliverableIconDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeliverableIconDto', package: const $pb.PackageName('api'))
    ..a<int>(1, 'id', $pb.PbFieldType.O3)
    ..e<DeliverableType>(2, 'deliverableType', $pb.PbFieldType.OE, DeliverableType.post, DeliverableType.valueOf, DeliverableType.values)
    ..a<List<int>>(3, 'iconData', $pb.PbFieldType.OY)
    ..aOS(4, 'name')
    ..hasRequiredFields = false
  ;

  DeliverableIconDto() : super();
  DeliverableIconDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeliverableIconDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeliverableIconDto clone() => new DeliverableIconDto()..mergeFromMessage(this);
  DeliverableIconDto copyWith(void Function(DeliverableIconDto) updates) => super.copyWith((message) => updates(message as DeliverableIconDto));
  $pb.BuilderInfo get info_ => _i;
  static DeliverableIconDto create() => new DeliverableIconDto();
  DeliverableIconDto createEmptyInstance() => create();
  static $pb.PbList<DeliverableIconDto> createRepeated() => new $pb.PbList<DeliverableIconDto>();
  static DeliverableIconDto getDefault() => _defaultInstance ??= create()..freeze();
  static DeliverableIconDto _defaultInstance;
  static void $checkItem(DeliverableIconDto v) {
    if (v is! DeliverableIconDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) { $_setSignedInt32(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  DeliverableType get deliverableType => $_getN(1);
  set deliverableType(DeliverableType v) { setField(2, v); }
  bool hasDeliverableType() => $_has(1);
  void clearDeliverableType() => clearField(2);

  List<int> get iconData => $_getN(2);
  set iconData(List<int> v) { $_setBytes(2, v); }
  bool hasIconData() => $_has(2);
  void clearIconData() => clearField(3);

  String get name => $_getS(3, '');
  set name(String v) { $_setString(3, v); }
  bool hasName() => $_has(3);
  void clearName() => clearField(4);
}

class DeliverableDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeliverableDto', package: const $pb.PackageName('api'))
    ..a<int>(1, 'id', $pb.PbFieldType.O3)
    ..pp<DeliverableType>(2, 'deliverableTypes', $pb.PbFieldType.PE, DeliverableType.$checkItem, null, DeliverableType.valueOf, DeliverableType.values)
    ..pPS(3, 'socialNetworkProviderIds')
    ..aOS(4, 'description')
    ..hasRequiredFields = false
  ;

  DeliverableDto() : super();
  DeliverableDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeliverableDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeliverableDto clone() => new DeliverableDto()..mergeFromMessage(this);
  DeliverableDto copyWith(void Function(DeliverableDto) updates) => super.copyWith((message) => updates(message as DeliverableDto));
  $pb.BuilderInfo get info_ => _i;
  static DeliverableDto create() => new DeliverableDto();
  DeliverableDto createEmptyInstance() => create();
  static $pb.PbList<DeliverableDto> createRepeated() => new $pb.PbList<DeliverableDto>();
  static DeliverableDto getDefault() => _defaultInstance ??= create()..freeze();
  static DeliverableDto _defaultInstance;
  static void $checkItem(DeliverableDto v) {
    if (v is! DeliverableDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) { $_setSignedInt32(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  List<DeliverableType> get deliverableTypes => $_getList(1);

  List<String> get socialNetworkProviderIds => $_getList(2);

  String get description => $_getS(3, '');
  set description(String v) { $_setString(3, v); }
  bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);
}

