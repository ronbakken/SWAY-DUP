///
//  Generated code. Do not modify.
//  source: net_get_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $1;

class NetGetProfileReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetProfileReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'accountId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetGetProfileReq() : super();
  NetGetProfileReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetProfileReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetProfileReq clone() => new NetGetProfileReq()..mergeFromMessage(this);
  NetGetProfileReq copyWith(void Function(NetGetProfileReq) updates) =>
      super.copyWith((message) => updates(message as NetGetProfileReq));
  $pb.BuilderInfo get info_ => _i;
  static NetGetProfileReq create() => new NetGetProfileReq();
  static $pb.PbList<NetGetProfileReq> createRepeated() =>
      new $pb.PbList<NetGetProfileReq>();
  static NetGetProfileReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetProfileReq _defaultInstance;
  static void $checkItem(NetGetProfileReq v) {
    if (v is! NetGetProfileReq) $pb.checkItemFailed(v, _i.messageName);
  }

  int get accountId => $_get(0, 0);
  set accountId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasAccountId() => $_has(0);
  void clearAccountId() => clearField(1);
}

class NetGetProfileRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetProfileRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $1.DataAccount.getDefault, $1.DataAccount.create)
    ..hasRequiredFields = false;

  NetGetProfileRes() : super();
  NetGetProfileRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetProfileRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetProfileRes clone() => new NetGetProfileRes()..mergeFromMessage(this);
  NetGetProfileRes copyWith(void Function(NetGetProfileRes) updates) =>
      super.copyWith((message) => updates(message as NetGetProfileRes));
  $pb.BuilderInfo get info_ => _i;
  static NetGetProfileRes create() => new NetGetProfileRes();
  static $pb.PbList<NetGetProfileRes> createRepeated() =>
      new $pb.PbList<NetGetProfileRes>();
  static NetGetProfileRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetProfileRes _defaultInstance;
  static void $checkItem(NetGetProfileRes v) {
    if (v is! NetGetProfileRes) $pb.checkItemFailed(v, _i.messageName);
  }

  $1.DataAccount get account => $_getN(0);
  set account($1.DataAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);
}

class NetGetOfferReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetOfferReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'offerId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetGetOfferReq() : super();
  NetGetOfferReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetOfferReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetOfferReq clone() => new NetGetOfferReq()..mergeFromMessage(this);
  NetGetOfferReq copyWith(void Function(NetGetOfferReq) updates) =>
      super.copyWith((message) => updates(message as NetGetOfferReq));
  $pb.BuilderInfo get info_ => _i;
  static NetGetOfferReq create() => new NetGetOfferReq();
  static $pb.PbList<NetGetOfferReq> createRepeated() =>
      new $pb.PbList<NetGetOfferReq>();
  static NetGetOfferReq getDefault() => _defaultInstance ??= create()..freeze();
  static NetGetOfferReq _defaultInstance;
  static void $checkItem(NetGetOfferReq v) {
    if (v is! NetGetOfferReq) $pb.checkItemFailed(v, _i.messageName);
  }

  int get offerId => $_get(0, 0);
  set offerId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);
}

class NetGetOfferRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetOfferRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataBusinessOffer>(1, 'offer', $pb.PbFieldType.OM,
        $1.DataBusinessOffer.getDefault, $1.DataBusinessOffer.create)
    ..hasRequiredFields = false;

  NetGetOfferRes() : super();
  NetGetOfferRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetOfferRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetOfferRes clone() => new NetGetOfferRes()..mergeFromMessage(this);
  NetGetOfferRes copyWith(void Function(NetGetOfferRes) updates) =>
      super.copyWith((message) => updates(message as NetGetOfferRes));
  $pb.BuilderInfo get info_ => _i;
  static NetGetOfferRes create() => new NetGetOfferRes();
  static $pb.PbList<NetGetOfferRes> createRepeated() =>
      new $pb.PbList<NetGetOfferRes>();
  static NetGetOfferRes getDefault() => _defaultInstance ??= create()..freeze();
  static NetGetOfferRes _defaultInstance;
  static void $checkItem(NetGetOfferRes v) {
    if (v is! NetGetOfferRes) $pb.checkItemFailed(v, _i.messageName);
  }

  $1.DataBusinessOffer get offer => $_getN(0);
  set offer($1.DataBusinessOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class NetGetApplicantReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetApplicantReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetGetApplicantReq() : super();
  NetGetApplicantReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetApplicantReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetApplicantReq clone() =>
      new NetGetApplicantReq()..mergeFromMessage(this);
  NetGetApplicantReq copyWith(void Function(NetGetApplicantReq) updates) =>
      super.copyWith((message) => updates(message as NetGetApplicantReq));
  $pb.BuilderInfo get info_ => _i;
  static NetGetApplicantReq create() => new NetGetApplicantReq();
  static $pb.PbList<NetGetApplicantReq> createRepeated() =>
      new $pb.PbList<NetGetApplicantReq>();
  static NetGetApplicantReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetApplicantReq _defaultInstance;
  static void $checkItem(NetGetApplicantReq v) {
    if (v is! NetGetApplicantReq) $pb.checkItemFailed(v, _i.messageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);
}

class NetGetApplicantRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetApplicantRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataApplicant>(1, 'applicant', $pb.PbFieldType.OM,
        $1.DataApplicant.getDefault, $1.DataApplicant.create)
    ..hasRequiredFields = false;

  NetGetApplicantRes() : super();
  NetGetApplicantRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetApplicantRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetApplicantRes clone() =>
      new NetGetApplicantRes()..mergeFromMessage(this);
  NetGetApplicantRes copyWith(void Function(NetGetApplicantRes) updates) =>
      super.copyWith((message) => updates(message as NetGetApplicantRes));
  $pb.BuilderInfo get info_ => _i;
  static NetGetApplicantRes create() => new NetGetApplicantRes();
  static $pb.PbList<NetGetApplicantRes> createRepeated() =>
      new $pb.PbList<NetGetApplicantRes>();
  static NetGetApplicantRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetApplicantRes _defaultInstance;
  static void $checkItem(NetGetApplicantRes v) {
    if (v is! NetGetApplicantRes) $pb.checkItemFailed(v, _i.messageName);
  }

  $1.DataApplicant get applicant => $_getN(0);
  set applicant($1.DataApplicant v) {
    setField(1, v);
  }

  bool hasApplicant() => $_has(0);
  void clearApplicant() => clearField(1);
}
