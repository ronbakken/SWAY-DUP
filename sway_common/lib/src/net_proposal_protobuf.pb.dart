///
//  Generated code. Do not modify.
//  source: net_proposal_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $13;

class NetProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposal',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataProposal>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'proposal',
        subBuilder: $13.DataProposal.create)
    ..pc<$13.DataProposalChat>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'chats',
        $pb.PbFieldType.PM,
        subBuilder: $13.DataProposalChat.create)
    ..hasRequiredFields = false;

  NetProposal._() : super();
  factory NetProposal() => create();
  factory NetProposal.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposal.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposal clone() => NetProposal()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposal copyWith(void Function(NetProposal) updates) =>
      super.copyWith((message) =>
          updates(message as NetProposal)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposal create() => NetProposal._();
  NetProposal createEmptyInstance() => create();
  static $pb.PbList<NetProposal> createRepeated() => $pb.PbList<NetProposal>();
  @$core.pragma('dart2js:noInline')
  static NetProposal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposal>(create);
  static NetProposal _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataProposal get proposal => $_getN(0);
  @$pb.TagNumber(1)
  set proposal($13.DataProposal v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposal() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataProposal ensureProposal() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$13.DataProposalChat> get chats => $_getList(1);
}

class NetProposalChat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposalChat',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$13.DataProposalChat>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'chat',
        subBuilder: $13.DataProposalChat.create)
    ..hasRequiredFields = false;

  NetProposalChat._() : super();
  factory NetProposalChat() => create();
  factory NetProposalChat.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposalChat.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposalChat clone() => NetProposalChat()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposalChat copyWith(void Function(NetProposalChat) updates) =>
      super.copyWith((message) =>
          updates(message as NetProposalChat)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposalChat create() => NetProposalChat._();
  NetProposalChat createEmptyInstance() => create();
  static $pb.PbList<NetProposalChat> createRepeated() =>
      $pb.PbList<NetProposalChat>();
  @$core.pragma('dart2js:noInline')
  static NetProposalChat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposalChat>(create);
  static NetProposalChat _defaultInstance;

  @$pb.TagNumber(1)
  $13.DataProposalChat get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat($13.DataProposalChat v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => clearField(1);
  @$pb.TagNumber(1)
  $13.DataProposalChat ensureChat() => $_ensure(0);
}

class NetApplyProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetApplyProposal',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offerId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'remarks')
    ..aOM<$13.DataTerms>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'terms',
        subBuilder: $13.DataTerms.create)
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionGhostId',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetApplyProposal._() : super();
  factory NetApplyProposal() => create();
  factory NetApplyProposal.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetApplyProposal.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetApplyProposal clone() => NetApplyProposal()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetApplyProposal copyWith(void Function(NetApplyProposal) updates) =>
      super.copyWith((message) => updates(
          message as NetApplyProposal)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetApplyProposal create() => NetApplyProposal._();
  NetApplyProposal createEmptyInstance() => create();
  static $pb.PbList<NetApplyProposal> createRepeated() =>
      $pb.PbList<NetApplyProposal>();
  @$core.pragma('dart2js:noInline')
  static NetApplyProposal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetApplyProposal>(create);
  static NetApplyProposal _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offerId => $_getI64(0);
  @$pb.TagNumber(1)
  set offerId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOfferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get remarks => $_getSZ(1);
  @$pb.TagNumber(2)
  set remarks($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRemarks() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemarks() => clearField(2);

  @$pb.TagNumber(3)
  $13.DataTerms get terms => $_getN(2);
  @$pb.TagNumber(3)
  set terms($13.DataTerms v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTerms() => $_has(2);
  @$pb.TagNumber(3)
  void clearTerms() => clearField(3);
  @$pb.TagNumber(3)
  $13.DataTerms ensureTerms() => $_ensure(2);

  @$pb.TagNumber(8)
  $core.int get sessionGhostId => $_getIZ(3);
  @$pb.TagNumber(8)
  set sessionGhostId($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasSessionGhostId() => $_has(3);
  @$pb.TagNumber(8)
  void clearSessionGhostId() => clearField(8);
}

class NetDirectProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetDirectProposal',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'remarks')
    ..aOM<$13.DataOffer>(
        4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offer',
        subBuilder: $13.DataOffer.create)
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionGhostId',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetDirectProposal._() : super();
  factory NetDirectProposal() => create();
  factory NetDirectProposal.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetDirectProposal.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetDirectProposal clone() => NetDirectProposal()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetDirectProposal copyWith(void Function(NetDirectProposal) updates) =>
      super.copyWith((message) => updates(
          message as NetDirectProposal)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetDirectProposal create() => NetDirectProposal._();
  NetDirectProposal createEmptyInstance() => create();
  static $pb.PbList<NetDirectProposal> createRepeated() =>
      $pb.PbList<NetDirectProposal>();
  @$core.pragma('dart2js:noInline')
  static NetDirectProposal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetDirectProposal>(create);
  static NetDirectProposal _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get remarks => $_getSZ(0);
  @$pb.TagNumber(2)
  set remarks($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRemarks() => $_has(0);
  @$pb.TagNumber(2)
  void clearRemarks() => clearField(2);

  @$pb.TagNumber(4)
  $13.DataOffer get offer => $_getN(1);
  @$pb.TagNumber(4)
  set offer($13.DataOffer v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasOffer() => $_has(1);
  @$pb.TagNumber(4)
  void clearOffer() => clearField(4);
  @$pb.TagNumber(4)
  $13.DataOffer ensureOffer() => $_ensure(1);

  @$pb.TagNumber(8)
  $core.int get sessionGhostId => $_getIZ(2);
  @$pb.TagNumber(8)
  set sessionGhostId($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasSessionGhostId() => $_has(2);
  @$pb.TagNumber(8)
  void clearSessionGhostId() => clearField(8);
}

class NetListProposals extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetListProposals',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'offerId')
    ..hasRequiredFields = false;

  NetListProposals._() : super();
  factory NetListProposals() => create();
  factory NetListProposals.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetListProposals.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetListProposals clone() => NetListProposals()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetListProposals copyWith(void Function(NetListProposals) updates) =>
      super.copyWith((message) => updates(
          message as NetListProposals)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetListProposals create() => NetListProposals._();
  NetListProposals createEmptyInstance() => create();
  static $pb.PbList<NetListProposals> createRepeated() =>
      $pb.PbList<NetListProposals>();
  @$core.pragma('dart2js:noInline')
  static NetListProposals getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetListProposals>(create);
  static NetListProposals _defaultInstance;

  @$pb.TagNumber(4)
  $fixnum.Int64 get offerId => $_getI64(0);
  @$pb.TagNumber(4)
  set offerId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasOfferId() => $_has(0);
  @$pb.TagNumber(4)
  void clearOfferId() => clearField(4);
}

class NetGetProposal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetGetProposal',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..hasRequiredFields = false;

  NetGetProposal._() : super();
  factory NetGetProposal() => create();
  factory NetGetProposal.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetGetProposal.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetGetProposal clone() => NetGetProposal()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetGetProposal copyWith(void Function(NetGetProposal) updates) =>
      super.copyWith((message) =>
          updates(message as NetGetProposal)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetGetProposal create() => NetGetProposal._();
  NetGetProposal createEmptyInstance() => create();
  static $pb.PbList<NetGetProposal> createRepeated() =>
      $pb.PbList<NetGetProposal>();
  @$core.pragma('dart2js:noInline')
  static NetGetProposal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetGetProposal>(create);
  static NetGetProposal _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);
}

class NetProposalWantDeal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposalWantDeal',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'termsChatId')
    ..hasRequiredFields = false;

  NetProposalWantDeal._() : super();
  factory NetProposalWantDeal() => create();
  factory NetProposalWantDeal.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposalWantDeal.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposalWantDeal clone() => NetProposalWantDeal()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposalWantDeal copyWith(void Function(NetProposalWantDeal) updates) =>
      super.copyWith((message) => updates(
          message as NetProposalWantDeal)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposalWantDeal create() => NetProposalWantDeal._();
  NetProposalWantDeal createEmptyInstance() => create();
  static $pb.PbList<NetProposalWantDeal> createRepeated() =>
      $pb.PbList<NetProposalWantDeal>();
  @$core.pragma('dart2js:noInline')
  static NetProposalWantDeal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposalWantDeal>(create);
  static NetProposalWantDeal _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get termsChatId => $_getI64(1);
  @$pb.TagNumber(2)
  set termsChatId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTermsChatId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTermsChatId() => clearField(2);
}

class NetProposalNegotiate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposalNegotiate',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..hasRequiredFields = false;

  NetProposalNegotiate._() : super();
  factory NetProposalNegotiate() => create();
  factory NetProposalNegotiate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposalNegotiate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposalNegotiate clone() =>
      NetProposalNegotiate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposalNegotiate copyWith(void Function(NetProposalNegotiate) updates) =>
      super.copyWith((message) => updates(
          message as NetProposalNegotiate)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposalNegotiate create() => NetProposalNegotiate._();
  NetProposalNegotiate createEmptyInstance() => create();
  static $pb.PbList<NetProposalNegotiate> createRepeated() =>
      $pb.PbList<NetProposalNegotiate>();
  @$core.pragma('dart2js:noInline')
  static NetProposalNegotiate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposalNegotiate>(create);
  static NetProposalNegotiate _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);
}

class NetProposalReject extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposalReject',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'reason')
    ..hasRequiredFields = false;

  NetProposalReject._() : super();
  factory NetProposalReject() => create();
  factory NetProposalReject.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposalReject.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposalReject clone() => NetProposalReject()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposalReject copyWith(void Function(NetProposalReject) updates) =>
      super.copyWith((message) => updates(
          message as NetProposalReject)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposalReject create() => NetProposalReject._();
  NetProposalReject createEmptyInstance() => create();
  static $pb.PbList<NetProposalReject> createRepeated() =>
      $pb.PbList<NetProposalReject>();
  @$core.pragma('dart2js:noInline')
  static NetProposalReject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposalReject>(create);
  static NetProposalReject _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class NetProposalReport extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposalReport',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..hasRequiredFields = false;

  NetProposalReport._() : super();
  factory NetProposalReport() => create();
  factory NetProposalReport.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposalReport.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposalReport clone() => NetProposalReport()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposalReport copyWith(void Function(NetProposalReport) updates) =>
      super.copyWith((message) => updates(
          message as NetProposalReport)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposalReport create() => NetProposalReport._();
  NetProposalReport createEmptyInstance() => create();
  static $pb.PbList<NetProposalReport> createRepeated() =>
      $pb.PbList<NetProposalReport>();
  @$core.pragma('dart2js:noInline')
  static NetProposalReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposalReport>(create);
  static NetProposalReport _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);
}

class NetProposalDispute extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposalDispute',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aOB(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'delivered')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rewarded')
    ..aOS(6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'disputeDescription')
    ..hasRequiredFields = false;

  NetProposalDispute._() : super();
  factory NetProposalDispute() => create();
  factory NetProposalDispute.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposalDispute.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposalDispute clone() => NetProposalDispute()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposalDispute copyWith(void Function(NetProposalDispute) updates) =>
      super.copyWith((message) => updates(
          message as NetProposalDispute)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposalDispute create() => NetProposalDispute._();
  NetProposalDispute createEmptyInstance() => create();
  static $pb.PbList<NetProposalDispute> createRepeated() =>
      $pb.PbList<NetProposalDispute>();
  @$core.pragma('dart2js:noInline')
  static NetProposalDispute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposalDispute>(create);
  static NetProposalDispute _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get delivered => $_getBF(1);
  @$pb.TagNumber(2)
  set delivered($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDelivered() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelivered() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get rewarded => $_getBF(2);
  @$pb.TagNumber(3)
  set rewarded($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRewarded() => $_has(2);
  @$pb.TagNumber(3)
  void clearRewarded() => clearField(3);

  @$pb.TagNumber(6)
  $core.String get disputeDescription => $_getSZ(3);
  @$pb.TagNumber(6)
  set disputeDescription($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasDisputeDescription() => $_has(3);
  @$pb.TagNumber(6)
  void clearDisputeDescription() => clearField(6);
}

class NetProposalCompletion extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetProposalCompletion',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..a<$core.int>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rating',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetProposalCompletion._() : super();
  factory NetProposalCompletion() => create();
  factory NetProposalCompletion.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetProposalCompletion.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetProposalCompletion clone() =>
      NetProposalCompletion()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetProposalCompletion copyWith(
          void Function(NetProposalCompletion) updates) =>
      super.copyWith((message) => updates(
          message as NetProposalCompletion)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetProposalCompletion create() => NetProposalCompletion._();
  NetProposalCompletion createEmptyInstance() => create();
  static $pb.PbList<NetProposalCompletion> createRepeated() =>
      $pb.PbList<NetProposalCompletion>();
  @$core.pragma('dart2js:noInline')
  static NetProposalCompletion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetProposalCompletion>(create);
  static NetProposalCompletion _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(4)
  $core.int get rating => $_getIZ(1);
  @$pb.TagNumber(4)
  set rating($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRating() => $_has(1);
  @$pb.TagNumber(4)
  void clearRating() => clearField(4);
}

class NetListChats extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetListChats',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..hasRequiredFields = false;

  NetListChats._() : super();
  factory NetListChats() => create();
  factory NetListChats.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetListChats.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetListChats clone() => NetListChats()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetListChats copyWith(void Function(NetListChats) updates) =>
      super.copyWith((message) =>
          updates(message as NetListChats)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetListChats create() => NetListChats._();
  NetListChats createEmptyInstance() => create();
  static $pb.PbList<NetListChats> createRepeated() =>
      $pb.PbList<NetListChats>();
  @$core.pragma('dart2js:noInline')
  static NetListChats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetListChats>(create);
  static NetListChats _defaultInstance;

  @$pb.TagNumber(5)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(5)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(5)
  void clearProposalId() => clearField(5);
}

class NetChatPlain extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetChatPlain',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'text')
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionGhostId',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatPlain._() : super();
  factory NetChatPlain() => create();
  factory NetChatPlain.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetChatPlain.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetChatPlain clone() => NetChatPlain()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetChatPlain copyWith(void Function(NetChatPlain) updates) =>
      super.copyWith((message) =>
          updates(message as NetChatPlain)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetChatPlain create() => NetChatPlain._();
  NetChatPlain createEmptyInstance() => create();
  static $pb.PbList<NetChatPlain> createRepeated() =>
      $pb.PbList<NetChatPlain>();
  @$core.pragma('dart2js:noInline')
  static NetChatPlain getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetChatPlain>(create);
  static NetChatPlain _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(6)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(6)
  set text($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(6)
  void clearText() => clearField(6);

  @$pb.TagNumber(8)
  $core.int get sessionGhostId => $_getIZ(2);
  @$pb.TagNumber(8)
  set sessionGhostId($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasSessionGhostId() => $_has(2);
  @$pb.TagNumber(8)
  void clearSessionGhostId() => clearField(8);
}

class NetChatNegotiate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetChatNegotiate',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'remarks')
    ..aOM<$13.DataTerms>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'terms',
        subBuilder: $13.DataTerms.create)
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionGhostId',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatNegotiate._() : super();
  factory NetChatNegotiate() => create();
  factory NetChatNegotiate.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetChatNegotiate.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetChatNegotiate clone() => NetChatNegotiate()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetChatNegotiate copyWith(void Function(NetChatNegotiate) updates) =>
      super.copyWith((message) => updates(
          message as NetChatNegotiate)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetChatNegotiate create() => NetChatNegotiate._();
  NetChatNegotiate createEmptyInstance() => create();
  static $pb.PbList<NetChatNegotiate> createRepeated() =>
      $pb.PbList<NetChatNegotiate>();
  @$core.pragma('dart2js:noInline')
  static NetChatNegotiate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetChatNegotiate>(create);
  static NetChatNegotiate _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get remarks => $_getSZ(1);
  @$pb.TagNumber(2)
  set remarks($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRemarks() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemarks() => clearField(2);

  @$pb.TagNumber(5)
  $13.DataTerms get terms => $_getN(2);
  @$pb.TagNumber(5)
  set terms($13.DataTerms v) {
    setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasTerms() => $_has(2);
  @$pb.TagNumber(5)
  void clearTerms() => clearField(5);
  @$pb.TagNumber(5)
  $13.DataTerms ensureTerms() => $_ensure(2);

  @$pb.TagNumber(8)
  $core.int get sessionGhostId => $_getIZ(3);
  @$pb.TagNumber(8)
  set sessionGhostId($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasSessionGhostId() => $_has(3);
  @$pb.TagNumber(8)
  void clearSessionGhostId() => clearField(8);
}

class NetChatImageKey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetChatImageKey',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposalId')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'imageKey')
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionGhostId',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  NetChatImageKey._() : super();
  factory NetChatImageKey() => create();
  factory NetChatImageKey.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetChatImageKey.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetChatImageKey clone() => NetChatImageKey()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetChatImageKey copyWith(void Function(NetChatImageKey) updates) =>
      super.copyWith((message) =>
          updates(message as NetChatImageKey)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetChatImageKey create() => NetChatImageKey._();
  NetChatImageKey createEmptyInstance() => create();
  static $pb.PbList<NetChatImageKey> createRepeated() =>
      $pb.PbList<NetChatImageKey>();
  @$core.pragma('dart2js:noInline')
  static NetChatImageKey getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetChatImageKey>(create);
  static NetChatImageKey _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get proposalId => $_getI64(0);
  @$pb.TagNumber(1)
  set proposalId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProposalId() => clearField(1);

  @$pb.TagNumber(5)
  $core.String get imageKey => $_getSZ(1);
  @$pb.TagNumber(5)
  set imageKey($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasImageKey() => $_has(1);
  @$pb.TagNumber(5)
  void clearImageKey() => clearField(5);

  @$pb.TagNumber(8)
  $core.int get sessionGhostId => $_getIZ(2);
  @$pb.TagNumber(8)
  set sessionGhostId($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasSessionGhostId() => $_has(2);
  @$pb.TagNumber(8)
  void clearSessionGhostId() => clearField(8);
}
