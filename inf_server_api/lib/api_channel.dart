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
import 'package:inf_server_api/api_channel_offer.dart';
import 'package:inf_server_api/api_channel_proposal.dart';
import 'package:inf_server_api/api_channel_proposal_transactions.dart';
import 'package:inf_server_api/api_service.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
// import 'package:crypto/crypto.dart';
import 'package:http_client/console.dart' as http;
import 'package:synchronized/synchronized.dart';
import 'package:mime/mime.dart';
import 'package:dospace/dospace.dart' as dospace;
import 'package:s2geometry/s2geometry.dart';

import 'package:inf_common/inf_common.dart';
import 'broadcast_center.dart';
import 'api_channel_profile.dart';
import 'api_channel_haggle_actions.dart';

// TODO: Move sql queries into a separate shared class, to allow prepared statements, and simplify code here

class ApiChannel {
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Onboarding messages
  /////////////////////////////////////////////////////////////////////



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
  // Utility
  /////////////////////////////////////////////////////////////////////



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

}

/* end of file */
