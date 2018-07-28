
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:api/inf.pb.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:wstalk/wstalk.dart';
// import 'package:crypto/crypto.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;

// TODO: Move sql queries into a separate shared class, to allow prepared statements, and simplify code here

class RemoteApp {
  bool _connected;

  static const String mapboxToken = "pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA"; // TODO: Replace with config. This is NBSPOU dev server token

  final sqljocky.ConnectionPool sql;
  final TalkSocket ts;

  final random = new Random.secure();

  int deviceId;
  AccountType accountType;
  int accountId;

  GlobalAccountState globalAccountState;
  GlobalAccountStateReason globalAccountStateReason;
  int addressId;

  List<DataSocialMedia> socialMedia = new List<DataSocialMedia>(10); // TODO: Proper length from configuration

  RemoteApp(this.sql, this.ts) {
    subscribeAuthentication();
  }

  void close() {
    _connected = false;
    unsubscribeAuthentication();
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Authentication messages
  /////////////////////////////////////////////////////////////////////
  
  void subscribeAuthentication() {
    _netDeviceAuthCreateReq = ts.stream(TalkSocket.encode("DA_CREAT")).listen(netDeviceAuthCreateReq);
    _netDeviceAuthChallengeReq = ts.stream(TalkSocket.encode("DA_CHALL")).listen(netDeviceAuthChallengeReq);
  }

  void unsubscribeAuthentication() {
    _netDeviceAuthCreateReq.cancel(); _netDeviceAuthCreateReq = null;
    _netDeviceAuthChallengeReq.cancel(); _netDeviceAuthChallengeReq = null;
  }

  StreamSubscription<TalkMessage> _netDeviceAuthCreateReq; // DA_CREAT
  netDeviceAuthCreateReq(TalkMessage message) async {
    try {
      NetDeviceAuthCreateReq pb = new NetDeviceAuthCreateReq();
      pb.mergeFromBuffer(message.data);
      if (deviceId == 0) { // Create only once 🤨😒
        sqljocky.RetainedConnection connection = await sql.getConnection(); // TODO: Transaction may be nicer than connection, to avoid dead device entries
        try {
          // Create a new device in the devices table of the database
          await connection.prepareExecute(
            "INSERT INTO `devices` (`aes_key`, `name`, `info`) VALUES (?, ?, ?)", 
            [ pb.aesKey, pb.name, pb.info ]);
          sqljocky.Results lastInsertedId = await connection.query("SELECT LAST_INSERT_ID()");
          await for (sqljocky.Row row in lastInsertedId) {
            deviceId = row[0];
            print("Inserted device_id $deviceId with aes_key '${pb.aesKey}'");
          }
        } catch (ex) {
          print("Failed to create device:");
          print(ex);
        }
        await connection.release();
      }
      if (deviceId != 0) {
        unsubscribeAuthentication(); // No longer respond to authentication messages when OK
        subscribeOnboarding();
      }
      sendNetDeviceAuthState(reply: message);
    } catch (ex) {
      print("Exception in message '${TalkSocket.decode(message.id)}':");
      print(ex);
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
      Future<TalkMessage> signatureMessageFuture = ts.sendRequest(_netDeviceAuthChallengeResReq, challengePb.writeToBuffer(), reply: message);
      
      // Get the pub_key from the device that can be used to decrypt the signed challenge
      sqljocky.Results pubKeyResults = await sql.prepareExecute("SELECT `aes_key` FROM `devices` WHERE `device_id` = ?", [ attemptDeviceId ]);
      Uint8List aesKey;// = base64.decode(input)
      await for (sqljocky.Row row in pubKeyResults) {
        aesKey = base64.decode(row[0].toString());
      }
      if (aesKey.length == 0) {
        print("AES key missing for device $attemptDeviceId");
      }

      // Await signature
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
          print("Signature verified succesfully for device $attemptDeviceId");
          deviceId = attemptDeviceId;
        } else {
          print("Signature verification failed for device $attemptDeviceId");
        }
      } else if (signaturePb.signature.length == 0) {
        print("Signature missing from authentication message for device $attemptDeviceId");
      }

      // Send authentication state
      await updateDeviceState();
      if (deviceId != 0) {
        unsubscribeAuthentication(); // No longer respond to authentication messages when OK
        if (accountId != 0) {
          // TODO: Permit app transactions!
        } else {
          subscribeOnboarding();
        }
      }
      sendNetDeviceAuthState(reply: signatureMessage);
    } catch (ex) {
      print("Exception in message '${TalkSocket.decode(message.id)}':");
      print(ex);
    }
  }

  Future updateDeviceState() async {
    // First get the account id (and account type, in case the account id has not been created yet)
    sqljocky.Results deviceResults = await sql.prepareExecute("SELECT `account_id`, `account_type` FROM `devices` WHERE `device_id` = ?", [ deviceId ]);
    await for (sqljocky.Row row in deviceResults) { // one row
      accountId = row[0]; // VERIFY
      accountType = AccountType.valueOf(row[1]); // VERIFY
    }
    sqljocky.Results mediaResults;
    if (accountId != 0) {
      // Get the account information if it exists
      sqljocky.Results accountResults = await sql.prepareExecute("SELECT `account_type`, `global_account_state`, `global_account_state_reason`, `address_id` FROM `accounts` WHERE `account_id` = ?", [ accountId ]);
      await for (sqljocky.Row row in accountResults) { // one row
        accountType = AccountType.valueOf(row[0]); // VERIFY
        globalAccountState = GlobalAccountState.valueOf(row[1]); // VERIFY
        globalAccountStateReason = GlobalAccountStateReason.valueOf(row[2]); // VERIFY
        addressId = row[3]; // VERIFY
      }
      mediaResults = await sql.prepareExecute("SELECT `oauth_provider`, `username`, `display_name`, `followers`, `following` FROM `oauth_connections` WHERE `account_id` = ?", [ accountId ]);
    } else {
      mediaResults = await sql.prepareExecute("SELECT `oauth_provider`, `username`, `display_name`, `followers`, `following` FROM `oauth_connections` WHERE `device_id` = ?", [ deviceId ]);
    }
    List<bool> connected = new List<bool>(socialMedia.length);
    await for (sqljocky.Row row in mediaResults) {
      int oauthProvider = row[0];
      if (oauthProvider < socialMedia.length) {
        connected[oauthProvider] = true;
        socialMedia[oauthProvider].userName = row[1].toString();
        socialMedia[oauthProvider].displayName = row[2].toString();
        socialMedia[oauthProvider].followers = row[3];
        socialMedia[oauthProvider].following = row[4];
      } else {
        print("Unknown social media provider $oauthProvider");
      }
    }
    for (int i = 0; i < socialMedia.length; ++i) {
      socialMedia[i].connected = connected[i];
    }
  }

  static int _netDeviceAuthState = TalkSocket.encode("DA_STATE");
  void sendNetDeviceAuthState({ TalkMessage reply }) {
    if (!_connected) {
      return;
    }
    NetDeviceAuthState pb = new NetDeviceAuthState();
    pb.deviceId = deviceId;
    pb.accountId = accountId;
    pb.accountType = accountType;
    pb.globalAccountState = globalAccountState;
    pb.globalAccountStateReason = globalAccountStateReason;
    pb.socialMedia.setAll(0, socialMedia);
    ts.sendMessage(_netDeviceAuthState, pb.writeToBuffer(), reply: reply);
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Onboarding messages
  /////////////////////////////////////////////////////////////////////
  
  void subscribeOnboarding() {
    _netSetAccountType = ts.stream(TalkSocket.encode("A_SETTYP")).listen(netSetAccountType);
    _netOAuthConnectReq = ts.stream(TalkSocket.encode("OA_CONNE")).listen(netOAuthConnectReq);
    _netAccountCreateReq = ts.stream(TalkSocket.encode("A_CREATE")).listen(netAccountCreateReq);
  }

  void unsubscribeOnboarding() {
    _netSetAccountType.cancel(); _netSetAccountType = null;
    _netOAuthConnectReq.cancel(); _netOAuthConnectReq = null;
    _netAccountCreateReq.cancel(); _netAccountCreateReq = null;
  }

  StreamSubscription<TalkMessage> _netSetAccountType; // A_SETTYP
  netSetAccountType(TalkMessage message) async {
    assert(accountId == 0);
    assert(deviceId != 0);
    try {
      // Received account type change request
      NetSetAccountType pb = new NetSetAccountType();
      pb.mergeFromBuffer(message.data);
      if (pb.accountType == accountType) {
        return; // no-op, may ignore
      }

      sqljocky.Transaction tx = await sql.startTransaction();
      try {
        await tx.prepareExecute("DELETE FROM `oauth_connections` WHERE `device_id` = ? AND `account_id` = 0", [ deviceId ]);
        await tx.prepareExecute("UPDATE `devices` SET `account_type` = 1 WHERE `device_id` = 1 AND `account_id` = 0", [ pb.accountType.value, deviceId]);
        await tx.commit();
      } catch (ex) {
        print("Failed to change account type:");
        print(ex);
        await tx.rollback();
      }

      // Send authentication state
      await updateDeviceState();
      sendNetDeviceAuthState();
    } catch (ex) {
      print("Exception in message '${TalkSocket.decode(message.id)}':");
      print(ex);
    }
  }

  StreamSubscription<TalkMessage> _netOAuthConnectReq; // OA_CONNE
  static int _netOAuthConnectRes = TalkSocket.encode("OA_R_CON");
  netOAuthConnectReq(TalkMessage message) async { // response: NetOAuthConnectRes
    assert(accountId == 0);
    assert(deviceId != 0);
    try {
      // Received oauth connection request
      NetOAuthConnectReq pb = new NetOAuthConnectReq();
      pb.mergeFromBuffer(message.data);
      NetOAuthConnectRes resPb = new NetOAuthConnectRes();
      resPb.socialMedia.connected = false;
      ts.sendMessage(_netOAuthConnectRes, resPb.writeToBuffer(), reply: message);
    } catch (ex) {
      print("Exception in message '${TalkSocket.decode(message.id)}':");
      print(ex);
    }
  }

  StreamSubscription<TalkMessage> _netAccountCreateReq; // A_CREATE
  netAccountCreateReq(TalkMessage message) async { // response: NetDeviceAuthState
    assert(accountId == 0);
    assert(deviceId != 0);
    try {
      // Received account creation request
      NetAccountCreateReq pb = new NetAccountCreateReq();
      pb.mergeFromBuffer(message.data);

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
      for (int i = 0; i < socialMedia.length; ++i) {
        if (socialMedia[i].connected)
          ++connectedNb;
      }
      if (accountType != AccountType.AT_UNKNOWN
        && connectedNb > 0
        && pb.name.length > 0) {
        // Changes sent in a single SQL transaction for reliability
        sqljocky.Transaction tx = await sql.startTransaction();
        try {
          
          
          await tx.commit();
        } catch (ex) {
          print("Failed to create account:");
          print(ex);
          await tx.rollback();
        }
      }

      // Send authentication state
      // await updateDeviceState();
      if (accountId != 0) {
        unsubscribeOnboarding(); // No longer respond to onboarding messages when OK
      }
      sendNetDeviceAuthState(reply: message);
    } catch (ex) {
      print("Exception in message '${TalkSocket.decode(message.id)}':");
      print(ex);
    }
  }
}
