///
//  Generated code. Do not modify.
//  source: net_offer_influencer_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

class NetOfferApplyReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetOfferApplyReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'offerId', $pb.PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
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

  int get deviceGhostId => $_get(2, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasDeviceGhostId() => $_has(2);
  void clearDeviceGhostId() => clearField(8);
}
