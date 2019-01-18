/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:pedantic/pedantic.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf_server_push/cache_map.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

import 'package:inf_common/inf_backend.dart';

const int kTokenUnknown = 0;
const int kTokenFirebase = 0;
const int kTokenOneSignal = 0;

class _CachedAccount {
  Set<Int64> sessionIds = Set<Int64>();
  Map<Int64, String> firebaseTokens = <Int64, String>{};

  _CachedAccount();
}

class _Listener {
  final grpc.ServiceCall call;
  final NetListen request;
  final StreamController<NetPush> controller;
  final Timer keepAlive;

  const _Listener(this.call, this.request, this.controller, this.keepAlive);
}

class _CallWrapperWebSocket implements grpc.ServiceCall {
  @override
  Map<String, String> clientMetadata = <String, String>{};

  @override
  DateTime deadline;

  @override
  Map<String, String> headers = <String, String>{};

  @override
  bool isCanceled = false;

  @override
  bool isTimedOut = false;

  @override
  void sendHeaders() {}

  @override
  void sendTrailers({int status, String message}) {}

  @override
  Map<String, String> trailers = <String, String>{};
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

  Future<_CachedAccount> _cachedAccount(Int64 accountId) async {
    // Load up cache from database
    _CachedAccount cached = _cachedAccounts[accountId];
    if (cached == null) {
      // Load up from database
      cached = _CachedAccount();
      final sqljocky.Results selectResults = await sql.prepareExecute(
        'SELECT `session_id`, `token_type`, `token`'
            '  FROM `push_tokens`'
            '  WHERE `account_id` = ?',
        <dynamic>[
          accountId,
        ],
      );
      await for (sqljocky.Row row in selectResults) {
        final Int64 sessionId = Int64(row[0]);
        cached.sessionIds.add(sessionId);
        final int tokenType = row[1].toInt();
        if (tokenType == kTokenFirebase) {
          cached.firebaseTokens[sessionId] = row[2].toString();
        }
      }
    }

    // Check for racing condition
    final _CachedAccount racingCached = _cachedAccounts[accountId];
    if (racingCached != null) {
      // Merge what was loaded into cache
      for (Int64 sessionId in cached.sessionIds) {
        racingCached.sessionIds.add(sessionId);
      }
      for (MapEntry<Int64, String> firebaseToken in cached.firebaseTokens.entries) {
        racingCached.firebaseTokens[firebaseToken.key] = firebaseToken.value;
      }
      return racingCached;
    } else {
      // Cache loaded
      _cachedAccounts[accountId] = cached;
      return cached;
    }
  }

  Future<void> _sendFirebaseNotificationChat(Int64 receiverAccountId,
      List<String> receiverFirebaseTokens, DataProposalChat chat) async {
    // TODO: Fetch sender summary from Explore backend
    final String senderName = 'Amazing Human Being';
    final Map<String, dynamic> notification = <String, dynamic>{};
    notification['title'] = senderName;
    // TODO: Generate text version of non-text messages
    notification['body'] = chat.plainText ?? 'A proposal has been updated.';
    notification['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
    notification['android_channel_id'] = 'chat';
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_account_id'] = chat.senderAccountId.toInt();
    data['receiver_account_id'] = receiverAccountId.toInt();
    data['proposal_id'] = chat.proposalId.toInt();
    data['type'] = chat.type.value;
    // TODO: Include image key, terms, etc, or not?
    data['domain'] = config.services.domain;
    final Map<String, dynamic> message = <String, dynamic>{};
    message['registration_ids'] = receiverFirebaseTokens;
    message['collapse_key'] = 'proposal_id=' + chat.proposalId.toString();
    message['notification'] = notification;
    message['data'] = data;
    String jm = json.encode(message);
    devLog.finest(jm);
    final HttpClientRequest req =
        await _httpClient.postUrl(Uri.parse(config.services.firebaseLegacyApi));
    req.headers.add('Content-Type', 'application/json');
    req.headers
        .add('Authorization', 'key=' + config.services.firebaseLegacyServerKey);
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

  @override
  Future<ResPush> push(grpc.ServiceCall call, ReqPush request) async {
    final _CachedAccount receiver =
        await _cachedAccount(request.receiverAccountId);
    final List<Future<dynamic>> done = <Future<dynamic>>[];
    for (Int64 sessionId in receiver.sessionIds) {
      final _Listener listener = _listeners[sessionId];
      if (listener.call.isCanceled) {
        // Minor issue with gRPC here is that we end up keeping controllers
        // for dead connections around until a message is sent to them...
        _listeners.remove(sessionId);
        listener.keepAlive.cancel();
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
        final List<String> receiverFirebaseTokens = firebaseTokens.toList();
        final DataProposalChat chat = request.message.newProposalChat.chat;
        done.add(_sendFirebaseNotificationChat(
            request.receiverAccountId, receiverFirebaseTokens, chat));
      } else if (request.message.hasNewProposal()) {
        final List<String> receiverFirebaseTokens = firebaseTokens.toList();
        for (DataProposalChat chat in request.message.newProposal.chats) {
          done.add(_sendFirebaseNotificationChat(
              request.receiverAccountId, receiverFirebaseTokens, chat));
        }
      }
    }

    // Do not await any futures between this and the creation of the futures list,
    // or Exceptions from the futures in the list will not be caught!
    await Future.wait<dynamic>(done);
    done.clear();

    // TODO: Process results from Firebase (receiver count)

    final ResPush response = ResPush();
    response.onlineSessions = receiver.sessionIds.length;
    return response;
  }

  @override
  Future<ResSetFirebaseToken> setFirebaseToken(
      grpc.ServiceCall call, ReqSetFirebaseToken request) async {
    // Find if there's a previously set token
    final sqljocky.Results selectResults = await sql.prepareExecute(
      'SELECT `token_type`, `token`'
          '  FROM `push_tokens`'
          '  WHERE `session_id` = ?',
      <dynamic>[
        request.sessionId,
      ],
    );
    int oldTokenType;
    String oldToken;
    await for (sqljocky.Row row in selectResults) {
      oldTokenType = row[0].toInt();
      oldToken = row[1].toString();
    }

    // Upsert the new token
    await sql.prepareExecute(
      'INSERT INTO `push_tokens`(`session_id`, `account_id`, `token_type`, `token`)'
          '  VALUES (?, ?, ?, ?)'
          '  ON DUPLICATE KEY'
          '    UPDATE `account_id` = ?, `token_type` = ?, `token` = ?',
      <dynamic>[
        request.sessionId,
        request.accountId,
        kTokenFirebase,
        request.token.firebaseToken,
        request.accountId,
        kTokenFirebase,
        request.token,
      ],
    );

    // Update any other matching tokens, which happens when sessions are on the same device
    if (oldTokenType != null &&
        oldToken != null &&
        oldTokenType == kTokenFirebase &&
        oldToken == request.token.oldFirebaseToken) {
      await sql.prepareExecute(
        'UPDATE `push_tokens`'
            '  SET `token_type` = ?, `token` = ?'
            '  WHERE `token_type` = ? AND `token` = ?',
        <dynamic>[
          kTokenFirebase,
          request.token,
          oldTokenType,
          oldToken,
        ],
      );
    }

    // Update cached token
    final _CachedAccount cached = _cachedAccounts[request.accountId];
    if (cached != null) {
      cached.firebaseTokens[request.sessionId] = request.token.firebaseToken;
    }

    // Respond
    final ResSetFirebaseToken response = ResSetFirebaseToken();
    return response;
  }

  Stream<NetPush> listenWebSocket(WebSocket ws, HttpRequest request) {
    final _CallWrapperWebSocket call = _CallWrapperWebSocket();
    call.clientMetadata['authority'] = request.headers['authority']?.first;
    call.clientMetadata['authorization'] =
        request.headers['authorization']?.first;
    call.clientMetadata['x-jwt-payload'] =
        request.headers['x-jwt-payload']?.first;
    /*
    // Bypass security.
    if (call.clientMetadata['x-jwt-payload'] == null && call.clientMetadata['authorization'] != null) {
      devLog.severe('WebSocket JWT not verified!');
      call.clientMetadata['authority'] = 'ws';
      call.clientMetadata['x-jwt-payload'] = call.clientMetadata['authorization'].split('.')[1];
    }
    */
    devLog.finest('WebSocket connection: ${request.headers}');
    final DataAuth auth = authFromJwtPayload(call);
    ws.listen((dynamic data) {
      ws.close();
    }, onDone: () {
      call.isCanceled = true;
      if (_listeners[auth.sessionId]?.call == call) {
        final _Listener listener = _listeners.remove(auth.sessionId);
        listener.keepAlive.cancel();
        unawaited(listener.controller.close());
      }
    });
    return listen(call, NetListen());
  }

  Stream<NetPush> listen(grpc.ServiceCall call, NetListen request) async* {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    // Kick any previous listener for this session. It's not allowed to listen twice on the same session.
    final _Listener previousListener = _listeners.remove(auth.sessionId);
    if (previousListener != null) {
      previousListener.keepAlive.cancel();
      await previousListener.controller.close();
    }

    // Create a new controller for this listener.
    final StreamController<NetPush> controller = StreamController<NetPush>();
    final Timer keepAlive = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (call.isCanceled) {
        if (_listeners[auth.sessionId]?.controller == controller) {
          _listeners.remove(auth.sessionId);
          timer.cancel();
          unawaited(controller.close());
        }
      } else {
        final NetPush push = NetPush();
        push.keepAlive = NetKeepAlive();
        controller.add(push);
      }
    });
    _listeners[auth.sessionId] =
        _Listener(call, request, controller, keepAlive);

    // Add session id to stored account information if not known yet locally
    final _CachedAccount cached = await _cachedAccount(auth.accountId);
    if (!cached.sessionIds.contains(auth.sessionId)) {
      await sql.prepareExecute(
        'INSERT INTO `push_tokens`(`session_id`, `account_id`)'
            '  VALUES (?, ?)'
            '  ON DUPLICATE KEY'
            '    UPDATE `account_id` = ?',
        <dynamic>[
          auth.sessionId,
          auth.accountId,
          auth.accountId,
        ],
      );
      cached.sessionIds.add(auth.sessionId);
    }

    final NetPush ready = NetPush();
    ready.pushing = NetPushing();
    yield ready;

    await for (NetPush push in controller.stream) {
      yield push;
    }
  }
}

/* end of file */
