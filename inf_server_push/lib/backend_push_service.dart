/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  final ConfigData config;
  final sqljocky.ConnectionPool sql;
  static final Logger opsLog = Logger('InfOps.BackendPushService');
  static final Logger devLog = Logger('InfDev.BackendPushService');

  final HttpClient _httpClient = HttpClient();

  BackendPushService(this.config, this.sql);

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
    final _CachedAccount receiver =
        await _cacheAccount(request.receiverAccountId);

    final List<Future<dynamic>> done = <Future<dynamic>>[];
    for (Int64 sessionId in receiver.sessionIds) {
      final _Listener listener = _listeners[sessionId];
      if (listener.call.isCanceled) {
        // Minor issue with gRPC here is that we end up keeping controllers
        // for dead connections around until a message is sent to them...
        _listeners.remove(sessionId);
        done.add(listener.controller.close());
        continue;
      }
      if (request.skipSenderSession && request.senderSessionId == sessionId) {
        // Skip sending to the session that sent this notification
        continue;
      }

      // Send the message to the listening stream
      listener.controller.sink.add(request.message);
    }
    // Do not await any futures between this and the creation of the futures list,
    // or Exceptions from the futures in the list will not be caught!
    await Future.wait<dynamic>(done);
    done.clear();

    // Send platform notifications if applicable
    if (request.sendNotifications) {
      // Find all elegible Firebase tokens
      Set<String> firebaseTokens;
      for (MapEntry<Int64, String> firebaseToken
          in receiver.firebaseTokens.entries) {
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

        firebaseTokens.add(firebaseToken.value);
      }

      // Generate and send a Firebase notification for chat
      if (request.message.hasNewProposalChat()) {
        // Get sender info
        final DataProposalChat chat = request.message.newProposalChat.chat;
        _CachedAccount sender = await _cacheAccount(chat.senderAccountId);
        sender ??= _CachedAccount(
          'Amazing Human Being',
          Set<Int64>(),
          <Int64, String>{},
        );

        final String senderName = sender.name;
        final List<String> receiverFirebaseTokens =firebaseTokens.toList();
        final Map<String, dynamic> notification = <String, dynamic>{};
        notification['title'] = senderName;
        // TODO: Generate text version of non-text messages
        notification['body'] = chat.plainText ??
            'A proposal has been updated.'; 
        notification['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
        notification['android_channel_id'] = 'chat';
        final Map<String, dynamic> data = <String, dynamic>{};
        data['sender_account_id'] = chat.senderAccountId.toInt();
        data['receiver_account_id'] = request.receiverAccountId.toInt();
        data['proposal_id'] = chat.proposalId.toInt();
        data['type'] = chat.type.value;
        // TODO: Include image key, terms, etc, or not?
        data['domain'] = config.services.domain;
        final Map<String, dynamic> message = <String, dynamic>{};
        message['registration_ids'] = receiverFirebaseTokens;
        message['collapse_key'] =
            'proposal_id=' + chat.proposalId.toString();
        message['notification'] = notification;
        message['data'] = data;
        String jm = json.encode(message);
        devLog.finest(jm);
        final HttpClientRequest req = await _httpClient
            .postUrl(Uri.parse(config.services.firebaseLegacyApi));
        req.headers.add('Content-Type', 'application/json');
        req.headers.add(
            'Authorization', 'key=' + config.services.firebaseLegacyServerKey);
        req.add(utf8.encode(jm));
        final HttpClientResponse res = await req.close();
        final BytesBuilder responseBuilder = BytesBuilder(copy: false);
        await res.forEach(responseBuilder.add);
        if (res.statusCode != 200) {
          opsLog.warning(
              'Status code ${res.statusCode}, request: $jm, response: ${utf8.decode(responseBuilder.toBytes())}');
        }
        final String rs = utf8.decode(responseBuilder.toBytes());
        devLog.finest('Firebase sent OK, response: $rs');
        final Map<dynamic, dynamic> doc = json.decode(rs);
        if (doc['failure'].toInt() > 0) {
          devLog.warning(
              'Failed to send Firebase notification to ${doc['failure']} receiver sessions, validate all tokens.');
          // TODO: Validate all registrations
        }
      }
    }

    // TODO: Process results from Firebase (receiver count)

    final ResPush response = ResPush();
    response.onlineSessions = receiver.sessionIds.length;
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
