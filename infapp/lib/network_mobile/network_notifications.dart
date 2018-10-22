/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf/network_generic/network_interface.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wstalk/wstalk.dart';

abstract class NetworkNotifications
    implements NetworkInterface, NetworkInternals {
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
        selectNotification: onSelectNotification);
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
        print("[INF] Domain: ${config.services.domain}");
        _firebaseMessaging.subscribeToTopic('domain_' + config.services.domain);
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
        ts.sendMessage(
            TalkSocket.encode("SFIREBAT"), setFirebaseToken.writeToBuffer());
        prefs.setString('firebase_token', token);
      }
    }
  }

  @override
  void pushSuppressChatNotifications(Int64 applicantId) {
    _suppressChatNotifications.add(applicantId.toInt());
  }

  @override
  void popSuppressChatNotifications() {
    _suppressChatNotifications.removeLast();
  }

  Future<dynamic> _firebaseOnMessage(Map<String, dynamic> data) async {
    print("[INF] Firebase Message Received");
    // Fired when a message is received when the app is in foreground
    print(data);
    // Handle all notifications not meant for the current account
    // And any current notifications which are not surpressed
    String domain = data['data']['domain'].toString();
    int accountId = int.tryParse(data['data']['account_id']);
    int applicantId = int.tryParse(data['data']['applicant_id']);
    String title = data['notification']['title'];
    String body = data['notification']['body'];
    if (_suppressChatNotifications.isEmpty ||
        _suppressChatNotifications.last != applicantId ||
        domain != config.services.domain ||
        accountId != account.state.accountId) {
      await flutterLocalNotificationsPlugin.show(
        applicantId,
        title,
        body,
        platformChannelSpecifics,
        payload:
            'domain=$domain&account_id=$accountId&applicant_id=$applicantId',
      );
    }
  }

  Future<dynamic> _firebaseOnLaunch(Map<String, dynamic> data) async {
    print("[INF] Firebase Launch Received: $data");
    // Fired when the app was opened by a message
    if (data['applicant_id'] != null) {
      _onNavigationRequest.add(new CrossNavigationRequest(
          data['domain'],
          Int64.parseInt(data['account_id']),
          NavigationTarget.Proposal,
          Int64.parseInt(data['applicant_id'])));
    }
  }

  Future<dynamic> _firebaseOnResume(Map<String, dynamic> data) async {
    print("[INF] Firebase Resume Received: $data");
    // Fired when the app was opened by a message
    /*{collapse_key: app.infmarketplace, 
    account_id: 10, 
    applicant_id: 16, 
    google.original_priority: high, 
    google.sent_time: 1537966114567, 
    google.delivered_priority: high, 
    domain: dev, google.ttl: 2419200, 
    from: 1051755311348, type: 0, 
    google.message_id: 0:1537966114577353%ddd1e337ddd1e337, 
    sender_id: 11}*/
    if (data['applicant_id'] != null) {
      _onNavigationRequest.add(new CrossNavigationRequest(
          data['domain'],
          Int64.parseInt(data['account_id']),
          NavigationTarget.Proposal,
          Int64.parseInt(data['applicant_id'])));
    }
  }

  Future<dynamic> onSelectNotification(String payload) async {
    if (payload != null) {
      print('[INF] Local notification payload: ' + payload);
      /*domain=dev&account_id=10&applicant_id=16*/
      Map<String, String> data = Uri.splitQueryString(payload);
      if (data['applicant_id'] != null) {
      _onNavigationRequest.add(new CrossNavigationRequest(
            data['domain'],
            Int64.parseInt(data['account_id']),
            NavigationTarget.Proposal,
            Int64.parseInt(data['applicant_id'])));
      }
    }
  }
}

/* end of file */
