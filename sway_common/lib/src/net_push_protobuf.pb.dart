///
//  Generated code. Do not modify.
//  source: net_push_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'net_account_protobuf.pb.dart' as $0;
import 'net_offer_protobuf.pb.dart' as $3;
import 'net_proposal_protobuf.pb.dart' as $6;

class NetListen extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetListen',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  NetListen._() : super();
  factory NetListen() => create();
  factory NetListen.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetListen.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetListen clone() => NetListen()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetListen copyWith(void Function(NetListen) updates) =>
      super.copyWith((message) =>
          updates(message as NetListen)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetListen create() => NetListen._();
  NetListen createEmptyInstance() => create();
  static $pb.PbList<NetListen> createRepeated() => $pb.PbList<NetListen>();
  @$core.pragma('dart2js:noInline')
  static NetListen getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetListen>(create);
  static NetListen _defaultInstance;
}

class NetConfigDownload extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetConfigDownload',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'configUrl')
    ..hasRequiredFields = false;

  NetConfigDownload._() : super();
  factory NetConfigDownload() => create();
  factory NetConfigDownload.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetConfigDownload.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetConfigDownload clone() => NetConfigDownload()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetConfigDownload copyWith(void Function(NetConfigDownload) updates) =>
      super.copyWith((message) => updates(
          message as NetConfigDownload)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetConfigDownload create() => NetConfigDownload._();
  NetConfigDownload createEmptyInstance() => create();
  static $pb.PbList<NetConfigDownload> createRepeated() =>
      $pb.PbList<NetConfigDownload>();
  @$core.pragma('dart2js:noInline')
  static NetConfigDownload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetConfigDownload>(create);
  static NetConfigDownload _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get configUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set configUrl($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasConfigUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfigUrl() => clearField(1);
}

class NetKeepAlive extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetKeepAlive',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  NetKeepAlive._() : super();
  factory NetKeepAlive() => create();
  factory NetKeepAlive.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetKeepAlive.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetKeepAlive clone() => NetKeepAlive()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetKeepAlive copyWith(void Function(NetKeepAlive) updates) =>
      super.copyWith((message) =>
          updates(message as NetKeepAlive)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetKeepAlive create() => NetKeepAlive._();
  NetKeepAlive createEmptyInstance() => create();
  static $pb.PbList<NetKeepAlive> createRepeated() =>
      $pb.PbList<NetKeepAlive>();
  @$core.pragma('dart2js:noInline')
  static NetKeepAlive getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetKeepAlive>(create);
  static NetKeepAlive _defaultInstance;
}

class NetPushing extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetPushing',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  NetPushing._() : super();
  factory NetPushing() => create();
  factory NetPushing.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetPushing.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetPushing clone() => NetPushing()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetPushing copyWith(void Function(NetPushing) updates) =>
      super.copyWith((message) =>
          updates(message as NetPushing)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetPushing create() => NetPushing._();
  NetPushing createEmptyInstance() => create();
  static $pb.PbList<NetPushing> createRepeated() => $pb.PbList<NetPushing>();
  @$core.pragma('dart2js:noInline')
  static NetPushing getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetPushing>(create);
  static NetPushing _defaultInstance;
}

enum NetPush_Push {
  updateAccount,
  updateOffer,
  newProposal,
  updateProposal,
  newProposalChat,
  updateProposalChat,
  configDownload,
  pushing,
  keepAlive,
  notSet
}

class NetPush extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, NetPush_Push> _NetPush_PushByTag = {
    1: NetPush_Push.updateAccount,
    2: NetPush_Push.updateOffer,
    3: NetPush_Push.newProposal,
    4: NetPush_Push.updateProposal,
    5: NetPush_Push.newProposalChat,
    6: NetPush_Push.updateProposalChat,
    7: NetPush_Push.configDownload,
    8: NetPush_Push.pushing,
    9: NetPush_Push.keepAlive,
    0: NetPush_Push.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NetPush',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..aOM<$0.NetAccount>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateAccount',
        subBuilder: $0.NetAccount.create)
    ..aOM<$3.NetOffer>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateOffer',
        subBuilder: $3.NetOffer.create)
    ..aOM<$6.NetProposal>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newProposal',
        subBuilder: $6.NetProposal.create)
    ..aOM<$6.NetProposal>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateProposal',
        subBuilder: $6.NetProposal.create)
    ..aOM<$6.NetProposalChat>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newProposalChat', subBuilder: $6.NetProposalChat.create)
    ..aOM<$6.NetProposalChat>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateProposalChat', subBuilder: $6.NetProposalChat.create)
    ..aOM<NetConfigDownload>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'configDownload', subBuilder: NetConfigDownload.create)
    ..aOM<NetPushing>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pushing', subBuilder: NetPushing.create)
    ..aOM<NetKeepAlive>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'keepAlive', subBuilder: NetKeepAlive.create)
    ..hasRequiredFields = false;

  NetPush._() : super();
  factory NetPush() => create();
  factory NetPush.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetPush.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetPush clone() => NetPush()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetPush copyWith(void Function(NetPush) updates) =>
      super.copyWith((message) =>
          updates(message as NetPush)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetPush create() => NetPush._();
  NetPush createEmptyInstance() => create();
  static $pb.PbList<NetPush> createRepeated() => $pb.PbList<NetPush>();
  @$core.pragma('dart2js:noInline')
  static NetPush getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetPush>(create);
  static NetPush _defaultInstance;

  NetPush_Push whichPush() => _NetPush_PushByTag[$_whichOneof(0)];
  void clearPush() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.NetAccount get updateAccount => $_getN(0);
  @$pb.TagNumber(1)
  set updateAccount($0.NetAccount v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUpdateAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdateAccount() => clearField(1);
  @$pb.TagNumber(1)
  $0.NetAccount ensureUpdateAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $3.NetOffer get updateOffer => $_getN(1);
  @$pb.TagNumber(2)
  set updateOffer($3.NetOffer v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUpdateOffer() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateOffer() => clearField(2);
  @$pb.TagNumber(2)
  $3.NetOffer ensureUpdateOffer() => $_ensure(1);

  @$pb.TagNumber(3)
  $6.NetProposal get newProposal => $_getN(2);
  @$pb.TagNumber(3)
  set newProposal($6.NetProposal v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasNewProposal() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewProposal() => clearField(3);
  @$pb.TagNumber(3)
  $6.NetProposal ensureNewProposal() => $_ensure(2);

  @$pb.TagNumber(4)
  $6.NetProposal get updateProposal => $_getN(3);
  @$pb.TagNumber(4)
  set updateProposal($6.NetProposal v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasUpdateProposal() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdateProposal() => clearField(4);
  @$pb.TagNumber(4)
  $6.NetProposal ensureUpdateProposal() => $_ensure(3);

  @$pb.TagNumber(5)
  $6.NetProposalChat get newProposalChat => $_getN(4);
  @$pb.TagNumber(5)
  set newProposalChat($6.NetProposalChat v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasNewProposalChat() => $_has(4);
  @$pb.TagNumber(5)
  void clearNewProposalChat() => clearField(5);
  @$pb.TagNumber(5)
  $6.NetProposalChat ensureNewProposalChat() => $_ensure(4);

  @$pb.TagNumber(6)
  $6.NetProposalChat get updateProposalChat => $_getN(5);
  @$pb.TagNumber(6)
  set updateProposalChat($6.NetProposalChat v) {
    setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasUpdateProposalChat() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdateProposalChat() => clearField(6);
  @$pb.TagNumber(6)
  $6.NetProposalChat ensureUpdateProposalChat() => $_ensure(5);

  @$pb.TagNumber(7)
  NetConfigDownload get configDownload => $_getN(6);
  @$pb.TagNumber(7)
  set configDownload(NetConfigDownload v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasConfigDownload() => $_has(6);
  @$pb.TagNumber(7)
  void clearConfigDownload() => clearField(7);
  @$pb.TagNumber(7)
  NetConfigDownload ensureConfigDownload() => $_ensure(6);

  @$pb.TagNumber(8)
  NetPushing get pushing => $_getN(7);
  @$pb.TagNumber(8)
  set pushing(NetPushing v) {
    setField(8, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPushing() => $_has(7);
  @$pb.TagNumber(8)
  void clearPushing() => clearField(8);
  @$pb.TagNumber(8)
  NetPushing ensurePushing() => $_ensure(7);

  @$pb.TagNumber(9)
  NetKeepAlive get keepAlive => $_getN(8);
  @$pb.TagNumber(9)
  set keepAlive(NetKeepAlive v) {
    setField(9, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasKeepAlive() => $_has(8);
  @$pb.TagNumber(9)
  void clearKeepAlive() => clearField(9);
  @$pb.TagNumber(9)
  NetKeepAlive ensureKeepAlive() => $_ensure(8);
}
