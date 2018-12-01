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

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_generic/network_common.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';
import 'package:device_info/device_info.dart';
import 'package:mime/mime.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart'; // Necessary for asynchronous hashing.

import 'package:inf/network_generic/network_manager.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';

export 'package:inf/network_generic/multi_account_client.dart';
export 'package:inf/network_generic/api_client.dart';

abstract class NetworkCommon implements ApiClient, NetworkInternals {
  @override
  final Switchboard switchboard = new Switchboard();

  @override
  TalkChannel channel;

  LocalAccountData _currentLocalAccount;

  @override
  DataAccount account;

  @override
  NetworkConnectionState connected = NetworkConnectionState.connecting;

  ConfigData _config;
  MultiAccountStore _multiAccountStore;
  int _lastPayloadLocalId;
  Uint8List _lastPayloadCookie;

  final Map<String, Function(TalkMessage message)> _procedureHandlers =
      new Map<String, Function(TalkMessage message)>();

  bool _alive;

  ConfigData get config {
    return _config;
  }

  MultiAccountStore get multiAccountStore {
    return _multiAccountStore;
  }

  final Logger log = new Logger('Inf.Network');

  String _overrideEndPoint;

  final random = new Random.secure();

  int nextSessionGhostId;

  int _keepAliveBackground = 0;

  bool _foreground = true;
  Completer<void> _awaitingForeground;

  void commonInitBase() {
    _alive = true;

    // Device ghost id is a semi sequential identifier for identifying messages by device (to ensure all are sent and to avoid duplicates)
    nextSessionGhostId =
        (new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF;

    // Initialize data
    resetAccountState();
  }

  void commonInitReady() {
    registerProcedure('SESREMOV', _sessionRemove);
    registerProcedure('CONFDOWN', _configDownload);
    registerProcedure('ACCOUNTU', _accountUpdate);

    registerProcedure('DB_OFFER', dataOffer); // TODO: Remove this!

    registerProcedure('LN_APPLI', liveNewProposal);
    registerProcedure('LN_A_CHA', liveNewProposalChat);
    registerProcedure('LU_APPLI', liveUpdateProposal);
    registerProcedure('LU_A_CHA', liveUpdateProposalChat);

    // Start network loop
    _networkLoop().catchError((e) {
      log.severe("Network loop died: $e");
    });

    new Timer.periodic(new Duration(seconds: 1), (timer) async {
      if (!_alive) {
        timer.cancel();
        return;
      }
      if (channel != null) {
        try {
          await channel.sendRequest("PING", new Uint8List(0));
        } catch (error, stack) {
          log.fine("Ping: $error\n$stack");
          if (channel != null) {
            channel.close();
            channel = null;
          }
        }
      }
    });
  }

  void registerProcedure(
    String procedureId,
    procedure(TalkMessage message),
  ) {
    _procedureHandlers[procedureId] = (TalkMessage message) async {
      try {
        await procedure(message);
      } catch (error, stack) {
        log.severe(
            "Unexpected error in procedure '$procedureId': $error\n$stack");
        if (message.requestId != 0) {
          channel.replyAbort(message, "Unexpected error.");
        }
      }
    };
  }

  void pushKeepAlive() {
    ++_keepAliveBackground;
  }

  void popKeepAlive() {
    --_keepAliveBackground;
  }

  @override
  void overrideUri(String serverUri) {
    _overrideEndPoint = serverUri;
    log.info("Override server uri to $serverUri");
    if (channel != null) {
      channel.close();
      channel = null;
    }
    if (!_kickstartNetwork.isCompleted) _kickstartNetwork.complete();
  }

  void syncMultiAccountStore(MultiAccountStore multiAccountStore) {
    _multiAccountStore = multiAccountStore;
  }

  void syncConfig(ConfigData config) {
    // May only be called from a setState block
    if (_config != config) {
      log.fine("Sync config changes to network");
      bool regionOrLanguageChanged = config.region != _config?.region ||
          config.language != _config?.language;
      _config = config;
      if (_config != null) {
        // Match array length
        for (int i = account.detail.socialMedia.length;
            i < _config.oauthProviders.length;
            ++i) {
          account.detail.socialMedia.add(new DataSocialMedia());
        }
        account.detail.socialMedia.length = _config.oauthProviders.length;
      }
      if (_config != null) {
        _updatePayload(closeExisting: regionOrLanguageChanged);
      }
      onCommonChanged();
    }
    if (_config == null) {
      log.severe(
          "Widget config is null in network sync"); // DEVELOPER - CRITICAL
    }
    if (!_kickstartNetwork.isCompleted) _kickstartNetwork.complete();
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

  void resetSessionPayload() {
    switchboard.setPayload(new Uint8List(0), closeExisting: true);
    _lastPayloadLocalId = null;
  }

  void reassembleCommon() {
    // Developer reload
    if (channel != null) {
      log.info("Network reload by developer");
      channel.close();
      channel = null;
    }
  }

  void disposeCommon() {
    _alive = false;
    if (channel != null) {
      log.fine("Dispose network connection");
      channel.close();
      channel = null;
    }
  }

  void dependencyChangedCommon() {
    if (channel != null) {
      log.info("Network reload by config or selection");
      channel.close();
      channel = null;
    }
  }

  void setApplicationForeground(bool foreground) {
    if (!foreground) {
      _foreground = false;
      if (_keepAliveBackground <= 0) {
        if (channel != null) {
          channel.close();
          channel = null;
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

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Session
  /////////////////////////////////////////////////////////////////////

  void processSwitchAccount(LocalAccountData localAccount) {
    if (localAccount != _currentLocalAccount) {
      cleanupStateSwitchingAccounts();
      if (channel != null) {
        channel.close();
        channel = null;
      }
      _currentLocalAccount = null;
      resetSessionPayload();
      if (!_kickstartNetwork.isCompleted) _kickstartNetwork.complete();
    }
  }

  Completer<void> _kickstartNetwork = new Completer<void>();

  void _updatePayload({bool closeExisting}) {
    if (_currentLocalAccount == null) {
      resetSessionPayload();
      return;
    }
    NetSessionPayload sessionPayload = new NetSessionPayload();
    if (_currentLocalAccount.sessionId != 0) {
      sessionPayload.sessionId = _currentLocalAccount.sessionId;
    }
    sessionPayload.cookie = multiAccountStore.getSessionCookie(
        _currentLocalAccount.domain, _currentLocalAccount.localId);
    sessionPayload.clientVersion = _config.clientVersion;
    sessionPayload.domain = _config.services.domain;
    sessionPayload.configTimestamp = _config.timestamp;
    sessionPayload.configRegion = _config.region;
    sessionPayload.configLanguage = _config.language;
    _lastPayloadLocalId = _currentLocalAccount.localId;
    if (!sessionPayload.hasSessionId()) {
      // Need cookie for _sessionCreate when sessionId is 0
      _lastPayloadCookie = sessionPayload.cookie;
    } else {
      _lastPayloadCookie = null;
    }
    switchboard.setPayload(sessionPayload.writeToBuffer(),
        closeExisting: closeExisting);
  }

  Future<void> _configDownload(TalkMessage message) async {
    NetConfigDownload download = new NetConfigDownload()
      ..mergeFromBuffer(message.data)
      ..freeze();
    // TODO: Tell config manager to download
    // download.configUrl
    // ConfigManager.............
    // config.
  }

  Future<void> _sessionCreate() async {
    log.info("Create session");
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
    NetSessionCreate create = new NetSessionCreate();
    create.deviceName = deviceName;
    create.deviceToken = multiAccountStore.getDeviceToken();
    create.deviceInfo = "{ debug: 'default_info' }";
    TalkMessage response =
        await channel.sendRequest('SESSIONC', create.writeToBuffer());
    NetSession session = new NetSession()
      ..mergeFromBuffer(response.data)
      ..freeze();
    if (_lastPayloadLocalId != _currentLocalAccount.localId) {
      log.warning("Already switched account, cannot finish session creation.");
      if (channel != null) {
        channel.close();
        channel = null;
      }
      return;
    }
    if (session.hasSessionId() && session.sessionId != 0) {
      // Successfull connection
      if (_lastPayloadCookie == null) {
        log.severe("Payload cookie missing");
        if (channel != null) {
          channel.close();
          channel = null;
        }
        return;
      }
      log.info("Session ${session.sessionId}");
      // Store session id and cookie
      multiAccountStore.setSessionId(_currentLocalAccount.domain,
          _currentLocalAccount.localId, session.sessionId, _lastPayloadCookie);
      _lastPayloadCookie = null;
      // Update payload for reconnection
      _updatePayload(closeExisting: false);
    }
  }

  Future<void> _sessionRemove(TalkMessage message) async {
    log.info("Remove session");
    if (_lastPayloadLocalId != _currentLocalAccount.localId) {
      log.warning("Already switched account, cannot remove session.");
      if (channel != null) {
        channel.close();
        channel = null;
      }
      return;
    }
    multiAccountStore.removeLocal(
        _currentLocalAccount.domain, _currentLocalAccount.localId);
    multiAccountStore.addAccount(_config.services.domain);
  }

  bool _netConfigWarning = false;
  Future<void> _sessionOpen() async {
    try {
      String endPoint = _overrideEndPoint ?? _config.services.endPoint;
      String service = _config.services.service;
      final LocalAccountData localAccount = multiAccountStore.current;
      bool matchingDomain = _config.services.domain == localAccount.domain;

      if (endPoint == null || endPoint.length == 0 || !matchingDomain) {
        if (!_netConfigWarning) {
          _netConfigWarning = true;
          log.warning("Incomplete network configuration, not connecting");
        }
        if (_kickstartNetwork.isCompleted)
          _kickstartNetwork = new Completer<void>();
        try {
          await _kickstartNetwork.future.timeout(new Duration(seconds: 3));
        } catch (TimeoutException) {}
        return;
      }

      _currentLocalAccount = localAccount;
      if (localAccount.localId != _lastPayloadLocalId) {
        _updatePayload(closeExisting: true);
      }

      _netConfigWarning = false;
      try {
        log.info("Try to open channel to service '$service' on '$endPoint'.");
        switchboard.setEndPoint(endPoint);
        channel = await switchboard
            .openServiceChannel(service)
            .timeout(new Duration(seconds: 3));
      } catch (e) {
        log.warning("Network cannot connect, retry in 3 seconds: $e");
        assert(channel == null);
        connected = NetworkConnectionState.offline;
        onCommonChanged();
        if (_kickstartNetwork.isCompleted)
          _kickstartNetwork = new Completer<void>();
        try {
          await _kickstartNetwork.future.timeout(new Duration(seconds: 3));
        } catch (TimeoutException) {}
        return;
      }

      // Future<void> listen = channel.listen();
      Completer<void> listen = new Completer<void>();
      channel.listen((TalkMessage message) async {
        if (_procedureHandlers.containsKey(message.procedureId)) {
          await _procedureHandlers[message.procedureId](message);
        } else {
          channel.unknownProcedure(message);
        }
      }, onError: (error, stack) {
        if (error is TalkAbort) {
          log.severe("Received abort from api remote: $error\n$stack");
        } else {
          log.severe("Unknown error from api remote: $error\n$stack");
        }
      }, onDone: () {
        listen.complete();
      });
      if (connected == NetworkConnectionState.offline) {
        connected = NetworkConnectionState.connecting;
        onCommonChanged();
      }

      if (_alive) {
        if (localAccount.sessionId == Int64.ZERO) {
          await _sessionCreate();
        }
      }

      await listen.future;
      channel = null;
      log.info("Network connection closed.");
      if (connected == NetworkConnectionState.ready) {
        connected = NetworkConnectionState.connecting;
        onCommonChanged();
      }
    } catch (error, stack) {
      log.warning("Network session exception: $error\n$stack");
      TalkChannel tempChannel = channel;
      channel = null;
      connected = NetworkConnectionState.failing;
      onCommonChanged();
      if (tempChannel != null) {
        tempChannel.close();
      }
    }
  }

  Future _networkLoop() async {
    log.fine("Start network loop.");
    while (_alive) {
      if (!_foreground && (_keepAliveBackground <= 0)) {
        log.fine("Awaiting foreground.");
        _awaitingForeground = new Completer<void>();
        await _awaitingForeground.future;
        log.fine("Now in foreground.");
      }
      await _sessionOpen();
    }
    log.fine("End network loop.");
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Account
  /////////////////////////////////////////////////////////////////////

  void _accountUpdate(TalkMessage message) async {
    NetAccountUpdate pb = new NetAccountUpdate();
    pb.mergeFromBuffer(message.data);
    await receivedAccountUpdate(pb);
  }

  Future<void> receivedAccountUpdate(NetAccountUpdate pb) async {
    log.info("Account state update received.");
    log.fine("NetAccountUpdate: $pb");
    if (pb.account.state.accountId != account.state.accountId) {
      // Any cache cleanup may be done here when switching accounts
      cleanupStateSwitchingAccounts();
    }
    account = pb.account;
    for (int i = account.detail.socialMedia.length;
        i < _config.oauthProviders.length;
        ++i) {
      account.detail.socialMedia.add(new DataSocialMedia());
    }
    account.detail.socialMedia.length = _config.oauthProviders.length;
    connected = NetworkConnectionState.ready;
    onCommonChanged();
    if (pb.account.state.accountId != 0) {
      if (_currentLocalAccount.sessionId != pb.account.state.sessionId) {
        log.severe(
            "Mismatching current session ID '${_currentLocalAccount.sessionId}' "
            "and received session ID '${pb.account.state.sessionId}'");
      } else {
        // Update local account store
        _multiAccountStore.setAccountId(
            _currentLocalAccount.domain,
            _currentLocalAccount.localId,
            account.state.accountId,
            account.state.accountType);
        _multiAccountStore.setNameAvatar(
            _currentLocalAccount.domain,
            _currentLocalAccount.localId,
            account.summary.name,
            account.summary.blurredAvatarThumbnailUrl,
            account.summary.avatarThumbnailUrl);
      }
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
  @override
  void setAccountType(AccountType accountType) {
    NetSetAccountType pb = new NetSetAccountType();
    pb.accountType = accountType;
    switchboard.sendMessage("api", "A_SETTYP", pb.writeToBuffer());
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
  @override
  Future<NetOAuthUrl> getOAuthUrls(int oauthProvider) async {
    NetOAuthGetUrl pb = new NetOAuthGetUrl();
    pb.oauthProvider = oauthProvider;
    TalkMessage res =
        await switchboard.sendRequest("api", "OA_URLRE", pb.writeToBuffer());
    NetOAuthUrl resPb = new NetOAuthUrl();
    resPb.mergeFromBuffer(res.data);
    return resPb;
  }

  @override
  Future<NetOAuthConnection> connectOAuth(
      int oauthProvider, String callbackQuery) async {
    NetOAuthConnect pb = new NetOAuthConnect();
    pb.oauthProvider = oauthProvider;
    pb.callbackQuery = callbackQuery;
    TalkMessage res =
        await switchboard.sendRequest("api", "OA_CONNE", pb.writeToBuffer());
    NetOAuthConnection resPb = new NetOAuthConnection();
    resPb.mergeFromBuffer(res.data);
    // Result contains the updated data, so needs to be put into the state
    if (oauthProvider < account.detail.socialMedia.length &&
        resPb.socialMedia != null) {
      account.detail.socialMedia[oauthProvider] = resPb.socialMedia;
      onCommonChanged();
    }
    // Return just whether connected or not
    return resPb;
  }

  @override
  Future<void> createAccount(double latitude, double longitude) async {
    NetAccountCreate pb = new NetAccountCreate();
    if (latitude != null &&
        latitude != 0.0 &&
        longitude != null &&
        longitude != 0.0) {
      pb.latitude = latitude;
      pb.longitude = longitude;
    }
    TalkMessage res =
        await switchboard.sendRequest("api", "A_CREATE", pb.writeToBuffer());
    NetAccountUpdate resPb = new NetAccountUpdate();
    resPb.mergeFromBuffer(res.data);
    await receivedAccountUpdate(resPb);
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
        await switchboard.sendRequest("api", "UP_IMAGE", req.writeToBuffer());
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
