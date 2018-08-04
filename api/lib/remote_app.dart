/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:wstalk/wstalk.dart';
// import 'package:crypto/crypto.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;
import 'package:synchronized/synchronized.dart';

import 'inf.pb.dart';
import 'remote_app_oauth.dart';

// TODO: Move sql queries into a separate shared class, to allow prepared statements, and simplify code here

class RemoteApp {
  bool _connected = true;

  static const String mapboxToken = "pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA"; // TODO: Replace with config. This is NBSPOU dev server token

  final ConfigData config;
  final sqljocky.ConnectionPool sql;
  final TalkSocket ts;

  final random = new Random.secure();

  /// Lock anytime making changes to the account state
  final lock = new Lock();

  /*
  int data.state.deviceId;
  AccountType data.state.accountType;
  int data.state.accountId;

  GlobalAccountState globalAccountState;
  GlobalAccountStateReason globalAccountStateReason;
  */

  DataAccount data;

  /*
  DataAccountState data.state = new DataAccountState();

  int addressId;

  List<DataSocialMedia> socialMedia; // TODO: Proper length from configuration
  */

  static final Logger opsLog = new Logger('InfOps.RemoteApp');
  static final Logger devLog = new Logger('InfDev.RemoteApp');

  RemoteAppOAuth _remoteAppOAuth;
  dynamic _remoteAppBusiness;
  dynamic _remoteAppInfluencer;
  dynamic _remoteAppCommon;

  RemoteApp(this.config, this.sql, this.ts) {
    devLog.fine("New connection");

    data = new DataAccount();
    data.state = new DataAccountState();
    data.summary = new DataAccountSummary();
    data.detail = new DataAccountDetail();

    data.detail.socialMedia.length = 0;
    for (int i = 0; i < data.detail.socialMedia.length; ++i) {
      data.detail.socialMedia.add(new DataSocialMedia());
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
    devLog.fine("Connection closed for device ${data.state.deviceId}");
  }

  StreamSubscription<TalkMessage> safeListen(String id, Future onData(TalkMessage message)) {
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
          if (data.state.deviceId == 0) { // Create only once 🤨😒
            sqljocky.RetainedConnection connection = await sql.getConnection(); // TODO: Transaction may be nicer than connection, to avoid dead device entries
            try {
              // Create a new device in the devices table of the database
              ts.sendExtend(message);
              await connection.prepareExecute(
                "INSERT INTO `devices` (`aes_key`, `common_device_id`, `name`, `info`) VALUES (?, ?, ?, ?)", 
                [ aesKeyStr, base64.encode(pb.commonDeviceId), pb.name, pb.info ]);
              sqljocky.Results lastInsertedId = await connection.query("SELECT LAST_INSERT_ID()");
              await for (sqljocky.Row row in lastInsertedId) {
                data.state.deviceId = row[0];
                devLog.info("Inserted device_id ${data.state.deviceId} with aes_key '${aesKeyStr}'");
              }
            } catch (ex) {
              devLog.warning("Failed to create device: $ex");
            }
            await connection.release();
          }
          if (data.state.deviceId != 0) {
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
            if (data.state.deviceId == 0) {
              data.state.deviceId = attemptDeviceId;
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
      await updateDeviceState();
      if (data.state.deviceId != 0) {
        unsubscribeAuthentication(); // No longer respond to authentication messages when OK
        if (data.state.accountId != 0) {
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

  Future updateDeviceState() async {
    await lock.synchronized(() async {
      // First get the account id (and account type, in case the account id has not been created yet)
      sqljocky.Results deviceResults = await sql.prepareExecute("SELECT `account_id`, `account_type` FROM `devices` WHERE `device_id` = ?", [ data.state.deviceId.toInt() ]);
      await for (sqljocky.Row row in deviceResults) { // one row
        data.state.accountId = row[0]; // VERIFY
        data.state.accountType = AccountType.valueOf(row[1]); // VERIFY
      }
      List<bool> connected = new List<bool>(data.detail.socialMedia.length);
      /*
      sqljocky.Results mediaResults;
      if (data.state.accountId != 0) {
        // Get the account information if it exists
        sqljocky.Results accountResults = await sql.prepareExecute("SELECT `account_type`, `global_account_state`, `global_account_state_reason`, `address_id` FROM `accounts` WHERE `account_id` = ?", [ data.state.accountId ]);
        await for (sqljocky.Row row in accountResults) { // one row
          data.state.accountType = AccountType.valueOf(row[0]); // VERIFY
          data.state.globalAccountState = GlobalAccountState.valueOf(row[1]); // VERIFY
          data.state.globalAccountStateReason = GlobalAccountStateReason.valueOf(row[2]); // VERIFY
          addressId = row[3]; // VERIFY
        }
        mediaResults = await sql.prepareExecute("SELECT `oauth_provider`, `screen_name`, `display_name`, `followers`, `following` FROM `oauth_connections` WHERE `account_id` = ?", [ data.state.accountId ]);
      } else {
        mediaResults = await sql.prepareExecute("SELECT `oauth_provider`, `screen_name`, `display_name`, `followers`, `following` FROM `oauth_connections` WHERE `device_id` = ?", [ data.state.deviceId ]);
      }
      await for (sqljocky.Row row in mediaResults) {
        int oauthProvider = row[0];
        if (oauthProvider < socialMedia.length) {
          connected[oauthProvider] = true;
          socialMedia[oauthProvider].screenName = row[1].toString();
          socialMedia[oauthProvider].displayName = row[2].toString();
          socialMedia[oauthProvider].followers = row[3];
          socialMedia[oauthProvider].following = row[4];
        } else {
          devLog.severe("Unknown social media provider $oauthProvider");
        }
      }
      */
      for (int i = 0; i < data.detail.socialMedia.length; ++i) {
        data.detail.socialMedia[i].connected = connected[i] == true;
      }
    });
  }

  static int _netDeviceAuthState = TalkSocket.encode("DA_STATE");
  Future sendNetDeviceAuthState({ TalkMessage replying }) async {
    if (!_connected) {
      return;
    }
    await lock.synchronized(() async {
      NetDeviceAuthState pb = new NetDeviceAuthState();
      pb.data = data;
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
    assert(data.state.deviceId != 0);
    try {
      // Received account type change request
      NetSetAccountType pb = new NetSetAccountType();
      pb.mergeFromBuffer(message.data);
      devLog.finest("NetSetAccountType ${pb.accountType}");

      await lock.synchronized(() async {
        if (pb.accountType == data.state.accountType) {
          return; // no-op, may ignore
        }
        if (data.state.accountId != 0) {
          return; // no-op, may ignore
        }

        try {
          await sql.startTransaction((sqljocky.Transaction tx) async {
            await tx.prepareExecute("DELETE FROM `oauth_connections` WHERE `device_id` = ? AND `account_id` = 0", [ data.state.deviceId ]);
            await tx.prepareExecute("UPDATE `devices` SET `account_type` = ? WHERE `device_id` = ? AND `account_id` = 0", [ pb.accountType.value, data.state.deviceId]);
            await tx.commit();
          });
        } catch (ex) {
          devLog.severe("Failed to change account type: $ex");
        }
      });

      // Send authentication state
      await updateDeviceState();
      await sendNetDeviceAuthState();
    } catch (ex) {
      devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
    }
  }
/*
  StreamSubscription<TalkMessage> _netOAuthConnectReq; // OA_CONNE
  static int _netOAuthConnectRes = TalkSocket.encode("OA_R_CON");
  netOAuthConnectReq(TalkMessage message) async { // response: NetOAuthConnectRes
    assert(data.state.deviceId != 0);
    try {
      // Received oauth connection request
      NetOAuthConnectReq pb = new NetOAuthConnectReq();
      pb.mergeFromBuffer(message.data);

      if (pb.oauthProvider >= socialMedia.length) {
        devLog.severe("Invalid OAuth provider specified by device ${data.state.deviceId}"); // CRITICAL - DEVELOPER (there are critical issues for developer, also critical issues for operations!)
      } else if (data.state.accountType == AccountType.AT_UNKNOWN) {
        devLog.severe("Account type was not yet set by device ${data.state.deviceId}"); // CRITICAL - DEVELOPER
      //} else if (data.state.accountId != 0) {
        // Race condition, the account was already created before receiving this connection request
      //  devLog.fine("OAuth request received but account ${data.state.accountId} already created by ${data.state.deviceId}"); // DEBUG - DEVELOPER
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
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", [ oauthUserId, oauthProvider, data.state.accountType.value,
            data.state.accountId, data.state.deviceId, username, displayName, followers, following ]);
        } catch (ex) {
          devLog.info("Failed to insert OAuth, may already be inserted!");
        }
        sqljocky.Results selectOAuth = await sql.prepareExecute("SELECT `account_id`, `device_id` FROM `oauth_connections`"
          "WHERE `oauth_user_id` = ?, `oauth_provider` = ?, `account_type` = ?", [ oauthUserId, oauthProvider, data.state.accountType.value ]);
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
          opsLog.severe("Failed to insert or retrieve OAuth ($oauthUserId, $oauthProvider, ${data.state.accountType}), database may have connection issues");
        }
      }

      NetOAuthConnectRes resPb = new NetOAuthConnectRes();
      if (pb.oauthProvider < socialMedia.length) {
        resPb.socialMedia = socialMedia[pb.oauthProvider];
      }
      ts.sendMessage(_netOAuthConnectRes, resPb.writeToBuffer(), replying: message);

      if (data.state.accountId != 0) {
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
    assert(data.state.deviceId != 0);
    try {
      // Received account creation request
      NetAccountCreateReq pb = new NetAccountCreateReq();
      pb.mergeFromBuffer(message.data);

      await lock.synchronized(() async {
        if (data.state.accountId == 0) {
          // Create account if sufficient data was received
          String addressName;
          String addressDetail;
          String addressApproximate;
          int addressPostcode;
          String addressRegionCode;
          String addressCountryCode;
          if (!pb.hasLat() || !pb.hasLng()) {
            // Default to LA
            // https://www.mapbox.com/api-documentation/#search-for-places
            pb.lat = 34.0207305;
            pb.lng = -118.6919159;
            addressName = "Los Angeles";
            addressDetail = "Los Angeles, California 90017";
            addressApproximate = "Los Angeles, California 90017";
            addressPostcode = 90017;
            addressRegionCode = "US-CA";
            addressCountryCode = "US";
          } else {
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
          }
          int connectedNb = 0;
          for (int i = 0; i < data.detail.socialMedia.length; ++i) {
            if (data.detail.socialMedia[i].connected)
              ++connectedNb;
          }
          if (data.state.accountType != AccountType.AT_UNKNOWN
            && connectedNb > 0
            && pb.name.length > 0) {
            // Changes sent in a single SQL transaction for reliability
            try {
              await sql.startTransaction((sqljocky.Transaction tx) async {
                // ...
                await tx.commit();
              });
            } catch (ex) {
              opsLog.severe("Failed to create account: $ex");
            }
          }

          // await updateDeviceState();
          if (data.state.accountId != 0) {
            unsubscribeOnboarding(); // No longer respond to onboarding messages when OK
            await transitionToApp();
          }
        }
      });

      // Send authentication state
      await sendNetDeviceAuthState(replying: message);
      if (data.state.accountId == 0) {
        devLog.severe("Account was not created for device ${data.state.deviceId}"); // DEVELOPER - DEVELOPMENT CRITICAL
      }
    } catch (ex) {
      devLog.severe("Exception in message '${TalkSocket.decode(message.id)}': $ex");
    }
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // App
  /////////////////////////////////////////////////////////////////////
  
  /// Transitions the user to the app context after registration or login succeeds. Call from lock
  Future transitionToApp() {
    assert(_netDeviceAuthCreateReq == null);
    assert(_netAccountCreateReq == null);
    assert(_remoteAppBusiness == null);
    assert(_remoteAppInfluencer == null);
    assert(_remoteAppCommon == null);
    assert(data.state.deviceId != null);
    assert(data.state.accountId != 0);
    // TODO: Permit app transactions!
    // TODO: Fetch social media from SQL and then from remote hosts!
    devLog.fine("Transition device ${data.state.deviceId} to app ${data.state.accountType}");
    subscribeOAuth();
  }
}

/* end of file */
