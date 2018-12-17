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

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:geohash/geohash.dart';
import 'package:inf_server_api/api_channel_demo.dart';
import 'package:inf_server_api/api_channel_offer.dart';
import 'package:inf_server_api/api_channel_proposal.dart';
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

  /*
  int account.sessionId;
  AccountType account.accountType;
  int account.accountId;

  GlobalAccountState globalAccountState;
  GlobalAccountStateReason globalAccountStateReason;
  */

  DataAccount account;

  /*
  DataAccountState account.state = DataAccountState();

  int addressId;

  List<DataSocialMedia> socialMedia; // TODO: Proper length from configuration
  */

  static final Logger opsLog = Logger('InfOps.ApiChannel');
  static final Logger devLog = Logger('InfDev.ApiChannel');

  final http.Client httpClient = http.ConsoleClient();
  final Map<String, Function(TalkMessage message)> _procedureHandlers =
      Map<String, Function(TalkMessage message)>();

  ApiChannelOAuth _apiChannelOAuth;
  ApiChannelUpload _apiChannelUpload;
  ApiChannelProfile _apiChannelProfile;
  ApiChannelOffer apiChannelOffer;
  ApiChannelProposal apiChannelProposal;
  ApiChannelDemo apiChannelDemo;
  ApiChannelBusiness _apiChannelBusiness;
  ApiChannelInfluencer _apiChannelInfluencer;

  ApiChannel(this.service, this.channel, Uint8List payload,
      {@required this.ipAddress}) {
    devLog.fine("New connection");
    _initializeListen(payload);
  }

  void _listen() {
    channel.listen((TalkMessage message) async {
      if (_procedureHandlers.containsKey(message.procedureId)) {
        await _procedureHandlers[message.procedureId](message);
      } else {
        try {
          channel.unknownProcedure(message);
        } catch (error, stackTrace) {
          devLog.finest("$error\n$stackTrace");
          await channel.close();
        }
      }
    }, onError: (dynamic error, StackTrace stackTrace) {
      if (error is TalkAbort) {
        devLog.severe("Received abort from api remote: $error\n$stackTrace");
      } else {
        devLog.severe("Unknown error from api remote: $error\n$stackTrace");
      }
    }, onDone: () {
      dispose();
    });
  }

  void dispose() {
    bc.accountDisconnected(this);
    _connected = false;
    unsubscribeOnboarding();
    if (_apiChannelOAuth != null) {
      _apiChannelOAuth.dispose();
      _apiChannelOAuth = null;
    }
    if (_apiChannelUpload != null) {
      _apiChannelUpload.dispose();
      _apiChannelUpload = null;
    }
    if (_apiChannelProfile != null) {
      _apiChannelProfile.dispose();
      _apiChannelProfile = null;
    }
    if (apiChannelOffer != null) {
      apiChannelOffer.dispose();
      apiChannelOffer = null;
    }
    if (apiChannelProposal != null) {
      apiChannelProposal.dispose();
      apiChannelProposal = null;
    }
    if (apiChannelDemo != null) {
      apiChannelDemo.dispose();
      apiChannelDemo = null;
    }
    if (_apiChannelBusiness != null) {
      _apiChannelBusiness.dispose();
      _apiChannelBusiness = null;
    }
    if (_apiChannelInfluencer != null) {
      _apiChannelInfluencer.dispose();
      _apiChannelInfluencer = null;
    }
    _procedureHandlers.clear();
    devLog.fine("Connection closed for session ${account.sessionId}");
  }

  void registerProcedure(
    String procedureId,
    GlobalAccountState requiredAccountState,
    Future<void> procedure(TalkMessage message),
  ) {
    _procedureHandlers[procedureId] = (TalkMessage message) async {
      if (requireGlobalAccountState(requiredAccountState,
          replying: (message.requestId != 0) ? message : null)) {
        try {
          await procedure(message);
        } catch (error, stackTrace) {
          devLog.severe(
              "Unexpected error in procedure '$procedureId': $error\n$stackTrace");
          try {
            if (message.requestId != 0) {
              channel.replyAbort(message, "Unexpected error.");
            }
          } catch (error, stackTrace) {
            devLog.finest("Failed to reply abort: $error\n$stackTrace");
          }
        }
      }
    };
  }

  void unregisterProcedure(String procedureId) {
    _procedureHandlers.remove(procedureId);
  }

  void subscribeOAuth() {
    if (_apiChannelOAuth == null) {
      _apiChannelOAuth = ApiChannelOAuth(this);
    }
  }

  void subscribeUpload() {
    if (_apiChannelUpload == null) {
      _apiChannelUpload = ApiChannelUpload(this);
    }
  }

  void subscribeCommon() {
    if (_apiChannelProfile == null) {
      _apiChannelProfile = ApiChannelProfile(this);
    }
    if (apiChannelOffer == null) {
      apiChannelOffer = ApiChannelOffer(this);
    }
    if (apiChannelProposal == null) {
      apiChannelProposal = ApiChannelProposal(this);
    }
    if (apiChannelDemo == null) {
      apiChannelDemo = ApiChannelDemo(this);
    }
  }

  void subscribeBusiness() {
    if (_apiChannelBusiness == null) {
      _apiChannelBusiness = ApiChannelBusiness(this);
    }
  }

  void subscribeInfluencer() {
    if (_apiChannelInfluencer == null) {
      _apiChannelInfluencer = ApiChannelInfluencer(this);
    }
  }

  Future<void> netPing(TalkMessage message) async {
    channel.replyMessage(message, "PONG", Uint8List(0));
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Session
  /////////////////////////////////////////////////////////////////////

  Future<void> _initializeListen(Uint8List payload) async {
    try {
      await _initializeSession(payload);
    } catch (error, stackTrace) {
      devLog.warning("Initialize session error: $error\n$stackTrace");
    }
    try {
      _listen();
    } catch (error, stackTrace) {
      devLog.warning("Listen error: $error\n$stackTrace");
    }
  }

  Future<void> _initializeSession(Uint8List payload) async {
    registerProcedure("PING", GlobalAccountState.initialize, netPing);

    account = DataAccount();
    account.socialMedia[0] = DataSocialMedia();

    NetSessionPayload sessionPayload = NetSessionPayload()
      ..mergeFromBuffer(payload)
      ..freeze();
    if (sessionPayload.hasSessionId() && sessionPayload.sessionId != 0) {
      // Attempt to connect to a requested session, send session deletion message on failure.
      await _sessionOpen(sessionPayload);
    } else {
      // No session, only permit session creation message.
      await lock.synchronized(() async {
        registerProcedure('SESSIONC', GlobalAccountState.initialize,
            (TalkMessage message) async {
          await _sessionCreate(message, sessionPayload);
        });
      });
    }
  }

  Future<void> _sessionCreate(
      TalkMessage message, NetSessionPayload sessionPayload) async {
    NetSessionCreate create = NetSessionCreate()
      ..mergeFromBuffer(message.data)
      ..freeze();
    NetSession session = NetSession();
    await lock.synchronized(() async {
      if (account.sessionId == 0) {
        // Create a session in the sessions table of the database
        Uint8List cookieHash = Uint8List.fromList(
            sha256.convert(sessionPayload.cookie + config.services.salt).bytes);
        Uint8List deviceHash = Uint8List.fromList(
            sha256.convert(create.deviceToken + config.services.salt).bytes);
        channel.replyExtend(message);
        sqljocky.Results results = await accountDb.prepareExecute(
            "INSERT INTO `sessions` (`cookie_hash`, `device_hash`, `name`, `info`) VALUES (?, ?, ?, ?)",
            <dynamic>[
              cookieHash,
              deviceHash,
              create.deviceName,
              create.deviceInfo
            ]);
        if (results.insertId != null && account.sessionId == 0) {
          account.sessionId = Int64(results.insertId);
          devLog.info(
              "Inserted session_id ${account.sessionId} with cookie_hash '${cookieHash}'");
        }
      }
      if (account.sessionId == 0) {
        channel.replyAbort(message, "Failed to create session.");
        return;
      }
      session.sessionId = account.sessionId;
      channel.replyMessage(message, 'R_SESSIO', session.writeToBuffer());
      if (_procedureHandlers.containsKey('SESSIONC')) {
        unregisterProcedure('SESSIONC');
        subscribeOnboarding();
        subscribeOAuth();
      }
      sendAccountUpdate();
    });
  }

  Future<void> _sessionOpen(NetSessionPayload sessionPayload) async {
    await lock.synchronized(() async {
      if (!sessionPayload.hasSessionId() || sessionPayload.sessionId == 0) {
        throw Exception("Session ID must be set.");
      }
      Uint8List cookieHash = Uint8List.fromList(
          sha256.convert(sessionPayload.cookie + config.services.salt).bytes);
      // Get the pub_key from the session that can be used to decrypt the signed challenge
      sqljocky.Results pubKeyResults = await accountDb.prepareExecute(
          "SELECT `session_id` FROM `sessions` WHERE `session_id` = ? AND `cookie_hash` = ?",
          <dynamic>[sessionPayload.sessionId, cookieHash]);
      Int64 sessionId;
      await for (sqljocky.Row row in pubKeyResults) {
        sessionId = Int64(row[0]);
      }
      if (sessionId != null && sessionId == sessionPayload.sessionId) {
        devLog.fine("Await session state");
        account.sessionId = sessionId;
        await refreshAccount();
        if (account.sessionId != 0) {
          if (account.accountId != 0) {
            await transitionToApp(); // Fetches all of the state data
          } else {
            subscribeOnboarding();
            subscribeOAuth();
          }
          try {
            sendAccountUpdate();
          } catch (error, stackTrace) {
            devLog.warning("Error sending account update: $error\n$stackTrace");
          }
        } else {
          await _sessionRemove();
        }
      } else {
        await _sessionRemove();
      }
    });
  }

  Future<void> _sessionRemove() async {
    NetSessionRemove remove = NetSessionRemove();
    channel.sendMessage('SESREMOV', remove.writeToBuffer());
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Account
  /////////////////////////////////////////////////////////////////////

  Future<DataSocialMedia> fetchCachedSocialMedia(
      String oauthUserId, int oauthProvider) async {
    sqljocky.Results results = await accountDb.prepareExecute(
        "SELECT `screen_name`, `display_name`, `avatar_url`, `profile_url`, " // 0123
        "`description`, `location`, `website`, `email`, `friends_count`, `followers_count`, " // 456789
        "`following_count`, `posts_count`, `verified` " // 10 11 12
        "FROM `social_media` "
        "WHERE `oauth_user_id` = ? AND `oauth_provider` = ?",
        <dynamic>[oauthUserId, oauthProvider]);
    DataSocialMedia dataSocialMedia = DataSocialMedia();
    dataSocialMedia.providerId = oauthProvider;
    await for (sqljocky.Row row in results) {
      // one row
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

  Future<DataLocation> fetchLocationFromSql(
      Int64 locationId, Int64 accountId) async {
    devLog.finest(
        "fetchLocationSummaryFromSql: locationId: $locationId, accountId: $accountId.");
    sqljocky.Results results = await accountDb.prepareExecute(
        "SELECT `name`, `approximate`, `detail`, " // 0 1 2
        "`postcode`, `region_code`, `country_code`, " // 3 4 5
        "`latitude`, `longitude`, `s2cell_id`, geohash " // 6 7 8 9
        "FROM `locations` "
        "WHERE `location_id` = ? AND `account_id` = ?",
        <dynamic>[locationId, accountId]);
    DataLocation location;
    await for (sqljocky.Row row in results) {
      // one row
      location = DataLocation();
      location.locationId = locationId;
      location.name = row[0].toString();
      location.approximate = row[1].toString();
      location.detail = row[2].toString();
      if (row[3] != null) location.postcode = row[3].toString();
      location.regionCode = row[4].toString();
      location.countryCode = row[5].toString();
      location.latitude = row[6].toDouble();
      location.longitude = row[7].toDouble();
      location.s2cellId = Int64(row[8]);
      // TODO: location.geohashInt
      location.geohash = row[9].toString();
      location.freeze();
    }
    return location;
  }

  Future<DataLocation> fetchLocationSummaryFromSql(
      Int64 locationId, Int64 accountId, bool detail) async {
    devLog.finest(
        "fetchLocationSummaryFromSql: locationId: $locationId, accountId: $accountId, detail: $detail.");
    sqljocky.Results results = await accountDb.prepareExecute(
        "SELECT " +
            (detail ? "`detail`" : "`approximate`") +
            ", " // 0 1
            "`latitude`, `longitude` " // 2 3
            "FROM `locations` "
            "WHERE `location_id` = ? AND `account_id` = ?",
        <dynamic>[locationId, accountId]);
    DataLocation location;
    await for (sqljocky.Row row in results) {
      // one row
      location = DataLocation();
      location.locationId = locationId;
      location.approximate = row[0].toString();
      location.detail = location.approximate;
      location.latitude = row[1].toDouble();
      location.longitude = row[2].toDouble();
      location.freeze();
    }
    return location;
  }

  /// May only be called from synchronized block.
  Future<void> refreshAccount({Function() extend}) async {
    if (!_connected) {
      return;
    }
    if (account.sessionId == 0) {
      devLog.severe(
          "Invalid attempt to update session state with no session id, skip, this is a bug");
      return;
    }
    // First get the account id (and account type, in case the account id has not been created yet)
    if (extend != null) extend();
    sqljocky.RetainedConnection connection = await accountDb.getConnection();
    try {
      sqljocky.Results sessionResults = await connection.prepareExecute(
          "SELECT `account_id`, `account_type`, `firebase_token` FROM `sessions` WHERE `session_id` = ?",
          <dynamic>[account.sessionId]);
      await for (sqljocky.Row row in sessionResults) {
        // one row
        if (account.accountId != Int64.ZERO &&
            account.accountId != Int64(row[0])) {
          devLog.severe(
              "Device account id changed, ignore, this is a bug, this should never happen");
        }
        account.accountId = Int64(row[0]);
        account.accountType = AccountType.valueOf(row[1].toInt());
        if (row[2] != null) account.firebaseToken = row[2].toString();
      }
      // Fetch account-specific info (overwrites session accountType, although it cannot possibly be different)
      if (account.accountId != Int64.ZERO) {
        if (extend != null) extend();
        sqljocky.Results accountResults = await connection.prepareExecute(
            "SELECT `name`, `account_type`, `global_account_state`, `global_account_state_reason`, "
            "`description`, `location_id`, `avatar_key`, `website`, `email` FROM `accounts` "
            "WHERE `account_id` = ?",
            <dynamic>[account.accountId]);
        // int locationId;
        await for (sqljocky.Row row in accountResults) {
          // one
          account.name = row[0].toString();
          account.accountType = AccountType.valueOf(row[1].toInt());
          account.globalAccountState =
              GlobalAccountState.valueOf(row[2].toInt());
          account.globalAccountStateReason =
              GlobalAccountStateReason.valueOf(row[3].toInt());
          account.description = row[4].toString();
          account.locationId = Int64(row[5]);
          if (row[6] != null) {
            account.avatarUrl = makeCloudinaryThumbnailUrl(row[6].toString());
            account.blurredAvatarUrl =
                makeCloudinaryBlurredThumbnailUrl(row[6].toString());
            account.coverUrls.clear();
            account.coverUrls.add(makeCloudinaryCoverUrl(row[6].toString()));
            account.blurredCoverUrls.clear();
            account.blurredCoverUrls
                .add(makeCloudinaryBlurredCoverUrl(row[6].toString()));
          }
          if (row[7] != null) account.website = row[7].toString();
          if (row[8] != null) account.email = row[8].toString();
        }
        if (account.locationId != null && account.locationId != 0) {
          if (extend != null) extend();
          /*
          sqljocky.Results locationResults = await connection.prepareExecute(
              "SELECT `${account.accountType == AccountType.business ? 'detail' : 'approximate'}`, `latitude`, `longitude` FROM `locations` "
              "WHERE `location_id` = ?",
              [account.locationId]);
          }*/
          DataLocation location = await fetchLocationSummaryFromSql(
              account.locationId,
              account.accountId,
              account.accountType == AccountType.business);
          if (location == null) {
            devLog.severe(
                "Account ${account.accountId} has an unknown location_id set");
            account.location = "Earth";
          }
        } else {
          devLog.severe(
              "Account ${account.accountId} does not have a location_id set");
          account.location = "Earth";
        }
      }
      // Find all connected social media accounts
      if (extend != null) extend();
      List<bool> connectedProviders = List<bool>(config.oauthProviders.length);
      sqljocky.Results connectionResults = await connection.prepareExecute(
          // The additional `account_id` = 0 here is required in order not to load halfway failed connected sessions
          "SELECT `oauth_user_id`, `oauth_provider`, `oauth_token_expires`, `expired` FROM `oauth_connections` WHERE ${account.accountId == 0 ? '`account_id` = 0 AND `session_id`' : '`account_id`'} = ?",
          <dynamic>[
            account.accountId == 0 ? account.sessionId : account.accountId
          ]);
      List<sqljocky.Row> connectionRows = await connectionResults
          .toList(); // Load to avoid blocking connections recursively
      for (sqljocky.Row row in connectionRows) {
        String oauthUserId = row[0].toString();
        int oauthProvider = row[1].toInt();
        int oauthTokenExpires = row[2].toInt();
        bool expired = row[3].toInt() != 0 ||
            oauthTokenExpires >=
                (new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
        if (oauthProvider < config.oauthProviders.length) {
          account.socialMedia[oauthProvider] =
              await fetchCachedSocialMedia(oauthUserId, oauthProvider);
          account.socialMedia[oauthProvider].expired = expired;
          connectedProviders[oauthProvider] =
              account.socialMedia[oauthProvider].connected;
        } else {
          devLog.severe(
              "Invalid attempt to update session state with no session id, skip, this indicates an incorrent database entry caused by a bug");
        }
      }
      // Wipe any lost accounts (note 0 does not get wiped)
      for (int i = 1; i < config.oauthProviders.length; ++i) {
        if (connectedProviders[i] != true &&
            account.socialMedia[i]?.connected == true) {
          account.socialMedia.remove(i);
        }
      }
    } finally {
      await connection.release();
    }
    // sendAccountUpdate();
  }

  /// May only be called from synchronized block.
  void sendAccountUpdate(
      {TalkMessage replying, String procedureId = 'ACCOUNTU'}) {
    if (!_connected) {
      return;
    }
    NetAccount update = NetAccount();
    update.account = account;
    devLog.finer("Send account update: $account");
    if (replying != null)
      channel.replyMessage(replying, procedureId, update.writeToBuffer());
    else
      channel.sendMessage(procedureId, update.writeToBuffer());
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Authentication messages
  /////////////////////////////////////////////////////////////////////

/*
  void subscribeAuthentication() {
    / *
    registerProcedure(
        "DA_CREAT", GlobalAccountState.initialize, netDeviceAuthCreateReq);
    registerProcedure(
        "DA_CHALL", GlobalAccountState.initialize, netDeviceAuthChallengeReq);
    * /
  }*/

/*
  void unsubscribeAuthentication() {
    unregisterProcedure("DA_CREAT");
    unregisterProcedure("DA_CHALL");
  }
  */

/*
  Future<void> netDeviceAuthCreateReq(TalkMessage message) async {
    NetDeviceAuthCreateReq pb = NetDeviceAuthCreateReq();
    pb.mergeFromBuffer(message.data);
    String aesKeyStr = base64.encode(pb.aesKey);
    await lock.synchronized(() async {
      if (account.sessionId == 0) {
        // Create only once 🤨😒
        sqljocky.RetainedConnection connection = await sql
            .getConnection(); // TODO: Transaction may be nicer than connection, to avoid dead session entries
        try {
          // Create a session in the sessions table of the database
          channel.replyExtend(message);
          await connection.prepareExecute(
              "INSERT INTO `sessions` (`aes_key`, `common_session_id`, `name`, `info`) VALUES (?, ?, ?, ?)",
              [aesKeyStr, base64.encode(pb.commonDeviceId), pb.name, pb.info]);
          sqljocky.Results lastInsertedId =
              await connection.query("SELECT LAST_INSERT_ID()");
          await for (sqljocky.Row row in lastInsertedId) {
            account.sessionId = Int64(row[0]);
            devLog.info(
                "Inserted session_id ${account.sessionId} with aes_key '${aesKeyStr}'");
          }
        } catch (error, stackTrace) {
          devLog.warning("Failed to create session: $error\n$stackTrace");
        }
        await connection.release();
      }
      if (account.sessionId != 0) {
        unsubscribeAuthentication(); // No longer respond to authentication messages when OK
        subscribeOnboarding();
        subscribeOAuth();
      }
    });
    devLog.fine("Send auth state ${message.requestId}");
    await sendNetDeviceAuthState(replying: message);
  }
  */

/*
  Future<void> netDeviceAuthChallengeReq(TalkMessage message) async {
    // Received authentication request
    NetDeviceAuthChallengeReq pb = NetDeviceAuthChallengeReq();
    pb.mergeFromBuffer(message.data);
    Int64 attemptDeviceId = pb.sessionId;

    // Send the message with the random challenge
    Uint8List challenge = Uint8List(256);
    for (int i = 0; i < challenge.length; ++i) {
      challenge[i] = random.nextInt(256);
    }
    NetDeviceAuthChallengeResReq challengePb =
        NetDeviceAuthChallengeResReq();
    challengePb.challenge = challenge;
    Future<TalkMessage> signatureMessageFuture =
        channel.replyRequest(message, "DA_R_CHA", challengePb.writeToBuffer());

    // Get the pub_key from the session that can be used to decrypt the signed challenge
    sqljocky.Results pubKeyResults = await sql.prepareExecute(
        "SELECT `aes_key` FROM `sessions` WHERE `session_id` = ?",
        [attemptDeviceId]);
    Uint8List aesKey; // = base64.decode(input)
    await for (sqljocky.Row row in pubKeyResults) {
      aesKey = base64.decode(row[0].toString());
    }
    if (aesKey == null || aesKey.length == 0) {
      devLog.severe("AES key missing for session $attemptDeviceId");
    }

    // Await signature
    devLog.fine("Await signature");
    TalkMessage signatureMessage = await signatureMessageFuture;
    channel.replyExtend(signatureMessage);
    NetDeviceAuthSignatureResReq signaturePb =
        NetDeviceAuthSignatureResReq();
    signaturePb.mergeFromBuffer(signatureMessage.data);
    if (aesKey != null &&
        aesKey.length > 0 &&
        signaturePb.signature.length > 0) {
      // Verify signature
      var keyParameter = pointycastle.KeyParameter(aesKey);
      var aesFastEngine = pointycastle.AESFastEngine();
      aesFastEngine
        ..reset()
        ..init(false, keyParameter);
      var decrypted = Uint8List(signaturePb.signature.length);
      for (int offset = 0; offset < signaturePb.signature.length;) {
        offset += aesFastEngine.processBlock(
            signaturePb.signature, offset, decrypted, offset);
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
        opsLog.fine(
            "Signature verified succesfully for session $attemptDeviceId");
        await lock.synchronized(() async {
          if (account.sessionId == 0) {
            account.sessionId = attemptDeviceId;
          }
        });
      } else {
        opsLog.warning(
            "Signature verification failed for session $attemptDeviceId");
      }
    } else if (signaturePb.signature.length == 0) {
      devLog.severe(
          "Signature missing from authentication message for session $attemptDeviceId");
    }

    // Send authentication state
    devLog.fine("Await session state");
    await updateDeviceState(extend: () {
      channel.replyExtend(signatureMessage);
    });
    if (account.sessionId != 0) {
      unsubscribeAuthentication(); // No longer respond to authentication messages when OK
      if (account.accountId != 0) {
        channel.replyExtend(signatureMessage);
        await transitionToApp(); // Fetches all of the state data
      } else {
        subscribeOnboarding();
        subscribeOAuth();
      }
    }
    await sendNetDeviceAuthState(replying: signatureMessage);
    devLog.fine("Device authenticated");
  }
  */

  String makeCloudinaryThumbnailUrl(String key) {
    int lastIndex = key.lastIndexOf('.');
    String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return config.services.galleryThumbnailUrl
        .replaceAll('{key}', key)
        .replaceAll('{keyNoExt}', keyNoExt);
  }

  String makeCloudinaryBlurredThumbnailUrl(String key) {
    int lastIndex = key.lastIndexOf('.');
    String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return config.services.galleryThumbnailBlurredUrl
        .replaceAll('{key}', key)
        .replaceAll('{keyNoExt}', keyNoExt);
  }

  String makeCloudinaryCoverUrl(String key) {
    int lastIndex = key.lastIndexOf('.');
    String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return config.services.galleryCoverUrl
        .replaceAll('{key}', key)
        .replaceAll('{keyNoExt}', keyNoExt);
  }

  String makeCloudinaryBlurredCoverUrl(String key) {
    int lastIndex = key.lastIndexOf('.');
    String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return config.services.galleryCoverBlurredUrl
        .replaceAll('{key}', key)
        .replaceAll('{keyNoExt}', keyNoExt);
  }

  /////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////

  // Deprecated
  Future<void> updateDeviceState({Function() extend}) async {
    if (account.sessionId == 0) {
      devLog.severe(
          "Invalid attempt to update session state with no session id, skip, this is a bug");
      return;
    }
    await lock.synchronized(() async {
      await refreshAccount(extend: extend);
    });
  }

/*
  Future<void> sendNetDeviceAuthState({TalkMessage replying}) async {
    if (!_connected) {
      return;
    }
    await lock.synchronized(() async {
      NetAcco pb = NetDeviceAuthState();
      pb.data = account;
      if (replying != null)
        channel.replyMessage(replying, "DA_STATE", pb.writeToBuffer());
      else
        channel.sendMessage("DA_STATE", pb.writeToBuffer());
    });
  }
  */

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
        devLog.severe("Failed to change account type: $error\n$stackTrace");
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
        devLog.severe("GPS Geocoding Exception: $error\n$stackTrace");
      });
    }
    DataLocation geoIPLocationRes;
    Future<dynamic> geoIPLocation =
        getGeoIPLocation(ipAddress).then((DataLocation location) {
      devLog.finest("GeoIP: $location");
      geoIPLocationRes = location;
      // locations.add(location);
    }).catchError((dynamic error, StackTrace stackTrace) {
      devLog.severe("GeoIP Location Exception: $error\n$stackTrace");
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
              "${config.oauthProviders[i].label}: Geocoding Exception: $error\n$stackTrace");
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
              "Failed to create account for session ${account.sessionId}: $error\n$stackTrace");
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
    } catch(error, stackTrace) {
      devLog.severe(
          "Failed to update device state at critical point: '$accountAvatarUrl': $error\n$stackTrace");
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
      devLog.severe(
          "Exception downloading avatar '$accountAvatarUrl': $error\n$stackTrace");
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
    String country = featureCountry['text'];
    DataLocation location = DataLocation();
    location.approximate =
        featureApproximate['place_name'].replaceAll(', United States', '');
    location.detail =
        featureDetail['place_name'].replaceAll(', United States', '');
    if (featurePostcode != null) location.postcode = featurePostcode['text'];
    location.regionCode = featureRegion['properties']['short_code'];
    location.countryCode = featureCountry['properties']['short_code'];
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
    location.regionCode = featureRegion == null
        ? contextRegion['short_code']
        : featureRegion['properties']['short_code'];
    location.countryCode = featureCountry == null
        ? contextCountry['short_code']
        : featureCountry['properties']['short_code'];
    location.latitude = featureDetail['center'][1];
    location.longitude = featureDetail['center'][0];
    location.s2cellId = Int64(new S2CellId.fromLatLng(
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
