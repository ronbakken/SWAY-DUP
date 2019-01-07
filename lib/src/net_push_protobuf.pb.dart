///
//  Generated code. Do not modify.
//  source: net_push_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'net_account_protobuf.pb.dart' as $0;
import 'net_offer_protobuf.pb.dart' as $4;
import 'net_proposal_protobuf.pb.dart' as $5;

class NetListen extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetListen',
      package: const $pb.PackageName('inf_common'))
    ..hasRequiredFields = false;

  NetListen() : super();
  NetListen.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetListen.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetListen clone() => new NetListen()..mergeFromMessage(this);
  NetListen copyWith(void Function(NetListen) updates) =>
      super.copyWith((message) => updates(message as NetListen));
  $pb.BuilderInfo get info_ => _i;
  static NetListen create() => new NetListen();
  static $pb.PbList<NetListen> createRepeated() => new $pb.PbList<NetListen>();
  static NetListen getDefault() => _defaultInstance ??= create()..freeze();
  static NetListen _defaultInstance;
  static void $checkItem(NetListen v) {
    if (v is! NetListen) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}

enum NetPush_Push {
  updateAccount,
  updateOffer,
  newProposal,
  updateProposal,
  newProposalChat,
  updateProposalChat,
  notSet
}

class NetPush extends $pb.GeneratedMessage {
  static const Map<int, NetPush_Push> _NetPush_PushByTag = {
    1: NetPush_Push.updateAccount,
    2: NetPush_Push.updateOffer,
    3: NetPush_Push.newProposal,
    4: NetPush_Push.updateProposal,
    5: NetPush_Push.newProposalChat,
    6: NetPush_Push.updateProposalChat,
    0: NetPush_Push.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetPush',
      package: const $pb.PackageName('inf_common'))
    ..a<$0.NetAccount>(1, 'updateAccount', $pb.PbFieldType.OM,
        $0.NetAccount.getDefault, $0.NetAccount.create)
    ..a<$4.NetOffer>(2, 'updateOffer', $pb.PbFieldType.OM,
        $4.NetOffer.getDefault, $4.NetOffer.create)
    ..a<$5.NetProposal>(3, 'newProposal', $pb.PbFieldType.OM,
        $5.NetProposal.getDefault, $5.NetProposal.create)
    ..a<$5.NetProposal>(4, 'updateProposal', $pb.PbFieldType.OM,
        $5.NetProposal.getDefault, $5.NetProposal.create)
    ..a<$5.NetProposalChat>(5, 'newProposalChat', $pb.PbFieldType.OM,
        $5.NetProposalChat.getDefault, $5.NetProposalChat.create)
    ..a<$5.NetProposalChat>(6, 'updateProposalChat', $pb.PbFieldType.OM,
        $5.NetProposalChat.getDefault, $5.NetProposalChat.create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..hasRequiredFields = false;

  NetPush() : super();
  NetPush.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetPush.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetPush clone() => new NetPush()..mergeFromMessage(this);
  NetPush copyWith(void Function(NetPush) updates) =>
      super.copyWith((message) => updates(message as NetPush));
  $pb.BuilderInfo get info_ => _i;
  static NetPush create() => new NetPush();
  static $pb.PbList<NetPush> createRepeated() => new $pb.PbList<NetPush>();
  static NetPush getDefault() => _defaultInstance ??= create()..freeze();
  static NetPush _defaultInstance;
  static void $checkItem(NetPush v) {
    if (v is! NetPush) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  NetPush_Push whichPush() => _NetPush_PushByTag[$_whichOneof(0)];
  void clearPush() => clearField($_whichOneof(0));

  $0.NetAccount get updateAccount => $_getN(0);
  set updateAccount($0.NetAccount v) {
    setField(1, v);
  }

  bool hasUpdateAccount() => $_has(0);
  void clearUpdateAccount() => clearField(1);

  $4.NetOffer get updateOffer => $_getN(1);
  set updateOffer($4.NetOffer v) {
    setField(2, v);
  }

  bool hasUpdateOffer() => $_has(1);
  void clearUpdateOffer() => clearField(2);

  $5.NetProposal get newProposal => $_getN(2);
  set newProposal($5.NetProposal v) {
    setField(3, v);
  }

  bool hasNewProposal() => $_has(2);
  void clearNewProposal() => clearField(3);

  $5.NetProposal get updateProposal => $_getN(3);
  set updateProposal($5.NetProposal v) {
    setField(4, v);
  }

  bool hasUpdateProposal() => $_has(3);
  void clearUpdateProposal() => clearField(4);

  $5.NetProposalChat get newProposalChat => $_getN(4);
  set newProposalChat($5.NetProposalChat v) {
    setField(5, v);
  }

  bool hasNewProposalChat() => $_has(4);
  void clearNewProposalChat() => clearField(5);

  $5.NetProposalChat get updateProposalChat => $_getN(5);
  set updateProposalChat($5.NetProposalChat v) {
    setField(6, v);
  }

  bool hasUpdateProposalChat() => $_has(5);
  void clearUpdateProposalChat() => clearField(6);
}
