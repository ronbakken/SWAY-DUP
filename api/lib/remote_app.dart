
import 'dart:async';

import 'package:api/inf.pb.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:wstalk/wstalk.dart';

class RemoteApp {
  bool _connected;

  final sqljocky.ConnectionPool sql;
  final TalkSocket ts;

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
          /*sqljocky.Results insert = */ await connection.prepareExecute(
            "INSERT INTO `devices` (`pub_key`, `name`, `info`) VALUES (?, ?, ?)", 
            [ pb.pubKey, pb.name, pb.info ]);
          sqljocky.Results lastInsertedId = await connection.query("SELECT LAST_INSERT_ID()");
          await for (sqljocky.Row row in lastInsertedId) {
            deviceId = row[0];
            print("Inserted device_id $deviceId with pub_key '${pb.pubKey}'");
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
  netDeviceAuthChallengeReq(TalkMessage message) async {
    try {
      NetDeviceAuthChallengeReq pb = new NetDeviceAuthChallengeReq();
      pb.mergeFromBuffer(message.data);
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
