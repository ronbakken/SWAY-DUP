/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/api.dart';
import 'package:inf/network_generic/api_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:pedantic/pedantic.dart';
import 'package:synchronized/synchronized.dart';
import 'package:grpc/grpc.dart' as grpc;

abstract class ApiPush implements Api, ApiInternals {
  Completer<void> __clientReady = Completer<void>();
  ApiPushClient _pushClient;
  Future<void> get _clientReady {
    return __clientReady.future;
  }

  String _endPoint;
  String _token;

  StreamSubscription<ApiSessionToken> _sessionSubscription;
  void _onSessionChanged(ApiSessionToken session) {
    if (session == null) {
      if (__clientReady.isCompleted) {
        __clientReady = Completer<void>();
      }
      _pushClient = null;
      _endPoint = null;
      _token = null;
      _disconnectListener();
    } else {
      if (!__clientReady.isCompleted) {
        __clientReady.complete();
      }
      _pushClient = ApiPushClient(
        session.channel,
        options: grpc.CallOptions(
          metadata: <String, String>{
            'authorization': 'Bearer ${session.token}'
          },
        ),
      );
      final Uri uri = Uri.parse(session.endPoint);
      _endPoint = Uri(
        scheme: uri.scheme == 'http' ? 'ws' : 'wss',
        host: uri.host,
        port: uri.port, // 8911, //
        path: '/ws',
      ).toString();
      _token = session.token;
      _backoff = null;
      if (_pushSubscription != null) {
        _disconnectListener();
      } else {
        _connectListener();
      }
    }
  }

  @override
  void initPush() {
    _sessionSubscription = sessionChanged.listen(_onSessionChanged);
  }

  @override
  Future<void> disposePush() async {
    await _pushSubscription.cancel();
    _pushSubscription = null;
    await _sessionSubscription.cancel();
    _sessionSubscription = null;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////

  final Lock _lock = Lock();
  Duration _backoff;
  StreamSubscription<dynamic> _pushSubscription;

  @override
  NetworkConnectionState receiving = NetworkConnectionState.waiting;

  static const bool _useWebSocket = false;

  void _connectListener() {
    unawaited(
      _lock.synchronized(
        () async {
          if (_pushClient != null &&
              _pushSubscription == null &&
              account.accountId != Int64.ZERO) {
            log.info(
                'Connect to push service, accountId: ${account.accountId}');
            if (receiving != NetworkConnectionState.failing) {
              receiving = NetworkConnectionState.connecting;
              onCommonChanged();
            }
            if (_useWebSocket) {
              try {
                final WebSocket ws = await WebSocket.connect(_endPoint,
                    headers: <String, dynamic>{
                      'authorization': 'Bearer $_token',
                    });
                _pushSubscription = ws.listen(_receiveData,
                    onError: _receiveError, onDone: _receiveDone);
              } catch (error, stackTrace) {
                _receiveError(error, stackTrace);
                _receiveDone();
              }
            } else {
              try {
                _pushSubscription = _pushClient.listen(NetListen()).listen(
                      _receiveMessage,
                      onError: _receiveError,
                      onDone: _receiveDone,
                    );
                // TODO: Does `_pushClient.listen` throw exceptions?
              } catch (error, stackTrace) {
                log.warning(
                    'Failed to connect to push service', error, stackTrace);
                if (error is grpc.GrpcError) {
                  final grpc.GrpcError grpcError = error;
                  if (grpcError.code == grpc.GrpcError.unavailable().code &&
                      grpcError.message.contains(
                          'The http/2 connection is no longer active')) {
                    // TODO: This seems to be a design flaw in the gRPC library...
                    // I/flutter ( 2588): gRPC Error (14, Error making call: Bad state: The http/2 connection is no longer active and can therefore not be used to make new streams.)
                    await refreshAccessToken();
                  }
                }
                rethrow;
              }
            }
          }
        },
      ),
    );
  }

  void _disconnectListener() {
    unawaited(_lock.synchronized(() async {
      if (_pushSubscription != null) {
        log.info('Disconnect from push service');
        final StreamSubscription<dynamic> subscription = _pushSubscription;
        _pushSubscription = null;
        await subscription.cancel();
      }
      receiving = NetworkConnectionState.waiting;
      onCommonChanged();
    }));
  }

  void _receiveData(dynamic data) {
    _receiveMessage(NetPush()..mergeFromBuffer(data as List<int>));
  }

  void _receiveMessage(NetPush push) {
    if (push.hasPushing()) {
      if (receiving != NetworkConnectionState.ready) {
        _backoff = null;
        log.info('Push connection ready');
        receiving = NetworkConnectionState.ready;
        onCommonChanged();
        markEverythingDirty();
      }
    } else if (push.hasKeepAlive()) {
      // Doesn't seem useful
      // _pushClient.keepAlive(push.keepAlive);
    } else if (push.hasUpdateAccount()) {
      receivedAccountUpdate(push.updateAccount.account);
    } else if (push.hasUpdateOffer()) {
      // TODO: Handle remote offer changes
    } else if (push.hasNewProposal()) {
      liveNewProposal(push.newProposal);
    } else if (push.hasUpdateProposal()) {
      liveUpdateProposal(push.updateProposal);
    } else if (push.hasNewProposalChat()) {
      liveNewProposalChat(push.newProposalChat);
    } else if (push.hasUpdateProposalChat()) {
      liveUpdateProposalChat(push.updateProposalChat);
    } else if (push.hasConfigDownload()) {
      // TODO: Signal the config downloader to redownload the configuration
    }
  }

  void _receiveError(Object error, StackTrace stackTrace) {
    log.warning('Push receive error.', error, stackTrace);
  }

  void _receiveDone() {
    log.info('Disconnection from push service occurred');
    if (receiving == NetworkConnectionState.connecting) {
      receiving = NetworkConnectionState.failing;
    } else if (receiving != NetworkConnectionState.failing &&
        receiving != NetworkConnectionState.waiting) {
      assert(receiving == NetworkConnectionState.offline ||
          receiving == NetworkConnectionState.ready);
      receiving = NetworkConnectionState.offline;
    }
    onCommonChanged();
    unawaited(() async {
      final StreamSubscription<dynamic> subscription = _pushSubscription;
      if (subscription != null) {
        _pushSubscription = null;
        await subscription.cancel();
      }
      if (_pushClient != null) {
        if (_backoff != null) {
          log.info('Retry push service in ${_backoff.inSeconds} second(s)');
          await Future<void>.delayed(_backoff);
        }
        _backoff = grpc.defaultBackoffStrategy(_backoff);
        _connectListener();
      }
    }());
  }
}

/* end of file */
