///
//  Generated code. Do not modify.
//  source: net_offer_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $10;

class NetOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOffer',
      package: const $pb.PackageName('inf_common'))
    ..a<$10.DataOffer>(1, 'offer', $pb.PbFieldType.OM, $10.DataOffer.getDefault,
        $10.DataOffer.create)
    ..aOB(2, 'state')
    ..aOB(3, 'summary')
    ..aOB(4, 'detail')
    ..hasRequiredFields = false;

  NetOffer() : super();
  NetOffer.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOffer.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOffer clone() => new NetOffer()..mergeFromMessage(this);
  NetOffer copyWith(void Function(NetOffer) updates) =>
      super.copyWith((message) => updates(message as NetOffer));
  $pb.BuilderInfo get info_ => _i;
  static NetOffer create() => new NetOffer();
  static $pb.PbList<NetOffer> createRepeated() => new $pb.PbList<NetOffer>();
  static NetOffer getDefault() => _defaultInstance ??= create()..freeze();
  static NetOffer _defaultInstance;
  static void $checkItem(NetOffer v) {
    if (v is! NetOffer) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataOffer get offer => $_getN(0);
  set offer($10.DataOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);

  bool get state => $_get(1, false);
  set state(bool v) {
    $_setBool(1, v);
  }

  bool hasState() => $_has(1);
  void clearState() => clearField(2);

  bool get summary => $_get(2, false);
  set summary(bool v) {
    $_setBool(2, v);
  }

  bool hasSummary() => $_has(2);
  void clearSummary() => clearField(3);

  bool get detail => $_get(3, false);
  set detail(bool v) {
    $_setBool(3, v);
  }

  bool hasDetail() => $_has(3);
  void clearDetail() => clearField(4);
}

class NetCreateOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetCreateOffer',
      package: const $pb.PackageName('inf_common'))
    ..a<$10.DataOffer>(1, 'offer', $pb.PbFieldType.OM, $10.DataOffer.getDefault,
        $10.DataOffer.create)
    ..hasRequiredFields = false;

  NetCreateOffer() : super();
  NetCreateOffer.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetCreateOffer.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetCreateOffer clone() => new NetCreateOffer()..mergeFromMessage(this);
  NetCreateOffer copyWith(void Function(NetCreateOffer) updates) =>
      super.copyWith((message) => updates(message as NetCreateOffer));
  $pb.BuilderInfo get info_ => _i;
  static NetCreateOffer create() => new NetCreateOffer();
  static $pb.PbList<NetCreateOffer> createRepeated() =>
      new $pb.PbList<NetCreateOffer>();
  static NetCreateOffer getDefault() => _defaultInstance ??= create()..freeze();
  static NetCreateOffer _defaultInstance;
  static void $checkItem(NetCreateOffer v) {
    if (v is! NetCreateOffer) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $10.DataOffer get offer => $_getN(0);
  set offer($10.DataOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class NetListOffers extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetListOffers',
      package: const $pb.PackageName('inf_common'))
    ..hasRequiredFields = false;

  NetListOffers() : super();
  NetListOffers.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetListOffers.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetListOffers clone() => new NetListOffers()..mergeFromMessage(this);
  NetListOffers copyWith(void Function(NetListOffers) updates) =>
      super.copyWith((message) => updates(message as NetListOffers));
  $pb.BuilderInfo get info_ => _i;
  static NetListOffers create() => new NetListOffers();
  static $pb.PbList<NetListOffers> createRepeated() =>
      new $pb.PbList<NetListOffers>();
  static NetListOffers getDefault() => _defaultInstance ??= create()..freeze();
  static NetListOffers _defaultInstance;
  static void $checkItem(NetListOffers v) {
    if (v is! NetListOffers) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

class NetGetOffer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetOffer',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'offerId')
    ..hasRequiredFields = false;

  NetGetOffer() : super();
  NetGetOffer.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetOffer.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetOffer clone() => new NetGetOffer()..mergeFromMessage(this);
  NetGetOffer copyWith(void Function(NetGetOffer) updates) =>
      super.copyWith((message) => updates(message as NetGetOffer));
  $pb.BuilderInfo get info_ => _i;
  static NetGetOffer create() => new NetGetOffer();
  static $pb.PbList<NetGetOffer> createRepeated() =>
      new $pb.PbList<NetGetOffer>();
  static NetGetOffer getDefault() => _defaultInstance ??= create()..freeze();
  static NetGetOffer _defaultInstance;
  static void $checkItem(NetGetOffer v) {
    if (v is! NetGetOffer) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get offerId => $_getI64(0);
  set offerId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);
}
