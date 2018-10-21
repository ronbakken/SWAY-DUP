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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_generic/network_offers_business.dart';
import 'package:inf/network_generic/network_offers_demo.dart';
import 'package:wstalk/wstalk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;
import 'package:mime/mime.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart';

import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_generic/network_offers.dart';
import 'package:inf/network_generic/network_profiles.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_generic/network_interface.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

export 'package:inf/network_generic/network_interface.dart';

// TODO: Reassemble should re-merge all protobuf

class NetworkManager extends StatelessWidget {
  const NetworkManager({
    Key key,
    this.child,
    this.multiAccountStore,
  }) : super(key: key);

  final Widget child;
  final MultiAccountStore multiAccountStore;

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
      multiAccountStore: multiAccountStore,
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
    this.multiAccountStore,
  }) : super(key: key);

  final NetworkManager networkManager;
  final Widget child;
  final ConfigData config;
  final MultiAccountStore multiAccountStore;

  @override
  _NetworkManagerState createState() => new _NetworkManagerState();
}

class _NetworkManagerState extends State<_NetworkManagerStateful>
    with
        WidgetsBindingObserver,
        NetworkProfiles,
        NetworkOffers,
        NetworkOffersBusiness,
        NetworkOffersDemo
    implements NetworkInterface, NetworkInternals {
  // see NetworkInterface

  LocalAccountData _currentLocalAccount;
  DataAccount account;
  NetworkConnectionState connected = NetworkConnectionState.Connecting;

  int _changed = 0; // trick to ensure rebuild
  ConfigData _config;

  bool _alive;
  TalkSocket _ts;

  TalkSocket get ts {
    return _ts;
  }

  String _overrideUri;

  final random = new Random.secure();

  int nextDeviceGhostId;

  bool _firebaseSetup = false;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationDetails platformChannelSpecifics;

  List<StreamSubscription<TalkMessage>> _subscriptions =
      new List<StreamSubscription<TalkMessage>>();

  List<int> _suppressChatNotifications = new List<int>();

  int _keepAliveBackground = 0;

  void pushKeepAlive() {
    ++_keepAliveBackground;
  }

  void popKeepAlive() {
    --_keepAliveBackground;
  }

  void onProfileChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onOfferChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onOffersBusinessChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  void onOffersDemoChanged(ChangeAction action, Int64 id) {
    setState(() {
      ++_changed;
    });
  }

  @override
  void overrideUri(String serverUri) {
    _overrideUri = serverUri;
    print("[INF] Override server uri to $serverUri");
    if (_ts != null) {
      _ts.close();
      _ts = null;
    }
  }

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

  void cleanupStateSwitchingAccounts() {
    resetProfilesState();
    resetOffersState();
    resetOffersBusinessState();
    resetOffersDemoState();
    _applicants.clear();
    _applicantsLoaded = false;
    _cachedApplicants.clear();
    resetAccountState();
  }

  void resetAccountState() {
    account = emptyAccount(); //..freeze();
  }

  Future<void> receivedDeviceAuthState(NetDeviceAuthState pb) async {
    print("NetDeviceAuthState: $pb");
    setState(() {
      if (pb.data.state.accountId != account.state.accountId) {
        // Any cache cleanup may be done here when switching accounts
        cleanupStateSwitchingAccounts();
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
    if (pb.data.state.accountId != 0) {
      // Update local account store
      widget.multiAccountStore.setAccountId(
          _currentLocalAccount.domain,
          _currentLocalAccount.localId,
          new Int64(account.state.accountId),
          account.state.accountType);
      widget.multiAccountStore.setNameAvatar(
          _currentLocalAccount.domain,
          _currentLocalAccount.localId,
          account.summary.name,
          account.summary.blurredAvatarThumbnailUrl,
          account.summary.avatarThumbnailUrl);
      // Mark all caches as dirty, since we may have been offline for a while
      markProfilesDirty();
      markOffersDirty();
      markOffersBusinessDirty();
      markOffersDemoDirty();
      _applicantsLoaded = false;
      _cachedApplicants.values.forEach((cached) {
        cached.dirty = true;
        cached.chatLoaded = false;
      });
      if (!_firebaseSetup) {
        // Set up Firebase
        _firebaseSetup = true;
        _firebaseMessaging.requestNotificationPermissions();
        _firebaseMessaging.configure(
          onMessage: _firebaseOnMessage,
          onLaunch: _firebaseOnLaunch,
          onResume: _firebaseOnResume,
        );
        _firebaseMessaging.onTokenRefresh.listen(
            _firebaseOnToken); // Ensure network manager is persistent or this may fail
        if (widget.config.services.domain.isNotEmpty) {
          // Allows to send dev messages under domain_dev topic
          print("[INF] Domain: ${widget.config.services.domain}");
          _firebaseMessaging
              .subscribeToTopic('domain_' + widget.config.services.domain);
        }
      }
      _firebaseOnToken(await _firebaseMessaging.getToken());
    }
  }

  void _firebaseOnToken(String token) async {
    // Set firebase token for current account if it has changed
    // Update it for other accounts as well in case there is a known old token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oldFirebaseToken;
    try {
      oldFirebaseToken = prefs.getString('firebase_token');
    } catch (error) {}
    if (account.state.accountId != 0) {
      if (account.state.firebaseToken != token || oldFirebaseToken != token) {
        account.state.firebaseToken = token;
        NetSetFirebaseToken setFirebaseToken = new NetSetFirebaseToken();
        if (oldFirebaseToken != null)
          setFirebaseToken.oldFirebaseToken = oldFirebaseToken;
        setFirebaseToken.firebaseToken = token;
        _ts.sendMessage(
            TalkSocket.encode("SFIREBAT"), setFirebaseToken.writeToBuffer());
        prefs.setString('firebase_token', token);
      }
    }
  }

  @override
  void pushSuppressChatNotifications(Int64 applicantId) {
    _suppressChatNotifications.add(applicantId.toInt());
  }

  @override
  void popSuppressChatNotifications() {
    _suppressChatNotifications.removeLast();
  }

  Future<dynamic> _firebaseOnMessage(Map<String, dynamic> data) async {
    print("[INF] Firebase Message Received");
    // Fired when a message is received when the app is in foreground
    print(data);
    // Handle all notifications not meant for the current account
    // And any current notifications which are not surpressed
    String domain = data['data']['domain'].toString();
    int accountId = int.tryParse(data['data']['account_id']);
    int applicantId = int.tryParse(data['data']['applicant_id']);
    String title = data['notification']['title'];
    String body = data['notification']['body'];
    if (_suppressChatNotifications.isEmpty ||
        _suppressChatNotifications.last != applicantId ||
        domain != _config.services.domain ||
        accountId != account.state.accountId) {
      await flutterLocalNotificationsPlugin.show(
        applicantId,
        title,
        body,
        platformChannelSpecifics,
        payload:
            'domain=$domain&account_id=$accountId&applicant_id=$applicantId',
      );
    }
  }

  Future<dynamic> _firebaseOnLaunch(Map<String, dynamic> data) async {
    print("[INF] Firebase Launch Received: $data");
    // Fired when the app was opened by a message
    if (data['applicant_id'] != null) {
      CrossAccountNavigation.of(context).navigate(
          data['domain'],
          Int64.parseInt(data['account_id']),
          NavigationTarget.Proposal,
          Int64.parseInt(data['applicant_id']));
    }
  }

  Future<dynamic> _firebaseOnResume(Map<String, dynamic> data) async {
    print("[INF] Firebase Resume Received: $data");
    // Fired when the app was opened by a message
    /*{collapse_key: app.infmarketplace, 
    account_id: 10, 
    applicant_id: 16, 
    google.original_priority: high, 
    google.sent_time: 1537966114567, 
    google.delivered_priority: high, 
    domain: dev, google.ttl: 2419200, 
    from: 1051755311348, type: 0, 
    google.message_id: 0:1537966114577353%ddd1e337ddd1e337, 
    sender_id: 11}*/
    if (data['applicant_id'] != null) {
      CrossAccountNavigation.of(context).navigate(
          data['domain'],
          Int64.parseInt(data['account_id']),
          NavigationTarget.Proposal,
          Int64.parseInt(data['applicant_id']));
    }
  }

  Future<dynamic> onSelectNotification(String payload) async {
    if (payload != null) {
      print('[INF] Local notification payload: ' + payload);
      /*domain=dev&account_id=10&applicant_id=16*/
      Map<String, String> data = Uri.splitQueryString(payload);
      if (data['applicant_id'] != null) {
        CrossAccountNavigation.of(context).navigate(
            data['domain'],
            Int64.parseInt(data['account_id']),
            NavigationTarget.Proposal,
            Int64.parseInt(data['applicant_id']));
      }
    }
  }

  /// Authenticate device connection, this process happens as if by magic
  Future<void> _authenticateDevice(TalkSocket ts) async {
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
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
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
    }*/
    final Uint8List commonDeviceId =
        widget.multiAccountStore.getCommonDeviceId();
    final LocalAccountData localAccount = widget.multiAccountStore.current;
    final Uint8List aesKey = widget.multiAccountStore
        .getDeviceCookie(localAccount.domain, localAccount.localId);
    _currentLocalAccount = localAccount;

    // Original plan was to use an assymetric key pair, but the generation was too slow. Hence just using a symmetric AES key for now
    /*
    int localAccountId = widget.networkManager.localAccountId;
    String aesKeyPref =
        widget.config.services.domain + '_aes_key_$localAccountId';
    String deviceIdPref =
        widget.config.services.domain + '_device_id_$localAccountId';
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
    */
    if (localAccount.deviceId == null || localAccount.deviceId == 0) {
      // Create new device
      print("[INF] Create new device");
      account.state.deviceId = 0;
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
      await receivedDeviceAuthState(pbRes);
      print("[INF] Device id ${account.state.deviceId}");
      if (account.state.deviceId != 0) {
        widget.multiAccountStore.setDeviceId(localAccount.domain,
            localAccount.localId, new Int64(account.state.deviceId), aesKey);
      }
    } else {
      // Authenticate existing device
      print("[INF] Authenticate existing device ${localAccount.deviceId}");

      NetDeviceAuthChallengeReq pbChallengeReq =
          new NetDeviceAuthChallengeReq();
      pbChallengeReq.deviceId = localAccount.deviceId.toInt();
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
      await receivedDeviceAuthState(pbRes);
      print("[INF] Device id ${account.state.deviceId}");
    }

    if (account.state.deviceId == 0) {
      widget.multiAccountStore
          .removeLocal(localAccount.domain, localAccount.localId);
      widget.multiAccountStore.addAccount(localAccount.domain);
      _currentLocalAccount = null;
      throw new Exception("Authentication did not succeed");
    } else {
      print("[INF] Network connection is ready");
      setState(() {
        connected = NetworkConnectionState.Ready;
        ++_changed;
      });

      // Register all listeners
      _subscriptions.add(
          ts.stream(TalkSocket.encode('DA_STATE')).listen(_netDeviceAuthState));
      _subscriptions.add(ts
          .stream(TalkSocket.encode("DB_OFFER"))
          .listen(dataBusinessOffer)); // TODO: Remove this!
      //_subscriptions.add(ts
      //    .stream(TalkSocket.encode("DE_OFFER"))
      //    .listen(_demoAllBusinessOffer));
      // LN_APPLI, LN_A_CHA, LU_APPLI, LU_A_CHA
      _subscriptions.add(
          ts.stream(TalkSocket.encode('LN_APPLI')).listen(_liveNewApplicant));
      _subscriptions.add(ts
          .stream(TalkSocket.encode('LN_A_CHA'))
          .listen(_liveNewApplicantChat));
      _subscriptions.add(ts
          .stream(TalkSocket.encode('LU_APPLI'))
          .listen(_liveUpdateApplicant));
      _subscriptions.add(ts
          .stream(TalkSocket.encode('LU_A_CHA'))
          .listen(_liveUpdateApplicantChat));

      _resubmitGhostChats();
    }

    // assert(accountState.deviceId != 0);
  }

  void _netDeviceAuthState(TalkMessage message) async {
    NetDeviceAuthState pb = new NetDeviceAuthState();
    pb.mergeFromBuffer(message.data);
    await receivedDeviceAuthState(pb);
  }

  bool _netConfigWarning = false;
  Future _networkSession() async {
    try {
      do {
        String uri = _overrideUri ??
            _config.services
                .apiHosts[random.nextInt(_config.services.apiHosts.length)];
        if (uri == null || uri.length == 0) {
          if (!_netConfigWarning) {
            _netConfigWarning = true;
            print("[INF] No network configuration, not connecting");
          }
          await new Future.delayed(new Duration(seconds: 3));
          return;
        }
        _netConfigWarning = false;
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
      } while (_alive &&
          (_foreground || (_keepAliveBackground > 0)) &&
          (_ts == null));
      Future<void> listen = _ts.listen();
      if (connected == NetworkConnectionState.Offline) {
        setState(() {
          connected = NetworkConnectionState.Connecting;
          ++_changed;
        });
      }
      if (_config != null /*&& widget.networkManager.localAccountId != 0*/) {
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
            "[INF] No configuration, connection will remain idle"); // , local account id ${widget.networkManager.localAccountId}");
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
    _subscriptions.forEach((s) {
      s.cancel();
    });
    _subscriptions.clear();
  }

  Future _networkLoop() async {
    print("[INF] Start network loop");
    while (_alive) {
      if (!_foreground && (_keepAliveBackground <= 0)) {
        print("[INF] Awaiting foreground");
        _awaitingForeground = new Completer<void>();
        await _awaitingForeground.future;
        print("[INF] Now in foreground");
      }
      await _networkSession();
    }
    print("[INF] End network loop");
  }

  StreamSubscription<LocalAccountData> _onSwitchAccountSubscription;

  @override
  void initState() {
    super.initState();
    _alive = true;

    // Device ghost id is a semi sequential identifier for identifying messages by device (to ensure all are sent and to avoid duplicates)
    nextDeviceGhostId =
        (new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF;

    // Setup sync
    _onSwitchAccountSubscription =
        widget.multiAccountStore.onSwitchAccount.listen(_onMultiSwitchAccount);

    // Initialize data
    resetAccountState();
    syncConfig();

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'chat', 'Messages', 'Messages received from other users',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    // Start network loop
    _networkLoop().catchError((e) {
      print("[INF] Network loop died: $e");
    });

    WidgetsBinding.instance.addObserver(this);

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
    _onSwitchAccountSubscription.cancel();
    _onSwitchAccountSubscription = null;
    WidgetsBinding.instance.removeObserver(this);
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
  }

  @override
  void didChangeDependencies() {
    // Called before build(), may change/update any state here without calling setState()
    super.didChangeDependencies();
    syncConfig();
    if (_ts != null) {
      print("[INF] Network reload by config or selection");
      _ts.close();
      _ts = null;
    }
  }

  void _onMultiSwitchAccount(LocalAccountData localAccount) {
    if (localAccount != _currentLocalAccount) {
      cleanupStateSwitchingAccounts();
      if (_ts != null) {
        _ts.close();
        _ts = null;
      }
    }
  }

  bool _foreground = true;
  Completer<void> _awaitingForeground;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed &&
        state != AppLifecycleState.inactive) {
      _foreground = false;
      if (_keepAliveBackground <= 0) {
        if (_ts != null) {
          _ts.close();
          _ts = null;
        }
      }
    } else {
      _foreground = true;
      if (_awaitingForeground != null) {
        _awaitingForeground.complete();
        _awaitingForeground = null;
      }
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
  Future<void> createAccount(double latitude, double longitude) async {
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
    await receivedDeviceAuthState(resPb);
    if (account.state.accountId == 0) {
      throw new NetworkException("No account has been created");
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Image upload
  /////////////////////////////////////////////////////////////////////////////

  static Digest _getContentSha256(File file) {
    DigestSink convertedSink = new DigestSink();
    ByteConversionSink fileSink = sha256.startChunkedConversion(convertedSink);
    RandomAccessFile readFile = file.openSync(mode: FileMode.read);
    Uint8List buffer = new Uint8List(65536);
    int read;
    while ((read = readFile.readIntoSync(buffer)) > 0) {
      fileSink.addSlice(buffer, 0, read, false);
    }
    fileSink.close();
    return convertedSink.value;
  }

  static int _netUploadImageReq = TalkSocket.encode("UP_IMAGE");
  @override
  Future<NetUploadImageRes> uploadImage(FileImage fileImage) async {
    // Build information on file
    BytesBuilder builder = new BytesBuilder(copy: false);
    // Digest contentSha256 =
    //     await sha256.bind(fileImage.file.openRead()).first; // FIXME: This hangs
    Digest contentSha256 = await compute(_getContentSha256, fileImage.file);
    await fileImage.file.openRead(0, 256).forEach(builder.add);
    String contentType = new MimeTypeResolver()
        .lookup(fileImage.file.path, headerBytes: builder.toBytes());
    int contentLength = await fileImage.file.length();

    // Create a request to upload the file
    NetUploadImageReq req = new NetUploadImageReq();
    req.fileName = fileImage.file.path;
    req.contentLength = contentLength;
    req.contentType = contentType;
    req.contentSha256 = contentSha256.bytes;

    // Fetch the pre-signed URL from the server
    TalkMessage resMessage =
        await _ts.sendRequest(_netUploadImageReq, req.writeToBuffer());
    NetUploadImageRes res = new NetUploadImageRes();
    res.mergeFromBuffer(resMessage.data);

    if (res.fileExists) {
      // File already exists, so no need to upload it again
      return res;
    }

    // Upload the file
    HttpClient httpClient = new HttpClient();
    HttpClientRequest httpRequest =
        await httpClient.openUrl(res.requestMethod, Uri.parse(res.requestUrl));
    httpRequest.headers.add("Content-Type", contentType);
    httpRequest.headers.add("Content-Length", contentLength);
    // FIXME: Spaces doesn't process this option when in pre-signed URL query
    httpRequest.headers.add('x-amz-acl', 'public-read');
    await httpRequest.addStream(fileImage.file.openRead());
    await httpRequest.flush();
    HttpClientResponse httpResponse = await httpRequest.close();
    BytesBuilder responseBuilder = new BytesBuilder(copy: false);
    await httpResponse.forEach(responseBuilder.add);
    if (httpResponse.statusCode != 200) {
      throw new NetworkException(
          "Status code ${httpResponse.statusCode}, response: ${utf8.decode(responseBuilder.toBytes())}");
    }

    // Upload successful
    return res;
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Business offers
  /////////////////////////////////////////////////////////////////////////////
/*
  @override
  set offers(Map<int, DataBusinessOffer> _offers) {
    // TODO: implement offers
  }*/

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Demo all offers
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Synchronization utilities
  /////////////////////////////////////////////////////////////////////////////

  /// Ensure to get the latest account data, in case we have it. Not necessary for network.account (unless detached)
  /*
  @override
  DataAccount latestAccount(DataAccount account) {
    // Check any caches if we have, otherwise just return
    // TODO: Timestamps...
    if (account.state.accountId == this.account.state.accountId) {
      // It's me...
      return this.account;
    }
    if (_cachedAccounts.containsKey(account.state.accountId)) {
      _CachedDataAccount cached = _cachedAccounts[account.state.accountId];
      if (cached.account != null) return cached.account;
      if (!cached.loading) {
        // Fetch but still use plain account
        tryGetPublicProfile(new Int64(account.state.accountId), fallback: account);
      }
    }
    return account;
  }
  */

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Get profile
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle
  /////////////////////////////////////////////////////////////////////////////

  Map<int, _CachedApplicant> _cachedApplicants =
      new Map<int, _CachedApplicant>();

  void _cacheApplicant(DataApplicant applicant) {
    _CachedApplicant cached = _cachedApplicants[applicant.applicantId];
    if (cached == null) {
      cached = new _CachedApplicant();
      _cachedApplicants[applicant.applicantId] = cached;
    }
    hintOfferProposal(applicant);
    setState(() {
      cached.fallback = null;
      cached.applicant = applicant;
      cached.dirty = false;
      if (applicant.businessAccountId == account.state.accountId ||
          applicant.influencerAccountId == account.state.accountId) {
        // Add received offer to known offers
        _applicants[applicant.applicantId] = applicant;
      }
      ++_changed;
    });
  }

  void _cacheApplicantChat(DataApplicantChat chat) {
    _CachedApplicant cached = _cachedApplicants[chat.applicantId];
    if (cached == null) {
      cached = new _CachedApplicant();
      _cachedApplicants[chat.applicantId] = cached;
    }
    setState(() {
      if (chat.deviceId == account.state.deviceId) {
        cached.ghostChats.remove(chat.deviceGhostId);
      }
      cached.chats[chat.chatId.toInt()] = chat;
      ++_changed;
    });
  }

  static int _netLoadApplicantsReq = TalkSocket.encode("L_APPLIS");
  @override
  Future<void> refreshApplicants() async {
    NetLoadOffersReq req =
        new NetLoadOffersReq(); // TODO: Specific requests for higher and lower refreshing
    await for (TalkMessage res
        in _ts.sendStreamRequest(_netLoadApplicantsReq, req.writeToBuffer())) {
      DataApplicant pb = new DataApplicant();
      pb.mergeFromBuffer(res.data);
      _cacheApplicant(pb);
    }
  }

  bool applicantsLoading = false;
  bool _applicantsLoaded = false;
  Map<int, DataApplicant> _applicants = new Map<int, DataApplicant>();

  @override
  Iterable<DataApplicant> get applicants {
    if (_applicantsLoaded == false &&
        connected == NetworkConnectionState.Ready) {
      _applicantsLoaded = true;
      applicantsLoading = true;
      refreshApplicants().catchError((error, stack) {
        print("[INF] Failed to get applicants: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          _applicantsLoaded =
              false; // Not using setState since we don't want to broadcast failure state
        });
      }).whenComplete(() {
        setState(() {
          applicantsLoading = false;
        });
      });
    }
    return _applicants.values;
  }

  static int _netOfferApplyReq = TalkSocket.encode("O_APPLYY");

  /// Create proposal
  @override
  Future<DataApplicant> applyForOffer(int offerId, String remarks) async {
    try {
      NetOfferApplyReq pbReq = new NetOfferApplyReq();
      pbReq.offerId = offerId;
      pbReq.deviceGhostId = ++nextDeviceGhostId;
      pbReq.remarks = remarks;
      TalkMessage res =
          await _ts.sendRequest(_netOfferApplyReq, pbReq.writeToBuffer());
      DataApplicant pbRes = new DataApplicant();
      pbRes.mergeFromBuffer(res.data);
      _cacheApplicant(pbRes); // FIXME: Chat not cached directly!
      return pbRes;
    } catch (error) {
      markOfferDirty(new Int64(offerId));
      rethrow;
    }
  }

  static int _netLoadApplicantReq = TalkSocket.encode("L_APPLIC");
  @override
  Future<DataApplicant> getApplicant(Int64 applicantId) async {
    NetLoadApplicantReq pbReq = new NetLoadApplicantReq();
    pbReq.applicantId = applicantId.toInt();
    TalkMessage res =
        await _ts.sendRequest(_netLoadApplicantReq, pbReq.writeToBuffer());
    DataApplicant applicant = new DataApplicant();
    applicant.mergeFromBuffer(res.data);
    _cacheApplicant(applicant);
    return applicant;
  }

  static int _netLoadApplicantChatReq = TalkSocket.encode("L_APCHAT");
  Future<void> _loadApplicantChats(int applicantId) async {
    NetLoadApplicantChatsReq pbReq = new NetLoadApplicantChatsReq();
    pbReq.applicantId = applicantId;
    print(applicantId);
    await for (TalkMessage res in _ts.sendStreamRequest(
        _netLoadApplicantChatReq, pbReq.writeToBuffer())) {
      DataApplicantChat chat = new DataApplicantChat();
      chat.mergeFromBuffer(res.data);
      print(chat);
      _cacheApplicantChat(chat);
    }
    print("done");
  }

  DataApplicant _tryGetApplicant(int applicantId,
      {DataApplicant fallback, DataBusinessOffer fallbackOffer}) {
    _CachedApplicant cached = _cachedApplicants[applicantId];
    if (cached == null) {
      cached = new _CachedApplicant();
      _cachedApplicants[applicantId] = cached;
    }
    if (cached.applicant == null || cached.dirty) {
      if (!cached.loading && connected == NetworkConnectionState.Ready) {
        cached.loading = true;
        getApplicant(new Int64(applicantId)).then((applicant) {
          cached.loading = false;
        }).catchError((error, stack) {
          print("[INF] Failed to get applicant: $error, $stack");
          new Timer(new Duration(seconds: 3), () {
            setState(() {
              cached.loading = false;
              ++_changed;
            });
          });
        });
      }
      if (cached.applicant != null) {
        return cached.applicant; // Return dirty
      }
      if (cached.fallback == null) {
        cached.fallback = new DataApplicant();
        cached.fallback.applicantId = applicantId;
      }
      if (fallback != null) {
        cached.fallback.mergeFromMessage(fallback);
      }
      if (fallbackOffer != null) {
        cached.fallback.offerId = fallbackOffer.offerId;
        cached.fallback.businessAccountId = fallbackOffer.accountId;
      }
      return cached.fallback;
    }
    return cached.applicant;
  }

  /// Fetch latest applicant from cache by id, fetch in background if non-existent
  @override
  DataApplicant tryGetApplicant(Int64 applicantId,
      {DataBusinessOffer fallbackOffer}) {
    return _tryGetApplicant(applicantId.toInt(), fallbackOffer: fallbackOffer);
  }

  /// Fetch latest applicant from cache, fetch in background if non-existent
  @override
  DataApplicant latestApplicant(DataApplicant applicant) {
    return _tryGetApplicant(applicant.applicantId, fallback: applicant);
  }

  /// Fetch latest known applicant chats from cache, fetch in background if not loaded yet
  @override
  Iterable<DataApplicantChat> tryGetApplicantChats(Int64 applicantId) {
    _CachedApplicant cached = _cachedApplicants[applicantId];
    if (cached == null) {
      cached = new _CachedApplicant();
      _cachedApplicants[applicantId.toInt()] = cached;
    }
    if (!cached.chatLoaded &&
        !cached.chatLoading &&
        connected == NetworkConnectionState.Ready) {
      print("fetch chat");
      cached.chatLoading = true;
      _loadApplicantChats(applicantId.toInt()).then((applicant) {
        cached.chatLoading = false;
        cached.chatLoaded = true;
      }).catchError((error, stack) {
        print("[INF] Failed to get applicant chats: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          setState(() {
            cached.chatLoading = false;
            ++_changed;
          });
        });
      });
    }
    return cached.chats.values.followedBy(cached.ghostChats.values);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle Notifications
  /////////////////////////////////////////////////////////////////////////////

  void _receivedUpdateApplicant(DataApplicant applicant) {
    _cacheApplicant(applicant);
  }

  void _receivedUpdateApplicantChat(DataApplicantChat chat) {
    _cacheApplicantChat(chat);
  }

  void _notifyNewApplicantChat(DataApplicantChat chat) {
    // TODO: Notify the user of a new applicant chat message if not own
    print("[INF] Notify: ${chat.text}");
  }

  void _receivedApplicantCommonRes(NetApplicantCommonRes res) {
    _receivedUpdateApplicant(res.updateApplicant);
    for (DataApplicantChat chat in res.newChats) {
      _receivedUpdateApplicantChat(chat);
      _notifyNewApplicantChat(chat);
    }
  }

  void _liveNewApplicant(TalkMessage message) {
    DataApplicant pb = new DataApplicant();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicant(pb);
  }

  void _liveNewApplicantChat(TalkMessage message) {
    DataApplicantChat pb = new DataApplicantChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicantChat(pb);
    _notifyNewApplicantChat(pb);
  }

  void _liveUpdateApplicant(TalkMessage message) {
    DataApplicant pb = new DataApplicant();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicant(pb);
  }

  void _liveUpdateApplicantChat(TalkMessage message) {
    DataApplicantChat pb = new DataApplicantChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicantChat(pb);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  static int _netApplicantReportReq = TalkSocket.encode("AP_REPOR");
  @override
  Future<void> reportApplicant(int applicantId, String text) async {
    NetApplicantReportReq pbReq = new NetApplicantReportReq();
    pbReq.applicantId = applicantId;
    pbReq.text = text;
    // Response blank. Exception on issue
    await _ts.sendRequest(_netApplicantReportReq, pbReq.writeToBuffer());
  }

  void _resubmitGhostChats() {
    for (_CachedApplicant cached in _cachedApplicants.values) {
      for (DataApplicantChat ghostChat in cached.ghostChats.values) {
        switch (ghostChat.type) {
          case ApplicantChatType.ACT_PLAIN:
            {
              NetChatPlain pbReq = new NetChatPlain();
              pbReq.applicantId = ghostChat.applicantId;
              pbReq.deviceGhostId = ghostChat.deviceGhostId;
              pbReq.text = ghostChat.text;
              _ts.sendMessage(_netChatPlain, pbReq.writeToBuffer());
            }
            break;
          case ApplicantChatType.ACT_HAGGLE:
            {
              NetChatHaggle pbReq = new NetChatHaggle();
              pbReq.applicantId = ghostChat.applicantId;
              pbReq.deviceGhostId = ghostChat.deviceGhostId;
              Map<String, String> query = Uri.splitQueryString(ghostChat.text);
              pbReq.deliverables = query['deliverables'];
              pbReq.reward = query['reward'];
              pbReq.remarks = query['remarks'];
              _ts.sendMessage(_netChatHaggle, pbReq.writeToBuffer());
            }
            break;
          case ApplicantChatType.ACT_IMAGE_KEY:
            {
              NetChatImageKey pbReq = new NetChatImageKey();
              pbReq.applicantId = ghostChat.applicantId;
              pbReq.deviceGhostId = ghostChat.deviceGhostId;
              Map<String, String> query = Uri.splitQueryString(ghostChat.text);
              pbReq.imageKey = query['key'];
              _ts.sendMessage(_netChatImageKey, pbReq.writeToBuffer());
            }
            break;
        }
      }
    }
  }

  void _createGhostChat(
      int applicantId, int deviceGhostId, ApplicantChatType type, String text) {
    _CachedApplicant cached = _cachedApplicants[applicantId];
    if (cached == null) {
      cached = new _CachedApplicant();
      _cachedApplicants[applicantId] = cached;
    }
    DataApplicantChat ghostChat = new DataApplicantChat();
    ghostChat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    ghostChat.senderId = account.state.accountId;
    ghostChat.applicantId = applicantId;
    ghostChat.deviceId = account.state.deviceId;
    ghostChat.deviceGhostId = deviceGhostId;
    ghostChat.type = type;
    ghostChat.text = text;
    setState(() {
      cached.ghostChats[deviceGhostId] = ghostChat;
      ++_changed;
    });

    // TODO: Store ghost chats offline
  }

  static int _netChatPlain = TalkSocket.encode("CH_PLAIN");
  @override
  void chatPlain(int applicantId, String text) {
    int ghostId = ++nextDeviceGhostId;
    if (connected == NetworkConnectionState.Ready) {
      NetChatPlain pbReq = new NetChatPlain();
      pbReq.applicantId = applicantId;
      pbReq.deviceGhostId = ghostId;
      pbReq.text = text;
      _ts.sendMessage(_netChatPlain, pbReq.writeToBuffer());
    }
    _createGhostChat(applicantId, ghostId, ApplicantChatType.ACT_PLAIN, text);
  }

  static int _netChatHaggle = TalkSocket.encode("CH_HAGGLE");
  @override
  void chatHaggle(
      int applicantId, String deliverables, String reward, String remarks) {
    int ghostId = ++nextDeviceGhostId;
    if (connected == NetworkConnectionState.Ready) {
      NetChatHaggle pbReq = new NetChatHaggle();
      pbReq.applicantId = applicantId;
      pbReq.deviceGhostId = ghostId;
      pbReq.deliverables = deliverables;
      pbReq.reward = reward;
      pbReq.remarks = remarks;
      _ts.sendMessage(_netChatHaggle, pbReq.writeToBuffer());
    }
    _createGhostChat(
      applicantId,
      ghostId,
      ApplicantChatType.ACT_HAGGLE,
      "deliverables=" +
          Uri.encodeQueryComponent(deliverables) +
          "&reward=" +
          Uri.encodeQueryComponent(reward) +
          "&remarks=" +
          Uri.encodeQueryComponent(remarks),
    );
  }

  static int _netChatImageKey = TalkSocket.encode("CH_IMAGE");
  @override
  void chatImageKey(int applicantId, String imageKey) {
    int ghostId = ++nextDeviceGhostId;
    if (connected == NetworkConnectionState.Ready) {
      NetChatImageKey pbReq = new NetChatImageKey();
      pbReq.applicantId = applicantId;
      pbReq.deviceGhostId = ghostId;
      pbReq.imageKey = imageKey;
      _ts.sendMessage(_netChatImageKey, pbReq.writeToBuffer());
    }
    _createGhostChat(
      applicantId,
      ghostId,
      ApplicantChatType.ACT_IMAGE_KEY,
      "key=" + Uri.encodeQueryComponent(imageKey),
    );
  }

  static int _netApplicantWantDealReq = TalkSocket.encode("AP_WADEA");
  @override
  Future<void> wantDeal(int applicantId, int haggleChatId) async {
    NetApplicantWantDealReq pbReq = NetApplicantWantDealReq();
    pbReq.applicantId = applicantId;
    pbReq.haggleChatId = new Int64(haggleChatId);
    TalkMessage res =
        await _ts.sendRequest(_netApplicantWantDealReq, pbReq.writeToBuffer());
    NetApplicantCommonRes pbRes = new NetApplicantCommonRes();
    pbRes.mergeFromBuffer(res.data);
    _receivedApplicantCommonRes(pbRes);
  }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

class _CachedApplicant {
  bool loading = false;
  bool dirty = false;
  DataApplicant applicant;
  DataApplicant fallback;
  bool chatLoading = false;
  bool chatLoaded = false;
  Map<int, DataApplicantChat> chats = new Map<int, DataApplicantChat>();
  Map<int, DataApplicantChat> ghostChats = new Map<int, DataApplicantChat>();
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

/* end of file */
