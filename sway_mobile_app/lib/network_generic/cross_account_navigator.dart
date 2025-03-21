/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

// TODO (2018 OCT 20): Hook into a network callback for navigation, rather than having the network call into this class.

/*

Cross Account Navigator
========================

This class serves as a buffer for navigation requests accross accounts.

Currently this only occurs when pushing on notifications.

The app should listen to events from it's user alone.

            If an event is fired for a different user, 
        this class will fire a request to switch accounts,
  and as soon as the network and configuration is done switching,
             the app will get it's navigation request.

*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:sway_mobile_app/network_generic/multi_account_client.dart';

class NavigationRequest {
  final NavigationTarget target;
  final Int64 id;
  const NavigationRequest(this.target, this.id);
}

class CrossAccountNavigator {
  MultiAccountClient multiAccountClient;
  final Map<String, StreamController<NavigationRequest>> _navigationRequests =
      <String, StreamController<NavigationRequest>>{};

  void dispose() {
    for (StreamController<NavigationRequest> controller
        in _navigationRequests.values) {
      controller.close();
    }
    _navigationRequests.clear();
  }

  StreamController<NavigationRequest> _createController(String key) {
    final StreamController<NavigationRequest> controller =
        StreamController<NavigationRequest>(onCancel: () {
      final StreamController<NavigationRequest> controller =
          _navigationRequests.remove(key);
      controller?.close(); // Bye
    });
    _navigationRequests[key] = controller;
    return controller;
  }

  StreamSubscription<NavigationRequest> listen(String domain, Int64 accountId,
      Function(NavigationTarget target, Int64 id) onData) {
    assert(onData != null);
    // assert(mounted);
    final String key = '$domain/$accountId'; // Works
    StreamController<NavigationRequest> controller = _navigationRequests[key];
    if (controller?.hasListener ?? false) {
      controller.close(); // Bye
      controller = null;
    }
    controller ??= _createController(key);
    return controller.stream.listen((NavigationRequest data) {
      onData(data.target, data.id);
    });
  }

  void navigate(
      String domain, Int64 accountId, NavigationTarget target, Int64 id) {
    // assert(mounted);
    final String key = '$domain/$accountId';
    StreamController<NavigationRequest> controller =
        _navigationRequests[key]; // Closed by dispose(), listen(), and onCancel
    controller ??= _createController(key);
    // We want to open this screen
    controller.add(NavigationRequest(target, id));
    // On this account
    assert(multiAccountClient != null);
    multiAccountClient.switchAccount(domain, accountId);
  }
}

/* end of file */
