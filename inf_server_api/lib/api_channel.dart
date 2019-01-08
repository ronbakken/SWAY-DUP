/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:geohash/geohash.dart';
import 'package:inf_server_api/api_channel_demo.dart';
import 'package:inf_server_api/api_channel_offer.dart';
import 'package:inf_server_api/api_channel_proposal.dart';
import 'package:inf_server_api/api_channel_proposal_transactions.dart';
import 'package:inf_server_api/api_service.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:switchboard/switchboard.dart';
// import 'package:crypto/crypto.dart';
import 'package:http_client/console.dart' as http;
import 'package:synchronized/synchronized.dart';
import 'package:mime/mime.dart';
import 'package:dospace/dospace.dart' as dospace;
import 'package:s2geometry/s2geometry.dart';

import 'package:inf_common/inf_common.dart';
import 'broadcast_center.dart';
import 'api_channel_oauth.dart';
import 'api_channel_upload.dart';
import 'api_channel_profile.dart';
import 'api_channel_haggle_actions.dart';
import 'api_channel_business.dart';
import 'api_channel_influencer.dart';

// TODO: Move sql queries into a separate shared class, to allow prepared statements, and simplify code here

class ApiChannel {
  bool _connected = true;

  final ApiService service;
  final TalkChannel channel;

  ConfigData get config {
    return service.config;
  }

  sqljocky.ConnectionPool get accountDb {
    return service.accountDb;
  }

  sqljocky.ConnectionPool get proposalDb {
    return service.proposalDb;
  }

  dospace.Bucket get bucket {
    return service.bucket;
  }

  Elasticsearch get elasticsearch {
    return service.elasticsearch;
  }

  BroadcastCenter get bc {
    return service.bc;
  }

  final String ipAddress;

  final Random random = Random.secure();

  /// Lock anytime making changes to the account state
  final Lock lock = Lock();


  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Onboarding messages
  /////////////////////////////////////////////////////////////////////

  void subscribeOnboarding() {
    registerProcedure(
        "A_SETTYP", GlobalAccountState.initialize, _accountSetType);
    registerProcedure(
        "A_CREATE", GlobalAccountState.initialize, _accountCreate);
  }

  void unsubscribeOnboarding() {
    unregisterProcedure("A_SETTYP");
    unregisterProcedure("A_CREATE");
  }

  Future<void> _accountSetType(TalkMessage message) async {
    assert(account.sessionId != 0);
    // Received account type change request
    NetSetAccountType pb = NetSetAccountType();
    pb.mergeFromBuffer(message.data);
    devLog.finest("NetSetAccountType ${pb.accountType}");

    bool update = false;
    await lock.synchronized(() async {
      if (pb.accountType == account.accountType) {
        devLog.finest("no-op");
        return; // no-op, may ignore
      }
      if (account.accountId != 0) {
        devLog.finest("no-op");
        return; // no-op, may ignore
      }
      update = true;
      try {
        await accountDb.startTransaction((sqljocky.Transaction tx) async {
          await tx.prepareExecute(
              "DELETE FROM `oauth_connections` WHERE `session_id` = ? AND `account_id` = 0",
              <dynamic>[account.sessionId]);
          await tx.prepareExecute(
              "UPDATE `sessions` SET `account_type` = ? WHERE `session_id` = ? AND `account_id` = 0",
              <dynamic>[pb.accountType.value, account.sessionId]);
          await tx.commit();
        });
      } catch (error, stackTrace) {
        devLog.severe("Failed to change account type", error, stackTrace);
      }
    });

    // Send authentication state
    if (update) {
      devLog.finest(
          "Send authentication state, account type is ${account.accountType} (set ${pb.accountType})");
      await refreshAccount();
      await sendAccountUpdate();
      devLog.finest(
          "Account type is now ${account.accountType} (set ${pb.accountType})");
    }
  }

  Future<void> _netSetFirebaseToken(TalkMessage message) async {
    if (account.sessionId == 0) return;
    // No validation here, no risk. Messages would just end up elsewhere
    NetSetFirebaseToken pb = NetSetFirebaseToken();
    pb.mergeFromBuffer(message.data);
    devLog.finer("Set Firebase Token: $pb");
    account.firebaseToken = pb.firebaseToken;

    String update =
        "UPDATE `sessions` SET `firebase_token`= ? WHERE `session_id` = ?";
    await accountDb.prepareExecute(update, <dynamic>[
      pb.firebaseToken.toString(),
      account.sessionId,
    ]);

    if (pb.hasOldFirebaseToken() && pb.oldFirebaseToken != null) {
      update =
          "UPDATE `sessions` SET `firebase_token`= ? WHERE `firebase_token` = ?";
      await accountDb.prepareExecute(update, <dynamic>[
        pb.firebaseToken.toString(),
        pb.oldFirebaseToken.toString(),
      ]);
    }

    bc.accountFirebaseTokensChanged(
        this); // TODO: Should SELECT all the accounts that were changed (with the token)
  }

  Future<void> _accountCreate(TalkMessage message) async {
    // response: NetDeviceAuthState
    assert(account.sessionId != 0);
    // Received account creation request
    NetAccountCreate pb = NetAccountCreate();
    pb.mergeFromBuffer(message.data);
    devLog.finest("NetAccountCreate: $pb");
    devLog.finest("ipAddress: $ipAddress");
    if (account.accountId != 0) {
      devLog.info("Skip create account, already has one");
      return;
    }

    const List<int> mediaPriority = const [
      3,
      1,
      4,
      8,
      6,
      2,
      5,
      7
    ]; // TODO: put this in the config

    // Attempt to get locations
    // Fetch location info from coordinates
    // Coordinates may exist in either the GPS data or in the user's IP address
    // Alternatively we can reverse one from location names in the user's social media
    List<DataLocation> locations = List<DataLocation>();
    DataLocation gpsLocationRes;
    Future<dynamic> gpsLocation;
    if (pb.latitude != null &&
        pb.longitude != null &&
        pb.latitude != 0.0 &&
        pb.longitude != 0.0) {
      gpsLocation = getGeocodingFromGPS(pb.latitude, pb.longitude)
          .then((DataLocation location) {
        devLog.finest("GPS: $location");
        gpsLocationRes = location;
      }).catchError((dynamic error, StackTrace stackTrace) {
        devLog.severe("GPS Geocoding Exception", error, stackTrace);
      });
    }
    DataLocation geoIPLocationRes;
    Future<dynamic> geoIPLocation =
        getGeoIPLocation(ipAddress).then((DataLocation location) {
      devLog.finest("GeoIP: $location");
      geoIPLocationRes = location;
      // locations.add(location);
    }).catchError((dynamic error, StackTrace stackTrace) {
      devLog.severe("GeoIP Location Exception", error, stackTrace);
    });

    // Wait for GPS Geocoding
    // Using await like this doesn't catch exceptions, so required to put handlers in advance -_-
    channel.replyExtend(message);
    if (gpsLocation != null) {
      await gpsLocation;
      if (gpsLocationRes != null) locations.add(gpsLocationRes);
    }

    // Also query all social media locations in the meantime, no particular order
    List<Future<dynamic>> mediaLocations = List<Future<dynamic>>();
    // for (int i = 0; i < config.oauthProviders.length; ++i) {
    for (int i in mediaPriority) {
      DataSocialMedia socialMedia = account.socialMedia[i];
      if (socialMedia != null &&
          socialMedia.connected &&
          socialMedia.location != null &&
          socialMedia.location.isNotEmpty) {
        mediaLocations.add(getGeocodingFromName(socialMedia.location)
            .then((DataLocation location) {
          devLog.finest(
              "${config.oauthProviders[i].label}: ${socialMedia.displayName}: $location");
          location.name = socialMedia.displayName;
          locations.add(location);
        }).catchError((dynamic error, StackTrace stackTrace) {
          devLog.severe(
              "${config.oauthProviders[i].label}: Geocoding Exception",
              error,
              stackTrace);
        }));
      }
    }

    // Wait for all social media
    for (Future<dynamic> futureLocation in mediaLocations) {
      channel.replyExtend(message);
      await futureLocation;
    }

    // Wait for GeoIP
    await geoIPLocation;
    if (geoIPLocationRes != null) locations.add(geoIPLocationRes);

    // Fallback location
    if (locations.isEmpty) {
      devLog.severe("Using fallback location for account ${account.accountId}");
      DataLocation location = DataLocation();
      location.name = "Los Angeles";
      location.approximate = "Los Angeles, California 90017";
      location.detail = "Los Angeles, California 90017";
      location.postcode = "90017";
      location.regionCode = "US-CA";
      location.countryCode = "US";
      location.latitude = 34.0207305;
      location.longitude = -118.6919159;
      location.s2cellId = Int64(new S2CellId.fromLatLng(
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
      DataSocialMedia socialMedia = account.socialMedia[i];
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
            socialMedia.url.isNotEmpty) accountUrl = socialMedia.url;
        if (accountEmail == null &&
            socialMedia.email != null &&
            socialMedia.email.isNotEmpty) accountEmail = socialMedia.email;
      }
    }
    if (accountName == null) {
      accountName = accountScreenName;
    }
    if (accountName == null) {
      accountName = "Your Name Here";
    }
    if (accountDescription == null) {
      List<String> influencerDefaults = [
        "Even the most influential influencers are influenced by this inf.",
        "Always doing the good things for the good people.",
        "Really always knows everything about what is going on.",
        "Who needs personality when you have brands.",
        "Believes even a person can become a product.",
        "My soul was sold with discount vouchers.",
        "Believes that there is still room for more pictures of food.",
        "Prove that freeloading can be a profession.",
        "Teaches balloon folding to self abusers.",
        "Free range ranger for sacrificial animals.",
        "Paints life-size boogie man in children's bedroom closets.",
        "On-sight plastic surgeon for fashion shows.",
        "Fred Kazinsky the e-mail bomber.",
        "Teaches flamboyant shuffling techniques to dull blackjack dealers.",
        "Sauerkraut unraveler.",
      ];
      List<String> businessDefaults = [
        "The best in town.",
        "We know our product, because we made it.",
        "Everything you expect and more.",
        "You will be lovin' it.",
      ];
      switch (account.accountType) {
        case AccountType.influencer:
          accountDescription =
              influencerDefaults[random.nextInt(influencerDefaults.length)];
          break;
        case AccountType.business:
          accountDescription =
              businessDefaults[random.nextInt(businessDefaults.length)];
          break;
        case AccountType.support:
          accountDescription = "Support Staff";
          break;
        default:
          accountDescription = "";
          break;
      }
    }

    // Set empty location names to account name
    for (DataLocation location in locations) {
      if (location.name == null || location.name.isEmpty) {
        location.name = accountName;
      }
    }

    // One more check
    if (account.accountId != 0) {
      devLog.info("Skip create account, already has one");
      return;
    }

    // Create account if sufficient data was received
    channel.replyExtend(message);
    await lock.synchronized(() async {
      // Count the number of connected authentication mechanisms
      int connectedNb = 0;
      for (DataSocialMedia socialMedia in account.socialMedia.values) {
        if (socialMedia.connected) ++connectedNb;
      }

      // Validate that the current state is sufficient to create an account
      if (account.accountId == 0 &&
          account.accountType != AccountType.unknown &&
          connectedNb > 0) {
        // Changes sent in a single SQL transaction for reliability
        try {
          // Process the account creation
          channel.replyExtend(message);
          await accountDb.startTransaction((sqljocky.Transaction tx) async {
            if (account.accountId != 0) {
              throw Exception(
                  "Race condition, account already created, not an issue");
            }
            // 1. Create the account entries
            // 2. Update session to LAST_INSERT_ID(), ensure that a row was modified, otherwise rollback (account already created)
            // 3. Update all session authentication connections to LAST_INSERT_ID()
            // 4. Create the location entries, in reverse (latest one always on top)
            // 5. Update account to first (last added) location with LAST_INSERT_ID()
            // 1.
            // TODO: Add notify flags field to SQL
            channel.replyExtend(message);
            GlobalAccountState globalAccountState;
            GlobalAccountStateReason globalAccountStateReason;
            // Initial approval state for accounts is defined here
            switch (account.accountType) {
              case AccountType.business:
              case AccountType.influencer:
                // globalAccountState = GlobalAccountState.readOnly;
                // globalAccountStateReason = GlobalAccountStateReason.GASR_PENDING;
                globalAccountState = GlobalAccountState.readWrite;
                globalAccountStateReason =
                    GlobalAccountStateReason.demoApproved;
                break;
              case AccountType.support:
                globalAccountState = GlobalAccountState.blocked;
                globalAccountStateReason = GlobalAccountStateReason.pending;
                break;
              default:
                opsLog.severe(
                    "Attempt to create account with invalid account type ${account.accountType} by session ${account.sessionId}");
                throw Exception(
                    "Attempt to create account with invalid account type");
            }
            sqljocky.Results res1 = await tx.prepareExecute(
                "INSERT INTO `accounts`("
                "`name`, `account_type`, "
                "`global_account_state`, `global_account_state_reason`, "
                "`description`, `website`, `email`" // avatarUrl is set later
                ") VALUES (?, ?, ?, ?, ?, ?, ?)",
                <dynamic>[
                  accountName.toString(),
                  account.accountType.value.toInt(),
                  globalAccountState.value.toInt(),
                  globalAccountStateReason.value.toInt(),
                  accountDescription.toString(),
                  accountUrl,
                  accountEmail,
                ]);
            if (res1.affectedRows == 0)
              throw Exception("Account was not inserted");
            int accountId = res1.insertId;
            if (accountId == 0) throw Exception("Invalid accountId");
            // 2.
            channel.replyExtend(message);
            sqljocky.Results res2 = await tx.prepareExecute(
                "UPDATE `sessions` SET `account_id` = LAST_INSERT_ID() "
                "WHERE `session_id` = ? AND `account_id` = 0",
                <dynamic>[account.sessionId]);
            if (res2.affectedRows == 0)
              throw Exception("Device was not updated");
            // 3.
            channel.replyExtend(message);
            sqljocky.Results res3 = await tx.prepareExecute(
                "UPDATE `oauth_connections` SET `account_id` = LAST_INSERT_ID() "
                "WHERE `session_id` = ? AND `account_id` = 0",
                <dynamic>[account.sessionId]);
            if (res3.affectedRows == 0)
              throw Exception("Social media was not updated");
            // 4.
            /* sqljocky.Results lastInsertedId = await tx.query("SELECT LAST_INSERT_ID()");
              int accountId = 0;
              await for (sqljocky.Row row in lastInsertedId) {
                accountId = row[0];
                devLog.info("Inserted account_id $accountId");
              }
              if (accountId == 0) throw Exception("Invalid accountId"); */
            for (DataLocation location in locations.reversed) {
              channel.replyExtend(message);
              sqljocky.Results res4 = await tx.prepareExecute(
                  "INSERT INTO `locations`("
                  "`account_id`, `name`, `detail`, `approximate`, "
                  "`postcode`, `region_code`, `country_code`, "
                  "`latitude`, `longitude`, `s2cell_id`, `geohash`) "
                  "VALUES ("
                  "?, ?, ?, ?, "
                  "?, ?, ?, "
                  "?, ?, ?, ?"
                  ")",
                  <dynamic>[
                    accountId,
                    location.name.toString(),
                    location.detail.toString(),
                    location.approximate.toString(),
                    location.postcode == null
                        ? null
                        : location.postcode.toString(),
                    location.regionCode.toString(),
                    location.countryCode.toString(),
                    location.latitude,
                    location.longitude,
                    location.s2cellId,
                    location.geohash
                  ]);
              if (res4.affectedRows == 0)
                throw Exception("Location was not inserted");
              devLog.finest("Inserted location");
            }
            devLog.finest("Inserted locations");
            // 5.
            channel.replyExtend(message);
            sqljocky.Results res5 = await tx.prepareExecute(
                "UPDATE `accounts` SET `location_id` = LAST_INSERT_ID() "
                "WHERE `account_id` = ?",
                <dynamic>[accountId]);
            if (res5.affectedRows == 0)
              throw Exception("Account was not updated with location");
            devLog.fine("Finished setting up account $accountId");
            await tx.commit();
          });
        } catch (error, stackTrace) {
          opsLog.severe(
              "Failed to create account for session ${account.sessionId}",
              error,
              stackTrace);
        }
      }
    });

    // Update state
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

    // Non-critical
    // 1. Download avatar
    // 2. Upload avatar to Spaces
    // 3. Update account to refer to avatar
    try {
      if (account.accountId != 0 &&
          accountAvatarUrl != null &&
          accountAvatarUrl.length > 0) {
        channel.replyExtend(message);
        String avatarKey =
            await downloadUserImage(account.accountId, accountAvatarUrl);
        channel.replyExtend(message);
        await accountDb.prepareExecute(
            "UPDATE `accounts` SET `avatar_key` = ? "
            "WHERE `account_id` = ?",
            <dynamic>[avatarKey.toString(), account.accountId]);
        account.avatarUrl = makeCloudinaryThumbnailUrl(avatarKey);
        account.blurredAvatarUrl = makeCloudinaryBlurredThumbnailUrl(avatarKey);
        account.coverUrls.clear();
        account.coverUrls.add(makeCloudinaryCoverUrl(avatarKey));
        account.blurredCoverUrls.clear();
        account.blurredCoverUrls.add(makeCloudinaryBlurredCoverUrl(avatarKey));
      }
    } catch (error, stackTrace) {
      devLog.severe("Exception downloading avatar '$accountAvatarUrl'", error,
          stackTrace);
    }

    // Send authentication state
    await lock.synchronized(() async {
      // Send all state to user
      await sendAccountUpdate(replying: message, procedureId: 'A_R_CREA');
    });
    if (account.accountId == 0) {
      devLog.severe(
          "Account was not created for session ${account.sessionId}"); // DEVELOPER - DEVELOPMENT CRITICAL
    }
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Access
  /////////////////////////////////////////////////////////////////////

  bool requireGlobalAccountState(GlobalAccountState globalAccountState,
      {TalkMessage replying}) {
    if (account.globalAccountState.value < globalAccountState.value) {
      opsLog.warning(
          "User ${account.accountId} is not authorized for $globalAccountState operations");
      if (replying != null) {
        channel.replyAbort(replying, "Not authorized.");
      }
      return false;
    }
    return true;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Utility
  /////////////////////////////////////////////////////////////////////

  Future<DataLocation> getGeoIPLocation(String ipAddress) async {
    DataLocation location = DataLocation();
    // location.name = ''; // User name
    // location.avatarUrl = ''; // View of the establishment

    // Fetch info
    http.Request request = http.Request(
        'GET',
        config.services.ipstackApi +
            '/' +
            Uri.encodeComponent(ipAddress) +
            '?access_key=' +
            config.services.ipstackKey);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    String body = utf8.decode(builder.toBytes());
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    dynamic doc = json.decode(body);
    if (doc['latitude'] == null || doc['longitude'] == null) {
      throw Exception("No GeoIP information for '$ipAddress'");
    }
    if (doc['country_code'] == null) {
      throw Exception("GeoIP information for '$ipAddress' not in a country");
    }

    // Not very localized, but works for US
    String approximate =
        ''; // "${doc['city']}, ${doc['region_name']} ${doc['zip']}";
    if (doc['city'] != null && doc['city'] != 'Singapore') {
      approximate = doc['city'];
    }
    if (doc['region_name'] != null) {
      if (approximate.length > 0) {
        approximate = approximate + ', ';
      }
      approximate = approximate + doc['region_name'];
      if (doc['zip'] != null) {
        approximate = approximate + ' ' + doc['zip'];
      }
    }
    if (approximate.length == 0 || doc['country_code'].toLowerCase() != 'us') {
      if (doc['country_name'] != null) {
        if (approximate.length > 0) {
          approximate = approximate + ', ';
        }
        approximate = approximate + doc['country_name'];
      }
    }
    if (approximate.length == 0) {
      throw Exception("Insufficient GeoIP information for '$ipAddress'");
    }
    location.approximate = approximate;
    location.detail = approximate;
    if (doc['zip'] != null) location.postcode = doc['zip'];
    if (doc['region_code'] != null)
      location.regionCode = doc['region_code'];
    else
      location.regionCode = doc['country_code'].toLowerCase();
    location.countryCode = doc['country_code'].toLowerCase();
    location.latitude = doc['latitude'];
    location.longitude = doc['longitude'];
    location.s2cellId = Int64(new S2CellId.fromLatLng(
            S2LatLng.fromDegrees(location.latitude, location.longitude))
        .id);
    location.geohash =
        Geohash.encode(location.latitude, location.longitude, codeLength: 20);
    return location;
  }

  Future<DataLocation> getGeocodingFromGPS(
      double latitude, double longitude) async {
    // /geocoding/v5/{mode}/{longitude},{latitude}.json
    // /geocoding/v5/{mode}/{query}.json
    String url = "${config.services.mapboxApi}/geocoding/v5/"
        "mapbox.places/$longitude,$latitude.json?"
        "access_token=${config.services.mapboxToken}";

    // Fetch info
    http.Request request = http.Request('GET', url);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    String body = utf8.decode(builder.toBytes());
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    dynamic doc = json.decode(body);
    if (doc['query'] == null ||
        doc['query'][0] == null ||
        doc['query'][1] == null) {
      throw Exception("No geocoding information for '$longitude,$latitude'");
    }
    dynamic features = doc['features'];
    if (features == null || features.length == 0) {
      throw Exception("No geocoding features at '$longitude,$latitude'");
    }

    // detailed place_type may be:
    // - address
    // for user search, may get detailed place as well from:
    // - poi.landmark
    // - poi
    // approximate place_type may be:
    // - neighborhood (downtown)
    // - (postcode (los angeles, not as user friendly) (skip))
    // - place (los angeles)
    // - region (california)
    // - country (us)
    // get the name from place_name
    // strip ", country text" (under context->id starting with country, text)
    // don't let the user change approximate address, just the detail one
    dynamic featureDetail;
    dynamic featureApproximate;
    dynamic featureRegion;
    dynamic featurePostcode;
    dynamic featureCountry;
    // List<String>().any((String v) => [ "address", "poi.landmark", "poi" ].contains(v));
    for (dynamic feature in features) {
      dynamic placeType = feature['place_type'];
      if (featureDetail == null &&
          placeType.any((dynamic v) => const ["address", "poi.landmark", "poi"]
              .contains(v.toString()))) {
        featureDetail = feature;
      } else if (featureApproximate == null &&
          placeType.any((dynamic v) => const [
                "locality",
                "neighborhood",
                "place"
              ].contains(v.toString()))) {
        featureApproximate = feature;
      } else if (featureRegion == null &&
          placeType
              .any((dynamic v) => const ["region"].contains(v.toString()))) {
        featureRegion = feature;
      } else if (featurePostcode == null &&
          placeType
              .any((dynamic v) => const ["postcode"].contains(v.toString()))) {
        featurePostcode = feature;
      } else if (featureCountry == null &&
          placeType
              .any((dynamic v) => const ["country"].contains(v.toString()))) {
        featureCountry = feature;
      }
    }
    if (featureCountry == null) {
      throw Exception("Geocoding not in a country at '$longitude,$latitude'");
    }
    if (featureRegion == null) {
      featureRegion = featureCountry;
    }
    if (featureApproximate == null) {
      featureApproximate = featureRegion;
    }
    if (featureDetail == null) {
      featureDetail = featureApproximate;
    }

    // Entry
    final String country = featureCountry['text'];
    final DataLocation location = DataLocation();
    location.approximate =
        featureApproximate['place_name'].replaceAll(', United States', '');
    location.detail =
        featureDetail['place_name'].replaceAll(', United States', '');
    if (featurePostcode != null) {
      location.postcode = featurePostcode['text'];
    }
    final String regionCode = featureRegion['properties']['short_code'];
    if (regionCode != null) {
      location.regionCode = regionCode;
    }
    final String countryCode = featureCountry['properties']['short_code'];
    if (countryCode != null) {
      location.countryCode = countryCode;
    }
    location.latitude = latitude;
    location.longitude = longitude;
    location.s2cellId = Int64(new S2CellId.fromLatLng(
            S2LatLng.fromDegrees(location.latitude, location.longitude))
        .id);
    location.geohash =
        Geohash.encode(location.latitude, location.longitude, codeLength: 20);
    return location;
  }

  Future<DataLocation> getGeocodingFromName(String name) async {
    // /geocoding/v5/{mode}/{longitude},{latitude}.json
    // /geocoding/v5/{mode}/{query}.json
    String url = "${config.services.mapboxApi}/geocoding/v5/"
        "mapbox.places/${Uri.encodeComponent(name)}.json?"
        "access_token=${config.services.mapboxToken}";

    // Fetch info
    http.Request request = http.Request('GET', url);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    String body = utf8.decode(builder.toBytes());
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    dynamic doc = json.decode(body);
    if (doc['query'] == null ||
        doc['query'][0] == null ||
        doc['query'][1] == null) {
      throw Exception("No geocoding information for '$name'");
    }
    dynamic features = doc['features'];
    if (features == null || features.length == 0) {
      throw Exception("No geocoding features at '$name'");
    }

    // detailed place_type may be:
    // - address
    // for user search, may get detailed place as well from:
    // - poi.landmark
    // - poi
    // approximate place_type may be:
    // - neighborhood (downtown)
    // - (postcode (los angeles, not as user friendly) (skip))
    // - place (los angeles)
    // - region (california)
    // - country (us)
    // get the name from place_name
    // strip ", country text" (under context->id starting with country, text)
    // don't let the user change approximate address, just the detail one
    dynamic featureDetail;
    dynamic featureApproximate;
    dynamic featureRegion;
    dynamic featurePostcode;
    dynamic featureCountry;
    // List<String>().any((String v) => [ "address", "poi.landmark", "poi" ].contains(v));
    for (dynamic feature in features) {
      dynamic placeType = feature['place_type'];
      if (featureDetail == null &&
          placeType.any((dynamic v) => const ["address", "poi.landmark", "poi"]
              .contains(v.toString()))) {
        featureDetail = feature;
      } else if (featureApproximate == null &&
          placeType.any((dynamic v) => const [
                "locality",
                "neighborhood",
                "place"
              ].contains(v.toString()))) {
        featureApproximate = feature;
      } else if (featureRegion == null &&
          placeType
              .any((dynamic v) => const ["region"].contains(v.toString()))) {
        featureRegion = feature;
      } else if (featurePostcode == null &&
          placeType
              .any((dynamic v) => const ["postcode"].contains(v.toString()))) {
        featurePostcode = feature;
      } else if (featureCountry == null &&
          placeType
              .any((dynamic v) => const ["country"].contains(v.toString()))) {
        featureCountry = feature;
      }
    }

    if (featureApproximate == null) {
      featureApproximate = featureRegion;
    }
    featureDetail = featureApproximate; // Override

    if (featureDetail == null) {
      throw Exception("No approximate geocoding found at '$name'");
    }

    dynamic contextPostcode;
    dynamic contextRegion;
    dynamic contextCountry;
    if (featureCountry == null) {
      for (dynamic context in featureDetail['context']) {
        if (contextPostcode == null &&
            context['id'].toString().startsWith('postcode.')) {
          contextPostcode = context;
        } else if (contextCountry == null &&
            context['id'].toString().startsWith('country.')) {
          contextCountry = context;
        } else if (contextRegion == null &&
            context['id'].toString().startsWith('region.')) {
          contextRegion = context;
        }
      }
    }

    if (contextRegion == null) {
      contextRegion = contextCountry;
    }

    if (contextCountry == null && featureCountry == null) {
      throw Exception("Geocoding not in a country at '$name'");
    }

    // Entry
    String country = featureCountry == null
        ? contextCountry['text']
        : featureCountry['text'];
    DataLocation location = DataLocation();
    location.approximate =
        featureApproximate['place_name'].replaceAll(', United States', '');
    location.detail =
        featureDetail['place_name'].replaceAll(', United States', '');
    if (contextPostcode != null)
      location.postcode = contextPostcode['text'];
    else if (featurePostcode != null)
      location.postcode = featurePostcode['text'];

    final String regionCode = featureRegion == null
        ? contextRegion['short_code']
        : featureRegion['properties']['short_code'];
    if (regionCode != null) {
      location.regionCode = regionCode;
    }
    final String countryCode = featureCountry == null
        ? contextCountry['short_code']
        : featureCountry['properties']['short_code'];
    if (countryCode != null) {
      location.countryCode = countryCode;
    }
    location.latitude = featureDetail['center'][1];
    location.longitude = featureDetail['center'][0];
    location.s2cellId = Int64(S2CellId.fromLatLng(
            S2LatLng.fromDegrees(location.latitude, location.longitude))
        .id);
    location.geohash =
        Geohash.encode(location.latitude, location.longitude, codeLength: 20);
    return location;
  }

  Future<Uint8List> downloadData(String url) async {
    final Uri uri = Uri.parse(url);
    devLog.fine(uri);
    devLog.fine(uri.host);
    final http.Request request = http.Request('GET', uri);
    final http.Response response = await httpClient.send(request);
    final BytesBuilder builder = BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    Uint8List body = builder.toBytes();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.reasonPhrase);
    }
    return body;
  }

  /// Downloads user image, returns key
  Future<String> downloadUserImage(Int64 accountId, String url) async {
    // Fetch image to memory
    Uri uri = Uri.parse(url);
    /*
    http.Request request = http.Request('GET', uri);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    Uint8List body = builder.toBytes();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.reasonPhrase);
    }*/
    Uint8List body = await downloadData(url);

    // Get mime type
    String contentType = MimeTypeResolver().lookup(url, headerBytes: body);
    if (contentType == null) {
      contentType = 'application/octet-stream';
      devLog.severe("Image '$url' does not have a detectable MIME type");
    }

    // Get hash and generate filename
    String uriExt;
    switch (contentType) {
      case 'image/jpeg':
        uriExt = 'jpg';
        break;
      case 'image/png':
        uriExt = 'png';
        break;
      case 'image/gif':
        uriExt = 'gif';
        break;
      case 'image/webp':
        uriExt = 'webp';
        break;
      case 'image/heif':
        uriExt = 'heif';
        break;
      default:
        {
          int lastIndex = uri.path.lastIndexOf('.');
          uriExt = lastIndex > 0
              ? uri.path.substring(lastIndex + 1).toLowerCase()
              : 'jpg';
        }
    }

    Digest contentSha256 = sha256.convert(body);
    String key =
        "${config.services.domain}/user/$accountId/$contentSha256.$uriExt";
    bucket.uploadData(key, body, contentType, dospace.Permissions.public,
        contentSha256: contentSha256);
    return key;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // App
  /////////////////////////////////////////////////////////////////////

  /// Transitions the user to the app context after registration or login succeeds. Call from lock
  Future<void> transitionToApp() async {
    if (_apiChannelBusiness != null || _apiChannelInfluencer != null) {
      await channel.close();
      throw Exception(
          "Cannot transition twice, forced connection to close due to potential issue");
    }
    assert(_apiChannelBusiness == null);
    assert(_apiChannelInfluencer == null);
    assert(account.sessionId != null);
    assert(account.accountId != 0);
    // TODO: Permit app transactions!
    // TODO: Fetch social media from SQL and then from remote hosts!
    devLog.fine(
        "Transition session ${account.sessionId} to app ${account.accountType}");
    if (account.globalAccountState.value > GlobalAccountState.blocked.value) {
      registerProcedure(
          'SFIREBAT', GlobalAccountState.blocked, _netSetFirebaseToken);
      subscribeOAuth();
      subscribeUpload();
      subscribeCommon();
      if (account.accountType == AccountType.business) {
        subscribeBusiness();
      } else if (account.accountType == AccountType.influencer) {
        subscribeInfluencer();
      }
      bc.accountConnected(this);
    }
  }

  Future<DataOffer> getOffer(Int64 offerId) async {
    return await apiChannelOffer.getOffer(offerId);
  }

  Future<DataProposal> getProposal(Int64 proposalId) async {
    return await apiChannelProposal.getProposal(proposalId);
  }

  /// Dirty proposal push, use in case of trouble
  Future<void> pushProposal(Int64 proposalId) async {
    return await apiChannelProposal.pushProposal(proposalId);
  }
}

/*

Example GeoJSON:

{
  "ip": "49.145.22.242",
  "type": "ipv4",
  "continent_code": "AS",
  "continent_name": "Asia",
  "country_code": "PH",
  "country_name": "Philippines",
  "region_code": "05",
  "region_name": "Bicol",
  "city": "Lagonoy",
  "zip": "4425",
  "latitude": 13.7386,
  "longitude": 123.5206,
  "location": {
    "geoname_id": 1708078,
    "capital": "Manila",
    "languages": [
      {
        "code": "en",
        "name": "English",
        "native": "English"
      }
    ],
    "country_flag": "http://assets.ipstack.com/flags/ph.svg",
    "country_flag_emoji": "🇵🇭",
    "country_flag_emoji_unicode": "U+1F1F5 U+1F1ED",
    "calling_code": "63",
    "is_eu": false
  }
}


*/

/* end of file */
