///
//  Generated code. Do not modify.
//  source: net_get_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $1;

class NetGetAccountReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetAccountReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'accountId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetGetAccountReq() : super();
  NetGetAccountReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetAccountReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetAccountReq clone() => new NetGetAccountReq()..mergeFromMessage(this);
  NetGetAccountReq copyWith(void Function(NetGetAccountReq) updates) =>
      super.copyWith((message) => updates(message as NetGetAccountReq));
  $pb.BuilderInfo get info_ => _i;
  static NetGetAccountReq create() => new NetGetAccountReq();
  static $pb.PbList<NetGetAccountReq> createRepeated() =>
      new $pb.PbList<NetGetAccountReq>();
  static NetGetAccountReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetAccountReq _defaultInstance;
  static void $checkItem(NetGetAccountReq v) {
    if (v is! NetGetAccountReq) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get accountId => $_get(0, 0);
  set accountId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasAccountId() => $_has(0);
  void clearAccountId() => clearField(1);
}

class NetGetAccountRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetAccountRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $1.DataAccount.getDefault, $1.DataAccount.create)
    ..hasRequiredFields = false;

  NetGetAccountRes() : super();
  NetGetAccountRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetAccountRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetAccountRes clone() => new NetGetAccountRes()..mergeFromMessage(this);
  NetGetAccountRes copyWith(void Function(NetGetAccountRes) updates) =>
      super.copyWith((message) => updates(message as NetGetAccountRes));
  $pb.BuilderInfo get info_ => _i;
  static NetGetAccountRes create() => new NetGetAccountRes();
  static $pb.PbList<NetGetAccountRes> createRepeated() =>
      new $pb.PbList<NetGetAccountRes>();
  static NetGetAccountRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetAccountRes _defaultInstance;
  static void $checkItem(NetGetAccountRes v) {
    if (v is! NetGetAccountRes) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
    if (v is! NetGetOfferReq) $pb.checkItemFailed(v, _i.qualifiedMessageName);
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
    ..a<$1.DataOffer>(1, 'offer', $pb.PbFieldType.OM, $1.DataOffer.getDefault,
        $1.DataOffer.create)
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
    if (v is! NetGetOfferRes) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataOffer get offer => $_getN(0);
  set offer($1.DataOffer v) {
    setField(1, v);
  }

  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class NetGetProposalReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetProposalReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetGetProposalReq() : super();
  NetGetProposalReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetProposalReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetProposalReq clone() => new NetGetProposalReq()..mergeFromMessage(this);
  NetGetProposalReq copyWith(void Function(NetGetProposalReq) updates) =>
      super.copyWith((message) => updates(message as NetGetProposalReq));
  $pb.BuilderInfo get info_ => _i;
  static NetGetProposalReq create() => new NetGetProposalReq();
  static $pb.PbList<NetGetProposalReq> createRepeated() =>
      new $pb.PbList<NetGetProposalReq>();
  static NetGetProposalReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetProposalReq _defaultInstance;
  static void $checkItem(NetGetProposalReq v) {
    if (v is! NetGetProposalReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);
}

class NetGetProposalRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetProposalRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataProposal>(1, 'proposal', $pb.PbFieldType.OM,
        $1.DataProposal.getDefault, $1.DataProposal.create)
    ..hasRequiredFields = false;

  NetGetProposalRes() : super();
  NetGetProposalRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetProposalRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetProposalRes clone() => new NetGetProposalRes()..mergeFromMessage(this);
  NetGetProposalRes copyWith(void Function(NetGetProposalRes) updates) =>
      super.copyWith((message) => updates(message as NetGetProposalRes));
  $pb.BuilderInfo get info_ => _i;
  static NetGetProposalRes create() => new NetGetProposalRes();
  static $pb.PbList<NetGetProposalRes> createRepeated() =>
      new $pb.PbList<NetGetProposalRes>();
  static NetGetProposalRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetGetProposalRes _defaultInstance;
  static void $checkItem(NetGetProposalRes v) {
    if (v is! NetGetProposalRes)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataProposal get proposal => $_getN(0);
  set proposal($1.DataProposal v) {
    setField(1, v);
  }

  bool hasProposal() => $_has(0);
  void clearProposal() => clearField(1);
}
