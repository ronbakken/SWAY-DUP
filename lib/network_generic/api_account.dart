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
import 'package:inf/network_generic/api_account.dart';
import 'package:logging/logging.dart';
import 'package:mime/mime.dart';
import 'package:isolate/isolate.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart'; // Necessary for asynchronous hashing.
import 'package:file/file.dart';
import 'package:http/http.dart' as http;
import 'package:grpc/grpc.dart' as grpc;
import 'package:pedantic/pedantic.dart';
import 'package:synchronized/synchronized.dart';

import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_generic/api.dart';
import 'package:inf/network_generic/api_internals.dart';
import 'package:inf_common/inf_common.dart';

export 'package:inf/network_generic/multi_account_client.dart';
export 'package:inf/network_generic/api.dart';

abstract class ApiAccount implements Api, ApiInternals {
  final Lock _lock = Lock();
  // grpc.ClientChannel _channel;

  Completer<void> __clientReady = Completer<void>();
  ApiAccountClient _accountClient;
  ApiOAuthClient _oauthClient;
  ApiStorageClient _storageClient;

  Future<void> get _clientReady {
    return __clientReady.future;
  }

  final StreamController<ApiSessionToken> _sessionChanged =
      StreamController<ApiSessionToken>.broadcast(sync: true);
  @override
  Stream<ApiSessionToken> get sessionChanged {
    return _sessionChanged.stream;
  }

  ApiSessionToken _currentApiSessionToken;
  LocalAccountData _wantedLocalAccount;
  LocalAccountData _currentLocalAccount;

  @override
  DataAccount account;
  DataAccount _realAccount;
  final List<DataAccount> _accountGhostChanges = <DataAccount>[];

  @override
  NetworkConnectionState connected = NetworkConnectionState.waiting;

  ConfigData _config;
  MultiAccountStore _multiAccountStore;

  void _onSessionChanged(ApiSessionToken session) {
    if (session == null) {
      if (__clientReady.isCompleted) {
        __clientReady = Completer<void>();
      }
      _accountClient = null;
      _oauthClient = null;
      _storageClient = null;
    } else {
      if (!__clientReady.isCompleted) {
        __clientReady.complete();
      }
      _accountClient = ApiAccountClient(
        session.channel,
        options: grpc.CallOptions(
          metadata: <String, String>{
            'authorization': 'Bearer ${session.token}'
          },
        ),
      );
      _oauthClient = ApiOAuthClient(
        session.channel,
        options: grpc.CallOptions(
          metadata: <String, String>{
            'authorization': 'Bearer ${session.token}'
          },
        ),
      );
      _storageClient = ApiStorageClient(
        session.channel,
        options: grpc.CallOptions(
          metadata: <String, String>{
            'authorization': 'Bearer ${session.token}'
          },
        ),
      );
    }
  }

  @override
  ConfigData get config {
    return _config;
  }

  @override
  MultiAccountStore get multiAccountStore {
    return _multiAccountStore;
  }

  @override
  final Logger log = Logger('Inf.Api');

  String _overrideEndPoint;

  final Random random = Random.secure();

  @override
  int nextSessionGhostId;

/*
  int _keepAliveBackground = 0;

  bool _foreground = true;
  Completer<void> _awaitingForeground;
  */

  bool _alive;

  /// Push the session token to the rest of the api
  void _pushSessionToken(ApiSessionToken session) {
    _currentApiSessionToken = session;
    _sessionChanged.add(session);
  }

  /// Force reopen
  Future<void> _forceReopenSession() async {
    final LocalAccountData wanted = _wantedLocalAccount;
    _wantedLocalAccount = null;
    await _kickstartSession();
    _wantedLocalAccount ??= wanted;
    await _kickstartSession();
  }

  /// To be called anytime the current session has changed
  Future<void> _kickstartSession() async {
    await _lock.synchronized(() async {
      if (!_alive ||
          _wantedLocalAccount == null ||
          _wantedLocalAccount.domain != config.services.domain) {
        // Close any existing session if no longer alive
        log.info('Cannot start an invalid session.');
        cleanupStateSwitchingAccounts();
        _currentLocalAccount = null;
        if (_currentApiSessionToken != null) {
          _pushSessionToken(null);
        }
        connected = NetworkConnectionState.waiting;
        onCommonChanged();
        return;
      }

      // Don't do anything if the local account was not changed
      if (_currentLocalAccount != null &&
          (_wantedLocalAccount.domain == _currentLocalAccount.domain &&
              _wantedLocalAccount.sessionId ==
                  _currentLocalAccount.sessionId)) {
        log.info('Session has not changed.');
        return;
      }

      // Close existing session
      log.info('Close any existing session.');
      cleanupStateSwitchingAccounts();
      _currentLocalAccount = null;
      if (_currentApiSessionToken != null) {
        _pushSessionToken(null);
      }

      // Open or create new session
      final LocalAccountData localAccount = _wantedLocalAccount;
      await _openOrCreateSession(localAccount);
    });
  }

  /// Refresh access token
  @override
  Future<void> refreshAccessToken() async {
    await _lock.synchronized(() async {
      if (!_alive) {
        // Close any existing session if no longer alive
        log.info('Cannot refresh invalid session.');
        cleanupStateSwitchingAccounts();
        _currentLocalAccount = null;
        if (_currentApiSessionToken != null) {
          _pushSessionToken(null);
        }
      }

      // Open or create new session
      final LocalAccountData localAccount = _currentLocalAccount;
      await _openOrCreateSession(localAccount);
    });
  }

  grpc.ClientChannel _createChannel(String endPoint,
      {grpc.BackoffStrategy backoffStrategy}) {
    final Uri uri = Uri.parse(endPoint);
    return grpc.ClientChannel(
      uri.host,
      port: uri.port,
      options: grpc.ChannelOptions(
        backoffStrategy: backoffStrategy,
        credentials: uri.scheme == 'http'
            ? const grpc.ChannelCredentials.insecure()
            : const grpc.ChannelCredentials.secure(),
      ),
    );
  }

  grpc.ClientChannel _createOneOffChannel(String endPoint) {
    return _createChannel(endPoint, backoffStrategy: (Duration duration) {
      throw Exception('Back off');
    });
  }

  Duration _backoff;
  int _triedEndPoints = 0;
  int _lastEndPoint = 0;
  Future<void> _openOrCreateSession(LocalAccountData localAccount) async {
    if (localAccount == null) {
      log.info('Not opening or creating session.');
      connected = NetworkConnectionState.waiting;
      onCommonChanged();
      return;
    }
    if (_multiAccountStore.getLocal(
            localAccount.domain, localAccount.localId) ==
        null) {
      if (_wantedLocalAccount == localAccount) {
        _wantedLocalAccount = null;
      }
      multiAccountStore.addAccount(_config.services.domain);
      return;
    }
    final String refreshToken = _multiAccountStore.getRefreshToken(
        localAccount.domain, localAccount.localId);
    assert(localAccount.domain == config.services.domain);
    if (connected != NetworkConnectionState.failing) {
      connected = NetworkConnectionState.connecting;
    }
    onCommonChanged();
    bool success = false;
    if (localAccount.sessionId == Int64.ZERO || refreshToken == null) {
      log.info('Creating a new session.');
      do {
        try {
          final String endPoint =
              _overrideEndPoint ?? _config.services.endPoints[_lastEndPoint];
          log.info("Using end point '$endPoint'.");
          final grpc.ClientChannel channel = _createOneOffChannel(endPoint);
          final ApiSessionClient client = ApiSessionClient(
            channel,
            options: grpc.CallOptions(
              metadata: <String, String>{
                'authorization': 'Bearer ${config.services.applicationToken}'
              },
            ),
          );
          final NetSessionCreate request = NetSessionCreate();
          request.deviceToken = multiAccountStore.getDeviceToken();
          request.clientVersion = config.clientVersion;
          request.domain = localAccount.domain;
          request.deviceInfo = '{}';
          request.deviceName = 'TODO';
          final NetSession response =
              await client.create(request).timeout(const Duration(seconds: 15));
          multiAccountStore.setSessionId(
              localAccount.domain,
              localAccount.localId,
              response.account.sessionId,
              response.refreshToken);
          final ApiSessionToken session = ApiSessionToken(
              endPoint, _createChannel(endPoint), response.accessToken);
          _currentLocalAccount = localAccount;
          _accountGhostChanges.clear();
          receivedAccountUpdate(response.account);
          _pushSessionToken(session);
          connected = NetworkConnectionState.ready;
          onCommonChanged();
          _backoff = null;
          log.info('Session created.');
          success = true;
        } catch (error, stackTrace) {
          ++_triedEndPoints;
          ++_lastEndPoint;
          _lastEndPoint %= _config.services.endPoints.length;
          log.warning('Failed to create session.', error, stackTrace);
          connected = NetworkConnectionState.failing;
          onCommonChanged();
        }
      } while (!success &&
          _triedEndPoints < _config.services.endPoints.length &&
          (_overrideEndPoint == null || _overrideEndPoint.isEmpty));
      _triedEndPoints = 0;
    } else {
      log.info('Opening an existing session.');
      do {
        try {
          final String endPoint =
              _overrideEndPoint ?? _config.services.endPoints[_lastEndPoint];
          log.info("Using end point '$endPoint'.");
          final grpc.ClientChannel channel = _createOneOffChannel(endPoint);
          final ApiSessionClient client = ApiSessionClient(
            channel,
            options: grpc.CallOptions(
              metadata: <String, String>{
                'authorization': 'Bearer $refreshToken'
              },
            ),
          );
          final NetSessionOpen request = NetSessionOpen();
          request.clientVersion = config.clientVersion;
          request.domain = localAccount.domain;
          final NetSession response =
              await client.open(request).timeout(const Duration(seconds: 15));
          final ApiSessionToken session = ApiSessionToken(
              endPoint, _createChannel(endPoint), response.accessToken);
          _currentLocalAccount = localAccount;
          _accountGhostChanges.clear();
          receivedAccountUpdate(response.account);
          _pushSessionToken(session);
          connected = NetworkConnectionState.ready;
          onCommonChanged();
          _backoff = null;
          log.info('Session opened.');
          success = true;
        } catch (error, stackTrace) {
          ++_triedEndPoints;
          ++_lastEndPoint;
          _lastEndPoint %= _config.services.endPoints.length;
          log.warning('Failed to open session.', error, stackTrace);
          connected = NetworkConnectionState.failing;
          onCommonChanged();
          if (error is grpc.GrpcError &&
              error.code == grpc.GrpcError.failedPrecondition().code) {
            log.warning(
                'This session is no longer valid for this server, removing session.');
            if (_wantedLocalAccount == localAccount) {
              _wantedLocalAccount = null;
            }
            multiAccountStore.removeLocal(
                localAccount.domain, localAccount.localId);
            multiAccountStore.addAccount(_config.services.domain);
            break;
          }
        }
      } while (!success &&
          _triedEndPoints < _config.services.endPoints.length &&
          (_overrideEndPoint == null || _overrideEndPoint.isEmpty));
      _triedEndPoints = 0;
    }
    if (!success) {
      // Close any existing session
      connected = NetworkConnectionState.offline;
      cleanupStateSwitchingAccounts();
      _currentLocalAccount = null;
      if (_currentApiSessionToken != null) {
        _pushSessionToken(null);
      }
      // Re-attempt after backoff
      _backoff = grpc.defaultBackoffStrategy(_backoff);
      log.info('Try again in ${_backoff.inSeconds} second(s).');
      final Duration backoff = _backoff;
      unawaited(() async {
        await Future<void>.delayed(backoff);
        await _kickstartSession();
      }());
    }
  }

  StreamSubscription<ApiSessionToken> _sessionSubscription;

  @override
  void initAccount() {
    _sessionSubscription = sessionChanged.listen(_onSessionChanged);
    _alive = true;

    // Device ghost id is a semi sequential identifier for identifying messages by device (to ensure all are sent and to avoid duplicates)
    nextSessionGhostId =
        (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF;

    // Initialize data
    resetAccountState();
  }

  @override
  void accountStartSession() {
    _wantedLocalAccount = multiAccountStore.current;
    unawaited(_kickstartSession());
  }

  @override
  void pushKeepAlive() {
    //++_keepAliveBackground;
  }

  @override
  void popKeepAlive() {
    //--_keepAliveBackground;
  }

  @override
  void overrideEndPoint(String serverUri) {
    log.info('Override server uri to $serverUri');
    _overrideEndPoint = serverUri;
    refreshAccessToken();
  }

  void syncMultiAccountStore(MultiAccountStore multiAccountStore) {
    _multiAccountStore = multiAccountStore;
  }

  void syncConfig(ConfigData config) {
    // May only be called from a setState block
    if (_config != config) {
      log.fine('Sync config changes to network');
      _config = config;
      onCommonChanged();
    }
    if (_config == null) {
      log.severe(
          'Widget config is null in network sync'); // DEVELOPER - CRITICAL
    }
    refreshAccessToken();
  }

  void cleanupStateSwitchingAccounts() {
    resetProfilesState();
    resetOffersState();
    resetExploreState();
    resetProposalsState();
    resetAccountState();
  }

  void resetAccountState() {
    _accountGhostChanges.clear();
    _realAccount = emptyAccount();
    account = emptyAccount(); //..freeze();
  }

  @override
  void accountReassemble() {
    if (connected != NetworkConnectionState.ready) {
      _lastEndPoint = 0;
      // unawaited(_forceReopenSession());
    } else {
      // unawaited(refreshAccessToken());
    }
    unawaited(refreshAccessToken());
  }

  @override
  void disposeAccount() {
    _alive = false;
    refreshAccessToken();
    _sessionSubscription.cancel();
    _sessionSubscription = null;
    _sessionChanged.close();
  }

  @override
  void accountDependencyChanged() {
    refreshAccessToken();
  }

  void setApplicationForeground(bool foreground) {
    // TODO: This affects push api, not the session api
    if (foreground) {
      refreshAccessToken();
    }
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Session
  /////////////////////////////////////////////////////////////////////

  @override
  void processSwitchAccount(LocalAccountData localAccount) {
    _wantedLocalAccount = localAccount;
    _kickstartSession();
  }

/*
  Future<void> _configDownload(TalkMessage message) async {
    final NetConfigDownload download = NetConfigDownload()
      ..mergeFromBuffer(message.data)
      ..freeze();
    // TODO: Tell config manager to download
    // download.configUrl
    // ConfigManager.............
    // config.
  }
*/
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

/*
  Future<void> _sessionRemove(TalkMessage message) async {
    log.info('Remove session.');
    if (_lastPayloadLocalId != _currentLocalAccount.localId) {
      log.warning('Already switched account, cannot remove session.');
      if (channel != null) {
        final TalkChannel closeChannel = channel;
        channel = null;
        await closeChannel.close();
      }
      return;
    }
    multiAccountStore.removeLocal(
        _currentLocalAccount.domain, _currentLocalAccount.localId);
    multiAccountStore.addAccount(_config.services.domain);
  }*/

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Account
  /////////////////////////////////////////////////////////////////////

  void addAccountGhost(DataAccount accountChanged) {
    _accountGhostChanges.add(accountChanged);
    _rebuildAccountGhost();
  }

  void removeAccountGhost(DataAccount accountChanged) {
    _accountGhostChanges.remove(accountChanged);
    _rebuildAccountGhost();
  }

  /// Rebuilds the account structure with pending modifications
  void _rebuildAccountGhost() {
    final DataAccount account = _realAccount.clone();
    for (DataAccount accountChanged in _accountGhostChanges) {
      if (accountChanged.categories.isNotEmpty) {
        account.categories.clear();
      }
      if (accountChanged.coverUrls.isNotEmpty) {
        account.coverUrls.clear();
      }
      if (accountChanged.blurredCoverUrls.isNotEmpty) {
        account.blurredCoverUrls.clear();
      }
      account.mergeFromMessage(accountChanged);
    }
    this.account = account..freeze();
    onCommonChanged();
  }

  @override
  void receivedAccountUpdate(DataAccount account, {DataAccount removeGhost}) {
    log.info('Account state update received.');
    log.fine('NetAccountUpdate: $account');
    if (this.account.accountId != account.accountId) {
      cleanupStateSwitchingAccounts();
    }
    _realAccount = account;
    if (removeGhost == null) {
      _rebuildAccountGhost();
    } else {
      removeAccountGhost(removeGhost);
    }
    if (this.account.accountId != Int64.ZERO) {
      if (_currentLocalAccount.sessionId != this.account.sessionId) {
        log.severe(
            "Mismatching current session ID '${_currentLocalAccount.sessionId}' "
            "and received session ID '${this.account.sessionId}'");
      } else {
        // Update local account store
        _multiAccountStore.setAccountId(
            _currentLocalAccount.domain,
            _currentLocalAccount.localId,
            this.account.accountId,
            this.account.accountType);
        _multiAccountStore.setNameAvatar(
            _currentLocalAccount.domain,
            _currentLocalAccount.localId,
            this.account.name,
            this.account.blurredAvatarUrl,
            this.account.avatarUrl);
      }
      // Mark all caches as dirty, since we may have been offline for a while
      markEverythingDirty();
      unawaited(refreshFirebaseNotifications());
    }
  }

  @override
  void markEverythingDirty() {
    markProfilesDirty();
    markOffersDirty();
    markExploreDirty();
    markProposalsDirty();
  }

  @override
  Future<void> setAccountType(AccountType accountType) async {
    if (accountType == account.accountType) {
      // no-op
      return;
    }

    // Create a ghost account delta
    final DataAccount accountChanged = DataAccount();
    accountChanged.accountType = accountType;
    for (DataSocialMedia media in account.socialMedia.values) {
      accountChanged.socialMedia[media.providerId] = media.clone();
      accountChanged.socialMedia[media.providerId].connected = false;
    }
    addAccountGhost(accountChanged..freeze());

    // Send server request
    try {
      await _clientReady;
      final NetSetAccountType request = NetSetAccountType();
      request.accountType = accountType;
      final NetAccount response =
          await _accountClient.setType(request..freeze());
      receivedAccountUpdate(response.account, removeGhost: accountChanged);
    } catch (_, __) {
      removeAccountGhost(accountChanged);
      rethrow;
    }
  }

  /// Set Firebase cloud messaging token
  @override
  Future<void> setFirebaseToken(
      String oldFirebaseToken, String firebaseToken) async {
    // Create a ghost account delta
    final DataAccount accountChanged = DataAccount();
    accountChanged.firebaseToken = firebaseToken;
    addAccountGhost(accountChanged..freeze());

    // Send server request
    try {
      await _clientReady;
      final NetSetFirebaseToken request = NetSetFirebaseToken();
      if (oldFirebaseToken != null) {
        request.oldFirebaseToken = oldFirebaseToken;
      }
      request.firebaseToken = firebaseToken;
      final NetAccount response =
          await _accountClient.setFirebaseToken(request..freeze());
      receivedAccountUpdate(response.account, removeGhost: accountChanged);
    } catch (_, __) {
      removeAccountGhost(accountChanged);
      rethrow;
    }
  }

  /// Update account
  @override
  Future<void> updateAccount(DataAccount accountChanged) async {
    // Create a ghost account delta
    addAccountGhost(accountChanged);

    // Send server request
    try {
      await _clientReady;
      // TODO: Implement on server and in API
      throw Exception();
      // receivedAccountUpdate(response.account, removeGhost: accountChanged);
    } catch (_, __) {
      removeAccountGhost(accountChanged);
      rethrow;
    }
  }

  @override
  Future<NetOAuthUrl> getOAuthUrls(int oauthProvider) async {
    await _clientReady;
    final NetOAuthGetUrl request = NetOAuthGetUrl();
    request.oauthProvider = oauthProvider;
    return await _oauthClient.getUrl(request);
  }

  @override
  Future<NetOAuthSecrets> getOAuthSecrets(int oauthProvider) async {
    await _clientReady;
    final NetOAuthGetSecrets request = NetOAuthGetSecrets();
    request.oauthProvider = oauthProvider;
    return await _oauthClient.getSecrets(request);
  }

  @override
  Future<NetOAuthConnection> connectOAuth(
      int oauthProvider, String callbackQuery) async {
    await _clientReady;

    final NetOAuthConnect request = NetOAuthConnect();
    request.oauthProvider = oauthProvider;
    request.callbackQuery = callbackQuery;
    final NetOAuthConnection response =
        await _accountClient.connectProvider(request);

    // Result contains the updated data, so needs to be put into the state
    if (response.hasAccount()) {
      receivedAccountUpdate(response.account);
    }
    if (oauthProvider < config.oauthProviders.length &&
        response.hasSocialMedia()) {
      final DataAccount account = _realAccount.clone();
      account.socialMedia[oauthProvider] = response.socialMedia;
      receivedAccountUpdate(account);
    }

    // Push updated access token
    if (response.hasAccessToken()) {
      _pushSessionToken(ApiSessionToken(
        _currentApiSessionToken.endPoint,
        _currentApiSessionToken.channel,
        response.accessToken,
      ));
    }

    // Return just whether connected or not
    return response;
  }

  @override
  Future<void> createAccount(double latitude, double longitude) async {
    await _clientReady;
    final NetAccountCreate request = NetAccountCreate();
    if (latitude != null &&
        latitude != 0.0 &&
        longitude != null &&
        longitude != 0.0) {
      request.latitude = latitude;
      request.longitude = longitude;
    }
    final NetSession response = await _accountClient.create(request);
    if (response.hasAccessToken()) {
      _pushSessionToken(ApiSessionToken(
        _currentApiSessionToken.endPoint,
        _currentApiSessionToken.channel,
        response.accessToken,
      ));
    }
    receivedAccountUpdate(response.account);
    if (account.accountId == 0) {
      throw const NetworkException('No account was created');
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
  Future<NetUploadSigned> uploadImage(File file) async {
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
    final NetUploadImage request = NetUploadImage();
    request.fileName = file.path;
    request.contentLength = contentLength;
    request.contentType = contentType;
    request.contentSha256 = contentSha256.bytes;

    // Fetch the pre-signed URL from the server
    final NetUploadSigned response =
        await _storageClient.signImageUpload(request);

    if (response.fileExists) {
      // File already exists, so no need to upload it again
      return response;
    }

    // Upload the file
    final http.StreamedRequest httpRequest = http.StreamedRequest(
        response.requestMethod, Uri.parse(response.requestUrl));
    httpRequest.headers['Content-Type'] = contentType;
    httpRequest.headers['Content-Length'] = contentLength.toString();
    // FIXME: Spaces doesn't process this option when in pre-signed URL query
    httpRequest.headers['x-amz-acl'] = 'public-read';
    final Future<http.StreamedResponse> futureResponse = httpRequest.send();
    await for (List<int> buffer in file.openRead()) {
      // TODO: Not sure if tracking progress here is feasible, since there's no write blocking on streams...
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
    return response;
  }
}

/* end of file */
