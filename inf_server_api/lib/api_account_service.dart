/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:geohash/geohash.dart';
import 'package:inf_server_api/broadcast_center.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:inf_server_api/common_location.dart';
import 'package:inf_server_api/common_oauth.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:s2geometry/s2geometry.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;
import 'package:http_client/console.dart' as http_client;

import 'package:inf_common/inf_common.dart';

class ApiAccountService extends ApiAccountServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final BroadcastCenter bc;
  final List<oauth1.Authorization> oauth1Auth;

  static final Logger opsLog = Logger('InfOps.ApiAccountService');
  static final Logger devLog = Logger('InfDev.ApiAccountService');

  final http.Client httpClient = http.Client();
  final http_client.Client httpClientClient = http_client.ConsoleClient();

  ApiAccountService(this.config, this.accountDb, this.bc, this.oauth1Auth);

  final Random _random = Random.secure();

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

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
      final DataSocialMedia dataSocialMedia = await fetchSocialMedia(
          config, httpClient, oauthProvider, oauthCredentials);

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
      result.account =
          await fetchSessionAccount(config, accountDb, auth.sessionId);

      // TODO: accessToken
      // result.accessToken = ...;
    }

    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetAccount> create(
      grpc.ServiceCall call, NetAccountCreate request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');

    // Accountless only
    if (auth.sessionId == Int64.ZERO || auth.accountId != Int64.ZERO) {
      throw grpc.GrpcError.permissionDenied();
    }

    // Validate accountless session
    final DataAccount accountless =
        await fetchSessionAccount(config, accountDb, auth.sessionId);
    if (accountless.accountId != Int64.ZERO ||
        accountless.accountType == AccountType.unknown) {
      throw grpc.GrpcError.failedPrecondition();
    }

    // Count the number of connected authentication mechanisms
    int connectedNb = 0;
    for (DataSocialMedia socialMedia in accountless.socialMedia.values) {
      if (socialMedia.connected) {
        ++connectedNb;
      }
    }

    // Validate that the current state is sufficient to create an account
    if (connectedNb == 0) {
      throw grpc.GrpcError.failedPrecondition();
    }

    // Received account creation request
    final String ipAddress = call.clientMetadata['x-real-ip'];
    devLog.finest('NetAccountCreate: $request');
    devLog.finest('ipAddress: $ipAddress');

    const List<int> mediaPriority = <int>[
      3,
      1,
      4,
      8,
      6,
      2,
      5,
      7,
      9,
      10,
      11,
      12,
      13,
      14,
      15
    ]; // TODO: put this in the config

    // Attempt to get locations
    // Fetch location info from coordinates
    // Coordinates may exist in either the GPS data or in the user's IP address
    // Alternatively we can reverse one from location names in the user's social media
    List<DataLocation> locations = List<DataLocation>();
    DataLocation gpsLocationRes;
    Future<dynamic> gpsLocation;
    if (request.latitude != null &&
        request.longitude != null &&
        request.latitude != 0.0 &&
        request.longitude != 0.0) {
      gpsLocation = getGeocodingFromGPS(
              config, httpClientClient, request.latitude, request.longitude)
          .then((DataLocation location) {
        devLog.finest('GPS: $location');
        gpsLocationRes = location;
      }).catchError((dynamic error, StackTrace stackTrace) {
        devLog.severe('GPS Geocoding Exception', error, stackTrace);
      });
    }
    DataLocation geoIPLocationRes;
    final Future<dynamic> geoIPLocation = ipAddress != null
        ? getGeoIPLocation(config, httpClientClient, ipAddress)
            .then((DataLocation location) {
            devLog.finest('GeoIP: $location');
            geoIPLocationRes = location;
            // locations.add(location);
          }).catchError((dynamic error, StackTrace stackTrace) {
            devLog.severe('GeoIP Location Exception', error, stackTrace);
          })
        : null;

    // Wait for GPS Geocoding
    // Using await like this doesn't catch exceptions, so required to put handlers in advance -_-
    if (gpsLocation != null) {
      await gpsLocation;
      if (gpsLocationRes != null) {
        locations.add(gpsLocationRes);
      }
    }

    // Also query all social media locations in the meantime, no particular order
    final List<Future<dynamic>> mediaLocations = <Future<dynamic>>[];
    // for (int i = 0; i < config.oauthProviders.length; ++i) {
    for (int i in mediaPriority) {
      final DataSocialMedia socialMedia = accountless.socialMedia[i];
      if (socialMedia != null &&
          socialMedia.connected &&
          socialMedia.location != null &&
          socialMedia.location.isNotEmpty) {
        mediaLocations.add(
            getGeocodingFromName(config, httpClientClient, socialMedia.location)
                .then((DataLocation location) {
          devLog.finest(
              '${config.oauthProviders[i].label}: ${socialMedia.displayName}: $location');
          location.name = socialMedia.displayName;
          locations.add(location);
        }).catchError((dynamic error, StackTrace stackTrace) {
          devLog.severe(
              '${config.oauthProviders[i].label}: Geocoding Exception',
              error,
              stackTrace);
        }));
      }
    }

    // Wait for all social media
    for (Future<dynamic> futureLocation in mediaLocations) {
      await futureLocation;
    }

    // Wait for GeoIP
    if (geoIPLocation != null) {
      await geoIPLocation;
      if (geoIPLocationRes != null) {
        locations.add(geoIPLocationRes);
      }
    }

    // Fallback location
    if (locations.isEmpty) {
      devLog.severe('Using fallback location for session ${auth.sessionId}');
      final DataLocation location = DataLocation();
      location.name = 'Los Angeles';
      location.approximate = 'Los Angeles, California 90017';
      location.detail = 'Los Angeles, California 90017';
      location.postcode = '90017';
      location.regionCode = 'US-CA';
      location.countryCode = 'US';
      location.latitude = 34.0207305;
      location.longitude = -118.6919159;
      location.s2cellId = Int64(S2CellId.fromLatLng(
              S2LatLng.fromDegrees(location.latitude, location.longitude))
          .id);
      location.geohash =
          Geohash.encode(location.latitude, location.longitude, codeLength: 20);
      locations.add(location);
    }

    // Build account info
    String accountName;
    String accountScreenName;
    String accountDescription;
    String accountAvatarUrl;
    String accountUrl;
    String accountEmail;
    for (int i in mediaPriority) {
      final DataSocialMedia socialMedia = accountless.socialMedia[i];
      if (socialMedia != null && socialMedia.connected) {
        if (accountName == null &&
            socialMedia.displayName != null &&
            socialMedia.displayName.isNotEmpty)
          accountName = socialMedia.displayName;
        if (accountScreenName == null &&
            socialMedia.screenName != null &&
            socialMedia.screenName.isNotEmpty)
          accountScreenName = socialMedia.screenName;
        if (accountDescription == null &&
            socialMedia.description != null &&
            socialMedia.description.isNotEmpty)
          accountDescription = socialMedia.description;
        if (accountAvatarUrl == null &&
            socialMedia.avatarUrl != null &&
            socialMedia.avatarUrl.isNotEmpty)
          accountAvatarUrl = socialMedia.avatarUrl;
        if (accountUrl == null &&
            socialMedia.url != null &&
            socialMedia.url.isNotEmpty) {
          accountUrl = socialMedia.url;
        }
        if (accountEmail == null &&
            socialMedia.email != null &&
            socialMedia.email.isNotEmpty) {
          accountEmail = socialMedia.email;
        }
      }
    }
    accountName ??= accountScreenName;
    accountName ??= 'Your Name Here';
    if (accountDescription == null) {
      const List<String> influencerDefaults = <String>[
        'Even the most influential influencers are influenced by this inf.',
        'Always doing the good things for the good people.',
        'Really always knows everything about what is going on.',
        'Who needs personality when you have brands.',
        'Believes even a person can become a product.',
        'My soul was sold with discount vouchers.',
        'Believes that there is still room for more pictures of food.',
        'Prove that freeloading can be a profession.',
        'Teaches balloon folding to self abusers.',
        'Free range ranger for sacrificial animals.',
        "Paints life-size boogie man in children's bedroom closets.",
        'On-sight plastic surgeon for fashion shows.',
        'Fred Kazinsky the e-mail bomber.',
        'Teaches flamboyant shuffling techniques to dull blackjack dealers.',
        'Sauerkraut unraveler.',
      ];
      const List<String> businessDefaults = <String>[
        'The best in town.',
        'We know our product, because we made it.',
        'Everything you expect and more.',
        "You will be lovin' it.",
      ];
      switch (accountless.accountType) {
        case AccountType.influencer:
          accountDescription =
              influencerDefaults[_random.nextInt(influencerDefaults.length)];
          break;
        case AccountType.business:
          accountDescription =
              businessDefaults[_random.nextInt(businessDefaults.length)];
          break;
        case AccountType.support:
          accountDescription = 'Support Staff';
          break;
        default:
          accountDescription = '';
          break;
      }
    }

    // Set empty location names to account name
    for (DataLocation location in locations) {
      if (location.name == null || location.name.isEmpty) {
        location.name = accountName;
      }
    }

    // Changes sent in a single SQL transaction for reliability
    // Process the account creation
    Int64 accountId;
    await accountDb.startTransaction((sqljocky.Transaction tx) async {
      // 1. Create the account entries
      // 2. Update session to LAST_INSERT_ID(), ensure that a row was modified, otherwise rollback (account already created)
      // 3. Update all session authentication connections to LAST_INSERT_ID()
      // 4. Create the location entries, in reverse (latest one always on top)
      // 1.
      // TODO: Add notify flags field to SQL
      GlobalAccountState globalAccountState;
      GlobalAccountStateReason globalAccountStateReason;
      // Initial approval state for accounts is defined here
      switch (auth.accountType) {
        case AccountType.business:
        case AccountType.influencer:
          // globalAccountState = GlobalAccountState.pending;
          // globalAccountStateReason = GlobalAccountStateReason.pending;
          globalAccountState = GlobalAccountState.readWrite;
          globalAccountStateReason = GlobalAccountStateReason.demoApproved;
          break;
        case AccountType.support:
          globalAccountState = GlobalAccountState.blocked;
          globalAccountStateReason = GlobalAccountStateReason.pending;
          break;
        default:
          opsLog.severe(
              'Attempt to create account with invalid account type ${accountless.accountType} by session ${accountless.sessionId}');
          throw Exception(
              'Attempt to create account with invalid account type');
      }
      final sqljocky.Results res1 = await tx.prepareExecute(
          'INSERT INTO `accounts`('
          '`name`, `account_type`, '
          '`global_account_state`, `global_account_state_reason`, '
          '`description`, `website`, `email`' // avatarUrl is set later
          ') VALUES (?, ?, ?, ?, ?, ?, ?)',
          <dynamic>[
            accountName.toString(),
            accountless.accountType.value.toInt(),
            globalAccountState.value.toInt(),
            globalAccountStateReason.value.toInt(),
            accountDescription.toString(),
            accountUrl,
            accountEmail,
          ]);
      if (res1.affectedRows == 0) {
        throw grpc.GrpcError.internal('Account was not inserted');
      }
      accountId = Int64(res1.insertId);
      if (accountId == Int64.ZERO) {
        throw grpc.GrpcError.internal('Invalid accountId');
      }
      // 2.
      final sqljocky.Results res2 = await tx.prepareExecute(
          'UPDATE `sessions` SET `account_id` = LAST_INSERT_ID() '
          'WHERE `session_id` = ? AND `account_id` = 0',
          <dynamic>[auth.sessionId]);
      if (res2.affectedRows == 0) {
        throw grpc.GrpcError.internal('Device was not updated');
      }
      // 3.
      final sqljocky.Results res3 = await tx.prepareExecute(
          'UPDATE `oauth_connections` SET `account_id` = LAST_INSERT_ID() '
          'WHERE `session_id` = ? AND `account_id` = 0',
          <dynamic>[auth.sessionId]);
      if (res3.affectedRows == 0)
        grpc.GrpcError.internal('Social media was not updated');
      // 4.
      for (DataLocation location in locations.reversed) {
        final sqljocky.Results res4 = await tx.prepareExecute(
            'INSERT INTO `locations`('
            '`account_id`, `name`, `detail`, `approximate`, '
            '`postcode`, `region_code`, `country_code`, '
            '`latitude`, `longitude`, `s2cell_id`, `geohash`) '
            'VALUES ('
            '?, ?, ?, ?, '
            '?, ?, ?, '
            '?, ?, ?, ?'
            ')',
            <dynamic>[
              accountId,
              location.name.toString(),
              location.detail.toString(),
              location.approximate.toString(),
              location.postcode == null ? null : location.postcode.toString(),
              location.regionCode.toString(),
              location.countryCode.toString(),
              location.latitude,
              location.longitude,
              location.s2cellId,
              location.geohash
            ]);
        if (res4.affectedRows == 0) {
          grpc.GrpcError.internal('Location was not inserted');
        }
        devLog.finest('Inserted location');
      }
      devLog.finest('Inserted locations');
      // 5.
      final sqljocky.Results res5 = await tx.prepareExecute(
          'UPDATE `accounts` SET `location_id` = LAST_INSERT_ID() '
          'WHERE `account_id` = ?',
          <dynamic>[accountId]);
      if (res5.affectedRows == 0)
        grpc.GrpcError.internal('Account was not updated with location');
      devLog.fine('Finished setting up account $accountId');
      await tx.commit();
    });

    // Update state
    /*
    try {
      await lock.synchronized(() async {
        channel.replyExtend(message);
        await refreshAccount(extend: () {
          channel.replyExtend(message);
        });
        if (account.accountId != 0) {
          channel.replyExtend(message);
          unsubscribeOnboarding(); // No longer respond to onboarding messages when OK
          await transitionToApp(); // TODO: Transitions and subs hould be handled by updateDeviceState preferably...
        }
      });
    } catch (error, stackTrace) {
      devLog.severe(
          "Failed to update device state at critical point: '$accountAvatarUrl'",
          error,
          stackTrace);
      await channel.close();
      rethrow;
    }
    */

    // TODO: Move downloadUserImage
    // Non-critical
    // 1. Download avatar
    // 2. Upload avatar to Spaces
    // 3. Update account to refer to avatar
    /*
    try {
      if (accountId != 0 &&
          accountAvatarUrl != null &&
          accountAvatarUrl.length > 0) {
        String avatarKey =
            await downloadUserImage(account.accountId, accountAvatarUrl);
        await accountDb.prepareExecute(
            'UPDATE `accounts` SET `avatar_key` = ? '
            'WHERE `account_id` = ?',
            <dynamic>[avatarKey.toString(), accountId]);
      }
    } catch (error, stackTrace) {
      devLog.severe("Exception downloading avatar '$accountAvatarUrl'", error,
          stackTrace);
    }
    */

    // Send authentication state
    /*
    await lock.synchronized(() async {
      // Send all state to user
      await sendAccountUpdate(replying: message, procedureId: 'A_R_CREA');
    });
    if (account.accountId == 0) {
      devLog.severe(
          "Account was not created for session ${account.sessionId}"); // DEVELOPER - DEVELOPMENT CRITICAL
    }
    */

    final NetAccount account = NetAccount();
    account.account = await fetchSessionAccount(config, accountDb, auth.sessionId);
    return account;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

}

/* end of file */
