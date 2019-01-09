///
//  Generated code. Do not modify.
//  source: backend_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'net_push_protobuf.pb.dart' as $6;
import 'net_account_protobuf.pb.dart' as $0;

class ReqPush extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReqPush',
      package: const $pb.PackageName('inf_common'))
    ..a<$6.NetPush>(1, 'message', $pb.PbFieldType.OM, $6.NetPush.getDefault,
        $6.NetPush.create)
    ..aInt64(2, 'recipientAccountId')
    ..aInt64(3, 'senderSessionId')
    ..aOB(4, 'skipSenderSession')
    ..aOB(5, 'sendNotifications')
    ..aOB(6, 'skipNotificationsWhenOnline')
    ..hasRequiredFields = false;

  ReqPush() : super();
  ReqPush.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ReqPush.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ReqPush clone() => new ReqPush()..mergeFromMessage(this);
  ReqPush copyWith(void Function(ReqPush) updates) =>
      super.copyWith((message) => updates(message as ReqPush));
  $pb.BuilderInfo get info_ => _i;
  static ReqPush create() => new ReqPush();
  ReqPush createEmptyInstance() => create();
  static $pb.PbList<ReqPush> createRepeated() => new $pb.PbList<ReqPush>();
  static ReqPush getDefault() => _defaultInstance ??= create()..freeze();
  static ReqPush _defaultInstance;
  static void $checkItem(ReqPush v) {
    if (v is! ReqPush) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $6.NetPush get message => $_getN(0);
  set message($6.NetPush v) {
    setField(1, v);
  }

  bool hasMessage() => $_has(0);
  void clearMessage() => clearField(1);

  Int64 get recipientAccountId => $_getI64(1);
  set recipientAccountId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasRecipientAccountId() => $_has(1);
  void clearRecipientAccountId() => clearField(2);

  Int64 get senderSessionId => $_getI64(2);
  set senderSessionId(Int64 v) {
    $_setInt64(2, v);
  }

  bool hasSenderSessionId() => $_has(2);
  void clearSenderSessionId() => clearField(3);

  bool get skipSenderSession => $_get(3, false);
  set skipSenderSession(bool v) {
    $_setBool(3, v);
  }

  bool hasSkipSenderSession() => $_has(3);
  void clearSkipSenderSession() => clearField(4);

  bool get sendNotifications => $_get(4, false);
  set sendNotifications(bool v) {
    $_setBool(4, v);
  }

  bool hasSendNotifications() => $_has(4);
  void clearSendNotifications() => clearField(5);

  bool get skipNotificationsWhenOnline => $_get(5, false);
  set skipNotificationsWhenOnline(bool v) {
    $_setBool(5, v);
  }

  bool hasSkipNotificationsWhenOnline() => $_has(5);
  void clearSkipNotificationsWhenOnline() => clearField(6);
}

class ResPush extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ResPush',
      package: const $pb.PackageName('inf_common'))
    ..a<int>(1, 'onlineSessions', $pb.PbFieldType.O3)
    ..a<int>(2, 'platformNotificationsAttempted', $pb.PbFieldType.O3)
    ..a<int>(3, 'platformNotificationsSucceeded', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  ResPush() : super();
  ResPush.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ResPush.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ResPush clone() => new ResPush()..mergeFromMessage(this);
  ResPush copyWith(void Function(ResPush) updates) =>
      super.copyWith((message) => updates(message as ResPush));
  $pb.BuilderInfo get info_ => _i;
  static ResPush create() => new ResPush();
  ResPush createEmptyInstance() => create();
  static $pb.PbList<ResPush> createRepeated() => new $pb.PbList<ResPush>();
  static ResPush getDefault() => _defaultInstance ??= create()..freeze();
  static ResPush _defaultInstance;
  static void $checkItem(ResPush v) {
    if (v is! ResPush) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get onlineSessions => $_get(0, 0);
  set onlineSessions(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasOnlineSessions() => $_has(0);
  void clearOnlineSessions() => clearField(1);

  int get platformNotificationsAttempted => $_get(1, 0);
  set platformNotificationsAttempted(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasPlatformNotificationsAttempted() => $_has(1);
  void clearPlatformNotificationsAttempted() => clearField(2);

  int get platformNotificationsSucceeded => $_get(2, 0);
  set platformNotificationsSucceeded(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasPlatformNotificationsSucceeded() => $_has(2);
  void clearPlatformNotificationsSucceeded() => clearField(3);
}

class ReqSetFirebaseToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ReqSetFirebaseToken',
      package: const $pb.PackageName('inf_common'))
    ..a<$0.NetSetFirebaseToken>(1, 'token', $pb.PbFieldType.OM,
        $0.NetSetFirebaseToken.getDefault, $0.NetSetFirebaseToken.create)
    ..aInt64(2, 'sessionId')
    ..aInt64(3, 'accountId')
    ..hasRequiredFields = false;

  ReqSetFirebaseToken() : super();
  ReqSetFirebaseToken.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ReqSetFirebaseToken.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ReqSetFirebaseToken clone() =>
      new ReqSetFirebaseToken()..mergeFromMessage(this);
  ReqSetFirebaseToken copyWith(void Function(ReqSetFirebaseToken) updates) =>
      super.copyWith((message) => updates(message as ReqSetFirebaseToken));
  $pb.BuilderInfo get info_ => _i;
  static ReqSetFirebaseToken create() => new ReqSetFirebaseToken();
  ReqSetFirebaseToken createEmptyInstance() => create();
  static $pb.PbList<ReqSetFirebaseToken> createRepeated() =>
      new $pb.PbList<ReqSetFirebaseToken>();
  static ReqSetFirebaseToken getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ReqSetFirebaseToken _defaultInstance;
  static void $checkItem(ReqSetFirebaseToken v) {
    if (v is! ReqSetFirebaseToken)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $0.NetSetFirebaseToken get token => $_getN(0);
  set token($0.NetSetFirebaseToken v) {
    setField(1, v);
  }

  bool hasToken() => $_has(0);
  void clearToken() => clearField(1);

  Int64 get sessionId => $_getI64(1);
  set sessionId(Int64 v) {
    $_setInt64(1, v);
  }

  bool hasSessionId() => $_has(1);
  void clearSessionId() => clearField(2);

  Int64 get accountId => $_getI64(2);
  set accountId(Int64 v) {
    $_setInt64(2, v);
  }

  bool hasAccountId() => $_has(2);
  void clearAccountId() => clearField(3);
}

class ResSetFirebaseToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ResSetFirebaseToken',
      package: const $pb.PackageName('inf_common'))
    ..hasRequiredFields = false;

  ResSetFirebaseToken() : super();
  ResSetFirebaseToken.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ResSetFirebaseToken.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ResSetFirebaseToken clone() =>
      new ResSetFirebaseToken()..mergeFromMessage(this);
  ResSetFirebaseToken copyWith(void Function(ResSetFirebaseToken) updates) =>
      super.copyWith((message) => updates(message as ResSetFirebaseToken));
  $pb.BuilderInfo get info_ => _i;
  static ResSetFirebaseToken create() => new ResSetFirebaseToken();
  ResSetFirebaseToken createEmptyInstance() => create();
  static $pb.PbList<ResSetFirebaseToken> createRepeated() =>
      new $pb.PbList<ResSetFirebaseToken>();
  static ResSetFirebaseToken getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ResSetFirebaseToken _defaultInstance;
  static void $checkItem(ResSetFirebaseToken v) {
    if (v is! ResSetFirebaseToken)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}
