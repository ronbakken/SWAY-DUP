import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:inf/backend/services/system_service_.dart';
import 'package:rxdart/rxdart.dart';


class SystemServiceMock with WidgetsBindingObserver implements SystemService
{

  final BehaviorSubject<NetworkConnectionState> _connectionSubject = new BehaviorSubject<NetworkConnectionState>();

  @override
  Observable<NetworkConnectionState> get connectionState => _connectionSubject;


  SystemServiceMock(NetworkConnectionState state)
  {
      _connectionSubject.add(state);
      WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  Observable<AppLifecycleState> get appLifecycleState => _appLifecycleSubject;

  final BehaviorSubject<AppLifecycleState> _appLifecycleSubject =
      new BehaviorSubject<AppLifecycleState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleSubject.add(state);
  }



}