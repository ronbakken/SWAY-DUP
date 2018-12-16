/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/network_common.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';
import 'package:mime/mime.dart';
import 'package:isolate/isolate.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart'; // Necessary for asynchronous hashing.
import 'package:file/file.dart';
import 'package:http/http.dart' as http;

import 'package:inf/network_generic/network_manager.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';

export 'package:inf/network_generic/multi_account_client.dart';
export 'package:inf/network_generic/api_client.dart';

abstract class NetworkCommon implements ApiClient, NetworkInternals {
  @override
  final Switchboard switchboard = Switchboard();

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
      <String, Function(TalkMessage message)>{};

  bool _alive;

  @override
  ConfigData get config {
    return _config;
  }

  @override
  MultiAccountStore get multiAccountStore {
    return _multiAccountStore;
  }

  @override
  final Logger log = Logger('Inf.Network');

  String _overrideEndPoint;

  final Random random = Random.secure();

  @override
  int nextSessionGhostId;

  int _keepAliveBackground = 0;

  bool _foreground = true;
  Completer<void> _awaitingForeground;

  @override
  void commonInitBase() {
    _alive = true;

    // Device ghost id is a semi sequential identifier for identifying messages by device (to ensure all are sent and to avoid duplicates)
    nextSessionGhostId =
        (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF;

    // Initialize data
    resetAccountState();
  }

  @override
  void commonInitReady() {
    registerProcedure('SESREMOV', _sessionRemove);
    registerProcedure('CONFDOWN', _configDownload);
    registerProcedure('ACCOUNTU', _accountUpdate);

    registerProcedure('LN_APPLI', liveNewProposal);
    registerProcedure('LN_A_CHA', liveNewProposalChat);
    registerProcedure('LU_APPLI', liveUpdateProposal);
    registerProcedure('LU_A_CHA', liveUpdateProposalChat);

    // Start network loop
    _networkLoop().catchError((dynamic error, StackTrace stackTrace) {
      log.severe('Network loop died: $error\n$stackTrace');
    });

    Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      if (!_alive) {
        timer.cancel();
        return;
      }
      if (channel != null) {
        final TalkChannel currentChannel = channel;
        try {
          await channel.sendRequest('PING', Uint8List(0));
        } catch (error, stackTrace) {
          log.fine('Ping: $error\n$stackTrace');
          if (channel == currentChannel) {
            channel = null;
            await currentChannel.close();
          }
        }
      }
    });
  }

  void registerProcedure(
    String procedureId,
    Future<void> procedure(TalkMessage message),
  ) {
    _procedureHandlers[procedureId] = (TalkMessage message) async {
      try {
        await procedure(message);
      } catch (error, stackTrace) {
        log.severe(
            "Unexpected error in procedure '$procedureId': $error\n$stackTrace");
        if (message.requestId != 0) {
          channel.replyAbort(message, 'Unexpected error.');
        }
      }
    };
  }

  @override
  void pushKeepAlive() {
    ++_keepAliveBackground;
  }

  @override
  void popKeepAlive() {
    --_keepAliveBackground;
  }

  @override
  void overrideUri(String serverUri) {
    _overrideEndPoint = serverUri;
    log.info('Override server uri to $serverUri');
    if (channel != null) {
      channel.close();
      channel = null;
    }
    if (!_kickstartNetwork.isCompleted) {
      _kickstartNetwork.complete();
    }
  }

  void syncMultiAccountStore(MultiAccountStore multiAccountStore) {
    _multiAccountStore = multiAccountStore;
  }

  void syncConfig(ConfigData config) {
    // May only be called from a setState block
    if (_config != config) {
      log.fine('Sync config changes to network');
      final bool regionOrLanguageChanged = config.region != _config?.region ||
          config.language != _config?.language;
      _config = config;
      if (_config != null) {
        _updatePayload(closeExisting: regionOrLanguageChanged);
      }
      onCommonChanged();
    }
    if (_config == null) {
      log.severe(
          'Widget config is null in network sync'); // DEVELOPER - CRITICAL
    }
    if (!_kickstartNetwork.isCompleted) {
      _kickstartNetwork.complete();
    }
  }

  void cleanupStateSwitchingAccounts() {
    resetProfilesState();
    resetOffersState();
    resetDemoAllOffersState();
    resetProposalsState();
    resetAccountState();
  }

  void resetAccountState() {
    account = emptyAccount(); //..freeze();
  }

  void resetSessionPayload() {
    switchboard.setPayload(Uint8List(0), closeExisting: true);
    _lastPayloadLocalId = null;
  }

  @override
  void reassembleCommon() {
    // Developer reload
    if (channel != null) {
      log.info('Network reload by developer.');
      channel.close();
      channel = null;
    }
    if (!_kickstartNetwork.isCompleted) {
      _kickstartNetwork.complete();
    }
  }

  @override
  void disposeCommon() {
    _alive = false;
    if (channel != null) {
      log.fine('Dispose network connection.');
      channel.close();
      channel = null;
    }
  }

  @override
  void dependencyChangedCommon() {
    if (channel != null) {
      log.info('Network reload by config or selection.');
      channel.close();
      channel = null;
    }
    if (!_kickstartNetwork.isCompleted) {
      _kickstartNetwork.complete();
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
    if (!_kickstartNetwork.isCompleted) {
      _kickstartNetwork.complete();
    }
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Session
  /////////////////////////////////////////////////////////////////////

  @override
  void processSwitchAccount(LocalAccountData localAccount) {
    if (localAccount != _currentLocalAccount) {
      cleanupStateSwitchingAccounts();
      if (channel != null) {
        channel.close();
        channel = null;
      }
      _currentLocalAccount = null;
      resetSessionPayload();
      if (!_kickstartNetwork.isCompleted) {
        _kickstartNetwork.complete();
      }
    }
  }

  Completer<void> _kickstartNetwork = Completer<void>();

  void _updatePayload({bool closeExisting}) {
    if (_currentLocalAccount == null) {
      resetSessionPayload();
      return;
    }
    final NetSessionPayload sessionPayload = NetSessionPayload();
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
    final NetConfigDownload download = NetConfigDownload()
      ..mergeFromBuffer(message.data)
      ..freeze();
    // TODO: Tell config manager to download
    // download.configUrl
    // ConfigManager.............
    // config.
  }

  Future<void> _sessionCreate() async {
    log.info('Create session.');
    // final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final String deviceName = 'unknown_device';
    /*
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo info = await deviceInfo.androidInfo;
        deviceName = info.model;
      } else if (Platform.isIOS) {
        final IosDeviceInfo info = await deviceInfo.iosInfo;
        deviceName = info.name;
      }
    } catch (ex) {
      log.severe('Failed to get device name');
    }
    */
    final NetSessionCreate create = NetSessionCreate();
    create.deviceName = deviceName;
    create.deviceToken = multiAccountStore.getDeviceToken();
    create.deviceInfo = "{ debug: 'default_info' }";
    final TalkMessage response =
        await channel.sendRequest('SESSIONC', create.writeToBuffer());
    final NetSession session = NetSession()
      ..mergeFromBuffer(response.data)
      ..freeze();
    if (_lastPayloadLocalId != _currentLocalAccount.localId) {
      log.warning('Already switched account, cannot finish session creation.');
      if (channel != null) {
        channel.close();
        channel = null;
      }
      return;
    }
    if (session.hasSessionId() && session.sessionId != 0) {
      // Successfull connection
      if (_lastPayloadCookie == null) {
        log.severe('Payload cookie missing.');
        if (channel != null) {
          channel.close();
          channel = null;
        }
        return;
      }
      log.info('Session ${session.sessionId}.');
      // Store session id and cookie
      multiAccountStore.setSessionId(_currentLocalAccount.domain,
          _currentLocalAccount.localId, session.sessionId, _lastPayloadCookie);
      _lastPayloadCookie = null;
      // Update payload for reconnection
      _updatePayload(closeExisting: false);
    }
  }

  Future<void> _sessionRemove(TalkMessage message) async {
    log.info('Remove session.');
    if (_lastPayloadLocalId != _currentLocalAccount.localId) {
      log.warning('Already switched account, cannot remove session.');
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
      final String endPoint = _overrideEndPoint ?? _config.services.endPoint;
      final String service = _config.services.service;
      final LocalAccountData localAccount = multiAccountStore.current;
      final bool matchingDomain =
          _config.services.domain == localAccount.domain;

      if (endPoint == null || endPoint.isEmpty || !matchingDomain) {
        if (!_netConfigWarning) {
          _netConfigWarning = true;
          log.warning("Incomplete network configuration, not connecting");
        }
        if (_kickstartNetwork.isCompleted)
          _kickstartNetwork = Completer<void>();
        try {
          await _kickstartNetwork.future.timeout(Duration(seconds: 3));
        } catch (TimeoutException) {
          //...
        }
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
            .timeout(Duration(seconds: 3));
      } catch (e) {
        log.warning('Network cannot connect, retry in 3 seconds: $e');
        assert(channel == null);
        connected = NetworkConnectionState.offline;
        onCommonChanged();
        if (_kickstartNetwork.isCompleted)
          _kickstartNetwork = Completer<void>();
        try {
          await _kickstartNetwork.future.timeout(Duration(seconds: 3));
        } catch (TimeoutException) {
          //...
        }
        return;
      }

      // Future<void> listen = channel.listen();
      final Completer<void> listen = Completer<void>();
      log.info('Listen to channel.');
      channel.listen((TalkMessage message) async {
        if (_procedureHandlers.containsKey(message.procedureId)) {
          await _procedureHandlers[message.procedureId](message);
        } else {
          channel.unknownProcedure(message);
        }
      }, onError: (dynamic error, StackTrace stackTrace) {
        if (error is TalkAbort) {
          log.severe('Received abort from api remote: $error\n$stackTrace');
        } else {
          log.severe('Unknown error from api remote: $error\n$stackTrace');
        }
      }, onDone: () {
        log.info('Connection done.');
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
      log.info('Network connection closed.');
      if (connected == NetworkConnectionState.ready) {
        connected = NetworkConnectionState.connecting;
        onCommonChanged();
      }
    } catch (error, stackTrace) {
      log.warning('Network session exception: $error\n$stackTrace');
      try {
        final TalkChannel tempChannel = channel;
        channel = null;
        connected = NetworkConnectionState.failing;
        onCommonChanged();
        if (tempChannel != null) {
          await tempChannel.close();
        }
      } catch (error, stackTrace) {
        log.warning('Network session reset exception: $error\n$stackTrace');
      }
    }
  }

  Future<void> _networkLoop() async {
    log.fine('Start network loop.');
    while (_alive) {
      if (!_foreground && (_keepAliveBackground <= 0)) {
        log.fine('Awaiting foreground.');
        _awaitingForeground = Completer<void>();
        await _awaitingForeground.future;
        log.fine('Now in foreground.');
      }
      await _sessionOpen();
    }
    log.fine('End network loop.');
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Account
  /////////////////////////////////////////////////////////////////////

  Future<void> _accountUpdate(TalkMessage message) async {
    final NetAccount pb = NetAccount();
    pb.mergeFromBuffer(message.data);
    await receivedAccountUpdate(pb);
  }

  Future<void> receivedAccountUpdate(NetAccount pb) async {
    log.info("Account state update received.");
    log.fine("NetAccountUpdate: $pb");
    if (pb.account.accountId != account.accountId) {
      // Any cache cleanup may be done here when switching accounts
      cleanupStateSwitchingAccounts();
    }
    account = pb.account;
    connected = NetworkConnectionState.ready;
    onCommonChanged();
    if (pb.account.accountId != 0) {
      if (_currentLocalAccount.sessionId != pb.account.sessionId) {
        log.severe(
            "Mismatching current session ID '${_currentLocalAccount.sessionId}' "
            "and received session ID '${pb.account.sessionId}'");
      } else {
        // Update local account store
        _multiAccountStore.setAccountId(
            _currentLocalAccount.domain,
            _currentLocalAccount.localId,
            account.accountId,
            account.accountType);
        _multiAccountStore.setNameAvatar(
            _currentLocalAccount.domain,
            _currentLocalAccount.localId,
            account.name,
            account.blurredAvatarUrl,
            account.avatarUrl);
      }
      // Mark all caches as dirty, since we may have been offline for a while
      markProfilesDirty();
      markOffersDirty();
      markDemoAllOffersDirty();
      markProposalsDirty();
      await initFirebaseNotifications();
    }
  }

  /* Device Registration */
  @override
  void setAccountType(AccountType accountType) {
    final NetSetAccountType pb = NetSetAccountType();
    pb.accountType = accountType;
    switchboard.sendMessage("api", "A_SETTYP", pb.writeToBuffer());
    // Cancel all social media logins on change, server update on this gets there later
    if (account.accountType != accountType) {
      for (DataSocialMedia media in account.socialMedia.values) {
        media.connected = false;
      }
    }
    // Ghost state, the server doesn't send update for this
    account.accountType = accountType;
    onCommonChanged();
  }

  /* OAuth */
  @override
  Future<NetOAuthUrl> getOAuthUrls(int oauthProvider) async {
    final NetOAuthGetUrl pb = NetOAuthGetUrl();
    pb.oauthProvider = oauthProvider;
    final TalkMessage res =
        await switchboard.sendRequest("api", "OA_URLRE", pb.writeToBuffer());
    final NetOAuthUrl resPb = NetOAuthUrl();
    resPb.mergeFromBuffer(res.data);
    return resPb;
  }

  @override
  Future<NetOAuthConnection> connectOAuth(
      int oauthProvider, String callbackQuery) async {
    final NetOAuthConnect pb = NetOAuthConnect();
    pb.oauthProvider = oauthProvider;
    pb.callbackQuery = callbackQuery;
    final TalkMessage res =
        await switchboard.sendRequest("api", "OA_CONNE", pb.writeToBuffer());
    final NetOAuthConnection resPb = NetOAuthConnection();
    resPb.mergeFromBuffer(res.data);
    // Result contains the updated data, so needs to be put into the state
    if (oauthProvider < config.oauthProviders.length &&
        resPb.socialMedia != null) {
      account.socialMedia[oauthProvider] = resPb.socialMedia;
      onCommonChanged();
    }
    // Return just whether connected or not
    return resPb;
  }

  @override
  Future<void> createAccount(double latitude, double longitude) async {
    final NetAccountCreate pb = NetAccountCreate();
    if (latitude != null &&
        latitude != 0.0 &&
        longitude != null &&
        longitude != 0.0) {
      pb.latitude = latitude;
      pb.longitude = longitude;
    }
    final TalkMessage res =
        await switchboard.sendRequest("api", "A_CREATE", pb.writeToBuffer());
    final NetAccount resPb = NetAccount();
    resPb.mergeFromBuffer(res.data);
    await receivedAccountUpdate(resPb);
    if (account.accountId == 0) {
      throw const NetworkException('No account has been created');
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Image upload
  /////////////////////////////////////////////////////////////////////////////

  static Digest _getContentSha256(File file) {
    final DigestSink convertedSink = DigestSink();
    final ByteConversionSink fileSink =
        sha256.startChunkedConversion(convertedSink);
    final RandomAccessFile readFile = file.openSync();
    final Uint8List buffer = Uint8List(65536);
    int read;
    while ((read = readFile.readIntoSync(buffer)) > 0) {
      fileSink.addSlice(buffer, 0, read, false);
    }
    fileSink.close();
    return convertedSink.value;
  }

  @override
  Future<NetUploadImageRes> uploadImage(File file) async {
    final IsolateRunner runner = await IsolateRunner.spawn();
    Digest contentSha256;
    try {
      contentSha256 = await runner.run<Digest, File>(_getContentSha256, file);
    } finally {
      await runner.close();
    }

    final List<int> headerBytes = <int>[];
    await for (List<int> buffer in file.openRead(0, 256)) {
      headerBytes.addAll(buffer);
    }
    final String contentType =
        MimeTypeResolver().lookup(file.path, headerBytes: headerBytes);
    final int contentLength = await file.length();

    // Create a request to upload the file
    final NetUploadImageReq req = NetUploadImageReq();
    req.fileName = file.path;
    req.contentLength = contentLength;
    req.contentType = contentType;
    req.contentSha256 = contentSha256.bytes;

    // Fetch the pre-signed URL from the server
    final TalkMessage resMessage =
        await switchboard.sendRequest('api', 'UP_IMAGE', req.writeToBuffer());
    final NetUploadImageRes res = NetUploadImageRes();
    res.mergeFromBuffer(resMessage.data);

    if (res.fileExists) {
      // File already exists, so no need to upload it again
      return res;
    }

    // Upload the file
    final http.StreamedRequest httpRequest =
        http.StreamedRequest(res.requestMethod, Uri.parse(res.requestUrl));
    httpRequest.headers['Content-Type'] = contentType;
    httpRequest.headers['Content-Length'] = contentLength.toString();
    // FIXME: Spaces doesn't process this option when in pre-signed URL query
    httpRequest.headers['x-amz-acl'] = 'public-read';
    final Future<http.StreamedResponse> futureResponse = httpRequest.send();
    await for (List<int> buffer in file.openRead()) {
      // TODO(kaetemi): Not sure if tracking progress here is feasible, since there's no write blocking on streams...
      httpRequest.sink.add(buffer);
    }
    httpRequest.sink.close();
    final http.StreamedResponse httpResponse = await futureResponse;
    final String body = await utf8.decodeStream(httpResponse.stream);
    if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
      throw NetworkException(
          'Status code ${httpResponse.statusCode}, response: $body');
    }

    // Upload successful
    return res;
  }
}

/* end of file */
