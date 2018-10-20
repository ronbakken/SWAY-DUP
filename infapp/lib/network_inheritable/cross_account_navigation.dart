/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Cross Account Navigation
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
import 'package:flutter/material.dart';
import 'package:inf/network_inheritable/multi_account_selection.dart';

enum NavigationTarget {
  Profile,
  Offer,
  Proposal, // aka Haggle Chat
}

class NavigationRequest {
  final NavigationTarget target;
  final Int64 id;
  const NavigationRequest(this.target, this.id);
}

class CrossAccountNavigation extends StatefulWidget {
  final Widget child;

  const CrossAccountNavigation({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new CrossAccountNavigator();
  }

  static CrossAccountNavigator of(BuildContext context) {
    final _CrossAccountNavigationInherited inherited =
        context.inheritFromWidgetOfExactType(_CrossAccountNavigationInherited);
    return inherited?.navigator;
  }
}

class CrossAccountNavigator extends State<CrossAccountNavigation> {
  final Map<String, StreamController<NavigationRequest>> _navigationRequests = new Map<String, StreamController<NavigationRequest>>();

  @override
  Widget build(BuildContext context) {
    return new _CrossAccountNavigationInherited(
        child: widget.child, navigator: this);
  }

  @override
  void dispose() {
    for (StreamController<NavigationRequest> controller in _navigationRequests.values) {
      controller.close();
    }
    _navigationRequests.clear();
    super.dispose();
  }

  StreamSubscription<NavigationRequest> listen(String domain, Int64 accountId, Function(NavigationTarget target, Int64 id) onData) {
    assert(onData != null);
    assert(mounted);
    String key = "$domain/$accountId"; // Good enough
    StreamController<NavigationRequest> controller = _navigationRequests[key]; 
    if (controller?.hasListener ?? false) {
      controller.close(); // Bye bye
      controller = null;
    }
    if (controller == null) {
      controller = new StreamController<NavigationRequest>();
      _navigationRequests[key] = controller;
    }
    return controller.stream.listen((data) {
      onData(data.target, data.id);
    });
  }

  void navigate(String domain, Int64 accountId, NavigationTarget target, Int64 id) {
    assert(mounted);
    String key = "$domain/$accountId";
    StreamController<NavigationRequest> controller = _navigationRequests[key]; 
    if (controller == null) {
      controller = new StreamController<NavigationRequest>();
      _navigationRequests[key] = controller;
    }
    // We want to open this screen
    controller.add(new NavigationRequest(target, id));
    // On this account
    MultiAccountSelection.of(context).switchAccount(domain, accountId);
  }
}

class _CrossAccountNavigationInherited extends InheritedWidget {
  final CrossAccountNavigator navigator;

  const _CrossAccountNavigationInherited(
      {Key key, Widget child, this.navigator})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

/* end of file */
