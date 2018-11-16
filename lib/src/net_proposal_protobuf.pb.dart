///
//  Generated code. Do not modify.
//  source: net_proposal_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $1;

class NetLoadProposalsReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadProposalsReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..a<int>(4, 'offerId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadProposalsReq() : super();
  NetLoadProposalsReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadProposalsReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadProposalsReq clone() =>
      new NetLoadProposalsReq()..mergeFromMessage(this);
  NetLoadProposalsReq copyWith(void Function(NetLoadProposalsReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadProposalsReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadProposalsReq create() => new NetLoadProposalsReq();
  static $pb.PbList<NetLoadProposalsReq> createRepeated() =>
      new $pb.PbList<NetLoadProposalsReq>();
  static NetLoadProposalsReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadProposalsReq _defaultInstance;
  static void $checkItem(NetLoadProposalsReq v) {
    if (v is! NetLoadProposalsReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

  int get offerId => $_get(3, 0);
  set offerId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasOfferId() => $_has(3);
  void clearOfferId() => clearField(4);
}

class NetLoadProposalReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadProposalReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadProposalReq() : super();
  NetLoadProposalReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadProposalReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadProposalReq clone() =>
      new NetLoadProposalReq()..mergeFromMessage(this);
  NetLoadProposalReq copyWith(void Function(NetLoadProposalReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadProposalReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadProposalReq create() => new NetLoadProposalReq();
  static $pb.PbList<NetLoadProposalReq> createRepeated() =>
      new $pb.PbList<NetLoadProposalReq>();
  static NetLoadProposalReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadProposalReq _defaultInstance;
  static void $checkItem(NetLoadProposalReq v) {
    if (v is! NetLoadProposalReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);
}

class NetLoadProposalChatsReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetLoadProposalChatsReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..a<int>(5, 'proposalId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadProposalChatsReq() : super();
  NetLoadProposalChatsReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadProposalChatsReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadProposalChatsReq clone() =>
      new NetLoadProposalChatsReq()..mergeFromMessage(this);
  NetLoadProposalChatsReq copyWith(
          void Function(NetLoadProposalChatsReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadProposalChatsReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadProposalChatsReq create() => new NetLoadProposalChatsReq();
  static $pb.PbList<NetLoadProposalChatsReq> createRepeated() =>
      new $pb.PbList<NetLoadProposalChatsReq>();
  static NetLoadProposalChatsReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadProposalChatsReq _defaultInstance;
  static void $checkItem(NetLoadProposalChatsReq v) {
    if (v is! NetLoadProposalChatsReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

  int get proposalId => $_get(3, 0);
  set proposalId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasProposalId() => $_has(3);
  void clearProposalId() => clearField(5);
}

class NetChatPlain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('NetChatPlain', package: const $pb.PackageName('inf'))
        ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
        ..aOS(6, 'text')
        ..a<int>(8, 'sessionGhostId', $pb.PbFieldType.O3)
        ..hasRequiredFields = false;

  NetChatPlain() : super();
  NetChatPlain.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatPlain.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatPlain clone() => new NetChatPlain()..mergeFromMessage(this);
  NetChatPlain copyWith(void Function(NetChatPlain) updates) =>
      super.copyWith((message) => updates(message as NetChatPlain));
  $pb.BuilderInfo get info_ => _i;
  static NetChatPlain create() => new NetChatPlain();
  static $pb.PbList<NetChatPlain> createRepeated() =>
      new $pb.PbList<NetChatPlain>();
  static NetChatPlain getDefault() => _defaultInstance ??= create()..freeze();
  static NetChatPlain _defaultInstance;
  static void $checkItem(NetChatPlain v) {
    if (v is! NetChatPlain) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  String get text => $_getS(1, '');
  set text(String v) {
    $_setString(1, v);
  }

  bool hasText() => $_has(1);
  void clearText() => clearField(6);

  int get sessionGhostId => $_get(2, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasSessionGhostId() => $_has(2);
  void clearSessionGhostId() => clearField(8);
}

class NetChatHaggle extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatHaggle',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..aOS(3, 'deliverables')
    ..aOS(4, 'reward')
    ..a<int>(8, 'sessionGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatHaggle() : super();
  NetChatHaggle.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatHaggle.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatHaggle clone() => new NetChatHaggle()..mergeFromMessage(this);
  NetChatHaggle copyWith(void Function(NetChatHaggle) updates) =>
      super.copyWith((message) => updates(message as NetChatHaggle));
  $pb.BuilderInfo get info_ => _i;
  static NetChatHaggle create() => new NetChatHaggle();
  static $pb.PbList<NetChatHaggle> createRepeated() =>
      new $pb.PbList<NetChatHaggle>();
  static NetChatHaggle getDefault() => _defaultInstance ??= create()..freeze();
  static NetChatHaggle _defaultInstance;
  static void $checkItem(NetChatHaggle v) {
    if (v is! NetChatHaggle) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  String get remarks => $_getS(1, '');
  set remarks(String v) {
    $_setString(1, v);
  }

  bool hasRemarks() => $_has(1);
  void clearRemarks() => clearField(2);

  String get deliverables => $_getS(2, '');
  set deliverables(String v) {
    $_setString(2, v);
  }

  bool hasDeliverables() => $_has(2);
  void clearDeliverables() => clearField(3);

  String get reward => $_getS(3, '');
  set reward(String v) {
    $_setString(3, v);
  }

  bool hasReward() => $_has(3);
  void clearReward() => clearField(4);

  int get sessionGhostId => $_get(4, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasSessionGhostId() => $_has(4);
  void clearSessionGhostId() => clearField(8);
}

class NetChatImageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatImageKey',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..aOS(5, 'imageKey')
    ..a<int>(8, 'sessionGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatImageKey() : super();
  NetChatImageKey.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatImageKey.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatImageKey clone() => new NetChatImageKey()..mergeFromMessage(this);
  NetChatImageKey copyWith(void Function(NetChatImageKey) updates) =>
      super.copyWith((message) => updates(message as NetChatImageKey));
  $pb.BuilderInfo get info_ => _i;
  static NetChatImageKey create() => new NetChatImageKey();
  static $pb.PbList<NetChatImageKey> createRepeated() =>
      new $pb.PbList<NetChatImageKey>();
  static NetChatImageKey getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetChatImageKey _defaultInstance;
  static void $checkItem(NetChatImageKey v) {
    if (v is! NetChatImageKey) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  String get imageKey => $_getS(1, '');
  set imageKey(String v) {
    $_setString(1, v);
  }

  bool hasImageKey() => $_has(1);
  void clearImageKey() => clearField(5);

  int get sessionGhostId => $_get(2, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasSessionGhostId() => $_has(2);
  void clearSessionGhostId() => clearField(8);
}

class NetProposalWantDealReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetProposalWantDealReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..aInt64(2, 'haggleChatId')
    ..hasRequiredFields = false;

  NetProposalWantDealReq() : super();
  NetProposalWantDealReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalWantDealReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalWantDealReq clone() =>
      new NetProposalWantDealReq()..mergeFromMessage(this);
  NetProposalWantDealReq copyWith(
          void Function(NetProposalWantDealReq) updates) =>
      super.copyWith((message) => updates(message as NetProposalWantDealReq));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalWantDealReq create() => new NetProposalWantDealReq();
  static $pb.PbList<NetProposalWantDealReq> createRepeated() =>
      new $pb.PbList<NetProposalWantDealReq>();
  static NetProposalWantDealReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalWantDealReq _defaultInstance;
  static void $checkItem(NetProposalWantDealReq v) {
    if (v is! NetProposalWantDealReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  Int64 get haggleChatId => $_getI64(1);
  set haggleChatId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasHaggleChatId() => $_has(1);
  void clearHaggleChatId() => clearField(2);
}

class NetProposalRejectReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalRejectReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..aOS(2, 'reason')
    ..hasRequiredFields = false;

  NetProposalRejectReq() : super();
  NetProposalRejectReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalRejectReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalRejectReq clone() =>
      new NetProposalRejectReq()..mergeFromMessage(this);
  NetProposalRejectReq copyWith(void Function(NetProposalRejectReq) updates) =>
      super.copyWith((message) => updates(message as NetProposalRejectReq));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalRejectReq create() => new NetProposalRejectReq();
  static $pb.PbList<NetProposalRejectReq> createRepeated() =>
      new $pb.PbList<NetProposalRejectReq>();
  static NetProposalRejectReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalRejectReq _defaultInstance;
  static void $checkItem(NetProposalRejectReq v) {
    if (v is! NetProposalRejectReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  String get reason => $_getS(1, '');
  set reason(String v) {
    $_setString(1, v);
  }

  bool hasReason() => $_has(1);
  void clearReason() => clearField(2);
}

class NetProposalReportReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalReportReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..aOS(2, 'text')
    ..hasRequiredFields = false;

  NetProposalReportReq() : super();
  NetProposalReportReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalReportReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalReportReq clone() =>
      new NetProposalReportReq()..mergeFromMessage(this);
  NetProposalReportReq copyWith(void Function(NetProposalReportReq) updates) =>
      super.copyWith((message) => updates(message as NetProposalReportReq));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalReportReq create() => new NetProposalReportReq();
  static $pb.PbList<NetProposalReportReq> createRepeated() =>
      new $pb.PbList<NetProposalReportReq>();
  static NetProposalReportReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalReportReq _defaultInstance;
  static void $checkItem(NetProposalReportReq v) {
    if (v is! NetProposalReportReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  String get text => $_getS(1, '');
  set text(String v) {
    $_setString(1, v);
  }

  bool hasText() => $_has(1);
  void clearText() => clearField(2);
}

class NetProposalCompletionReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetProposalCompletionReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'proposalId', $pb.PbFieldType.O3)
    ..aOB(2, 'delivered')
    ..aOB(3, 'rewarded')
    ..a<int>(4, 'rating', $pb.PbFieldType.O3)
    ..aOB(5, 'dispute')
    ..aOS(6, 'disputeDescription')
    ..hasRequiredFields = false;

  NetProposalCompletionReq() : super();
  NetProposalCompletionReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalCompletionReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalCompletionReq clone() =>
      new NetProposalCompletionReq()..mergeFromMessage(this);
  NetProposalCompletionReq copyWith(
          void Function(NetProposalCompletionReq) updates) =>
      super.copyWith((message) => updates(message as NetProposalCompletionReq));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalCompletionReq create() => new NetProposalCompletionReq();
  static $pb.PbList<NetProposalCompletionReq> createRepeated() =>
      new $pb.PbList<NetProposalCompletionReq>();
  static NetProposalCompletionReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalCompletionReq _defaultInstance;
  static void $checkItem(NetProposalCompletionReq v) {
    if (v is! NetProposalCompletionReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get proposalId => $_get(0, 0);
  set proposalId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  bool get delivered => $_get(1, false);
  set delivered(bool v) {
    $_setBool(1, v);
  }

  bool hasDelivered() => $_has(1);
  void clearDelivered() => clearField(2);

  bool get rewarded => $_get(2, false);
  set rewarded(bool v) {
    $_setBool(2, v);
  }

  bool hasRewarded() => $_has(2);
  void clearRewarded() => clearField(3);

  int get rating => $_get(3, 0);
  set rating(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasRating() => $_has(3);
  void clearRating() => clearField(4);

  bool get dispute => $_get(4, false);
  set dispute(bool v) {
    $_setBool(4, v);
  }

  bool hasDispute() => $_has(4);
  void clearDispute() => clearField(5);

  String get disputeDescription => $_getS(5, '');
  set disputeDescription(String v) {
    $_setString(5, v);
  }

  bool hasDisputeDescription() => $_has(5);
  void clearDisputeDescription() => clearField(6);
}

class NetProposalCommonRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalCommonRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataProposal>(1, 'updateProposal', $pb.PbFieldType.OM,
        $1.DataProposal.getDefault, $1.DataProposal.create)
    ..pp<$1.DataProposalChat>(2, 'newChats', $pb.PbFieldType.PM,
        $1.DataProposalChat.$checkItem, $1.DataProposalChat.create)
    ..hasRequiredFields = false;

  NetProposalCommonRes() : super();
  NetProposalCommonRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalCommonRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalCommonRes clone() =>
      new NetProposalCommonRes()..mergeFromMessage(this);
  NetProposalCommonRes copyWith(void Function(NetProposalCommonRes) updates) =>
      super.copyWith((message) => updates(message as NetProposalCommonRes));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalCommonRes create() => new NetProposalCommonRes();
  static $pb.PbList<NetProposalCommonRes> createRepeated() =>
      new $pb.PbList<NetProposalCommonRes>();
  static NetProposalCommonRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalCommonRes _defaultInstance;
  static void $checkItem(NetProposalCommonRes v) {
    if (v is! NetProposalCommonRes)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataProposal get updateProposal => $_getN(0);
  set updateProposal($1.DataProposal v) {
    setField(1, v);
  }

  bool hasUpdateProposal() => $_has(0);
  void clearUpdateProposal() => clearField(1);

  List<$1.DataProposalChat> get newChats => $_getList(1);
}
