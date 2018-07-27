
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

class RemoteApp {
  bool _connected;

  final sqljocky.ConnectionPool sql;
  final TalkSocket ts;

  final random = new Random.secure();

  int deviceId;

  RemoteApp(this.sql, this.ts) {
    subscribeAuthentication();
  }

  void close() {
    _connected = false;
    unsubscribeAuthentication();
  }

  // Authentication messages
  void subscribeAuthentication() {
    _netDeviceAuthCreateReq = ts.stream(TalkSocket.encode("DA_CREAT")).listen(netDeviceAuthCreateReq);
    _netDeviceAuthChallengeReq = ts.stream(TalkSocket.encode("DA_CHALL")).listen(netDeviceAuthChallengeReq);
  }

  void unsubscribeAuthentication() {
    _netDeviceAuthCreateReq.cancel();
    _netDeviceAuthChallengeReq.cancel();
  }

  StreamSubscription<TalkMessage> _netDeviceAuthCreateReq; // DA_CREAT
  netDeviceAuthCreateReq(TalkMessage message) async {
    try {
      NetDeviceAuthCreateReq pb = new NetDeviceAuthCreateReq();
      pb.mergeFromBuffer(message.data);
      if (deviceId == 0) { // Create only once 🤨😒
        sqljocky.RetainedConnection connection = await sql.getConnection();
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
        connection.release();
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
      sqljocky.Results pubKeyResults = await sql.prepareExecute("SELECT `aes_key` FROM `devices` WHERE `deviceId` = ?", [ attemptDeviceId ]);
      Uint8List aesKey;// = base64.decode(input)
      await for (sqljocky.Row row in pubKeyResults) {
        aesKey = base64.decode(row[0].toString());
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
      }

      // Send authentication state
      sendNetDeviceAuthState(reply: message);
    } catch (ex) {
      print("Exception in message '${TalkSocket.decode(message.id)}':");
      print(ex);
    }
  }

  static int _netDeviceAuthState = TalkSocket.encode("DA_STATE");
  void sendNetDeviceAuthState({ TalkMessage reply }) {
    if (!_connected) {
      return;
    }
    NetDeviceAuthState pb = new NetDeviceAuthState();
    pb.deviceId = deviceId;
    ts.sendMessage(_netDeviceAuthState, pb.writeToBuffer(), reply: reply);
  }

}
