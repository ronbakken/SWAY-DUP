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
import 'package:inf_server_api/common_oauth.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;

import 'package:inf_common/inf_common.dart';

class ApiAccountService extends ApiAccountServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final BroadcastCenter bc;
  final List<oauth1.Authorization> oauth1Auth;

  static final Logger opsLog = Logger('InfOps.ApiAccountService');
  static final Logger devLog = Logger('InfDev.ApiAccountService');

  final http.Client httpClient = http.Client();

  ApiAccountService(this.config, this.accountDb, this.bc, this.oauth1Auth);

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
  Future<NetOAuthConnection> connectProvider(
      grpc.ServiceCall call, NetOAuthConnect request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');

    // Can either be used by an accountless session
    // or by an account that's not banned
    if (auth.sessionId == Int64.ZERO ||
        auth.accountType == AccountType.unknown ||
        (auth.accountId != Int64.ZERO &&
            auth.globalAccountState.value <
                GlobalAccountState.readOnly.value)) {
      throw grpc.GrpcError.permissionDenied();
    }

    if (request.oauthProvider == 0 ||
        request.oauthProvider >= config.oauthProviders.length) {
      throw grpc.GrpcError.invalidArgument(
          "Invalid oauthProvider specified '${request.oauthProvider}'.");
    }

    final int oauthProvider = request.oauthProvider;

    // TODO: Fetch this from other service
    final DataOAuthCredentials oauthCredentials = await fetchOAuthCredentials(
        config, oauth1Auth, httpClient, oauthProvider, request.callbackQuery);

    // bool transitionAccount = false;
    // bool connected = false;

    // final ConfigOAuthProvider provider = config.oauthProviders[oauthProvider];
    final NetOAuthConnection result = NetOAuthConnection();

    bool inserted = false;
    bool takeover = false;
    bool refreshed = false;
    if (oauthCredentials != null) {
      // Attempt to process valid OAuth transaction.
      // Sets connected true if successfully added to session.
      // Sets transitionAccount if logged in to an account instead.
      // There's another situation where media is already connected and we're just updating tokens
      // await fetchSocialMedia(oauthProvider, oauthCredentials); // FOR TESTING PURPOSE -- REMOVE THIS LINE

      // Insert the data we have
      try {
        final sqljocky.Results insertResult = await accountDb.prepareExecute(
            'INSERT INTO `oauth_connections`('
            '`oauth_user_id`, `oauth_provider`, `account_type`, `account_id`, `session_id`, `oauth_token`, `oauth_token_secret`, `oauth_token_expires`'
            ') VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            <dynamic>[
              oauthCredentials.userId.toString(),
              oauthProvider.toInt(),
              auth.accountType.value.toInt(),
              auth.accountId,
              auth.sessionId,
              oauthCredentials.token.toString(),
              oauthCredentials.tokenSecret.toString(),
              oauthCredentials.tokenExpires.toString()
            ]);
        inserted = insertResult.affectedRows > 0;
        devLog.finest('Inserted new OAuth connection: $inserted');
      } catch (ex) {
        // TODO: Need to catch the specific SQL exception
        // This is permitted to fail
        devLog.finest(
            'Atomical (INSERT INTO `oauth_connections`) Exception: $ex');
      }

      // Alternative is to update a previously pending connection that has account_id = 0
      if (!inserted) {
        try {
          if (auth.accountId == 0) {
            // Attempt to login to an existing account, or regain a lost connection
            devLog.finest('Try takeover');
            const String query = 'UPDATE `oauth_connections` '
                'SET `updated` = CURRENT_TIMESTAMP(), `session_id` = ?, '
                '`oauth_token` = ?, `oauth_token_secret` = ?, `oauth_token_expires` = ? '
                'WHERE `oauth_user_id` = ? AND `oauth_provider` = ? AND `account_type` = ?';
            final sqljocky.Results updateResults =
                await accountDb.prepareExecute(query, <dynamic>[
              auth.sessionId,
              oauthCredentials.token.toString(),
              oauthCredentials.tokenSecret.toString(),
              oauthCredentials.tokenExpires.toString(),
              oauthCredentials.userId.toString(),
              oauthProvider,
              auth.accountType.value
            ]);
            takeover =
                updateResults.affectedRows > 0; // Also check for account state
            devLog.finest(updateResults.affectedRows);
            devLog.finest(
                'Attempt to takeover OAuth connection result: $takeover');
          }
          if (takeover) {
            // Find out if we are logged into an account now
            devLog.finest('Verify takeover');
            final sqljocky.Results connectionResults = await accountDb
                .prepareExecute(
                    'SELECT `account_id` FROM `oauth_connections` '
                    'WHERE `oauth_user_id` = ? AND `oauth_provider` = ? AND `account_type` = ?',
                    <dynamic>[
                  oauthCredentials.userId.toString(),
                  oauthProvider,
                  auth.accountType.value
                ]);
            Int64 takeoverAccountId = Int64.ZERO;
            await for (sqljocky.Row row in connectionResults) {
              takeoverAccountId = Int64(row[0]);
            }
            takeover = takeoverAccountId != Int64.ZERO;
            if (takeover) {
              // updateDeviceState loads the new state from the database into account.accountId
              devLog.finest(
                  'Takeover, existing account $takeoverAccountId on session ${auth.sessionId}');
              const String query = 'UPDATE `sessions` '
                  'SET `account_id` = ? '
                  'WHERE `session_id` = ? AND `account_id` = 0';
              await accountDb.prepareExecute(
                  query, <dynamic>[takeoverAccountId, auth.sessionId]);
              // NOTE: Technically, here we may escalate any OAuth connections of this session to the account,
              // as long as the account has no connections yet for the connected providers (long-term)
            }
            refreshed =
                !takeover; // If not anymore a takeover, then simply refreshed by sessionId
            devLog.finest('refreshed: $refreshed, takeover: $takeover');
          }
          if (!takeover && !refreshed) {
            // In case account state changed, or in case the user is simply refreshing tokens
            devLog.finest('Try refresh');
            const String query = 'UPDATE `oauth_connections` '
                'SET `updated` = CURRENT_TIMESTAMP(), `account_id` = ?, `session_id` = ?, `oauth_token` = ?, `oauth_token_secret` = ?, `oauth_token_expires` = ? '
                'WHERE `oauth_user_id` = ? AND `oauth_provider` = ? AND `account_type` = ? AND (`account_id` = 0 OR `account_id` = ?)'; // Also allow account_id 0 in case of issue
            final sqljocky.Results updateResults =
                await accountDb.prepareExecute(query, <dynamic>[
              auth.accountId,
              auth.sessionId,
              oauthCredentials.token.toString(),
              oauthCredentials.tokenSecret.toString(),
              oauthCredentials.tokenExpires.toInt(),
              oauthCredentials.userId.toString(),
              oauthProvider.toInt(),
              auth.accountType.value.toInt(),
              auth.accountId
            ]);
            refreshed = updateResults.affectedRows > 0;
            devLog.finest('Attempt to refresh OAuth tokens: $refreshed');
          }
        } catch (ex) {
          // TODO: Need to catch the specific SQL exception
          // This is permitted to fail
          devLog.finest('Atomical (UPDATE `oauth_connections`) Exception: $ex');
        }
      }
    }

    devLog.finest('itf: $inserted, $takeover, $refreshed');
    if (inserted || takeover || refreshed) {
      // Wipe any other previously connected accounts to avoid inconsistent data
      // Happens after addition to ensure race condition will prioritize deletion
      if (auth.accountId != Int64.ZERO) {
        const String query =
            'DELETE FROM `oauth_connections` WHERE `account_id` = ? AND `oauth_user_id` != ? AND `oauth_provider` = ?';
        await accountDb.prepareExecute(query, <dynamic>[
          auth.accountId,
          oauthCredentials.userId.toString(),
          oauthProvider.toInt()
        ]);
      }
      // Again for session
      if (auth.sessionId != Int64.ZERO) {
        const String query =
            'DELETE FROM `oauth_connections` WHERE `session_id` = ? AND `oauth_user_id` != ? AND `oauth_provider` = ?';
        await accountDb.prepareExecute(query, <dynamic>[
          auth.sessionId,
          oauthCredentials.userId.toString(),
          oauthProvider.toInt()
        ]);
      }

      // Fetch useful data from social media
      final DataSocialMedia dataSocialMedia =
          await fetchSocialMedia(config, httpClient, oauthProvider, oauthCredentials);

      // Write fetched social media data to SQL database
      await _cacheSocialMedia(
          oauthCredentials.userId, oauthProvider, dataSocialMedia);

      result.socialMedia = DataSocialMedia();
      result.socialMedia.mergeFromMessage(dataSocialMedia);
      result.socialMedia.connected = true;
      result.socialMedia.canSignUp =
          config.oauthProviders[oauthProvider].canAlwaysAuthenticate &&
              !takeover;
    }

    if (takeover) {
      // Account was found during connection, transition
      result.account = await fetchSessionAccount(config, accountDb, auth.sessionId);

      // TODO: accessToken
      // result.accessToken = ...;
    }

    return result;
  }

  @override
  Future<NetAccount> create(
      grpc.ServiceCall call, NetAccountCreate request) async {
    // devLog.finest(request.callbackQuery);
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

  Future<void> _cacheSocialMedia(String oauthUserId, int oauthProvider,
      DataSocialMedia dataSocialMedia) async {
    final Map<String, String> stringValues = <String, String>{};
    final Map<String, int> intValues = <String, int>{};
    if (dataSocialMedia.screenName.isNotEmpty)
      stringValues['screen_name'] = dataSocialMedia.screenName;
    if (dataSocialMedia.displayName.isNotEmpty)
      stringValues['display_name'] = dataSocialMedia.displayName;
    if (dataSocialMedia.avatarUrl.isNotEmpty)
      stringValues['avatar_url'] = dataSocialMedia.avatarUrl;
    if (dataSocialMedia.profileUrl.isNotEmpty)
      stringValues['profile_url'] = dataSocialMedia.profileUrl;
    if (dataSocialMedia.description.isNotEmpty)
      stringValues['description'] = dataSocialMedia.description;
    if (dataSocialMedia.location.isNotEmpty)
      stringValues['location'] = dataSocialMedia.location;
    if (dataSocialMedia.url.isNotEmpty)
      stringValues['website'] = dataSocialMedia.url;
    if (dataSocialMedia.email.isNotEmpty)
      stringValues['email'] = dataSocialMedia.email;
    if (dataSocialMedia.friendsCount > 0)
      intValues['friends_count'] = dataSocialMedia.friendsCount;
    if (dataSocialMedia.followersCount > 0)
      intValues['followers_count'] = dataSocialMedia.followersCount;
    if (dataSocialMedia.followingCount > 0)
      intValues['following_count'] = dataSocialMedia.followingCount;
    if (dataSocialMedia.postsCount > 0)
      intValues['posts_count'] = dataSocialMedia.postsCount;
    if (dataSocialMedia.hasVerified())
      intValues['verified'] = dataSocialMedia.verified ? 1 : 0;
    bool comma = true;
    String queryNames = '`updated`';
    String queryValues = 'CURRENT_TIMESTAMP()';
    String queryUpdates = '`updated` = CURRENT_TIMESTAMP()';
    final List<dynamic> queryParams = new List<dynamic>();
    for (MapEntry<String, String> v in stringValues.entries) {
      if (comma) {
        queryNames += ', ';
        queryValues += ', ';
        queryUpdates += ', ';
      } else {
        comma = true;
      }
      queryNames += '`${v.key}`';
      queryValues += '?';
      queryUpdates += '`${v.key}` = ?';
      queryParams.add(v.value);
    }
    for (MapEntry<String, int> v in intValues.entries) {
      if (comma) {
        queryNames += ', ';
        queryValues += ', ';
        queryUpdates += ', ';
      } else {
        comma = true;
      }
      queryNames += '`${v.key}`';
      queryValues += '?';
      queryUpdates += '`${v.key}` = ?';
      queryParams.add(v.value);
    }
    if (comma) {
      final String query =
          'INSERT INTO `social_media`(`oauth_user_id`, `oauth_provider`, $queryNames) VALUES (?, ?, $queryValues) ON DUPLICATE KEY UPDATE $queryUpdates';
      await accountDb.prepareExecute(
          query,
          <dynamic>[oauthUserId.toString(), oauthProvider.toInt()]
            ..addAll(queryParams)
            ..addAll(queryParams));
    }
  }
}

/* end of file */
