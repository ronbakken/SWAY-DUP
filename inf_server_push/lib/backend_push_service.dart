/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_push/cache_map.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

import 'package:inf_common/inf_backend.dart';

class _CachedAccount {
  final String name;
  final Set<Int64> sessionIds;
  final Map<Int64, String> firebaseTokens;

  const _CachedAccount(this.name, this.sessionIds, this.firebaseTokens);
}

class _Listener {
  final grpc.ServiceCall call;
  final NetListen request;
  final StreamController<NetPush> controller;

  const _Listener(this.call, this.request, this.controller);
}

class BackendPushService extends BackendPushServiceBase {
  final sqljocky.ConnectionPool sql;
  static final Logger opsLog = Logger('InfOps.BackendPushService');
  static final Logger devLog = Logger('InfDev.BackendPushService');

  BackendPushService(this.sql);

  /// Map account id to session ids
  final CacheMap<Int64, _CachedAccount> _cachedAccounts =
      CacheMap<Int64, _CachedAccount>();

  /// Controllers mapped by session id
  final Map<Int64, _Listener> _listeners = <Int64, _Listener>{};

  Future<_CachedAccount> _cacheAccount(Int64 accountId) async {
    // TODO: Fetch from database
    return _cachedAccounts[accountId];
  }

  @override
  Future<ResPush> push(grpc.ServiceCall call, ReqPush request) async {
    final _CachedAccount recipient =
        await _cacheAccount(request.recipientAccountId);
    final List<Future<dynamic>> futures = <Future<dynamic>>[];

    for (Int64 sessionId in recipient.sessionIds) {
      final _Listener listener = _listeners[sessionId];
      if (listener.call.isCanceled) {
        // Minor issue with gRPC here is that we end up keeping controllers
        // for dead connections around until a message is sent to them...
        _listeners.remove(sessionId);
        futures.add(listener.controller.close());
        continue;
      }
      if (request.skipSenderSession && request.senderSessionId == sessionId) {
        // Skip sending to the session that sent this notification
        continue;
      }

      // Send the message to the listening stream
      listener.controller.sink.add(request.message);
    }

    if (request.sendNotifications) {
      for (MapEntry<Int64, String> firebaseToken
          in recipient.firebaseTokens.entries) {
        if (request.skipNotificationsWhenOnline &&
            _listeners.containsKey(firebaseToken.key)) {
          // Skip sending Firebase notifications when a user is online
          continue;
        }
        if (request.skipSenderSession &&
            request.senderSessionId == firebaseToken.key) {
          // Skip sending to the session that sent this notification
          continue;
        }

        // TODO: Generate and send a Firebase notification
      }
    }

    // Do not await any futures between this and the creation of the futures list,
    // or Exceptions from the futures in the list will not be caught!
    final List<dynamic> results = await Future.wait<dynamic>(futures);

    // TODO: Process results.

    final ResPush response = ResPush();
    response.onlineSessions = recipient.sessionIds.length;
    return response;
  }

  @override
  Future<ResSetFirebaseToken> setFirebaseToken(
      grpc.ServiceCall call, ReqSetFirebaseToken request) async {
    // TODO: implement setFirebaseToken
    return null;
  }

  Stream<NetPush> listen(grpc.ServiceCall call, NetListen request) async* {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    // Kick any previous listener for this session. It's not allowed to listen twice on the same session.
    final _Listener previousListener = _listeners.remove(auth.sessionId);
    if (previousListener != null) {
      await previousListener.controller.close();
    }

    // Create a new controller for this listener.
    final StreamController<NetPush> controller = StreamController<NetPush>();
    _listeners[auth.sessionId] = _Listener(call, request, controller);

    // TODO: This is a temporary hack since the database is not implemented yet.
    _cachedAccounts[auth.accountId] = _CachedAccount(
      'Amazing Human Being',
      Set<Int64>.from(<Int64>[auth.sessionId]),
      <Int64, String>{},
    );

    await for (NetPush push in controller.stream) {
      yield push;
    }
  }

  @override
  Future<ResSetAccountName> setAccountName(
      grpc.ServiceCall call, ReqSetAccountName request) {
    // TODO: This writes the account name to the push database, and clears the cached data.
    throw grpc.GrpcError.unimplemented();
  }
}

/* end of file */
