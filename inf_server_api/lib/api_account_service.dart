/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/broadcast_center.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

import 'package:inf_common/inf_common.dart';

class ApiAccountService extends ApiAccountServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final BroadcastCenter bc;
  static final Logger opsLog = Logger('InfOps.ApiAccountService');
  static final Logger devLog = Logger('InfDev.ApiAccountService');

  ApiAccountService(this.config, this.accountDb, this.bc);

  @override
  Future<NetAccount> setType(
      grpc.ServiceCall call, NetSetAccountType request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');

    // Can only set account type for accountless sessions
    if (auth.sessionId == Int64.ZERO || auth.accountId != Int64.ZERO) {
      throw grpc.GrpcError.permissionDenied();
    }

    try {
      await accountDb.startTransaction((sqljocky.Transaction tx) async {
        await tx.prepareExecute(
            'DELETE FROM `oauth_connections` WHERE `session_id` = ? AND `account_id` = 0',
            <dynamic>[auth.sessionId]);
        final sqljocky.Results updateResults = await tx.prepareExecute(
            'UPDATE `sessions` SET `account_type` = ? WHERE `session_id` = ? AND `account_id` = 0',
            <dynamic>[request.accountType.value, auth.sessionId]);
        if (updateResults.affectedRows > 0) {
          await tx.commit();
        } else {
          devLog.severe('Account type could not be changed');
          throw grpc.GrpcError.failedPrecondition();
        }
      });
    } catch (error, stackTrace) {
      devLog.severe('Failed to change account type', error, stackTrace);
      throw grpc.GrpcError.internal();
    }

    final NetAccount account = NetAccount();
    account.account =
        await fetchSessionAccount(config, accountDb, auth.sessionId);
    return account;
  }

  @override
  Future<NetAccount> create(
      grpc.ServiceCall call, NetAccountCreate request) async {
    // TODO: implement create
    return null;
  }

  @override
  Future<NetOAuthConnection> connectProvider(
      grpc.ServiceCall call, NetOAuthConnection request) async {
    // TODO: implement connectProvider
    return null;
  }

  @override
  Future<NetAccount> setFirebaseToken(
      grpc.ServiceCall call, NetSetFirebaseToken request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');
    if (auth.sessionId == Int64.ZERO) {
      throw grpc.GrpcError.permissionDenied();
    }

    // TODO: Get old firebase token from database instead of from client message!

    // No validation here, no risk. Messages would just end up elsewhere
    String update =
        'UPDATE `sessions` SET `firebase_token`= ? WHERE `session_id` = ?';
    await accountDb.prepareExecute(update, <dynamic>[
      request.firebaseToken.toString(),
      auth.sessionId,
    ]);

    if (request.hasOldFirebaseToken() && request.oldFirebaseToken != null) {
      update =
          'UPDATE `sessions` SET `firebase_token`= ? WHERE `firebase_token` = ?';
      await accountDb.prepareExecute(update, <dynamic>[
        request.firebaseToken.toString(),
        request.oldFirebaseToken.toString(),
      ]);
    }

    // TODO: Notify push service that the old firebase token is no longer valid
    // bc.accountFirebaseTokensChanged(this);

    final NetAccount account = NetAccount();
    account.account =
        await fetchSessionAccount(config, accountDb, auth.sessionId);
    return account;
  }
}

/* end of file */
