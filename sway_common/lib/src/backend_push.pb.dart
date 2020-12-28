///
//  Generated code. Do not modify.
//  source: backend_push.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'net_push_protobuf.pb.dart' as $7;
import 'net_account_protobuf.pb.dart' as $0;

class ReqPush extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ReqPush',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$7.NetPush>(
        1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message',
        subBuilder: $7.NetPush.create)
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'receiverAccountId')
    ..aInt64(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderSessionId')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skipSenderSession')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sendNotifications')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'skipNotificationsWhenOnline')
    ..hasRequiredFields = false;

  ReqPush._() : super();
  factory ReqPush() => create();
  factory ReqPush.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReqPush.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ReqPush clone() => ReqPush()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ReqPush copyWith(void Function(ReqPush) updates) =>
      super.copyWith((message) =>
          updates(message as ReqPush)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReqPush create() => ReqPush._();
  ReqPush createEmptyInstance() => create();
  static $pb.PbList<ReqPush> createRepeated() => $pb.PbList<ReqPush>();
  @$core.pragma('dart2js:noInline')
  static ReqPush getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReqPush>(create);
  static ReqPush _defaultInstance;

  @$pb.TagNumber(1)
  $7.NetPush get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($7.NetPush v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
  @$pb.TagNumber(1)
  $7.NetPush ensureMessage() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receiverAccountId => $_getI64(1);
  @$pb.TagNumber(2)
  set receiverAccountId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasReceiverAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverAccountId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get senderSessionId => $_getI64(2);
  @$pb.TagNumber(3)
  set senderSessionId($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSenderSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderSessionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get skipSenderSession => $_getBF(3);
  @$pb.TagNumber(4)
  set skipSenderSession($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSkipSenderSession() => $_has(3);
  @$pb.TagNumber(4)
  void clearSkipSenderSession() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get sendNotifications => $_getBF(4);
  @$pb.TagNumber(5)
  set sendNotifications($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSendNotifications() => $_has(4);
  @$pb.TagNumber(5)
  void clearSendNotifications() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get skipNotificationsWhenOnline => $_getBF(5);
  @$pb.TagNumber(6)
  set skipNotificationsWhenOnline($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSkipNotificationsWhenOnline() => $_has(5);
  @$pb.TagNumber(6)
  void clearSkipNotificationsWhenOnline() => clearField(6);
}

class ResPush extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ResPush',
          package: const $pb.PackageName(
              const $core.bool.fromEnvironment('protobuf.omit_message_names')
                  ? ''
                  : 'inf'),
          createEmptyInstance: create)
        ..a<$core.int>(
            1,
            const $core.bool.fromEnvironment('protobuf.omit_field_names')
                ? ''
                : 'onlineSessions',
            $pb.PbFieldType.O3)
        ..a<$core.int>(
            2,
            const $core.bool.fromEnvironment('protobuf.omit_field_names')
                ? ''
                : 'platformNotificationsAttempted',
            $pb.PbFieldType.O3)
        ..a<$core.int>(
            3,
            const $core.bool.fromEnvironment('protobuf.omit_field_names')
                ? ''
                : 'platformNotificationsSucceeded',
            $pb.PbFieldType.O3)
        ..hasRequiredFields = false;

  ResPush._() : super();
  factory ResPush() => create();
  factory ResPush.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResPush.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ResPush clone() => ResPush()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ResPush copyWith(void Function(ResPush) updates) =>
      super.copyWith((message) =>
          updates(message as ResPush)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResPush create() => ResPush._();
  ResPush createEmptyInstance() => create();
  static $pb.PbList<ResPush> createRepeated() => $pb.PbList<ResPush>();
  @$core.pragma('dart2js:noInline')
  static ResPush getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResPush>(create);
  static ResPush _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get onlineSessions => $_getIZ(0);
  @$pb.TagNumber(1)
  set onlineSessions($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOnlineSessions() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnlineSessions() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get platformNotificationsAttempted => $_getIZ(1);
  @$pb.TagNumber(2)
  set platformNotificationsAttempted($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPlatformNotificationsAttempted() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatformNotificationsAttempted() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get platformNotificationsSucceeded => $_getIZ(2);
  @$pb.TagNumber(3)
  set platformNotificationsSucceeded($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPlatformNotificationsSucceeded() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatformNotificationsSucceeded() => clearField(3);
}

class ReqSetFirebaseToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ReqSetFirebaseToken',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOM<$0.NetSetFirebaseToken>(1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token',
        subBuilder: $0.NetSetFirebaseToken.create)
    ..aInt64(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'sessionId')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountId')
    ..hasRequiredFields = false;

  ReqSetFirebaseToken._() : super();
  factory ReqSetFirebaseToken() => create();
  factory ReqSetFirebaseToken.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReqSetFirebaseToken.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ReqSetFirebaseToken clone() => ReqSetFirebaseToken()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ReqSetFirebaseToken copyWith(void Function(ReqSetFirebaseToken) updates) =>
      super.copyWith((message) => updates(
          message as ReqSetFirebaseToken)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReqSetFirebaseToken create() => ReqSetFirebaseToken._();
  ReqSetFirebaseToken createEmptyInstance() => create();
  static $pb.PbList<ReqSetFirebaseToken> createRepeated() =>
      $pb.PbList<ReqSetFirebaseToken>();
  @$core.pragma('dart2js:noInline')
  static ReqSetFirebaseToken getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReqSetFirebaseToken>(create);
  static ReqSetFirebaseToken _defaultInstance;

  @$pb.TagNumber(1)
  $0.NetSetFirebaseToken get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($0.NetSetFirebaseToken v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
  @$pb.TagNumber(1)
  $0.NetSetFirebaseToken ensureToken() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sessionId => $_getI64(1);
  @$pb.TagNumber(2)
  set sessionId($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get accountId => $_getI64(2);
  @$pb.TagNumber(3)
  set accountId($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAccountId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountId() => clearField(3);
}

class ResSetFirebaseToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ResSetFirebaseToken',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  ResSetFirebaseToken._() : super();
  factory ResSetFirebaseToken() => create();
  factory ResSetFirebaseToken.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ResSetFirebaseToken.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ResSetFirebaseToken clone() => ResSetFirebaseToken()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ResSetFirebaseToken copyWith(void Function(ResSetFirebaseToken) updates) =>
      super.copyWith((message) => updates(
          message as ResSetFirebaseToken)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResSetFirebaseToken create() => ResSetFirebaseToken._();
  ResSetFirebaseToken createEmptyInstance() => create();
  static $pb.PbList<ResSetFirebaseToken> createRepeated() =>
      $pb.PbList<ResSetFirebaseToken>();
  @$core.pragma('dart2js:noInline')
  static ResSetFirebaseToken getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResSetFirebaseToken>(create);
  static ResSetFirebaseToken _defaultInstance;
}
