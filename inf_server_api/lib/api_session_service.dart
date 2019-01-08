/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

import 'package:inf_common/inf_common.dart';

class ApiSessionService extends ApiSessionServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  static final Logger opsLog = Logger('InfOps.ApiSessionService');
  static final Logger devLog = Logger('InfDev.ApiSessionService');

  final Random _random = Random.secure();

  ApiSessionService(this.config, this.accountDb);

  @override
  Future<NetSession> create(
      grpc.ServiceCall call, NetSessionCreate request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');

    if (auth.sessionId != Int64.ZERO) {
      throw grpc.GrpcError.permissionDenied();
    }

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

    final DataAuth bearerPayload = DataAuth();
    final DataAuth accessPayload = DataAuth();

    // Bearer token payload for the created session.
    // Cannot be retrieved in the future.
    bearerPayload.sessionId = sessionId;
    bearerPayload.cookie = cookie;

    // Access token for the created session.
    // Does not yet have an associated account.
    accessPayload.sessionId = sessionId;

    // TODO: response.bearerToken JWT
    // TODO: response.accessToken JWT

    return response;
  }

  @override
  Future<NetSession> open(grpc.ServiceCall call, NetSessionOpen request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');

    if (auth.sessionId != Int64.ZERO) {
      throw grpc.GrpcError.permissionDenied();
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
      throw grpc.GrpcError.dataLoss();
    }

    response.account = await fetchSessionAccount(config, accountDb, sessionId);

    final DataAuth accessPayload = DataAuth();
    accessPayload.sessionId = sessionId;
    accessPayload.accountId = response.account.accountId;
    accessPayload.accountType = response.account.accountType;
    accessPayload.globalAccountState = response.account.globalAccountState;
    accessPayload.accountLevel = response.account.accountLevel;

    // TODO: response.accessToken JWT

    return response;
  }
}

/* end of file */
