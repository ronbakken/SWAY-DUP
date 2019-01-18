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

class DeliverableIcon extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DeliverableIcon', package: const $pb.PackageName('api'))
    ..a<int>(1, 'id', $pb.PbFieldType.O3)
    ..e<DeliverableType>(2, 'deliverableType', $pb.PbFieldType.OE, DeliverableType.post, DeliverableType.valueOf, DeliverableType.values)
    ..a<List<int>>(3, 'iconData', $pb.PbFieldType.OY)
    ..aOS(4, 'name')
    ..hasRequiredFields = false
  ;

  DeliverableIcon() : super();
  DeliverableIcon.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeliverableIcon.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeliverableIcon clone() => new DeliverableIcon()..mergeFromMessage(this);
  DeliverableIcon copyWith(void Function(DeliverableIcon) updates) => super.copyWith((message) => updates(message as DeliverableIcon));
  $pb.BuilderInfo get info_ => _i;
  static DeliverableIcon create() => new DeliverableIcon();
  DeliverableIcon createEmptyInstance() => create();
  static $pb.PbList<DeliverableIcon> createRepeated() => new $pb.PbList<DeliverableIcon>();
  static DeliverableIcon getDefault() => _defaultInstance ??= create()..freeze();
  static DeliverableIcon _defaultInstance;
  static void $checkItem(DeliverableIcon v) {
    if (v is! DeliverableIcon) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class Deliverable extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Deliverable', package: const $pb.PackageName('api'))
    ..a<int>(1, 'id', $pb.PbFieldType.O3)
    ..e<DeliverableType>(2, 'type', $pb.PbFieldType.OE, DeliverableType.post, DeliverableType.valueOf, DeliverableType.values)
    ..aOS(3, 'description')
    ..hasRequiredFields = false
  ;

  Deliverable() : super();
  Deliverable.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Deliverable.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Deliverable clone() => new Deliverable()..mergeFromMessage(this);
  Deliverable copyWith(void Function(Deliverable) updates) => super.copyWith((message) => updates(message as Deliverable));
  $pb.BuilderInfo get info_ => _i;
  static Deliverable create() => new Deliverable();
  Deliverable createEmptyInstance() => create();
  static $pb.PbList<Deliverable> createRepeated() => new $pb.PbList<Deliverable>();
  static Deliverable getDefault() => _defaultInstance ??= create()..freeze();
  static Deliverable _defaultInstance;
  static void $checkItem(Deliverable v) {
    if (v is! Deliverable) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get id => $_get(0, 0);
  set id(int v) { $_setSignedInt32(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  DeliverableType get type => $_getN(1);
  set type(DeliverableType v) { setField(2, v); }
  bool hasType() => $_has(1);
  void clearType() => clearField(2);

  String get description => $_getS(2, '');
  set description(String v) { $_setString(2, v); }
  bool hasDescription() => $_has(2);
  void clearDescription() => clearField(3);
}

