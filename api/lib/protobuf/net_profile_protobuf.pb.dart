///
//  Generated code. Do not modify.
//  source: net_profile_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

class NetProfileModify extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProfileModify',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..aOS(4, 'avatarKey')
    ..aOS(6, 'url')
    ..a<double>(14, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(15, 'longitude', $pb.PbFieldType.OD)
    ..a<List<int>>(16, 'categories', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  NetProfileModify() : super();
  NetProfileModify.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProfileModify.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProfileModify clone() => new NetProfileModify()..mergeFromMessage(this);
  NetProfileModify copyWith(void Function(NetProfileModify) updates) =>
      super.copyWith((message) => updates(message as NetProfileModify));
  $pb.BuilderInfo get info_ => _i;
  static NetProfileModify create() => new NetProfileModify();
  static $pb.PbList<NetProfileModify> createRepeated() =>
      new $pb.PbList<NetProfileModify>();
  static NetProfileModify getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProfileModify _defaultInstance;
  static void $checkItem(NetProfileModify v) {
    if (v is! NetProfileModify) $pb.checkItemFailed(v, _i.messageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get description => $_getS(1, '');
  set description(String v) {
    $_setString(1, v);
  }

  bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);

  String get avatarKey => $_getS(2, '');
  set avatarKey(String v) {
    $_setString(2, v);
  }

  bool hasAvatarKey() => $_has(2);
  void clearAvatarKey() => clearField(4);

  String get url => $_getS(3, '');
  set url(String v) {
    $_setString(3, v);
  }

  bool hasUrl() => $_has(3);
  void clearUrl() => clearField(6);

  double get latitude => $_getN(4);
  set latitude(double v) {
    $_setDouble(4, v);
  }

  bool hasLatitude() => $_has(4);
  void clearLatitude() => clearField(14);

  double get longitude => $_getN(5);
  set longitude(double v) {
    $_setDouble(5, v);
  }

  bool hasLongitude() => $_has(5);
  void clearLongitude() => clearField(15);

  List<int> get categories => $_getN(6);
  set categories(List<int> v) {
    $_setBytes(6, v);
  }

  bool hasCategories() => $_has(6);
  void clearCategories() => clearField(16);
}
