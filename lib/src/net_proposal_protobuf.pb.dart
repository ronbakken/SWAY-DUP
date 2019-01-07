///
//  Generated code. Do not modify.
//  source: net_proposal_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $3;

class NetProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposal',
      package: const $pb.PackageName('inf_common'))
    ..a<$3.DataProposal>(1, 'proposal', $pb.PbFieldType.OM,
        $3.DataProposal.getDefault, $3.DataProposal.create)
    ..pp<$3.DataProposalChat>(2, 'chats', $pb.PbFieldType.PM,
        $3.DataProposalChat.$checkItem, $3.DataProposalChat.create)
    ..hasRequiredFields = false;

  NetProposal() : super();
  NetProposal.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposal.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposal clone() => new NetProposal()..mergeFromMessage(this);
  NetProposal copyWith(void Function(NetProposal) updates) =>
      super.copyWith((message) => updates(message as NetProposal));
  $pb.BuilderInfo get info_ => _i;
  static NetProposal create() => new NetProposal();
  static $pb.PbList<NetProposal> createRepeated() =>
      new $pb.PbList<NetProposal>();
  static NetProposal getDefault() => _defaultInstance ??= create()..freeze();
  static NetProposal _defaultInstance;
  static void $checkItem(NetProposal v) {
    if (v is! NetProposal) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $3.DataProposal get proposal => $_getN(0);
  set proposal($3.DataProposal v) {
    setField(1, v);
  }

  bool hasProposal() => $_has(0);
  void clearProposal() => clearField(1);

  List<$3.DataProposalChat> get chats => $_getList(1);
}

class NetProposalChat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalChat',
      package: const $pb.PackageName('inf_common'))
    ..a<$3.DataProposalChat>(1, 'chat', $pb.PbFieldType.OM,
        $3.DataProposalChat.getDefault, $3.DataProposalChat.create)
    ..hasRequiredFields = false;

  NetProposalChat() : super();
  NetProposalChat.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalChat.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalChat clone() => new NetProposalChat()..mergeFromMessage(this);
  NetProposalChat copyWith(void Function(NetProposalChat) updates) =>
      super.copyWith((message) => updates(message as NetProposalChat));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalChat create() => new NetProposalChat();
  static $pb.PbList<NetProposalChat> createRepeated() =>
      new $pb.PbList<NetProposalChat>();
  static NetProposalChat getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalChat _defaultInstance;
  static void $checkItem(NetProposalChat v) {
    if (v is! NetProposalChat) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $3.DataProposalChat get chat => $_getN(0);
  set chat($3.DataProposalChat v) {
    setField(1, v);
  }

  bool hasChat() => $_has(0);
  void clearChat() => clearField(1);
}

class NetApplyProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetApplyProposal',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'offerId')
    ..aOS(2, 'remarks')
    ..a<$3.DataTerms>(3, 'terms', $pb.PbFieldType.OM, $3.DataTerms.getDefault,
        $3.DataTerms.create)
    ..a<int>(8, 'sessionGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetApplyProposal() : super();
  NetApplyProposal.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetApplyProposal.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetApplyProposal clone() => new NetApplyProposal()..mergeFromMessage(this);
  NetApplyProposal copyWith(void Function(NetApplyProposal) updates) =>
      super.copyWith((message) => updates(message as NetApplyProposal));
  $pb.BuilderInfo get info_ => _i;
  static NetApplyProposal create() => new NetApplyProposal();
  static $pb.PbList<NetApplyProposal> createRepeated() =>
      new $pb.PbList<NetApplyProposal>();
  static NetApplyProposal getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetApplyProposal _defaultInstance;
  static void $checkItem(NetApplyProposal v) {
    if (v is! NetApplyProposal) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get offerId => $_getI64(0);
  set offerId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  String get remarks => $_getS(1, '');
  set remarks(String v) {
    $_setString(1, v);
  }

  bool hasRemarks() => $_has(1);
  void clearRemarks() => clearField(2);

  $3.DataTerms get terms => $_getN(2);
  set terms($3.DataTerms v) {
    setField(3, v);
  }

  bool hasTerms() => $_has(2);
  void clearTerms() => clearField(3);

  int get sessionGhostId => $_get(3, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasSessionGhostId() => $_has(3);
  void clearSessionGhostId() => clearField(8);
}

class NetDirectProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetDirectProposal',
      package: const $pb.PackageName('inf_common'))
    ..aOS(2, 'remarks')
    ..a<$3.DataOffer>(4, 'offer', $pb.PbFieldType.OM, $3.DataOffer.getDefault,
        $3.DataOffer.create)
    ..a<int>(8, 'sessionGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetDirectProposal() : super();
  NetDirectProposal.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDirectProposal.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDirectProposal clone() => new NetDirectProposal()..mergeFromMessage(this);
  NetDirectProposal copyWith(void Function(NetDirectProposal) updates) =>
      super.copyWith((message) => updates(message as NetDirectProposal));
  $pb.BuilderInfo get info_ => _i;
  static NetDirectProposal create() => new NetDirectProposal();
  static $pb.PbList<NetDirectProposal> createRepeated() =>
      new $pb.PbList<NetDirectProposal>();
  static NetDirectProposal getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetDirectProposal _defaultInstance;
  static void $checkItem(NetDirectProposal v) {
    if (v is! NetDirectProposal)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get remarks => $_getS(0, '');
  set remarks(String v) {
    $_setString(0, v);
  }

  bool hasRemarks() => $_has(0);
  void clearRemarks() => clearField(2);

  $3.DataOffer get offer => $_getN(1);
  set offer($3.DataOffer v) {
    setField(4, v);
  }

  bool hasOffer() => $_has(1);
  void clearOffer() => clearField(4);

  int get sessionGhostId => $_get(2, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasSessionGhostId() => $_has(2);
  void clearSessionGhostId() => clearField(8);
}

class NetListProposals extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetListProposals',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(4, 'offerId')
    ..hasRequiredFields = false;

  NetListProposals() : super();
  NetListProposals.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetListProposals.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetListProposals clone() => new NetListProposals()..mergeFromMessage(this);
  NetListProposals copyWith(void Function(NetListProposals) updates) =>
      super.copyWith((message) => updates(message as NetListProposals));
  $pb.BuilderInfo get info_ => _i;
  static NetListProposals create() => new NetListProposals();
  static $pb.PbList<NetListProposals> createRepeated() =>
      new $pb.PbList<NetListProposals>();
  static NetListProposals getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetListProposals _defaultInstance;
  static void $checkItem(NetListProposals v) {
    if (v is! NetListProposals) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get offerId => $_getI64(0);
  set offerId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(4);
}

class NetGetProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetProposal',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..hasRequiredFields = false;

  NetGetProposal() : super();
  NetGetProposal.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetProposal.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetProposal clone() => new NetGetProposal()..mergeFromMessage(this);
  NetGetProposal copyWith(void Function(NetGetProposal) updates) =>
      super.copyWith((message) => updates(message as NetGetProposal));
  $pb.BuilderInfo get info_ => _i;
  static NetGetProposal create() => new NetGetProposal();
  static $pb.PbList<NetGetProposal> createRepeated() =>
      new $pb.PbList<NetGetProposal>();
  static NetGetProposal getDefault() => _defaultInstance ??= create()..freeze();
  static NetGetProposal _defaultInstance;
  static void $checkItem(NetGetProposal v) {
    if (v is! NetGetProposal) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);
}

class NetProposalWantDeal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalWantDeal',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..aInt64(2, 'termsChatId')
    ..hasRequiredFields = false;

  NetProposalWantDeal() : super();
  NetProposalWantDeal.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalWantDeal.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalWantDeal clone() =>
      new NetProposalWantDeal()..mergeFromMessage(this);
  NetProposalWantDeal copyWith(void Function(NetProposalWantDeal) updates) =>
      super.copyWith((message) => updates(message as NetProposalWantDeal));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalWantDeal create() => new NetProposalWantDeal();
  static $pb.PbList<NetProposalWantDeal> createRepeated() =>
      new $pb.PbList<NetProposalWantDeal>();
  static NetProposalWantDeal getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalWantDeal _defaultInstance;
  static void $checkItem(NetProposalWantDeal v) {
    if (v is! NetProposalWantDeal)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  Int64 get termsChatId => $_getI64(1);
  set termsChatId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasTermsChatId() => $_has(1);
  void clearTermsChatId() => clearField(2);
}

class NetProposalNegotiate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalNegotiate',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..hasRequiredFields = false;

  NetProposalNegotiate() : super();
  NetProposalNegotiate.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalNegotiate.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalNegotiate clone() =>
      new NetProposalNegotiate()..mergeFromMessage(this);
  NetProposalNegotiate copyWith(void Function(NetProposalNegotiate) updates) =>
      super.copyWith((message) => updates(message as NetProposalNegotiate));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalNegotiate create() => new NetProposalNegotiate();
  static $pb.PbList<NetProposalNegotiate> createRepeated() =>
      new $pb.PbList<NetProposalNegotiate>();
  static NetProposalNegotiate getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalNegotiate _defaultInstance;
  static void $checkItem(NetProposalNegotiate v) {
    if (v is! NetProposalNegotiate)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);
}

class NetProposalReject extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalReject',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..aOS(2, 'reason')
    ..hasRequiredFields = false;

  NetProposalReject() : super();
  NetProposalReject.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalReject.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalReject clone() => new NetProposalReject()..mergeFromMessage(this);
  NetProposalReject copyWith(void Function(NetProposalReject) updates) =>
      super.copyWith((message) => updates(message as NetProposalReject));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalReject create() => new NetProposalReject();
  static $pb.PbList<NetProposalReject> createRepeated() =>
      new $pb.PbList<NetProposalReject>();
  static NetProposalReject getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalReject _defaultInstance;
  static void $checkItem(NetProposalReject v) {
    if (v is! NetProposalReject)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
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

class NetProposalReport extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalReport',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..aOS(2, 'text')
    ..hasRequiredFields = false;

  NetProposalReport() : super();
  NetProposalReport.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalReport.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalReport clone() => new NetProposalReport()..mergeFromMessage(this);
  NetProposalReport copyWith(void Function(NetProposalReport) updates) =>
      super.copyWith((message) => updates(message as NetProposalReport));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalReport create() => new NetProposalReport();
  static $pb.PbList<NetProposalReport> createRepeated() =>
      new $pb.PbList<NetProposalReport>();
  static NetProposalReport getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalReport _defaultInstance;
  static void $checkItem(NetProposalReport v) {
    if (v is! NetProposalReport)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
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

class NetProposalDispute extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalDispute',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..aOB(2, 'delivered')
    ..aOB(3, 'rewarded')
    ..aOS(6, 'disputeDescription')
    ..hasRequiredFields = false;

  NetProposalDispute() : super();
  NetProposalDispute.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalDispute.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalDispute clone() =>
      new NetProposalDispute()..mergeFromMessage(this);
  NetProposalDispute copyWith(void Function(NetProposalDispute) updates) =>
      super.copyWith((message) => updates(message as NetProposalDispute));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalDispute create() => new NetProposalDispute();
  static $pb.PbList<NetProposalDispute> createRepeated() =>
      new $pb.PbList<NetProposalDispute>();
  static NetProposalDispute getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalDispute _defaultInstance;
  static void $checkItem(NetProposalDispute v) {
    if (v is! NetProposalDispute)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
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

  String get disputeDescription => $_getS(3, '');
  set disputeDescription(String v) {
    $_setString(3, v);
  }

  bool hasDisputeDescription() => $_has(3);
  void clearDisputeDescription() => clearField(6);
}

class NetProposalCompletion extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProposalCompletion',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..a<int>(4, 'rating', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetProposalCompletion() : super();
  NetProposalCompletion.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProposalCompletion.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProposalCompletion clone() =>
      new NetProposalCompletion()..mergeFromMessage(this);
  NetProposalCompletion copyWith(
          void Function(NetProposalCompletion) updates) =>
      super.copyWith((message) => updates(message as NetProposalCompletion));
  $pb.BuilderInfo get info_ => _i;
  static NetProposalCompletion create() => new NetProposalCompletion();
  static $pb.PbList<NetProposalCompletion> createRepeated() =>
      new $pb.PbList<NetProposalCompletion>();
  static NetProposalCompletion getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetProposalCompletion _defaultInstance;
  static void $checkItem(NetProposalCompletion v) {
    if (v is! NetProposalCompletion)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  int get rating => $_get(1, 0);
  set rating(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasRating() => $_has(1);
  void clearRating() => clearField(4);
}

class NetListChats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetListChats',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(5, 'proposalId')
    ..hasRequiredFields = false;

  NetListChats() : super();
  NetListChats.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetListChats.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetListChats clone() => new NetListChats()..mergeFromMessage(this);
  NetListChats copyWith(void Function(NetListChats) updates) =>
      super.copyWith((message) => updates(message as NetListChats));
  $pb.BuilderInfo get info_ => _i;
  static NetListChats create() => new NetListChats();
  static $pb.PbList<NetListChats> createRepeated() =>
      new $pb.PbList<NetListChats>();
  static NetListChats getDefault() => _defaultInstance ??= create()..freeze();
  static NetListChats _defaultInstance;
  static void $checkItem(NetListChats v) {
    if (v is! NetListChats) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(5);
}

class NetChatPlain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatPlain',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
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

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
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

class NetChatNegotiate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatNegotiate',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
    ..aOS(2, 'remarks')
    ..a<$3.DataTerms>(5, 'terms', $pb.PbFieldType.OM, $3.DataTerms.getDefault,
        $3.DataTerms.create)
    ..a<int>(8, 'sessionGhostId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatNegotiate() : super();
  NetChatNegotiate.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetChatNegotiate.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetChatNegotiate clone() => new NetChatNegotiate()..mergeFromMessage(this);
  NetChatNegotiate copyWith(void Function(NetChatNegotiate) updates) =>
      super.copyWith((message) => updates(message as NetChatNegotiate));
  $pb.BuilderInfo get info_ => _i;
  static NetChatNegotiate create() => new NetChatNegotiate();
  static $pb.PbList<NetChatNegotiate> createRepeated() =>
      new $pb.PbList<NetChatNegotiate>();
  static NetChatNegotiate getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetChatNegotiate _defaultInstance;
  static void $checkItem(NetChatNegotiate v) {
    if (v is! NetChatNegotiate) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasProposalId() => $_has(0);
  void clearProposalId() => clearField(1);

  String get remarks => $_getS(1, '');
  set remarks(String v) {
    $_setString(1, v);
  }

  bool hasRemarks() => $_has(1);
  void clearRemarks() => clearField(2);

  $3.DataTerms get terms => $_getN(2);
  set terms($3.DataTerms v) {
    setField(5, v);
  }

  bool hasTerms() => $_has(2);
  void clearTerms() => clearField(5);

  int get sessionGhostId => $_get(3, 0);
  set sessionGhostId(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasSessionGhostId() => $_has(3);
  void clearSessionGhostId() => clearField(8);
}

class NetChatImageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetChatImageKey',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'proposalId')
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

  Int64 get proposalId => $_getI64(0);
  set proposalId(Int64 v) {
    $_setInt64(0, v);
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
