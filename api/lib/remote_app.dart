/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:wstalk/wstalk.dart';
// import 'package:crypto/crypto.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;
import 'package:http_client/console.dart' as http;
import 'package:synchronized/synchronized.dart';

import 'inf.pb.dart';
import 'remote_app_oauth.dart';

// TODO: Move sql queries into a separate shared class, to allow prepared statements, and simplify code here

class RemoteApp {
  bool _connected = true;

  final ConfigData config;
  final sqljocky.ConnectionPool sql;
  final TalkSocket ts;

  final String ipAddress;

  final random = new Random.secure();

  /// Lock anytime making changes to the account state
  final lock = new Lock();

  /*
  int account.state.deviceId;
  AccountType account.state.accountType;
  int account.state.accountId;

  GlobalAccountState globalAccountState;
  GlobalAccountStateReason globalAccountStateReason;
  */

  DataAccount account;

  /*
  DataAccountState account.state = new DataAccountState();

  int addressId;

  List<DataSocialMedia> socialMedia; // TODO: Proper length from configuration
  */

  static final Logger opsLog = new Logger('InfOps.RemoteApp');
  static final Logger devLog = new Logger('InfDev.RemoteApp');

  final http.Client httpClient = new http.ConsoleClient();

  RemoteAppOAuth _remoteAppOAuth;
  dynamic _remoteAppBusiness;
  dynamic _remoteAppInfluencer;
  dynamic _remoteAppCommon;

  RemoteApp(this.config, this.sql, this.ts, { 
    @required this.ipAddress }) {
    devLog.fine("New connection");

    account = new DataAccount();
    account.state = new DataAccountState();
    account.summary = new DataAccountSummary();
    account.detail = new DataAccountDetail();

    account.detail.socialMedia.length = 0;
    for (int i = 0; i < config.oauthProviders.all.length; ++i) {
      account.detail.socialMedia.add(new DataSocialMedia());
    }

    subscribeAuthentication();
  }

  void dispose() {
    _connected = false;
    unsubscribeAuthentication();
    unsubscribeOnboarding();
    if (_remoteAppOAuth != null) {
      _remoteAppOAuth.dispose();
      _remoteAppOAuth = null;
    }
    devLog.fine("Connection closed for device ${account.state.deviceId}");
  }

  StreamSubscription<TalkMessage> safeListen(String id, Future<void> onData(TalkMessage message)) {
    if (_connected) {
      return ts.stream(TalkSocket.encode(id)).listen((TalkMessage message) async {
        try {
          await onData(message);
        } catch (ex) {
          devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
        }
      });
    }
    return null;
  }

  void subscribeOAuth() {
    if (_remoteAppOAuth == null) {
      _remoteAppOAuth = new RemoteAppOAuth(this);
    }
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Authentication messages
  /////////////////////////////////////////////////////////////////////
  
  void subscribeAuthentication() {
    try {
      _netDeviceAuthCreateReq = ts.stream(TalkSocket.encode("DA_CREAT")).listen(netDeviceAuthCreateReq);
      _netDeviceAuthChallengeReq = ts.stream(TalkSocket.encode("DA_CHALL")).listen(netDeviceAuthChallengeReq);
    } catch (e) {
      devLog.warning("Failed to subscribe to Authentication: $e");
    }
  }

  void unsubscribeAuthentication() {
    if (_netDeviceAuthCreateReq == null) {
      return;
    }
    _netDeviceAuthCreateReq.cancel(); _netDeviceAuthCreateReq = null;
    _netDeviceAuthChallengeReq.cancel(); _netDeviceAuthChallengeReq = null;
  }

  StreamSubscription<TalkMessage> _netDeviceAuthCreateReq; // DA_CREAT
  netDeviceAuthCreateReq(TalkMessage message) async {
    try {
      NetDeviceAuthCreateReq pb = new NetDeviceAuthCreateReq();
      pb.mergeFromBuffer(message.data);
      String aesKeyStr = base64.encode(pb.aesKey);
      await lock.synchronized(() async {
          if (account.state.deviceId == 0) { // Create only once 🤨😒
            sqljocky.RetainedConnection connection = await sql.getConnection(); // TODO: Transaction may be nicer than connection, to avoid dead device entries
            try {
              // Create a new device in the devices table of the database
              ts.sendExtend(message);
              await connection.prepareExecute(
                "INSERT INTO `devices` (`aes_key`, `common_device_id`, `name`, `info`) VALUES (?, ?, ?, ?)", 
                [ aesKeyStr, base64.encode(pb.commonDeviceId), pb.name, pb.info ]);
              sqljocky.Results lastInsertedId = await connection.query("SELECT LAST_INSERT_ID()");
              await for (sqljocky.Row row in lastInsertedId) {
                account.state.deviceId = row[0];
                devLog.info("Inserted device_id ${account.state.deviceId} with aes_key '${aesKeyStr}'");
              }
            } catch (ex) {
              devLog.warning("Failed to create device: $ex");
            }
            await connection.release();
          }
          if (account.state.deviceId != 0) {
            unsubscribeAuthentication(); // No longer respond to authentication messages when OK
            subscribeOnboarding();
          }
      });
      devLog.fine("Send auth state ${message.request}");
      await sendNetDeviceAuthState(replying: message);
    } catch (ex) {
      devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
    }
  }

  StreamSubscription<TalkMessage> _netDeviceAuthChallengeReq; // DA_CHALL
  static int _netDeviceAuthChallengeResReq = TalkSocket.encode("DA_R_CHA");
  netDeviceAuthChallengeReq(TalkMessage message) async {
    try {
      // Received authentication request
      NetDeviceAuthChallengeReq pb = new NetDeviceAuthChallengeReq();
      pb.mergeFromBuffer(message.data);
      int attemptDeviceId = pb.deviceId;

      // Send the message with the random challenge
      Uint8List challenge = new Uint8List(256);
      for (int i = 0; i < challenge.length; ++i) {
        challenge[i] = random.nextInt(256);
      }
      NetDeviceAuthChallengeResReq challengePb = new NetDeviceAuthChallengeResReq();
      challengePb.challenge = challenge;
      Future<TalkMessage> signatureMessageFuture = ts.sendRequest(_netDeviceAuthChallengeResReq, challengePb.writeToBuffer(), replying: message);
      
      // Get the pub_key from the device that can be used to decrypt the signed challenge
      sqljocky.Results pubKeyResults = await sql.prepareExecute("SELECT `aes_key` FROM `devices` WHERE `device_id` = ?", [ attemptDeviceId ]);
      Uint8List aesKey;// = base64.decode(input)
      await for (sqljocky.Row row in pubKeyResults) {
        aesKey = base64.decode(row[0].toString());
      }
      if (aesKey.length == 0) {
        devLog.severe("AES key missing for device $attemptDeviceId");
      }

      // Await signature
      devLog.fine("Await signature");
      TalkMessage signatureMessage = await signatureMessageFuture;
      ts.sendExtend(signatureMessage);
      NetDeviceAuthSignatureResReq signaturePb = new NetDeviceAuthSignatureResReq();
      signaturePb.mergeFromBuffer(signatureMessage.data);
      if (aesKey.length > 0 && signaturePb.signature.length > 0) {
        // Verify signature
        var keyParameter = new pointycastle.KeyParameter(aesKey);
        var aesFastEngine = new pointycastle.AESFastEngine();
        aesFastEngine..reset()..init(false, keyParameter);
        var decrypted = new Uint8List(signaturePb.signature.length);
        for (int offset = 0; offset < signaturePb.signature.length;) {
          offset += aesFastEngine.processBlock(signaturePb.signature, offset, decrypted, offset);
        }
        bool equals = true;
        for (int i = 0; i < challenge.length; ++i) {
          if (challenge[i] != decrypted[i]) {
            equals = false;
            break;
          }
        }
        if (equals) {
          // Successfully verified signature
          opsLog.fine("Signature verified succesfully for device $attemptDeviceId");
          await lock.synchronized(() async {
            if (account.state.deviceId == 0) {
              account.state.deviceId = attemptDeviceId;
            }
          });
        } else {
          opsLog.warning("Signature verification failed for device $attemptDeviceId");
        }
      } else if (signaturePb.signature.length == 0) {
        devLog.severe("Signature missing from authentication message for device $attemptDeviceId");
      }

      // Send authentication state
      devLog.fine("Await device state");
      await updateDeviceState(extend: () { ts.sendExtend(signatureMessage); });
      if (account.state.deviceId != 0) {
        unsubscribeAuthentication(); // No longer respond to authentication messages when OK
        if (account.state.accountId != 0) {
          ts.sendExtend(signatureMessage);
          await transitionToApp(); // Fetches all of the state data
        } else {
          subscribeOnboarding();
        }
      }
      await sendNetDeviceAuthState(replying: signatureMessage);
      devLog.fine("Device authenticated");
    } catch (ex) {
      devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
    }
  }

  Future<DataSocialMedia> fetchCachedSocialMedia(String oauthUserId, int oauthProvider) async {
    sqljocky.Results results = await sql.prepareExecute(
      "SELECT `screen_name`, `display_name`, `avatar_url`, `profile_url`, " // 0123
      "`description`, `location`, `url`, `email`, `friends_count`, `followers_count`, " // 456789
      "`following_count`, `posts_count`, `verified` " // 10 11 12
      "FROM `social_media` "
      "WHERE `oauth_user_id` = ? AND `oauth_provider` = ?",
      [ oauthUserId.toString(), oauthProvider.toInt() ]);
    DataSocialMedia dataSocialMedia = new DataSocialMedia();
    await for (sqljocky.Row row in results) { // one row
      if (row[0] != null) dataSocialMedia.screenName = row[0].toString();
      if (row[1] != null) dataSocialMedia.displayName = row[1].toString();
      if (row[2] != null) dataSocialMedia.avatarUrl = row[2].toString();
      if (row[3] != null) dataSocialMedia.profileUrl = row[3].toString();
      if (row[4] != null) dataSocialMedia.description = row[4].toString();
      if (row[5] != null) dataSocialMedia.location = row[5].toString();
      if (row[6] != null) dataSocialMedia.url = row[6].toString();
      if (row[7] != null) dataSocialMedia.email = row[7].toString();
      dataSocialMedia.friendsCount = row[8].toInt();
      dataSocialMedia.followersCount = row[9].toInt();
      dataSocialMedia.followingCount = row[10].toInt();
      dataSocialMedia.postsCount = row[11].toInt();
      dataSocialMedia.verified = row[12].toInt() != 0;
      dataSocialMedia.connected = true;
      devLog.finest("fetchCachedSocialMedia: $dataSocialMedia");
    }
    return dataSocialMedia;
  }

  Future<Null> updateDeviceState({ Function() extend }) async {
    if (account.state.deviceId == 0) {
      devLog.severe("Invalid attempt to update device state with no device id, skip, this is a bug");
      return;
    }
    await lock.synchronized(() async {
      // First get the account id (and account type, in case the account id has not been created yet)
      if (extend != null) extend();
      sqljocky.Results deviceResults = await sql.prepareExecute("SELECT `account_id`, `account_type` FROM `devices` WHERE `device_id` = ?", [ account.state.deviceId.toInt() ]);
      await for (sqljocky.Row row in deviceResults) { // one row
        if (account.state.accountId != 0 && account.state.accountId != row[0].toInt()) {
          devLog.severe("Device account id changed, ignore, this is a bug, this should never happen");
        }
        account.state.accountId = row[0].toInt();
        account.state.accountType = AccountType.valueOf(row[1].toInt());
      }
      // Fetch account-specific info (overwrites device accountType, although it cannot possibly be different)
      if (account.state.accountId != 0) {
        // TODO
      }
      // Find all connected social media accounts
      if (extend != null) extend();
      List<bool> connectedProviders = new List<bool>(account.detail.socialMedia.length);
      sqljocky.Results connectionResults = await sql.prepareExecute( // The additional `account_id` = 0 here is required in order not to load halfway failed connected devices
        "SELECT `oauth_user_id`, `oauth_provider`, `oauth_token_expires`, `expired` FROM `oauth_connections` WHERE ${account.state.accountId == 0 ? '`account_id` = 0 AND `device_id`' : '`account_id`'} = ?", 
        [ account.state.accountId == 0 ? account.state.deviceId.toInt() : account.state.accountId.toInt() ]);
      List<sqljocky.Row> connectionRows = await connectionResults.toList(); // Load to avoid blocking connections recursively
      for (sqljocky.Row row in connectionRows) {
        String oauthUserId = row[0].toString();
        int oauthProvider = row[1].toInt();
        int oauthTokenExpires = row[2].toInt();
        bool expired = row[3].toInt() != 0 || oauthTokenExpires >= (new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
        if (oauthProvider < account.detail.socialMedia.length) {
          account.detail.socialMedia[oauthProvider] = await fetchCachedSocialMedia(oauthUserId, oauthProvider);
          account.detail.socialMedia[oauthProvider].expired = expired;
          connectedProviders[oauthProvider] = account.detail.socialMedia[oauthProvider].connected;
        } else {
          devLog.severe("Invalid attempt to update device state with no device id, skip, this indicates an incorrent database entry caused by a bug");
        }
      }
      // Wipe any lost accounts
      for (int i = 0; i < account.detail.socialMedia.length; ++i) {
        if (!connectedProviders[i] && account.detail.socialMedia[i].connected) {
          account.detail.socialMedia[i] = new DataSocialMedia(); // Wipe
        }
      }
    });
  }

  static int _netDeviceAuthState = TalkSocket.encode("DA_STATE");
  Future<Null> sendNetDeviceAuthState({ TalkMessage replying }) async {
    if (!_connected) {
      return;
    }
    await lock.synchronized(() async {
      NetDeviceAuthState pb = new NetDeviceAuthState();
      pb.data = account;
      ts.sendMessage(_netDeviceAuthState, pb.writeToBuffer(), replying: replying);
    });
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Onboarding messages
  /////////////////////////////////////////////////////////////////////
  
  void subscribeOnboarding() {
    try {
      _netSetAccountType = ts.stream(TalkSocket.encode("A_SETTYP")).listen(netSetAccountType);
      // _netOAuthConnectReq = ts.stream(TalkSocket.encode("OA_CONNE")).listen(netOAuthConnectReq);
      _netAccountCreateReq = ts.stream(TalkSocket.encode("A_CREATE")).listen(netAccountCreateReq);
      subscribeOAuth();
    } catch (e) {
      devLog.warning("Failed to subscribe to Onboarding: $e");
    }
  }

  void unsubscribeOnboarding() {
    if (_netSetAccountType == null) {
      return;
    }
    _netSetAccountType.cancel(); _netSetAccountType = null;
    // _netOAuthConnectReq.cancel(); _netOAuthConnectReq = null;
    _netAccountCreateReq.cancel(); _netAccountCreateReq = null;
  }

  StreamSubscription<TalkMessage> _netSetAccountType; // A_SETTYP
  netSetAccountType(TalkMessage message) async {
    assert(account.state.deviceId != 0);
    try {
      // Received account type change request
      NetSetAccountType pb = new NetSetAccountType();
      pb.mergeFromBuffer(message.data);
      devLog.finest("NetSetAccountType ${pb.accountType}");

      bool update = false;
      await lock.synchronized(() async {
        if (pb.accountType == account.state.accountType) {
          devLog.finest("no-op");
          return; // no-op, may ignore
        }
        if (account.state.accountId != 0) {
          devLog.finest("no-op");
          return; // no-op, may ignore
        }
        update = true;
        try {
          await sql.startTransaction((sqljocky.Transaction tx) async {
            await tx.prepareExecute("DELETE FROM `oauth_connections` WHERE `device_id` = ? AND `account_id` = 0", [ account.state.deviceId ]);
            await tx.prepareExecute("UPDATE `devices` SET `account_type` = ? WHERE `device_id` = ? AND `account_id` = 0", [ pb.accountType.value, account.state.deviceId]);
            await tx.commit();
          });
        } catch (ex) {
          devLog.severe("Failed to change account type: $ex");
        }
      });

      // Send authentication state
      if (update) {
        devLog.finest("Send authentication state, account type is ${account.state.accountType} (set ${pb.accountType})");
        await updateDeviceState();
        await sendNetDeviceAuthState();
        devLog.finest("Account type is now ${account.state.accountType} (set ${pb.accountType})");
      }
    } catch (ex) {
      devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
    }
  }
/*
  StreamSubscription<TalkMessage> _netOAuthConnectReq; // OA_CONNE
  static int _netOAuthConnectRes = TalkSocket.encode("OA_R_CON");
  netOAuthConnectReq(TalkMessage message) async { // response: NetOAuthConnectRes
    assert(account.state.deviceId != 0);
    try {
      // Received oauth connection request
      NetOAuthConnectReq pb = new NetOAuthConnectReq();
      pb.mergeFromBuffer(message.data);

      if (pb.oauthProvider >= socialMedia.length) {
        devLog.severe("Invalid OAuth provider specified by device ${account.state.deviceId}"); // CRITICAL - DEVELOPER (there are critical issues for developer, also critical issues for operations!)
      } else if (account.state.accountType == AccountType.AT_UNKNOWN) {
        devLog.severe("Account type was not yet set by device ${account.state.deviceId}"); // CRITICAL - DEVELOPER
      //} else if (account.state.accountId != 0) {
        // Race condition, the account was already created before receiving this connection request
      //  devLog.fine("OAuth request received but account ${account.state.accountId} already created by ${account.state.deviceId}"); // DEBUG - DEVELOPER
        // TO/DO: Forward to other handling mechanism - can handle this here normally, just less optimal
      } else {
        // First check the OAuth and get the data
        
        / *
        // nbspou
I/chromium(24593): ", source: https://api.twitter.com/oauth/authenticate?oauth_token=nrbd1wAAAAAA5_oKAAABZOP7dpI (0)
I/flutter (24593): Authorization success
I/flutter (24593): Success:
I/flutter (24593): nrbd1wAAAAAA5_oKAAABZOP7dpI
I/flutter (24593): aEekwxXd2hlMNrAFIzpq29FPtBHHyIHY
// ['oauth_token'], uri.queryParameters['oauth_verifier']

  // beyondtcurtain
  https://api.twitter.com/oauth/authenticate?oauth_token=MAAuAAAAAAAA5_oKAAABZOQQItM (0)
,c768 tcontext=u:object_r:system_data_file:s0:c512,c768 tclass=dir permissive=1
I/flutter (26706): Authorization success
I/flutter (26706): Success:
I/flutter (26706): MAAuAAAAAAAA5_oKAAABZOQQItM
I/flutter (26706): Hgpkpp5Fkjh1KWnnD97jOHKiZPl9bpeb
I/flutter (26706): OAuth Providers: 8

/flutter (26706): Authorization success
: https://api.twitter.com/oauth/authenticate?oauth_token=tgaumAAAAAAA5_oKAAABZOQREl8 (0)
I/flutter (26706): Success:
I/flutter (26706): tgaumAAAAAAA5_oKAAABZOQREl8
I/flutter (26706): yyKPvHFCpWLk8nbfRD6oulkjkJYd9wse
I/flutter (26706): OAuth Providers: 8

/flutter (26706): Authorization success
I/flutter (26706): Success:
I/flutter (26706): wwDI0QAAAAAA5_oKAAABZOQYsJc
I/flutter (26706): eTEcxq7n8qjuEEUgJfKedNA2m4qRcPjJ
I/flutter (26706): OAuth Providers: 8

        * /
        






        // Procedure for adding an OAuth connection during onboarding:
        // - Find existing OAuth, if one exists, there are two situations:
        //   - The existing OAuth has no account attached - this implies the user aborted onboarding previously and switched device (unusual)
        //   - The existing OAuth has an account (this is easiest!)
        // - If one does not exist, just create it, easy!
        String oauthUserId;
        int oauthProvider;
        String username = "nbspou";
        String displayName = "NO-BREAK SPACE OÜ";
        int followers = 37;
        int following = 11;
        try {
          await sql.prepareExecute("INSERT INTO `oauth_connections`("
            "`oauth_user_id`, `oauth_provider`, `account_type`, `account_id`, `device_id`, `username`, `display_name`, `followers`, `following`"
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", [ oauthUserId, oauthProvider, account.state.accountType.value,
            account.state.accountId, account.state.deviceId, username, displayName, followers, following ]);
        } catch (ex) {
          devLog.info("Failed to insert OAuth, may already be inserted!");
        }
        sqljocky.Results selectOAuth = await sql.prepareExecute("SELECT `account_id`, `device_id` FROM `oauth_connections`"
          "WHERE `oauth_user_id` = ?, `oauth_provider` = ?, `account_type` = ?", [ oauthUserId, oauthProvider, account.state.accountType.value ]);
        int oauthAccountId;
        int oauthDeviceId;
        await for (sqljocky.Row row in selectOAuth) {
          oauthAccountId = row[0];
          oauthDeviceId = row[1];
        }
        if (oauthAccountId != 0 || oauthAccountId != 0)
        {
          await lock.synchronized(() async {
            // Decide what to do
          });
        } else {
          opsLog.severe("Failed to insert or retrieve OAuth ($oauthUserId, $oauthProvider, ${account.state.accountType}), database may have connection issues");
        }
      }

      NetOAuthConnectRes resPb = new NetOAuthConnectRes();
      if (pb.oauthProvider < socialMedia.length) {
        resPb.socialMedia = socialMedia[pb.oauthProvider];
      }
      ts.sendMessage(_netOAuthConnectRes, resPb.writeToBuffer(), replying: message);

      if (account.state.accountId != 0) {
        // The OAuth has an account attached, let's go!
        unsubscribeOnboarding();
        await updateDeviceState();
        await sendNetDeviceAuthState();
      }
    } catch (ex) {
      devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
    }
  }*/

  StreamSubscription<TalkMessage> _netAccountCreateReq; // A_CREATE
  netAccountCreateReq(TalkMessage message) async { // response: NetDeviceAuthState
    assert(account.state.deviceId != 0);
    try {
      // Received account creation request
      NetAccountCreateReq pb = new NetAccountCreateReq();
      pb.mergeFromBuffer(message.data);
      devLog.finest("NetAccountCreateReq: $pb");
      devLog.finest("ipAddress: $ipAddress");
      if (account.state.accountId != 0) {
        devLog.info("Skip create account, already has one");
        return;
      }

      const List<int> mediaPriority = const [ 3, 1, 4, 8, 6, 2, 5, 7 ];

      // Attempt to get locations
      // Fetch location info from coordinates
      // Coordinates may exist in either the GPS data or in the user's IP address
      // Alternatively we can reverse one from location names in the user's social media
      List<DataLocation> locations = new List<DataLocation>();
      DataLocation gpsLocationRes;
      Future<DataLocation> gpsLocation;
      if (pb.latitude != null && pb.longitude != null && pb.latitude != 0.0 && pb.longitude != 0.0) {
        gpsLocation = getGeocodingFromGPS(pb.latitude, pb.longitude).then((DataLocation location) {
          devLog.finest("GPS: $location");
          gpsLocationRes = location;
        }).catchError((ex) {
          devLog.severe("GPS Geocoding Exception: $ex");
        });
      }
      DataLocation geoIPLocationRes;
      Future<DataLocation> geoIPLocation = getGeoIPLocation(ipAddress).then((DataLocation location) {
        devLog.finest("GeoIP: $location");
        geoIPLocationRes = location;
        // locations.add(location);
      }).catchError((ex) {
        devLog.severe("GeoIP Location Exception: $ex");
      });

      // Wait for GPS Geocoding
      // Using await like this doesn't catch exceptions, so required to put handlers in advance -_-
      ts.sendExtend(message);
      if (gpsLocation != null) {
        await gpsLocation;
        if (gpsLocationRes != null) locations.add(gpsLocationRes);
      }

      // Also query all social media locations in the meantime, no particular order
      List<Future<DataLocation>> mediaLocations = new List<Future<DataLocation>>();
      // for (int i = 0; i < account.detail.socialMedia.length; ++i) {
      for (int i in mediaPriority) {
        DataSocialMedia socialMedia = account.detail.socialMedia[i];
        if (socialMedia.connected && socialMedia.location != null && socialMedia.location.isNotEmpty) {
          mediaLocations.add(getGeocodingFromName(socialMedia.location).then((DataLocation location) {
            devLog.finest("${config.oauthProviders.all[i].label}: ${socialMedia.displayName}: $location");
            location.name = socialMedia.displayName;
            locations.add(location);
          }).catchError((ex) {
            devLog.severe("${config.oauthProviders.all[i].label}: Geocoding Exception: $ex");
          }));
        }
      }

      // Wait for all social media
      for (Future<DataLocation> futureLocation in mediaLocations) {
        ts.sendExtend(message);
        await futureLocation;
      }

      // Wait for GeoIP
      await geoIPLocation;
      if (geoIPLocationRes != null) locations.add(geoIPLocationRes);

      // Fallback location
      if (locations.isEmpty) {
        devLog.severe("Using fallback location for account ${account.state.accountId}");
        DataLocation location = new DataLocation();
        location.name = "Los Angeles";
        location.approximate = "Los Angeles, California 90017";
        location.detail = "Los Angeles, California 90017";
        location.postcode = "90017";
        location.regionCode = "US-CA";
        location.countryCode = "US";
        location.latitude = 34.0207305;
        location.longitude = -118.6919159;
        locations.add(location);
      }

      // Build account info
      String accountName;
      String accountScreenName;
      String accountDescription;
      String accountAvatarUrl;
      String accountUrl;
      for (int i in mediaPriority) {
        DataSocialMedia socialMedia = account.detail.socialMedia[i];
        if (socialMedia.connected) {
          if (accountName == null && socialMedia.displayName != null) accountName = socialMedia.displayName;
          if (accountScreenName == null && socialMedia.screenName != null) accountScreenName = socialMedia.screenName;
          if (accountDescription == null && socialMedia.description != null) accountDescription = socialMedia.description;
          if (accountAvatarUrl == null && socialMedia.avatarUrl != null) accountAvatarUrl = socialMedia.avatarUrl;
          if (accountUrl == null && socialMedia.url != null) accountUrl = socialMedia.url;
        }
      }
      if (accountName == null) {
        accountName = accountScreenName;
      }
      if (accountName == null) {
        accountName = "Your Name Here";
      }
      if (accountDescription == null) {
        accountDescription = "";
      }

      // Set empty location names to account name
      for (DataLocation location in locations) {
        if (location.name == null || location.name.isEmpty) {
          location.name = accountName;
        }
      }

      // One more check
      if (account.state.accountId != 0) {
        devLog.info("Skip create account, already has one");
        return;
      }

      // Create account if sufficient data was received
      ts.sendExtend(message);
      await lock.synchronized(() async {
        // Count the number of connected authentication mechanisms
        int connectedNb = 0;
        for (int i = 0; i < account.detail.socialMedia.length; ++i) {
          if (account.detail.socialMedia[i].connected)
            ++connectedNb;
        }

        // Validate that the current state is sufficient to create an account
        if (account.state.accountId == 0
          && account.state.accountType != AccountType.AT_UNKNOWN
          && connectedNb > 0) {
          // Changes sent in a single SQL transaction for reliability
          try {
            // Process the account creation
            ts.sendExtend(message);
            await sql.startTransaction((sqljocky.Transaction tx) async {
              // 1. Create the new account entries
              // tx
              // 2. Update device to LAST_INSERT_ID(), ensure that a row was modified, otherwise rollback (account already created)
              // 3. Update all device authentication connections to LAST_INSERT_ID()
              // 4. Create the new location entries, in reverse (latest one always on top)
              // 5. Update account to first (last added) location with LAST_INSERT_ID()
              await tx.commit();
            });
          } catch (ex) {
            opsLog.severe("Failed to create account: $ex");
          }
        }
      });

      // Update state
      ts.sendExtend(message);
      await updateDeviceState();
      if (account.state.accountId != 0) {
        ts.sendExtend(message);
        unsubscribeOnboarding(); // No longer respond to onboarding messages when OK
        await transitionToApp(); // TODO: Transitions and subs hould be handled by updateDeviceState preferably...
      }
      
      // Non-critical
      // 1. Download avatar
      // 2. Upload avatar to Spaces
      // 3. Update account to refer to avatar

      // Send authentication state
      await sendNetDeviceAuthState(replying: message);
      if (account.state.accountId == 0) {
        devLog.severe("Account was not created for device ${account.state.deviceId}"); // DEVELOPER - DEVELOPMENT CRITICAL
      }

    } catch (ex) {
      devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
    }
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Utility
  /////////////////////////////////////////////////////////////////////
  
  Future<DataLocation> getGeoIPLocation(String ipAddress) async {
    DataLocation location = new DataLocation();
    // location.name = ''; // User name
    // location.avatarUrl = ''; // View of the establishment

    // Fetch info
    http.Request request = new http.Request('GET', 
      config.services.ipstackApi + '/' + Uri.encodeComponent(ipAddress) 
      + '?access_key=' + config.services.ipstackKey);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = new BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    String body = utf8.decode(builder.toBytes());
    if (response.statusCode != 200) {
      throw new Exception(response.reasonPhrase);
    }
    dynamic doc = json.decode(body);
    if (doc['latitude'] == null || doc['longitude'] == null) {
      throw new Exception("No GeoIP information for '$ipAddress'");
    }

    // Not very localized, but works for US
    location.approximate = "${doc['city']}, ${doc['region_name']} ${doc['zip']}";
    location.detail = location.approximate;
    location.postcode = doc['zip'];
    location.regionCode = doc['region_code'];
    location.countryCode = doc['country_code'];
    location.latitude = doc['latitude'];
    location.longitude = doc['longitude'];

    return location;
  }

  Future<DataLocation> getGeocodingFromGPS(double latitude, double longitude) async {
    // /geocoding/v5/{mode}/{longitude},{latitude}.json
    // /geocoding/v5/{mode}/{query}.json
    String url = "${config.services.mapboxApi}/geocoding/v5/"
      "mapbox.places/$longitude,$latitude.json?"
      "access_token=${config.services.mapboxToken}";

    // Fetch info
    http.Request request = new http.Request('GET', url);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = new BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    String body = utf8.decode(builder.toBytes());
    if (response.statusCode != 200) {
      throw new Exception(response.reasonPhrase);
    }
    dynamic doc = json.decode(body);
    if (doc['query'] == null || doc['query'][0] == null || doc['query'][1] == null) {
      throw new Exception("No geocoding information for '$longitude,$latitude'");
    }
    dynamic features = doc['features'];
    if (features == null || features.length == 0) {
      throw new Exception("No geocoding features at '$longitude,$latitude'");
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
    // new List<String>().any((String v) => [ "address", "poi.landmark", "poi" ].contains(v));
    for (dynamic feature in features) {
      dynamic placeType = feature['place_type'];
      if (featureDetail == null && placeType.any((String v) => const [ "address", "poi.landmark", "poi" ].contains(v))) {
        featureDetail = feature;
      } else if (featureApproximate == null && placeType.any((String v) => const [ "locality", "neighborhood", "place" ].contains(v))) {
        featureApproximate = feature;
      } else if (featureRegion == null && placeType.any((String v) => const [ "region" ].contains(v))) {
        featureRegion = feature;
      } else if (featurePostcode == null && placeType.any((String v) => const [ "postcode" ].contains(v))) {
        featurePostcode = feature;
      } else if (featureCountry == null && placeType.any((String v) => const [ "country" ].contains(v))) {
        featureCountry = feature;
      }
    }
    if (featureCountry == null) {
      throw new Exception("Geocoding not in a country at '$longitude,$latitude'");
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
    String country = featureCountry['text'];
    DataLocation location = new DataLocation();
    location.approximate = featureApproximate['place_name'].replaceAll(', United States', '');
    location.detail = featureDetail['place_name'].replaceAll(', United States', '');
    if (featurePostcode != null) location.postcode = featurePostcode['text'];
    location.regionCode = featureRegion['properties']['short_code'];
    location.countryCode = featureCountry['properties']['short_code'];
    location.latitude = latitude;
    location.longitude = longitude;
    return location;
  }

  Future<DataLocation> getGeocodingFromName(String name) async {
    // /geocoding/v5/{mode}/{longitude},{latitude}.json
    // /geocoding/v5/{mode}/{query}.json
    String url = "${config.services.mapboxApi}/geocoding/v5/"
      "mapbox.places/${Uri.encodeComponent(name)}.json?"
      "access_token=${config.services.mapboxToken}";

    // Fetch info
    http.Request request = new http.Request('GET', url);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = new BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    String body = utf8.decode(builder.toBytes());
    if (response.statusCode != 200) {
      throw new Exception(response.reasonPhrase);
    }
    dynamic doc = json.decode(body);
    if (doc['query'] == null || doc['query'][0] == null || doc['query'][1] == null) {
      throw new Exception("No geocoding information for '$name'");
    }
    dynamic features = doc['features'];
    if (features == null || features.length == 0) {
      throw new Exception("No geocoding features at '$name'");
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
    // new List<String>().any((String v) => [ "address", "poi.landmark", "poi" ].contains(v));
    for (dynamic feature in features) {
      dynamic placeType = feature['place_type'];
      if (featureDetail == null && placeType.any((String v) => const [ "address", "poi.landmark", "poi" ].contains(v))) {
        featureDetail = feature;
      } else if (featureApproximate == null && placeType.any((String v) => const [ "locality", "neighborhood", "place" ].contains(v))) {
        featureApproximate = feature;
      } else if (featureRegion == null && placeType.any((String v) => const [ "region" ].contains(v))) {
        featureRegion = feature;
      } else if (featurePostcode == null && placeType.any((String v) => const [ "postcode" ].contains(v))) {
        featurePostcode = feature;
      } else if (featureCountry == null && placeType.any((String v) => const [ "country" ].contains(v))) {
        featureCountry = feature;
      }
    }
    
    if (featureApproximate == null) {
      featureApproximate = featureRegion;
    }
    featureDetail = featureApproximate; // Override

    if (featureDetail == null) {
      throw new Exception("No approximate geocoding found at '$name'");
    }

    dynamic contextPostcode;
    dynamic contextRegion;
    dynamic contextCountry;
    if (featureCountry == null) {
      for (dynamic context in featureDetail['context']) {
        if (contextPostcode == null && context['id'].toString().startsWith('postcode.')) {
          contextPostcode = context;
        } else if (contextCountry == null && context['id'].toString().startsWith('country.')) {
          contextCountry = context;
        } else if (contextRegion == null && context['id'].toString().startsWith('region.')) {
          contextRegion = context;
        } 
      }
    }

    if (contextRegion == null) {
      contextRegion = contextCountry;
    }

    if (contextCountry == null && featureCountry == null) {
      throw new Exception("Geocoding not in a country at '$name'");
    }

    // Entry
    String country = featureCountry == null ? contextCountry['text'] : featureCountry['text'];
    DataLocation location = new DataLocation();
    location.approximate = featureApproximate['place_name'].replaceAll(', United States', '');
    location.detail = featureDetail['place_name'].replaceAll(', United States', '');
    if (contextPostcode != null)location.postcode = contextPostcode['text'];
    else if (featurePostcode != null) location.postcode = featurePostcode['text'];
    location.regionCode = featureRegion == null ? contextRegion['short_code'] : featureRegion['properties']['short_code'];
    location.countryCode = featureCountry == null ? contextCountry['short_code'] : featureCountry['properties']['short_code'];
    location.latitude = featureDetail['center'][1];
    location.longitude = featureDetail['center'][0];
    return location;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // App
  /////////////////////////////////////////////////////////////////////
  
  /// Transitions the user to the app context after registration or login succeeds. Call from lock
  Future<Null> transitionToApp() {
    assert(_netDeviceAuthCreateReq == null);
    assert(_netAccountCreateReq == null);
    assert(_remoteAppBusiness == null);
    assert(_remoteAppInfluencer == null);
    assert(_remoteAppCommon == null);
    assert(account.state.deviceId != null);
    assert(account.state.accountId != 0);
    // TODO: Permit app transactions!
    // TODO: Fetch social media from SQL and then from remote hosts!
    devLog.fine("Transition device ${account.state.deviceId} to app ${account.state.accountType}");
    subscribeOAuth();
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
