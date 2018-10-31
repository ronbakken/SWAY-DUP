///
//  Generated code. Do not modify.
//  source: net_applicants_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $1;

class NetLoadApplicantsReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadApplicantsReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..a<int>(4, 'offerId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadApplicantsReq() : super();
  NetLoadApplicantsReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadApplicantsReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadApplicantsReq clone() =>
      new NetLoadApplicantsReq()..mergeFromMessage(this);
  NetLoadApplicantsReq copyWith(void Function(NetLoadApplicantsReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadApplicantsReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadApplicantsReq create() => new NetLoadApplicantsReq();
  static $pb.PbList<NetLoadApplicantsReq> createRepeated() =>
      new $pb.PbList<NetLoadApplicantsReq>();
  static NetLoadApplicantsReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadApplicantsReq _defaultInstance;
  static void $checkItem(NetLoadApplicantsReq v) {
    if (v is! NetLoadApplicantsReq)
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

class NetLoadApplicantReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetLoadApplicantReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadApplicantReq() : super();
  NetLoadApplicantReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadApplicantReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadApplicantReq clone() =>
      new NetLoadApplicantReq()..mergeFromMessage(this);
  NetLoadApplicantReq copyWith(void Function(NetLoadApplicantReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadApplicantReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadApplicantReq create() => new NetLoadApplicantReq();
  static $pb.PbList<NetLoadApplicantReq> createRepeated() =>
      new $pb.PbList<NetLoadApplicantReq>();
  static NetLoadApplicantReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadApplicantReq _defaultInstance;
  static void $checkItem(NetLoadApplicantReq v) {
    if (v is! NetLoadApplicantReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);
}

class NetLoadApplicantChatsReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetLoadApplicantChatsReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'before', $pb.PbFieldType.O3)
    ..a<int>(2, 'after', $pb.PbFieldType.O3)
    ..a<int>(3, 'limit', $pb.PbFieldType.O3)
    ..a<int>(5, 'applicantId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetLoadApplicantChatsReq() : super();
  NetLoadApplicantChatsReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetLoadApplicantChatsReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetLoadApplicantChatsReq clone() =>
      new NetLoadApplicantChatsReq()..mergeFromMessage(this);
  NetLoadApplicantChatsReq copyWith(
          void Function(NetLoadApplicantChatsReq) updates) =>
      super.copyWith((message) => updates(message as NetLoadApplicantChatsReq));
  $pb.BuilderInfo get info_ => _i;
  static NetLoadApplicantChatsReq create() => new NetLoadApplicantChatsReq();
  static $pb.PbList<NetLoadApplicantChatsReq> createRepeated() =>
      new $pb.PbList<NetLoadApplicantChatsReq>();
  static NetLoadApplicantChatsReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetLoadApplicantChatsReq _defaultInstance;
  static void $checkItem(NetLoadApplicantChatsReq v) {
    if (v is! NetLoadApplicantChatsReq)
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

  int get applicantId => $_get(3, 0);
  set applicantId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasApplicantId() => $_has(3);
  void clearApplicantId() => clearField(5);
}

class NetChatPlain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      new $pb.BuilderInfo('NetChatPlain', package: const $pb.PackageName('inf'))
        ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
        ..aOS(6, 'text')
        ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
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

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get text => $_getS(1, '');
  set text(String v) {
    $_setString(1, v);
  }

  bool hasText() => $_has(1);
  void clearText() => clearField(6);

  int get deviceGhostId => $_get(2, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasDeviceGhostId() => $_has(2);
  void clearDeviceGhostId() => clearField(8);
}

class NetChatHaggle extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatHaggle',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(2, 'remarks')
    ..aOS(3, 'deliverables')
    ..aOS(4, 'reward')
    ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
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

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

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

  int get deviceGhostId => $_get(4, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(4, v);
  }

  bool hasDeviceGhostId() => $_has(4);
  void clearDeviceGhostId() => clearField(8);
}

class NetChatImageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatImageKey',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(5, 'imageKey')
    ..a<int>(8, 'deviceGhostId', $pb.PbFieldType.O3)
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

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get imageKey => $_getS(1, '');
  set imageKey(String v) {
    $_setString(1, v);
  }

  bool hasImageKey() => $_has(1);
  void clearImageKey() => clearField(5);

  int get deviceGhostId => $_get(2, 0);
  set deviceGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasDeviceGhostId() => $_has(2);
  void clearDeviceGhostId() => clearField(8);
}

class NetApplicantWantDealReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetApplicantWantDealReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aInt64(2, 'haggleChatId')
    ..hasRequiredFields = false;

  NetApplicantWantDealReq() : super();
  NetApplicantWantDealReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantWantDealReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantWantDealReq clone() =>
      new NetApplicantWantDealReq()..mergeFromMessage(this);
  NetApplicantWantDealReq copyWith(
          void Function(NetApplicantWantDealReq) updates) =>
      super.copyWith((message) => updates(message as NetApplicantWantDealReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantWantDealReq create() => new NetApplicantWantDealReq();
  static $pb.PbList<NetApplicantWantDealReq> createRepeated() =>
      new $pb.PbList<NetApplicantWantDealReq>();
  static NetApplicantWantDealReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantWantDealReq _defaultInstance;
  static void $checkItem(NetApplicantWantDealReq v) {
    if (v is! NetApplicantWantDealReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  Int64 get haggleChatId => $_getI64(1);
  set haggleChatId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasHaggleChatId() => $_has(1);
  void clearHaggleChatId() => clearField(2);
}

class NetApplicantRejectReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetApplicantRejectReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(2, 'reason')
    ..hasRequiredFields = false;

  NetApplicantRejectReq() : super();
  NetApplicantRejectReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantRejectReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantRejectReq clone() =>
      new NetApplicantRejectReq()..mergeFromMessage(this);
  NetApplicantRejectReq copyWith(
          void Function(NetApplicantRejectReq) updates) =>
      super.copyWith((message) => updates(message as NetApplicantRejectReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantRejectReq create() => new NetApplicantRejectReq();
  static $pb.PbList<NetApplicantRejectReq> createRepeated() =>
      new $pb.PbList<NetApplicantRejectReq>();
  static NetApplicantRejectReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantRejectReq _defaultInstance;
  static void $checkItem(NetApplicantRejectReq v) {
    if (v is! NetApplicantRejectReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get reason => $_getS(1, '');
  set reason(String v) {
    $_setString(1, v);
  }

  bool hasReason() => $_has(1);
  void clearReason() => clearField(2);
}

class NetApplicantReportReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetApplicantReportReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOS(2, 'text')
    ..hasRequiredFields = false;

  NetApplicantReportReq() : super();
  NetApplicantReportReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantReportReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantReportReq clone() =>
      new NetApplicantReportReq()..mergeFromMessage(this);
  NetApplicantReportReq copyWith(
          void Function(NetApplicantReportReq) updates) =>
      super.copyWith((message) => updates(message as NetApplicantReportReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantReportReq create() => new NetApplicantReportReq();
  static $pb.PbList<NetApplicantReportReq> createRepeated() =>
      new $pb.PbList<NetApplicantReportReq>();
  static NetApplicantReportReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantReportReq _defaultInstance;
  static void $checkItem(NetApplicantReportReq v) {
    if (v is! NetApplicantReportReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

  String get text => $_getS(1, '');
  set text(String v) {
    $_setString(1, v);
  }

  bool hasText() => $_has(1);
  void clearText() => clearField(2);
}

class NetApplicantCompletionReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'NetApplicantCompletionReq',
      package: const $pb.PackageName('inf'))
    ..a<int>(1, 'applicantId', $pb.PbFieldType.O3)
    ..aOB(2, 'delivered')
    ..aOB(3, 'rewarded')
    ..a<int>(4, 'rating', $pb.PbFieldType.O3)
    ..aOB(5, 'dispute')
    ..aOS(6, 'disputeDescription')
    ..hasRequiredFields = false;

  NetApplicantCompletionReq() : super();
  NetApplicantCompletionReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantCompletionReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantCompletionReq clone() =>
      new NetApplicantCompletionReq()..mergeFromMessage(this);
  NetApplicantCompletionReq copyWith(
          void Function(NetApplicantCompletionReq) updates) =>
      super
          .copyWith((message) => updates(message as NetApplicantCompletionReq));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantCompletionReq create() => new NetApplicantCompletionReq();
  static $pb.PbList<NetApplicantCompletionReq> createRepeated() =>
      new $pb.PbList<NetApplicantCompletionReq>();
  static NetApplicantCompletionReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantCompletionReq _defaultInstance;
  static void $checkItem(NetApplicantCompletionReq v) {
    if (v is! NetApplicantCompletionReq)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get applicantId => $_get(0, 0);
  set applicantId(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasApplicantId() => $_has(0);
  void clearApplicantId() => clearField(1);

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

class NetApplicantCommonRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetApplicantCommonRes',
      package: const $pb.PackageName('inf'))
    ..a<$1.DataApplicant>(1, 'updateApplicant', $pb.PbFieldType.OM,
        $1.DataApplicant.getDefault, $1.DataApplicant.create)
    ..pp<$1.DataApplicantChat>(2, 'newChats', $pb.PbFieldType.PM,
        $1.DataApplicantChat.$checkItem, $1.DataApplicantChat.create)
    ..hasRequiredFields = false;

  NetApplicantCommonRes() : super();
  NetApplicantCommonRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplicantCommonRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplicantCommonRes clone() =>
      new NetApplicantCommonRes()..mergeFromMessage(this);
  NetApplicantCommonRes copyWith(
          void Function(NetApplicantCommonRes) updates) =>
      super.copyWith((message) => updates(message as NetApplicantCommonRes));
  $pb.BuilderInfo get info_ => _i;
  static NetApplicantCommonRes create() => new NetApplicantCommonRes();
  static $pb.PbList<NetApplicantCommonRes> createRepeated() =>
      new $pb.PbList<NetApplicantCommonRes>();
  static NetApplicantCommonRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplicantCommonRes _defaultInstance;
  static void $checkItem(NetApplicantCommonRes v) {
    if (v is! NetApplicantCommonRes)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $1.DataApplicant get updateApplicant => $_getN(0);
  set updateApplicant($1.DataApplicant v) {
    setField(1, v);
  }

  bool hasUpdateApplicant() => $_has(0);
  void clearUpdateApplicant() => clearField(1);

  List<$1.DataApplicantChat> get newChats => $_getList(1);
}
