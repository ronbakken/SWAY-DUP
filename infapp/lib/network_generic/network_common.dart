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
import 'package:inf/network_generic/network_common.dart';
import 'package:inf/network_generic/network_offers_business.dart';
import 'package:inf/network_generic/network_offers_demo.dart';
import 'package:inf/network_generic/network_proposals.dart';
import 'package:inf/network_mobile/network_notifications.dart';
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;
import 'package:pointycastle/block/aes_fast.dart' as pointycastle;
import 'package:mime/mime.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart'; // Necessary for asynchronous hashing.

import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_generic/network_offers.dart';
import 'package:inf/network_generic/network_profiles.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_generic/network_interface.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';

export 'package:inf/network_generic/network_interface.dart';

abstract class NetworkCommon implements NetworkInterface, NetworkInternals {
  LocalAccountData _currentLocalAccount;
  DataAccount account;
  NetworkConnectionState connected = NetworkConnectionState.connecting;

  ConfigData _config;
  MultiAccountStore _multiAccountStore;

  bool _alive;
  TalkSocket _ts;

  TalkSocket get ts {
    return _ts;
  }

  ConfigData get config {
    return _config;
  }

  MultiAccountStore get multiAccountStore {
    return _multiAccountStore;
  }

  final Logger log = new Logger('Inf.Network');

  String _overrideUri;

  final random = new Random.secure();

  int nextDeviceGhostId;

  List<StreamSubscription<TalkMessage>> _subscriptions =
      new List<StreamSubscription<TalkMessage>>();

  int _keepAliveBackground = 0;

  bool _foreground = true;
  Completer<void> _awaitingForeground;

  void commonInitBase() {
    _alive = true;

    // Device ghost id is a semi sequential identifier for identifying messages by device (to ensure all are sent and to avoid duplicates)
    nextDeviceGhostId =
        (new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF;

    // Initialize data
    resetAccountState();
  }

  void commonInitReady() {
    // Start network loop
    _networkLoop().catchError((e) {
      log.severe("Network loop died: $e");
    });

    new Timer.periodic(new Duration(seconds: 1), (timer) async {
      if (!_alive) {
        timer.cancel();
        return;
      }
      if (_ts != null) {
        try {
          await _ts.ping();
        } catch (error, stack) {
          log.fine("[PING] $error\n$stack");
        }
      }
    });
  }

  void pushKeepAlive() {
    ++_keepAliveBackground;
  }

  void popKeepAlive() {
    --_keepAliveBackground;
  }

  @override
  void overrideUri(String serverUri) {
    _overrideUri = serverUri;
    log.info("Override server uri to $serverUri");
    if (_ts != null) {
      _ts.close();
      _ts = null;
    }
  }

  void syncMultiAccountStore(MultiAccountStore multiAccountStore) {
    _multiAccountStore = multiAccountStore;
  }

  void syncConfig(ConfigData config) {
    // May only be called from a setState block
    if (_config != config) {
      log.fine("Sync config changes to network");
      _config = config;
      if (_config != null) {
        // Match array length
        for (int i = account.detail.socialMedia.length;
            i < _config.oauthProviders.all.length;
            ++i) {
          account.detail.socialMedia.add(new DataSocialMedia());
        }
        account.detail.socialMedia.length = _config.oauthProviders.all.length;
      }
      onCommonChanged();
    }
    if (_config == null) {
      log.severe(
          "Widget config is null in network sync"); // DEVELOPER - CRITICAL
    }
  }

  void cleanupStateSwitchingAccounts() {
    resetProfilesState();
    resetOffersState();
    resetOffersBusinessState();
    resetOffersDemoState();
    resetProposalsState();
    resetAccountState();
  }

  void resetAccountState() {
    account = emptyAccount(); //..freeze();
  }

  void reassembleCommon() {
    // Developer reload
    if (_ts != null) {
      log.info("Network reload by developer");
      _ts.close();
      _ts = null;
    }
  }

  void disposeCommon() {
    _alive = false;
    if (_ts != null) {
      log.fine("Dispose network connection");
      _ts.close();
      _ts = null;
    }
  }

  void dependencyChangedCommon() {
    if (_ts != null) {
      log.info("Network reload by config or selection");
      _ts.close();
      _ts = null;
    }
  }

  void processSwitchAccount(LocalAccountData localAccount) {
    if (localAccount != _currentLocalAccount) {
      cleanupStateSwitchingAccounts();
      if (_ts != null) {
        _ts.close();
        _ts = null;
      }
    }
  }

  void setApplicationForeground(bool foreground) {
    if (!foreground) {
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

  /// Authenticate device connection, this process happens as if by magic
  Future<void> _authenticateDevice(TalkSocket ts) async {
    // Initialize connection
    log.info("Authenticate device");
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
      log.severe('Failed to get device name');
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
    final Uint8List commonDeviceId = multiAccountStore.getCommonDeviceId();
    final LocalAccountData localAccount = multiAccountStore.current;
    final Uint8List aesKey = multiAccountStore.getDeviceCookie(
        localAccount.environment, localAccount.localId);
    _currentLocalAccount = localAccount;

    // Original plan was to use an assymetric key pair, but the generation was too slow. Hence just using a symmetric AES key for now
    /*
    int localAccountId = widget.networkManager.localAccountId;
    String aesKeyPref =
        widget.config.services.environment + '_aes_key_$localAccountId';
    String deviceIdPref =
        widget.config.services.environment + '_device_id_$localAccountId';
    String aesKeyStr;
    Uint8List aesKey;
    int attemptDeviceId = 0;
    try {
      // prefs.setString(aesKeyPref, ''); // DEBUG: Reset profile
      aesKeyStr = prefs.getString(aesKeyPref);
      aesKey = base64.decode(aesKeyStr);
      attemptDeviceId = prefs.getInt(deviceIdPref);
      if (attemptDeviceId != account.state.sessionId) {
        account.state.sessionId = 0;
      }
    } catch (e) {}
    */
    if (localAccount.sessionId == null || localAccount.sessionId == 0) {
      // Create new device
      log.info("Create new device");
      account.state.sessionId = Int64.ZERO;
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
      log.info("Device id ${account.state.sessionId}");
      if (account.state.sessionId != 0) {
        multiAccountStore.setDeviceId(localAccount.environment, localAccount.localId,
            account.state.sessionId, aesKey);
      }
    } else {
      // Authenticate existing device
      log.info("Authenticate existing device ${localAccount.sessionId}");

      NetDeviceAuthChallengeReq pbChallengeReq =
          new NetDeviceAuthChallengeReq();
      pbChallengeReq.sessionId = localAccount.sessionId;
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
      log.info("Device id ${account.state.sessionId}");
    }

    if (account.state.sessionId == 0) {
      // TODO: Differentiate between connection error and exception received from server? Seems to be going wrong sometimes.
      // multiAccountStore.removeLocal(localAccount.environment, localAccount.localId);
      multiAccountStore.addAccount(localAccount.environment);
      _currentLocalAccount = null;
      throw new Exception("Authentication did not succeed");
    } else {
      log.info("Network connection is ready");
      connected = NetworkConnectionState.ready;
      onCommonChanged();

      // Register all listeners
      _subscriptions.add(
          ts.stream(TalkSocket.encode('DA_STATE')).listen(_netDeviceAuthState));
      _subscriptions.add(ts
          .stream(TalkSocket.encode("DB_OFFER"))
          .listen(dataOffer)); // TODO: Remove this!
      //_subscriptions.add(ts
      //    .stream(TalkSocket.encode("DE_OFFER"))
      //    .listen(_demoAllOffer));
      // LN_APPLI, LN_A_CHA, LU_APPLI, LU_A_CHA
      _subscriptions.add(
          ts.stream(TalkSocket.encode('LN_APPLI')).listen(liveNewProposal));
      _subscriptions.add(ts
          .stream(TalkSocket.encode('LN_A_CHA'))
          .listen(liveNewProposalChat));
      _subscriptions.add(
          ts.stream(TalkSocket.encode('LU_APPLI')).listen(liveUpdateProposal));
      _subscriptions.add(ts
          .stream(TalkSocket.encode('LU_A_CHA'))
          .listen(liveUpdateProposalChat));

      resubmitGhostChats();
    }

    // assert(accountState.sessionId != 0);
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
            (_config.services.apiHosts.length > 0 ? _config.services
                .apiHosts[random.nextInt(_config.services.apiHosts.length)] : null);
        if (uri == null || uri.length == 0) {
          if (!_netConfigWarning) {
            _netConfigWarning = true;
            log.warning("No network configuration, not connecting");
          }
          await new Future.delayed(new Duration(seconds: 3));
          return;
        }
        _netConfigWarning = false;
        try {
          log.info("Try connect to $uri");
          _ts = await TalkSocket.connect(uri);
        } catch (e) {
          log.warning("Network cannot connect, retry in 3 seconds: $e");
          assert(_ts == null);
          connected = NetworkConnectionState.offline;
          onCommonChanged();
          await new Future.delayed(new Duration(seconds: 3));
        }
      } while (_alive &&
          (_foreground || (_keepAliveBackground > 0)) &&
          (_ts == null));
      Future<void> listen = _ts.listen();
      if (connected == NetworkConnectionState.offline) {
        connected = NetworkConnectionState.connecting;
        onCommonChanged();
      }
      if (_config != null /*&& widget.networkManager.localAccountId != 0*/) {
        if (_alive) {
          // Authenticate device, this will set connected = ready when successful
          _authenticateDevice(_ts).catchError((e) {
            log.warning(
                "[INF] Network authentication exception, retry in 3 seconds: $e");
            connected = NetworkConnectionState.failing;
            onCommonChanged();
            TalkSocket ts = _ts;
            _ts = null;
            () async {
              log.fine("Wait");
              await new Future.delayed(new Duration(seconds: 3));
              log.fine("Retry now");
              if (ts != null) {
                ts.close();
              }
            }()
                .catchError((e) {
              log.severe("Fatal network exception, cannot recover: $e");
            });
          });
        } else {
          _ts.close();
        }
      } else {
        log.warning(
            "No configuration, connection will remain idle"); // , local account id ${widget.networkManager.localAccountId}");
        connected = NetworkConnectionState.failing;
        onCommonChanged();
      }
      await listen;
      _ts = null;
      log.info("Network connection closed");
      if (connected == NetworkConnectionState.ready) {
        connected = NetworkConnectionState.connecting;
        onCommonChanged();
      }
    } catch (error, stack) {
      log.warning("Network session exception: $error\n$stack");
      TalkSocket ts = _ts;
      _ts = null;
      connected = NetworkConnectionState.failing;
      onCommonChanged();
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
    log.fine("Start network loop");
    while (_alive) {
      if (!_foreground && (_keepAliveBackground <= 0)) {
        log.fine("Awaiting foreground");
        _awaitingForeground = new Completer<void>();
        await _awaitingForeground.future;
        log.fine("Now in foreground");
      }
      await _networkSession();
    }
    log.fine("End network loop");
  }

  Future<void> receivedDeviceAuthState(NetDeviceAuthState pb) async {
    log.info("Account state received");
    log.fine("NetDeviceAuthState: $pb");
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
    onCommonChanged();
    if (pb.data.state.accountId != 0) {
      // Update local account store
      _multiAccountStore.setAccountId(
          _currentLocalAccount.environment,
          _currentLocalAccount.localId,
          account.state.accountId,
          account.state.accountType);
      _multiAccountStore.setNameAvatar(
          _currentLocalAccount.environment,
          _currentLocalAccount.localId,
          account.summary.name,
          account.summary.blurredAvatarThumbnailUrl,
          account.summary.avatarThumbnailUrl);
      // Mark all caches as dirty, since we may have been offline for a while
      markProfilesDirty();
      markOffersDirty();
      markOffersBusinessDirty();
      markOffersDemoDirty();
      markProposalsDirty();
      await initFirebaseNotifications();
    }
  }

  /* Device Registration */
  static int _netSetAccountType = TalkSocket.encode("A_SETTYP");
  @override
  void setAccountType(AccountType accountType) {
    NetSetAccountType pb = new NetSetAccountType();
    pb.accountType = accountType;
    ts.sendMessage(_netSetAccountType, pb.writeToBuffer());
    // Cancel all social media logins on change, server update on this gets there later
    if (account.state.accountType != accountType) {
      for (int i = 0; i < account.detail.socialMedia.length; ++i) {
        account.detail.socialMedia[i].connected = false;
      }
    }
    // Ghost state, the server doesn't send update for this
    account.state.accountType = accountType;
    onCommonChanged();
  }

  /* OAuth */
  static int _netOAuthUrlReq = TalkSocket.encode("OA_URLRE");
  @override
  Future<NetOAuthUrlRes> getOAuthUrls(int oauthProvider) async {
    NetOAuthUrlReq pb = new NetOAuthUrlReq();
    pb.oauthProvider = oauthProvider;
    TalkMessage res = await ts.sendRequest(_netOAuthUrlReq, pb.writeToBuffer());
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
        await ts.sendRequest(_netOAuthConnectReq, pb.writeToBuffer());
    NetOAuthConnectRes resPb = new NetOAuthConnectRes();
    resPb.mergeFromBuffer(res.data);
    // Result contains the updated data, so needs to be put into the state
    if (oauthProvider < account.detail.socialMedia.length &&
        resPb.socialMedia != null) {
      account.detail.socialMedia[oauthProvider] = resPb.socialMedia;
      onCommonChanged();
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
        await ts.sendRequest(_netAccountCreateReq, pb.writeToBuffer());
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
        await ts.sendRequest(_netUploadImageReq, req.writeToBuffer());
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
}

/* end of file */
