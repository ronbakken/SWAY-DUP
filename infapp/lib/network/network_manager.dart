/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wstalk/wstalk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config_manager.dart';
import 'inf.pb.dart';

class NetworkManager extends StatelessWidget {
  const NetworkManager({
    Key key,
    this.overrideUri,
    this.child,
  }) : super(key: key);

  final String overrideUri;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    String ks = key.toString();
    return new _NetworkManagerStateful(
      key: (key != null && ks.length > 0) ? new Key(ks + '.Stateful') : null,
      networkManager: this,
      child: child,
      config: ConfigManager.of(context),
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

  TalkSocket _ts;

  void syncConfig() {
    print("[INF] Sync config changes to network");
    if (_config != widget.config) {
      _config = widget.config;
      socialMedia.length = _config.oauthProviders.all.length; // Match array length
    }
  }

  /// Authenticate device connection, this process happens as if by magic
  Future<bool> _authenticateDevice(TalkSocket ts) async {
    // Initialize connection
    print("[INF] Authenticate device");
    ts.sendMessage(TalkSocket.encode("INFAPP"), new Uint8List(0));

    // TODO: We'll use an SQLite database to keep the local cache stored
    int localAccountId = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String aesKey;
    try {
      aesKey = prefs.getString('aes_key_$localAccountId');
    } catch (e) { }
    if (aesKey == null || aesKey.length == 0) {
      // Authenticate existing device
      
    } else {
      // Create new device

    }

    // assert(accountState.deviceId != 0);
  }

  Future _networkLoop() async {
    print("[INF] Start network loop");
    while (true) {
      try {
        do {
          try {
            print("[INF] Try connect to ${widget.networkManager.overrideUri}");
            _ts = await TalkSocket.connect(widget.networkManager.overrideUri);
          } catch (e) {
            print("[INF] Network cannot connect, retry in 3 seconds: $e");
            assert(_ts == null);
            connected = NetworkConnectionState.Offline;
            await new Future.delayed(new Duration(seconds: 3));
          }
        } while (true && (_ts == null));
        Future listen = _ts.listen();
        if (connected == NetworkConnectionState.Offline) {
          connected = NetworkConnectionState.Connecting;
        }
        // Authenticate device, this will set connected = Ready when successful
        _authenticateDevice(_ts).catchError((e) {
          print("[INF] Network authentication exception: $e");
          _ts.close();
          connected = NetworkConnectionState.Failing;
        });
        await listen;
        _ts = null;
        if (connected == NetworkConnectionState.Ready) {
          connected = NetworkConnectionState.Connecting;
        }
      } catch (e) {
        print("[INF] Network loop exception: $e");
        TalkSocket ts = _ts;
        _ts = null;
        connected = NetworkConnectionState.Failing;
        ts.close(); // TODO: change code?
      }
    }
  }

  @override
  void initState() {
    super.initState();

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
    }
  }

  @override
  void dispose() {
    // ...
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
