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
import 'package:wstalk/wstalk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;
import 'package:mime/mime.dart';
import 'package:crypto/crypto.dart';

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

  static NetworkInterface of(BuildContext context) {
    final _InheritedNetworkManager inherited =
        context.inheritFromWidgetOfExactType(_InheritedNetworkManager);
    return inherited != null ? inherited.networkInterface : null;
  }

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

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  String toString() {
    return "NetworkException { message: \"$message\" }";
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

  @override
  _NetworkManagerState createState() => new _NetworkManagerState();
}

class _NetworkManagerState extends State<_NetworkManagerStateful>
    implements NetworkInterface {
  // see NetworkInterface

  DataAccount account;
  NetworkConnectionState connected = NetworkConnectionState.Connecting;

  int _changed = 0; // trick to ensure rebuild
  ConfigData _config;

  bool _alive;
  TalkSocket _ts;

  final random = new Random.secure();

  void syncConfig() {
    // May only be called from a setState block
    if (_config != widget.config) {
      print("[INF] Sync config changes to network");
      _config = widget.config;
      if (_config != null) {
        // Match array length
        for (int i = account.detail.socialMedia.length;
            i < _config.oauthProviders.all.length;
            ++i) {
          account.detail.socialMedia.add(new DataSocialMedia());
        }
        account.detail.socialMedia.length = _config.oauthProviders.all.length;
      }
      ++_changed;
    }
    if (_config == null) {
      print(
          "[INF] Widget config is null in network sync"); // DEVELOPER - CRITICAL
    }
  }

  void receivedDeviceAuthState(NetDeviceAuthState pb) {
    print("NetDeviceAuthState: $pb");
    setState(() {
      if (pb.data.state.accountId != account.state.accountId) {
        // Any cache cleanup may be done here when switching accounts
        _offers.clear();
        _offersLoaded = false;
      }
      account = pb.data;
      for (int i = account.detail.socialMedia.length;
          i < _config.oauthProviders.all.length;
          ++i) {
        account.detail.socialMedia.add(new DataSocialMedia());
      }
      account.detail.socialMedia.length = _config.oauthProviders.all.length;
      ++_changed;
    });
  }

  /// Authenticate device connection, this process happens as if by magic
  Future _authenticateDevice(TalkSocket ts) async {
    // Initialize connection
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

    // Basic info from preferences
    // Generate a common device id to identify devices with mutiple accounts
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String commonDeviceIdStr;
    try {
      commonDeviceIdStr = prefs.getString('common_device_id');
    } catch (e) {}
    Uint8List commonDeviceId;
    if (commonDeviceIdStr == null || commonDeviceIdStr.length == 0) {
      commonDeviceId = new Uint8List(32);
      for (int i = 0; i < commonDeviceId.length; ++i) {
        commonDeviceId[i] = random.nextInt(256);
      }
      commonDeviceIdStr = base64.encode(commonDeviceId);
      prefs.setString('common_device_id', commonDeviceIdStr);
    } else {
      commonDeviceId = base64.decode(commonDeviceIdStr);
    }

    // Original plan was to use an assymetric key pair, but the generation was too slow. Hence just using a symmetric AES key for now
    int localAccountId = widget.networkManager.localAccountId;
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
      if (attemptDeviceId != account.state.deviceId) {
        account.state.deviceId = 0;
      }
    } catch (e) {}
    if (aesKey == null ||
        aesKey.length == 0 ||
        attemptDeviceId == null ||
        attemptDeviceId == 0) {
      // Create new device
      print("[INF] Create new device");
      account.state.deviceId = 0;
      aesKey = new Uint8List(32);
      for (int i = 0; i < aesKey.length; ++i) {
        aesKey[i] = random.nextInt(256);
      }
      aesKeyStr = base64.encode(aesKey);
      NetDeviceAuthCreateReq pbReq = new NetDeviceAuthCreateReq();
      pbReq.aesKey = aesKey;
      pbReq.commonDeviceId = commonDeviceId;
      pbReq.name = deviceName;
      pbReq.info = "{ debug: 'default_info' }";

      TalkMessage res = await ts.sendRequest(
          TalkSocket.encode("DA_CREAT"), pbReq.writeToBuffer());
      NetDeviceAuthState pbRes = new NetDeviceAuthState();
      pbRes.mergeFromBuffer(res.data);
      if (!_alive) {
        throw Exception("No longer alive, don't authorize");
      }
      receivedDeviceAuthState(pbRes);
      print("[INF] Device id ${account.state.deviceId}");
      if (account.state.deviceId != 0) {
        prefs.setString(aesKeyPref, aesKeyStr);
        prefs.setInt(deviceIdPref, account.state.deviceId);
      }
    } else {
      // Authenticate existing device
      print("[INF] Authenticate existing device $attemptDeviceId");

      NetDeviceAuthChallengeReq pbChallengeReq =
          new NetDeviceAuthChallengeReq();
      pbChallengeReq.deviceId = attemptDeviceId;
      TalkMessage msgChallengeResReq = await ts.sendRequest(
          TalkSocket.encode("DA_CHALL"), pbChallengeReq.writeToBuffer());
      NetDeviceAuthChallengeResReq pbChallengeResReq =
          new NetDeviceAuthChallengeResReq();
      pbChallengeResReq.mergeFromBuffer(msgChallengeResReq.data);

      // Sign challenge
      var keyParameter = new pointycastle.KeyParameter(aesKey);
      var aesFastEngine = new pointycastle.AESFastEngine();
      aesFastEngine
        ..reset()
        ..init(true, keyParameter);
      Uint8List challenge = pbChallengeResReq.challenge;
      Uint8List signature = new Uint8List(challenge.length);
      for (int offset = 0; offset < challenge.length;) {
        offset +=
            aesFastEngine.processBlock(challenge, offset, signature, offset);
      }

      // Send signature, wait for device status
      NetDeviceAuthSignatureResReq pbSignature =
          new NetDeviceAuthSignatureResReq();
      pbSignature.signature = signature;
      TalkMessage res = await ts.sendRequest(
          TalkSocket.encode("DA_R_SIG"), pbSignature.writeToBuffer(),
          replying: msgChallengeResReq);
      NetDeviceAuthState pbRes = new NetDeviceAuthState();
      pbRes.mergeFromBuffer(res.data);
      if (!_alive) {
        throw Exception("No longer alive, don't authorize");
      }
      receivedDeviceAuthState(pbRes);
      print("[INF] Device id ${account.state.deviceId}");
    }

    if (account.state.deviceId == 0) {
      throw new Exception("Authentication did not succeed");
    } else {
      print("[INF] Network connection is ready");
      setState(() {
        connected = NetworkConnectionState.Ready;
        ++_changed;
      });

      // Register all listeners
      ts.stream(TalkSocket.encode('DA_STATE')).listen(_netDeviceAuthState);
      ts.stream(TalkSocket.encode("DB_OFFER")).listen(_dataBusinessOffer);
    }

    // assert(accountState.deviceId != 0);
  }

  void _netDeviceAuthState(TalkMessage message) {
    NetDeviceAuthState pb = new NetDeviceAuthState();
    pb.mergeFromBuffer(message.data);
    receivedDeviceAuthState(pb);
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
          setState(() {
            connected = NetworkConnectionState.Offline;
            ++_changed;
          });
          await new Future.delayed(new Duration(seconds: 3));
        }
      } while (_alive && (_ts == null));
      Future listen = _ts.listen();
      if (connected == NetworkConnectionState.Offline) {
        setState(() {
          connected = NetworkConnectionState.Connecting;
          ++_changed;
        });
      }
      if (_config != null && widget.networkManager.localAccountId != 0) {
        if (_alive) {
          // Authenticate device, this will set connected = Ready when successful
          _authenticateDevice(_ts).catchError((e) {
            print(
                "[INF] Network authentication exception, retry in 3 seconds: $e");
            setState(() {
              connected = NetworkConnectionState.Failing;
              ++_changed;
            });
            TalkSocket ts = _ts;
            _ts = null;
            () async {
              print("[INF] Wait");
              await new Future.delayed(new Duration(seconds: 3));
              print("[INF] Retry now");
              if (ts != null) {
                ts.close();
              }
            }()
                .catchError((e) {
              print("[INF] Fatal network exception, cannot recover: $e");
            });
          });
        } else {
          _ts.close();
        }
      } else {
        print(
            "[INF] No configuration, connection will remain idle, local account id ${widget.networkManager.localAccountId}");
        setState(() {
          connected = NetworkConnectionState.Failing;
          ++_changed;
        });
      }
      await listen;
      _ts = null;
      print("[INF] Network connection closed");
      if (connected == NetworkConnectionState.Ready) {
        setState(() {
          connected = NetworkConnectionState.Connecting;
          ++_changed;
        });
      }
    } catch (e) {
      print("[INF] Network session exception: $e");
      TalkSocket ts = _ts;
      _ts = null;
      setState(() {
        connected = NetworkConnectionState.Failing;
        ++_changed;
      });
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
    account = new DataAccount();
    account.state = new DataAccountState();
    account.summary = new DataAccountSummary();
    account.detail = new DataAccountDetail();
    syncConfig();

    // Start network loop
    _networkLoop().catchError((e) {
      print("[INF] Network loop died: $e");
    });

    new Timer.periodic(new Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_ts != null) {
        try {
          await _ts.ping();
        } catch (error, stack) {
          print("[INF] [PING] $error\n$stack");
        }
      }
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
      key: (widget.key != null && ks.length > 0)
          ? new Key(ks + '.Inherited')
          : null,
      networkInterface: this,
      changed: _changed,
      child: widget.child,
    );
  }

  /* Device Registration */
  static int _netSetAccountType = TalkSocket.encode("A_SETTYP");
  @override
  void setAccountType(AccountType accountType) {
    NetSetAccountType pb = new NetSetAccountType();
    pb.accountType = accountType;
    _ts.sendMessage(_netSetAccountType, pb.writeToBuffer());
    setState(() {
      // Cancel all social media logins on change, server update on this gets there later
      if (account.state.accountType != accountType) {
        for (int i = 0; i < account.detail.socialMedia.length; ++i) {
          account.detail.socialMedia[i].connected = false;
        }
      }
      // Ghost state, the server doesn't send update for this
      account.state.accountType = accountType;
      ++_changed;
    });
  }

  /* OAuth */
  static int _netOAuthUrlReq = TalkSocket.encode("OA_URLRE");
  @override
  Future<NetOAuthUrlRes> getOAuthUrls(int oauthProvider) async {
    NetOAuthUrlReq pb = new NetOAuthUrlReq();
    pb.oauthProvider = oauthProvider;
    TalkMessage res =
        await _ts.sendRequest(_netOAuthUrlReq, pb.writeToBuffer());
    NetOAuthUrlRes resPb = new NetOAuthUrlRes();
    resPb.mergeFromBuffer(res.data);
    return resPb;
  }

  static int _netOAuthConnectReq = TalkSocket.encode("OA_CONNE");
  @override
  Future<bool> connectOAuth(int oauthProvider, String callbackQuery) async {
    NetOAuthConnectReq pb = new NetOAuthConnectReq();
    pb.oauthProvider = oauthProvider;
    pb.callbackQuery = callbackQuery;
    TalkMessage res =
        await _ts.sendRequest(_netOAuthConnectReq, pb.writeToBuffer());
    NetOAuthConnectRes resPb = new NetOAuthConnectRes();
    resPb.mergeFromBuffer(res.data);
    // Result contains the updated data, so needs to be put into the state
    if (oauthProvider < account.detail.socialMedia.length &&
        resPb.socialMedia != null) {
      setState(() {
        account.detail.socialMedia[oauthProvider] = resPb.socialMedia;
        ++_changed;
      });
    }
    // Return just whether connected or not
    return resPb.socialMedia.connected;
  }

  static int _netAccountCreateReq = TalkSocket.encode("A_CREATE");
  @override
  Future<Null> createAccount(double latitude, double longitude) async {
    NetAccountCreateReq pb = new NetAccountCreateReq();
    if (latitude != null &&
        latitude != 0.0 &&
        longitude != null &&
        longitude != 0.0) {
      pb.latitude = latitude;
      pb.longitude = longitude;
    }
    TalkMessage res =
        await _ts.sendRequest(_netAccountCreateReq, pb.writeToBuffer());
    NetDeviceAuthState resPb = new NetDeviceAuthState();
    resPb.mergeFromBuffer(res.data);
    receivedDeviceAuthState(resPb);
    if (account.state.accountId == 0) {
      throw new NetworkException("No account has been created");
    }
  }

  static int _netUploadImageReq = TalkSocket.encode("UP_IMAGE");
  @override
  Future<NetUploadImageRes> uploadImage(FileImage fileImage) async {
    // Build information on file
    BytesBuilder builder = new BytesBuilder(copy: false);
    Digest contentSha256 = await sha256.bind(fileImage.file.openRead()).first;
    await fileImage.file.openRead(0, 256).forEach(builder.add);
    String contentType = new MimeTypeResolver()
        .lookup(fileImage.file.path, headerBytes: builder.toBytes());
    int contentLength = await fileImage.file.length();

    NetUploadImageReq req = new NetUploadImageReq();
    req.fileName = fileImage.file.path;
    req.contentLength = contentLength;
    req.contentType = contentType;
    req.contentSha256 = contentSha256.bytes;

    TalkMessage resMessage =
        await _ts.sendRequest(_netUploadImageReq, req.writeToBuffer());
    NetUploadImageRes res = new NetUploadImageRes();
    res.mergeFromBuffer(resMessage.data);

    if (res.fileExists) {
      // File already exists, so no need to upload it again
      return res;
    }

    HttpClient httpClient = new HttpClient();
    HttpClientRequest httpRequest =
        await httpClient.openUrl(res.requestMethod, Uri.parse(res.requestUrl));
    httpRequest.headers.add("Content-Type", contentType);
    httpRequest.headers.add("Content-Length", contentLength);
    httpRequest.headers.add('x-amz-acl', 'public-read');
    await httpRequest.addStream(fileImage.file.openRead());
    await httpRequest.flush();
    HttpClientResponse httpResponse = await httpRequest.close();
    BytesBuilder responseBuilder = new BytesBuilder(copy: false);
    await httpResponse.forEach(builder.add);
    if (httpResponse.statusCode != 200) {
      throw new NetworkException(
          "Status code ${httpResponse.statusCode}, response: ${utf8.decode(responseBuilder.toBytes())}");
    }

    // Upload successful
    return res;
  }

  static int _netCreateOfferReq = TalkSocket.encode("C_OFFERR");
  @override
  Future<DataBusinessOffer> createOffer(
      NetCreateOfferReq createOfferReq) async {
    TalkMessage res = await _ts.sendRequest(
        _netCreateOfferReq, createOfferReq.writeToBuffer());
    DataBusinessOffer resPb = new DataBusinessOffer();
    resPb.mergeFromBuffer(res.data);
    setState(() {
      // Add resulting offer to known offers
      _offers[resPb.offerId.toInt()] = resPb;
      ++_changed;
    });
    return resPb;
  }

  void _dataBusinessOffer(TalkMessage message) {
    DataBusinessOffer pb = new DataBusinessOffer();
    pb.mergeFromBuffer(message.data);
    if (pb.accountId == account.state.accountId) {
      setState(() {
        // Add received offer to known offers
        _offers[pb.offerId.toInt()] = pb;
        ++_changed;
      });
    } else {
      print("[INF] Received offer for other account ${pb.accountId}");
    }
  }

  static int _netLoadOffersReq = TalkSocket.encode("L_OFFERS");
  @override
  Future<void> refreshOffers() async {
    NetLoadOffersReq loadOffersReq =
        new NetLoadOffersReq(); // TODO: Specific requests for higher and lower refreshing
    await _ts.sendRequest(_netLoadOffersReq,
        loadOffersReq.writeToBuffer()); // TODO: Use response data maybe
  }

  bool _offersLoaded;
  Map<int, DataBusinessOffer> _offers = new Map<int, DataBusinessOffer>();

  @override
  Map<int, DataBusinessOffer> get offers {
    if (_offersLoaded == false && connected == NetworkConnectionState.Ready) {
      _offersLoaded = true;
      if (account.state.accountType == AccountType.AT_BUSINESS) {
        offersLoading = true;
        refreshOffers().catchError((error, stack) {
          print("[INF] Failed to get offers: $error, $stack");
          new Timer(new Duration(seconds: 3), () {
            _offersLoaded =
                false; // Not using setState since we don't want to broadcast failure state
          });
        }).whenComplete(() {
          offersLoading = false;
        });
      }
    }
    return _offers;
  }

  @override
  bool offersLoading = false;

/*
  @override
  set offers(Map<int, DataBusinessOffer> _offers) {
    // TODO: implement offers
  }*/
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
    return this.changed != old.changed;
  }
}

enum NetworkConnectionState { Connecting, Failing, Offline, Ready }

abstract class NetworkInterface {
  /* Cached Data */
  /// Cached account state. Use this data directly from your build function
  DataAccount account;

  /// Whether we are connected to the network.
  NetworkConnectionState connected;

  /// List of offers owned by this account (applicable for AT_BUSINESS)
  Map<int, DataBusinessOffer> get offers;

  /// Whether [offers] is in the process of loading. Not set by refreshOffers call
  bool offersLoading;

  /* Device Registration */
  /// Set account type. Only possible when not yet created.
  void setAccountType(AccountType accountType);

  /* OAuth */
  /// Get the URLs to use for the OAuth process
  Future<NetOAuthUrlRes> getOAuthUrls(int oauthProvider);

  /// Try to connect an OAuth provider with the received callback query
  Future<bool> connectOAuth(int oauthProvider, String callbackQuery);

  /// Create an account
  Future<Null> createAccount(double latitude, double longitude);

  /// Upload an image. Disregard the returned request options. Throws error in case of failure
  Future<NetUploadImageRes> uploadImage(FileImage fileImage);

  /// Create an offer.
  Future<DataBusinessOffer> createOffer(NetCreateOfferReq createOfferReq);

  /// Refresh all offers (currently latest offers)
  Future<void> refreshOffers();
}

/* end of file */
