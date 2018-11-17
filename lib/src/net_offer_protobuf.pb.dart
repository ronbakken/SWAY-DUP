///
//  Generated code. Do not modify.
//  source: net_offer_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

class NetCreateOfferReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetCreateOfferReq',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'title')
    ..pPS(2, 'imageKeys')
    ..aOS(3, 'description')
    ..aOS(4, 'deliverables')
    ..aOS(5, 'reward')
    ..a<int>(6, 'locationId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetCreateOfferReq() : super();
  NetCreateOfferReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetCreateOfferReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetCreateOfferReq clone() => new NetCreateOfferReq()..mergeFromMessage(this);
  NetCreateOfferReq copyWith(void Function(NetCreateOfferReq) updates) =>
      super.copyWith((message) => updates(message as NetCreateOfferReq));
  $pb.BuilderInfo get info_ => _i;
  static NetCreateOfferReq create() => new NetCreateOfferReq();
  static $pb.PbList<NetCreateOfferReq> createRepeated() =>
      new $pb.PbList<NetCreateOfferReq>();
  static NetCreateOfferReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetCreateOfferReq _defaultInstance;
  static void $checkItem(NetCreateOfferReq v) {
    if (v is! NetCreateOfferReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get title => $_getS(0, '');
  set title(String v) {
    $_setString(0, v);
  }

  bool hasTitle() => $_has(0);
  void clearTitle() => clearField(1);

  List<String> get imageKeys => $_getList(1);

  String get description => $_getS(2, '');
  set description(String v) {
    $_setString(2, v);
  }

  bool hasDescription() => $_has(2);
  void clearDescription() => clearField(3);

  String get deliverables => $_getS(3, '');
  set deliverables(String v) {
    $_setString(3, v);
  }

  bool hasDeliverables() => $_has(3);
  void clearDeliverables() => clearField(4);

  String get reward => $_getS(4, '');
  set reward(String v) {
    $_setString(4, v);
  }

  bool hasReward() => $_has(4);
  void clearReward() => clearField(5);

  int get locationId => $_get(5, 0);
  set locationId(int v) {
    $_setSignedInt32(5, v);
  }

  bool hasLocationId() => $_has(5);
  void clearLocationId() => clearField(6);
}

class NetLoadOffersReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadOffersReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadOffersReq() : super();
  NetLoadOffersReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadOffersReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadOffersReq clone() => new NetLoadOffersReq()..mergeFromMessage(this);
  NetLoadOffersReq copyWith(void Function(NetLoadOffersReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadOffersReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadOffersReq create() => new NetLoadOffersReq();
  static $pb.PbList<NetLoadOffersReq> createRepeated() =>
      new $pb.PbList<NetLoadOffersReq>();
  static NetLoadOffersReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadOffersReq _defaultInstance;
  static void $checkItem(NetLoadOffersReq v) {
    if (v is! NetLoadOffersReq) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get before => $_get(0, 0);
  set before(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasBefore() => $_has(0);
  void clearBefore() => clearField(1);

  int get after => $_get(1, 0);
  set after(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasAfter() => $_has(1);
  void clearAfter() => clearField(2);

  int get limit => $_get(2, 0);
  set limit(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasLimit() => $_has(2);
  void clearLimit() => clearField(3);
}

class NetLoadOffersRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadOffersRes',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'oldest', $pb.PbFieldType.O3)
    ..a<int>(2, 'newest', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadOffersRes() : super();
  NetLoadOffersRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadOffersRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadOffersRes clone() => new NetLoadOffersRes()..mergeFromMessage(this);
  NetLoadOffersRes copyWith(void Function(NetLoadOffersRes) updates) =>
      super.copyWith((message) => updates(message as NetLoadOffersRes));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadOffersRes create() => new NetLoadOffersRes();
  static $pb.PbList<NetLoadOffersRes> createRepeated() =>
      new $pb.PbList<NetLoadOffersRes>();
  static NetLoadOffersRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadOffersRes _defaultInstance;
  static void $checkItem(NetLoadOffersRes v) {
    if (v is! NetLoadOffersRes) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get oldest => $_get(0, 0);
  set oldest(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOldest() => $_has(0);
  void clearOldest() => clearField(1);

  int get newest => $_get(1, 0);
  set newest(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasNewest() => $_has(1);
  void clearNewest() => clearField(2);
}

class NetOfferApplyReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOfferApplyReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'offerId', $pb.PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..a<int>(8, 'sessionGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetOfferApplyReq() : super();
  NetOfferApplyReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetOfferApplyReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetOfferApplyReq clone() => new NetOfferApplyReq()..mergeFromMessage(this);
  NetOfferApplyReq copyWith(void Function(NetOfferApplyReq) updates) =>
      super.copyWith((message) => updates(message as NetOfferApplyReq));
  $pb.BuilderInfo get info_ => _i;
  static NetOfferApplyReq create() => new NetOfferApplyReq();
  static $pb.PbList<NetOfferApplyReq> createRepeated() =>
      new $pb.PbList<NetOfferApplyReq>();
  static NetOfferApplyReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetOfferApplyReq _defaultInstance;
  static void $checkItem(NetOfferApplyReq v) {
    if (v is! NetOfferApplyReq) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get offerId => $_get(0, 0);
  set offerId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  String get remarks => $_getS(1, '');
  set remarks(String v) {
    $_setString(1, v);
  }

  bool hasRemarks() => $_has(1);
  void clearRemarks() => clearField(2);

  int get sessionGhostId => $_get(2, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasSessionGhostId() => $_has(2);
  void clearSessionGhostId() => clearField(8);
}
