import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inf/backend/services/system_service_.dart';
import 'package:rxdart/rxdart.dart';

class SystemServiceImplementation
    with WidgetsBindingObserver
    implements SystemService {
  @override
  Observable<NetWorkConnectionState> get connectionState => _connectionSubject;

  final BehaviorSubject<NetWorkConnectionState> _connectionSubject =
      new BehaviorSubject<NetWorkConnectionState>();

  @override
  Observable<AppLifecycleState> get appLifecycleState => _appLifecycleSubject;

  final BehaviorSubject<AppLifecycleState> _appLifecycleSubject =
      new BehaviorSubject<AppLifecycleState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleSubject.add(state);
  }

  SystemServiceImplementation(){
      WidgetsBinding.instance.addObserver(this);
  }
}
