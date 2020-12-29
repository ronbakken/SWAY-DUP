/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

import 'package:sway_common/inf_backend.dart';

class ApiSessionService extends ApiSessionServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  static final Logger opsLog = Logger('InfOps.ApiSessionService');
  static final Logger devLog = Logger('InfDev.ApiSessionService');

  final Random _random = Random.secure();

  grpc.ClientChannel backendJwtChannel;
  BackendJwtClient backendJwt;

  ApiSessionService(this.config, this.accountDb) {
    final Uri backendJwtUri = Uri.parse(
        Platform.environment['INF_BACKEND_JWT'] ?? config.services.backendJwt);
    backendJwtChannel = grpc.ClientChannel(
      backendJwtUri.host,
      port: backendJwtUri.port,
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
    backendJwt = BackendJwtClient(backendJwtChannel);
  }

  @override
  Future<NetSession> create(
      grpc.ServiceCall call, NetSessionCreate request) async {
    devLog.finest(call.clientMetadata['x-jwt-payload']);
    authFromJwtPayload(call, applicationToken: true);

    final NetSession response = NetSession();
    final Uint8List cookie = Uint8List(32);
    for (int i = 0; i < cookie.length; ++i) {
      cookie[i] = _random.nextInt(256);
    }

    // Create a session in the sessions table of the database
    final Uint8List cookieHash = Uint8List.fromList(
        sha256.convert(cookie + config.services.salt).bytes); // n.v.t.
    final Uint8List deviceHash = Uint8List.fromList(
        sha256.convert(request.deviceToken + config.services.salt).bytes);

    final sqljocky.Results insertResults = await accountDb.prepareExecute(
        'INSERT INTO `sessions` (`cookie_hash`, `device_hash`, `name`, `info`) VALUES (?, ?, ?, ?)',
        <dynamic>[
          cookieHash,
          deviceHash,
          request.deviceName,
          request.deviceInfo
        ]);
    final Int64 sessionId = Int64(insertResults.insertId);

    if (sessionId == Int64.ZERO) {
      throw grpc.GrpcError.failedPrecondition('Failed to create session.');
    }

    devLog
        .info("Inserted session_id $sessionId with cookie_hash '$cookieHash'");

    response.account = DataAccount(); // await fetchFullAccount();
    response.account.sessionId = sessionId;

    final DataAuth refreshPayload = DataAuth();
    final DataAuth accessPayload = DataAuth();

    // Refresh token payload for the created session.
    // Cannot be retrieved in the future.
    // Must create new session to get a new refresh token.
    refreshPayload.sessionId = sessionId;
    refreshPayload.cookie = cookie;

    // Access token for the created session.
    // Does not yet have an associated account.
    accessPayload.sessionId = sessionId;

    final ReqSign refreshSignRequest = ReqSign();
    refreshSignRequest.claim = json.encode(<String, dynamic>{
      'iss': 'https://sway-dev.net',
      'aud': 'sway-dev',
      'pb': base64.encode(refreshPayload.writeToBuffer())
    });
    refreshSignRequest.freeze();
    final ResSign refreshResponse = await backendJwt.sign(
      refreshSignRequest,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'x-request-id': call.clientMetadata['x-request-id'],
        },
        // TODO: timeout: call.deadline.difference(DateTime.now()),
      ),
    );
    response.refreshToken = refreshResponse.token;

    final ReqSign accessSignRequest = ReqSign();
    accessSignRequest.claim = json.encode(<String, dynamic>{
      'iss': 'https://sway-dev.net',
      'aud': 'sway-dev',
      'pb': base64.encode(accessPayload.writeToBuffer())
      // TODO: Expire
    });
    accessSignRequest.freeze();
    final ResSign accessResponse = await backendJwt.sign(
      accessSignRequest,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'x-request-id': call.clientMetadata['x-request-id'],
        },
        // TODO: timeout: call.deadline.difference(DateTime.now()),
      ),
    );
    response.accessToken = accessResponse.token;

    return response;
  }

  @override
  Future<NetSession> open(grpc.ServiceCall call, NetSessionOpen request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (!auth.hasCookie()) {
      throw grpc.GrpcError.permissionDenied('Not a refresh token.');
    }
    if (auth.accountId != Int64.ZERO) {
      throw grpc.GrpcError.permissionDenied('Refresh token invalid.');
    }

    final NetSession response = NetSession();
    final Uint8List cookieHash = Uint8List.fromList(
        sha256.convert(auth.cookie + config.services.salt).bytes);

    // Validate the hashed cookie with the one in the session database
    final sqljocky.Results selectResults = await accountDb.prepareExecute(
        'SELECT `session_id` FROM `sessions` WHERE `session_id` = ? AND `cookie_hash` = ?',
        <dynamic>[auth.sessionId, cookieHash]);

    Int64 sessionId = Int64.ZERO;
    await for (sqljocky.Row row in selectResults) {
      sessionId = Int64(row[0]);
    }

    if (sessionId == Int64.ZERO) {
      throw grpc.GrpcError.failedPrecondition('Failed to open session.');
    }

    if (sessionId != auth.sessionId) {
      // Sanity
      throw grpc.GrpcError.dataLoss('Session id mismatch.');
    }

    response.account = await fetchSessionAccount(config, accountDb, sessionId);

    final DataAuth accessPayload = DataAuth();
    accessPayload.sessionId = sessionId;
    accessPayload.accountId = response.account.accountId;
    accessPayload.accountType = response.account.accountType;
    accessPayload.globalAccountState = response.account.globalAccountState;
    accessPayload.accountLevel = response.account.accountLevel;

    final ReqSign accessSignRequest = ReqSign();
    accessSignRequest.claim = json.encode(<String, dynamic>{
      'iss': 'https://sway-dev.net',
      'aud': 'sway-dev',
      'pb': base64.encode(accessPayload.writeToBuffer())
      // TODO: Expire
    });
    accessSignRequest.freeze();
    final ResSign accessResponse = await backendJwt.sign(
      accessSignRequest,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'x-request-id': call.clientMetadata['x-request-id'],
        },
        // TODO: timeout: call.deadline.difference(DateTime.now()),
      ),
    );
    response.accessToken = accessResponse.token;

    return response;
  }
}

/* end of file */
