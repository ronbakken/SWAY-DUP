///
//  Generated code. Do not modify.
//  source: net_get_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $1;

class NetGetOfferReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetOfferReq',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'offerId')
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

  Int64 get offerId => $_getI64(0);
  set offerId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);
}

class NetGetOfferRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetOfferRes',
      package: const $pb.PackageName('inf_common'))
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
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
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

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);
}

class NetGetProposalRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetProposalRes',
      package: const $pb.PackageName('inf_common'))
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
