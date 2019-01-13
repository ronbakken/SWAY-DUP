/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

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

  StreamSubscription<ApiSessionToken> _sessionSubscription;
  void _onSessionChanged(ApiSessionToken session) {
    if (session == null) {
      if (__clientReady.isCompleted) {
        __clientReady = Completer<void>();
      }
      _pushClient = null;
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
    await _sessionSubscription.cancel();
    _sessionSubscription = null;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////

  final Lock _lock = Lock();
  Duration _backoff;
  StreamSubscription<NetPush> _pushSubscription;

  @override
  NetworkConnectionState receiving = NetworkConnectionState.waiting;

  void _connectListener() {
    unawaited(
      _lock.synchronized(
        () async {
          if (_pushClient != null && _pushSubscription == null) {
            log.info('Connect to push service');
            if (receiving != NetworkConnectionState.failing) {
              receiving = NetworkConnectionState.connecting;
              onCommonChanged();
            }
            _pushSubscription = _pushClient.listen(NetListen()).listen(
                  _receiveMessage,
                  onError: _receiveError,
                  onDone: _receiveDone,
                );
            // TODO: Does `_pushClient.listen` throw exceptions?
          }
        },
      ),
    );
  }

  void _disconnectListener() {
    unawaited(_lock.synchronized(() async {
      if (_pushSubscription != null) {
        log.info('Disconnect from push service');
        final StreamSubscription<NetPush> subscription = _pushSubscription;
        _pushSubscription = null;
        await subscription.cancel();
      }
      receiving = NetworkConnectionState.waiting;
      onCommonChanged();
    }));
  }

  void _receiveMessage(NetPush push) {
    if (push.hasPushing()) {
      _backoff = null;
      log.info('Push connection ready');
      receiving = NetworkConnectionState.ready;
      onCommonChanged();
    }
    /*
    1: NetPush_Push.updateAccount,
    2: NetPush_Push.updateOffer,
    3: NetPush_Push.newProposal,
    4: NetPush_Push.updateProposal,
    5: NetPush_Push.newProposalChat,
    6: NetPush_Push.updateProposalChat,
    7: NetPush_Push.configDownload,
    8: NetPush_Push.pushing,
    */
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
      final StreamSubscription<NetPush> subscription = _pushSubscription;
      _pushSubscription = null;
      await subscription.cancel();
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
