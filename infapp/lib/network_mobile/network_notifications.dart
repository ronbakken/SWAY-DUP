/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switchboard/switchboard.dart';

abstract class NetworkNotifications implements ApiClient, NetworkInternals {
  bool _firebaseSetup = false;
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationDetails platformChannelSpecifics;

  List<int> _suppressChatNotifications = new List<int>();

  Stream<CrossNavigationRequest> get onNavigationRequest {
    return _onNavigationRequest.stream;
  }

  StreamController<CrossNavigationRequest> _onNavigationRequest =
      new StreamController<CrossNavigationRequest>();

  void disposeNotifications() {
    _onNavigationRequest.close();
  }

  void initNotifications() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'chat', 'Messages', 'Messages received from other users',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  @override
  Future<void> initFirebaseNotifications() async {
    if (!_firebaseSetup) {
      // Set up Firebase
      _firebaseSetup = true;
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: _firebaseOnMessage,
        onLaunch: _firebaseOnLaunch,
        onResume: _firebaseOnResume,
      );
      _firebaseMessaging.onTokenRefresh.listen(
          _firebaseOnToken); // Ensure network manager is persistent or this may fail
      if (config.services.domain.isNotEmpty) {
        // Allows to send dev messages under domain_dev topic
        log.fine("Domain: ${config.services.domain}");
        _firebaseMessaging
            .subscribeToTopic('domain_' + config.services.domain);
      }
    }
    _firebaseOnToken(await _firebaseMessaging.getToken());
  }

  void _firebaseOnToken(String token) async {
    // Set firebase token for current account if it has changed
    // Update it for other accounts as well in case there is a known old token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oldFirebaseToken;
    try {
      oldFirebaseToken = prefs.getString('firebase_token');
    } catch (error) {}
    if (account.state.accountId != 0) {
      if (account.state.firebaseToken != token || oldFirebaseToken != token) {
        account.state.firebaseToken = token;
        NetSetFirebaseToken setFirebaseToken = new NetSetFirebaseToken();
        if (oldFirebaseToken != null)
          setFirebaseToken.oldFirebaseToken = oldFirebaseToken;
        setFirebaseToken.firebaseToken = token;
        channel.sendMessage("SFIREBAT", setFirebaseToken.writeToBuffer());
        prefs.setString('firebase_token', token);
      }
    }
  }

  @override
  void pushSuppressChatNotifications(Int64 proposalId) {
    _suppressChatNotifications.add(proposalId.toInt());
  }

  @override
  void popSuppressChatNotifications() {
    _suppressChatNotifications.removeLast();
  }

  Future<dynamic> _firebaseOnMessage(Map<String, dynamic> data) async {
    log.fine("Firebase Message Received");
    // Fired when a message is received when the app is in foreground
    log.fine(data);
    // Handle all notifications not meant for the current account
    // And any current notifications which are not surpressed
    String domain = data['data']['domain'].toString();
    int accountId = int.tryParse(data['data']['account_id']);
    int proposalId = int.tryParse(data['data']['proposal_id']);
    String title = data['notification']['title'];
    String body = data['notification']['body'];
    if (_suppressChatNotifications.isEmpty ||
        _suppressChatNotifications.last != proposalId ||
        domain != config.services.domain ||
        accountId != account.state.accountId) {
      await flutterLocalNotificationsPlugin.show(
        proposalId,
        title,
        body,
        platformChannelSpecifics,
        payload:
            'domain=$domain&account_id=$accountId&proposal_id=$proposalId',
      );
    }
  }

  Future<dynamic> _firebaseOnLaunch(Map<String, dynamic> data) async {
    log.fine("Firebase Launch Received: $data");
    // Fired when the app was opened by a message
    if (data['proposal_id'] != null) {
      _onNavigationRequest.add(new CrossNavigationRequest(
          data['domain'],
          Int64.parseInt(data['account_id']),
          NavigationTarget.Proposal,
          Int64.parseInt(data['proposal_id'])));
    }
  }

  Future<dynamic> _firebaseOnResume(Map<String, dynamic> data) async {
    log.fine("Firebase Resume Received: $data");
    // Fired when the app was opened by a message
    /*{collapse_key: app.infmarketplace, 
    account_id: 10, 
    proposal_id: 16, 
    google.original_priority: high, 
    google.sent_time: 1537966114567, 
    google.delivered_priority: high, 
    domain: dev, google.ttl: 2419200, 
    from: 1051755311348, type: 0, 
    google.message_id: 0:1537966114577353%ddd1e337ddd1e337, 
    sender_id: 11}*/
    if (data['proposal_id'] != null) {
      _onNavigationRequest.add(new CrossNavigationRequest(
          data['domain'],
          Int64.parseInt(data['account_id']),
          NavigationTarget.Proposal,
          Int64.parseInt(data['proposal_id'])));
    }
  }

  Future<dynamic> onSelectNotification(String payload) async {
    if (payload != null) {
      log.fine('Local notification payload: $payload');
      /*domain=dev&account_id=10&proposal_id=16*/
      Map<String, String> data = Uri.splitQueryString(payload);
      if (data['proposal_id'] != null) {
        _onNavigationRequest.add(new CrossNavigationRequest(
            data['domain'],
            Int64.parseInt(data['account_id']),
            NavigationTarget.Proposal,
            Int64.parseInt(data['proposal_id'])));
      }
    }
  }
}

/* end of file */
