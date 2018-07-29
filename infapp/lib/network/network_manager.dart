/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wstalk/wstalk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;

import 'config_manager.dart';
import 'inf.pb.dart';

class NetworkManager extends StatelessWidget {
  const NetworkManager({
    Key key,
    this.overrideUri,
    @required this.localAccountId,
    this.child,
  }) : super(key: key);

  final String overrideUri;
  final int localAccountId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    String ks = key.toString();
    ConfigData config = ConfigManager.of(context);
    assert(config != null);
    return new _NetworkManagerStateful(
      key: (key != null && ks.length > 0) ? new Key('$ks.Stateful') : null,
      networkManager: this,
      child: child,
      config: config,
    );
  }
}

class _NetworkManagerStateful extends StatefulWidget {
  const _NetworkManagerStateful({
    Key key,
    this.networkManager,
    this.child,
    this.config,
  }) : super(key: key);

  final NetworkManager networkManager;
  final Widget child;
  final ConfigData config;

  static NetworkInterface of(BuildContext context) {
    final _InheritedNetworkManager inherited = context.inheritFromWidgetOfExactType(_InheritedNetworkManager);
    return inherited != null ? inherited.networkInterface : null;
  }

  @override
  _NetworkManagerState createState() => new _NetworkManagerState();
}

class _NetworkManagerState extends State<_NetworkManagerStateful> implements NetworkInterface {  
  // see NetworkInterface
  DataAccountState accountState;
  List<DataSocialMedia> socialMedia;
  NetworkConnectionState connected = NetworkConnectionState.Connecting;

  int _changed = 0; // trick to ensure rebuild
  ConfigData _config;

  bool _alive;
  TalkSocket _ts;

  final random = new Random.secure();

  void syncConfig() {
    if (_config != widget.config) {
      print("[INF] Sync config changes to network");
      _config = widget.config;
      if (_config != null) {
        socialMedia.length = _config.oauthProviders.all.length; // Match array length
        for (int i = 0; i < socialMedia.length; ++i) {
          if (socialMedia[i] == null) {
            socialMedia[i] = new DataSocialMedia();
          }
        }
      }
    }
    if (_config == null) {
      print("[INF] Widget config is null in network sync"); // DEVELOPER - CRITICAL
    }
  }

  void receivedAuthDeviceState(NetDeviceAuthState pb) {
    setState(() {
      accountState = pb.accountState;
      socialMedia = pb.socialMedia;
      socialMedia.length = _config.oauthProviders.all.length; // Match array length
      for (int i = 0; i < socialMedia.length; ++i) {
        if (socialMedia[i] == null) {
          socialMedia[i] = new DataSocialMedia();
        }
      }
    });
  }

  /// Authenticate device connection, this process happens as if by magic
  Future _authenticateDevice(TalkSocket ts) async {
    // Initialize connection
    accountState.deviceId = 0;
    print("[INF] Authenticate device");
    ts.sendMessage(TalkSocket.encode("INFAPP"), new Uint8List(0));

    // TODO: We'll use an SQLite database to keep the local cache stored
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    String deviceName = "unknown_device";
    try {
      if (Platform.isAndroid) {
        var info = await deviceInfo.androidInfo;
        deviceName = info.model;
      } else if (Platform.isIOS) {
        var info = await deviceInfo.iosInfo;
        deviceName = info.name;
      }
    } catch (ex) {
      print('[INF] Failed to get device name');
    }
    int localAccountId = widget.networkManager.localAccountId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aesKeyPref = 'aes_key_$localAccountId';
    String deviceIdPref = 'device_id_$localAccountId';
    String aesKeyStr;
    Uint8List aesKey;
    int attemptDeviceId = 0;
    try {
      // prefs.setString(aesKeyPref, ''); // DEBUG: Reset profile
      aesKeyStr = prefs.getString(aesKeyPref);
      aesKey = base64.decode(aesKeyStr);
      attemptDeviceId = prefs.getInt(deviceIdPref);
    } catch (e) { }
    if (aesKey == null || aesKey.length == 0 || attemptDeviceId == null || attemptDeviceId == 0) {
      // Create new device
      print("[INF] Create new device");
      aesKey = new Uint8List(32);
      for (int i = 0; i < aesKey.length; ++i) {
        aesKey[i] = random.nextInt(256);
      }
      aesKeyStr = base64.encode(aesKey);
      NetDeviceAuthCreateReq pbReq = new NetDeviceAuthCreateReq();
      pbReq.aesKey = aesKey;
      pbReq.name = deviceName;
      pbReq.info = "{ debug: 'default_info' }";

      TalkMessage res = await ts.sendRequest(TalkSocket.encode("DA_CREAT"), pbReq.writeToBuffer());
      NetDeviceAuthState pbRes = new NetDeviceAuthState();
      pbRes.mergeFromBuffer(res.data);
      if (!_alive) {
        throw Exception("No longer alive, don't authorize");
      }
      receivedAuthDeviceState(pbRes);
      print("[INF] Device id ${accountState.deviceId}");
      if (accountState.deviceId != 0) {
        prefs.setString(aesKeyPref, aesKeyStr);
        prefs.setInt(deviceIdPref, accountState.deviceId);
      }
    } else {
      // Authenticate existing device
      print("[INF] Authenticate existing device $attemptDeviceId");

      NetDeviceAuthChallengeReq pbChallengeReq = new NetDeviceAuthChallengeReq();
      pbChallengeReq.deviceId = attemptDeviceId;
      TalkMessage msgChallengeResReq = await ts.sendRequest(TalkSocket.encode("DA_CHALL"), pbChallengeReq.writeToBuffer());
      NetDeviceAuthChallengeResReq pbChallengeResReq = new NetDeviceAuthChallengeResReq();
      pbChallengeResReq.mergeFromBuffer(msgChallengeResReq.data);

      // Sign challenge
      var keyParameter = new pointycastle.KeyParameter(aesKey);
      var aesFastEngine = new pointycastle.AESFastEngine();
      aesFastEngine..reset()..init(true, keyParameter);
      Uint8List challenge = pbChallengeResReq.challenge;
      Uint8List signature = new Uint8List(challenge.length);
      for (int offset = 0; offset < challenge.length;) {
        offset += aesFastEngine.processBlock(challenge, offset, signature, offset);
      }

      // Send signature, wait for device status
      NetDeviceAuthSignatureResReq pbSignature = new NetDeviceAuthSignatureResReq();
      pbSignature.signature = signature;
      TalkMessage res = await ts.sendRequest(TalkSocket.encode("DA_R_SIG"), pbSignature.writeToBuffer(), reply: msgChallengeResReq);
      NetDeviceAuthState pbRes = new NetDeviceAuthState();
      pbRes.mergeFromBuffer(res.data);
      if (!_alive) {
        throw Exception("No longer alive, don't authorize");
      }
      receivedAuthDeviceState(pbRes);
      print("[INF] Device id ${accountState.deviceId}");
    }
    
    if (accountState.deviceId == 0) {
      throw new Exception("Authentication did not succeed");
    } else {
      print("[INF] Network connection is ready");
      connected = NetworkConnectionState.Ready;
    }

    // assert(accountState.deviceId != 0);
  }

  bool _netConfigWarning = false;
  Future _networkSession() async {
    try {
      String uri = widget.networkManager.overrideUri;
      if (uri == null || uri.length == 0) {
        if (!_netConfigWarning) {
          _netConfigWarning = true;
          print("[INF] No network configuration, not connecting");
        }
        await new Future.delayed(new Duration(seconds: 3));
        return;
      }
      _netConfigWarning = false;
      do {
        try {
          print("[INF] Try connect to $uri");
          _ts = await TalkSocket.connect(uri);
        } catch (e) {
          print("[INF] Network cannot connect, retry in 3 seconds: $e");
          assert(_ts == null);
          connected = NetworkConnectionState.Offline;
          await new Future.delayed(new Duration(seconds: 3));
        }
      } while (_alive && (_ts == null));
      Future listen = _ts.listen();
      if (connected == NetworkConnectionState.Offline) {
        connected = NetworkConnectionState.Connecting;
      }
      if (_config != null && widget.networkManager.localAccountId != 0) {
        if (_alive) {
          // Authenticate device, this will set connected = Ready when successful
          _authenticateDevice(_ts).catchError((e) {
            print("[INF] Network authentication exception, retry in 3 seconds: $e");
            connected = NetworkConnectionState.Failing;
            TalkSocket ts = _ts;
            _ts = null;
            () async {
              print("[INF] Wait");
              await new Future.delayed(new Duration(seconds: 3));
              print("[INF] Retry now");
              if (ts != null) {
                ts.close();
              }
            }().catchError((e) {
              print("[INF] Fatal network exception, cannot recover: $e");
            });
          });
        } else {
          _ts.close();
        }
      } else {
        print("[INF] No configuration, connection will remain idle, local account id ${widget.networkManager.localAccountId}");
        connected = NetworkConnectionState.Failing;
      }
      await listen;
      _ts = null;
      print("[INF] Network connection closed");
      if (connected == NetworkConnectionState.Ready) {
        connected = NetworkConnectionState.Connecting;
      }
    } catch (e) {
      print("[INF] Network session exception: $e");
      TalkSocket ts = _ts;
      _ts = null;
      connected = NetworkConnectionState.Failing;
      if (ts != null) {
        ts.close(); // TODO: close code?
      }
    }
  }

  Future _networkLoop() async {
    print("[INF] Start network loop");
    while (_alive) {
      await _networkSession();
    }
    print("[INF] End network loop");
  }

  @override
  void initState() {
    super.initState();
    _alive = true;

    // Initialize data
    accountState = new DataAccountState();
    socialMedia = new List<DataSocialMedia>();
    syncConfig();

    // Start network loop
    _networkLoop().catchError((e) {
      print("[INF] Network loop died: $e");
    });
  }

  @override
  void reassemble() { 
    super.reassemble();

    // Developer reload
    if (_ts != null) {
      print("[INF] Network reload by developer");
      _ts.close();
      _ts = null;
    }
  }

  @override
  void dispose() {
    _alive = false;
    if (_ts != null) {
      print("[INF] Dispose network connection");
      _ts.close();
      _ts = null;
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(_NetworkManagerStateful oldWidget) {
    // Called before build(), may change/update any state here without calling setState()
    super.didUpdateWidget(oldWidget);
    syncConfig();
    if (_ts != null) {
      print("[INF] Network reload by config");
      _ts.close();
      _ts = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String ks = widget.key.toString();
    return new _InheritedNetworkManager(
      key: (widget.key != null && ks.length > 0) ? new Key(ks + '.Inherited') : null,
      networkInterface: this,
      changed: _changed++,
      child: widget.child,
    );
  }
}

class _InheritedNetworkManager extends InheritedWidget {
  const _InheritedNetworkManager({
    Key key,
    @required this.networkInterface,
    @required this.changed,
    @required Widget child,
  }) : super(key: key, child: child);

  final NetworkInterface networkInterface; // NetworkInterface remains!
  final int changed;
  
  @override
  bool updateShouldNotify(_InheritedNetworkManager old) {
    if (networkInterface.accountState != old.networkInterface.accountState) {
      return true;
    }
    if (networkInterface.socialMedia != old.networkInterface.socialMedia) {
      return true;
    }
    if (networkInterface.socialMedia.length != old.networkInterface.socialMedia.length) {
      return true;
    }
    for (int i = 0; i < networkInterface.socialMedia.length; ++i) {
      if (networkInterface.socialMedia[i] != old.networkInterface.socialMedia[i]) {
        return true;
      }
    }
    return false;
  }
}

enum NetworkConnectionState {
  Connecting,
  Failing,
  Offline,
  Ready
}

class NetworkInterface {
  /// Cached account state. Use this data directly from your build function
  DataAccountState accountState;

  /// Cached social media information. Use this data directly from your build function
  List<DataSocialMedia> socialMedia;

  /// Whether we are connected to the network.
  NetworkConnectionState connected;

}

/* end of file */
