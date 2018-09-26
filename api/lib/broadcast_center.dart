/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:quiver/collection.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;
import 'package:synchronized/synchronized.dart';

import 'inf.pb.dart';
import 'remote_app.dart';
import 'cache_map.dart';

class _CachedApplicant {
  final int influencerAccountId;
  final int businessAccountId;
  _CachedApplicant(this.influencerAccountId, this.businessAccountId);
}

/// Cached account information with the purpose of sending notifications
class _CachedAccountName {
  final String name;
  _CachedAccountName(this.name);
}

class _CachedAccountFirebaseTokens {
  final List<String> firebaseTokens;
  _CachedAccountFirebaseTokens(this.firebaseTokens);
}

class BroadcastCenter {
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  final ConfigData config;
  final sqljocky.ConnectionPool sql;
  final dospace.Bucket bucket;

  final HttpClient _httpClient = new HttpClient();

  Multimap<int, RemoteApp> _accountToRemoteApps =
      new Multimap<int, RemoteApp>();

  CacheMap<int, _CachedApplicant> _applicantToInfluencerBusiness =
      new CacheMap<int, _CachedApplicant>();

  final _lockCachedAccountName = new Lock();
  CacheMap<int, _CachedAccountName> _cachedAccountName =
      new CacheMap<int, _CachedAccountName>();
  final _lockCachedAccountFirebaseTokens = new Lock();
  CacheMap<int, _CachedAccountFirebaseTokens> _cachedAccountFirebaseTokens =
      new CacheMap<int, _CachedAccountFirebaseTokens>();

  static final Logger opsLog = new Logger('InfOps.BroadcastCenter');
  static final Logger devLog = new Logger('InfDev.BroadcastCenter');

  BroadcastCenter(this.config, this.sql, this.bucket) {}

  /////////////////////////////////////////////////////////////////////////////
  // Caches (cache non-critical static-ish data only)
  /////////////////////////////////////////////////////////////////////////////

  Future<_CachedApplicant> _getApplicant(int applicantId) async {
    _CachedApplicant applicant = _applicantToInfluencerBusiness[applicantId];
    if (applicant != null) return applicant;
    sqljocky.Results res = await sql.prepareExecute(
        "SELECT `influencer_account_id`, `business_account_id` "
        "FROM `applicants` WHERE `applicant_id` = ?",
        [applicantId.toInt()]);
    await for (sqljocky.Row row in res) {
      applicant = new _CachedApplicant(row[0].toInt(), row[1].toInt());
      _applicantToInfluencerBusiness[applicantId] = applicant;
    }
    return applicant; // May be null if not found
  }

  Future<String> _getAccountName(int accountId) async {
    _CachedAccountName cached = _cachedAccountName[accountId];
    if (cached != null) return cached.name;
    await _lockCachedAccountName.synchronized(() async {
      sqljocky.Results res = await sql.prepareExecute(
          "SELECT `name`"
          "FROM `accounts` "
          "WHERE `account_id` = ? ",
          [accountId.toInt()]);
      await for (sqljocky.Row row in res) {
        cached = new _CachedAccountName(row[0].toString());
        _cachedAccountName[accountId] = cached;
      }
    });
    return cached.name; // May be null if not found
  }

  Future<List<String>> _getAccountFirebaseTokens(int accountId) async {
    _CachedAccountFirebaseTokens cached = _cachedAccountFirebaseTokens[accountId];
    if (cached != null) return cached.firebaseTokens;
    await _lockCachedAccountFirebaseTokens.synchronized(() async {
      Set<String> firebaseTokens = new Set<String>();
      sqljocky.Results res = await sql.prepareExecute(
          "SELECT `firebase_token`"
          "FROM `devices` "
          "WHERE `account_id` = ? ",
          [accountId.toInt()]);
      await for (sqljocky.Row row in res) {
        if (row[0] != null) {
          String firebaseToken = row[0].toString();
          firebaseTokens.add(firebaseToken);
        }
      }
      cached = new _CachedAccountFirebaseTokens(firebaseTokens.toList());
      _cachedAccountFirebaseTokens[accountId] = cached;
    });
    return cached.firebaseTokens;
  }

  void _dirtyAccountFirebaseTokens(int accountId) {
    _lockCachedAccountFirebaseTokens.synchronized(() async {
      _cachedAccountFirebaseTokens.remove(accountId);
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  // Senders
  /////////////////////////////////////////////////////////////////////////////

  Future<void> _push(
      int senderDeviceId, int receiverAccountId, int id, Uint8List data) async {
    // Push to apps connected locally
    for (RemoteApp remoteApp in _accountToRemoteApps[receiverAccountId]) {
      try {
        if (remoteApp.account.state.deviceId != senderDeviceId) {
          remoteApp.ts.sendMessage(id, data);
        }
      } catch (error, stack) {
        devLog.warning("Exception while pushing to remote app: $error\n$stack");
      }
    }

    // TODO: Push to apps connected on remote servers if applicable
  }

  // TODO: Offer changed: Sends to same account to sync devices when multi devicing...

  static int _applicantPosted = TalkSocket.encode("LN_APPLI");
  Future<void> _pushApplicantPosted(int senderDeviceId, int receiverAccountId,
      DataApplicant applicant) async {
    // Push to local apps and and apps on remote servers
    // (Applicant creation always causes a first haggle chat to be sent, so no Firebase post)
    await _push(senderDeviceId, receiverAccountId, _applicantPosted,
        applicant.writeToBuffer());
  }

  static int _applicantChanged = TalkSocket.encode("LU_APPLI");
  Future<void> _pushApplicantChanged(int senderDeviceId, int receiverAccountId,
      DataApplicant applicant) async {
    // Push only to local apps and and apps on remote servers
    // (Important changes are posted through chat marker, so no Firebase posting here)
    await _push(senderDeviceId, receiverAccountId, _applicantChanged,
        applicant.writeToBuffer());
  }

  static int _applicantChatPosted = TalkSocket.encode("LN_A_CHA");
  Future<void> _pushApplicantChatPosted(
      int senderDeviceId, int receiverAccountId, DataApplicantChat chat) async {
    // Push to local apps and and apps on remote servers
    await _push(senderDeviceId, receiverAccountId, _applicantChatPosted,
        chat.writeToBuffer());

    // Push Firebase (even if sent directly, Firebase notifications don't show while the app is running)
    // Don't send notifications to the sender
    if (receiverAccountId != chat.senderId) {
      String senderName = await _getAccountName(chat.senderId);
      List<String> receiverFirebaseTokens = await _getAccountFirebaseTokens(receiverAccountId);
      Map<String, dynamic> notification = new Map<String, dynamic>();
      notification['title'] = senderName;
      notification['body'] = chat.text;
      notification['click_action'] = 'FLUTTER_NOTIFICATION_CLICK';
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['sender_id'] = chat.senderId;
      data['account_id'] = receiverAccountId;
      data['applicant_id'] = chat.applicantId;
      data['type'] = chat.type.value;
      data['domain'] = config.services.domain;
      Map<String, dynamic> message = new Map<String, dynamic>();
      message['registration_ids'] = receiverFirebaseTokens;
      message['collapse_key'] = 'applicant_id=' + chat.applicantId.toString();
      message['notification'] = notification;
      message['data'] = data;
      String jm = json.encode(message);
      devLog.finest(jm);
      HttpClientRequest req = await _httpClient.postUrl(Uri.parse(config.services.firebaseLegacyApi));
      req.headers.add('Content-Type', 'application/json');
      req.headers.add('Authorization', 'key=' + config.services.firebaseLegacyServerKey);
      req.add(utf8.encode(jm));
      HttpClientResponse res = await req.close();
      BytesBuilder responseBuilder = new BytesBuilder(copy: false);
      await res.forEach(responseBuilder.add);
      if (res.statusCode != 200) {
        opsLog.warning("Status code ${res.statusCode}, request: $jm, response: ${utf8.decode(responseBuilder.toBytes())}");
      }
      String rs = utf8.decode(responseBuilder.toBytes());
      devLog.finest("Firebase sent OK, response: ${rs}");
      Map<dynamic, dynamic> doc = json.decode(rs);
      if (doc['failure'].toInt() > 0) {
        devLog.warning("Failed to send Firebase notification to ${doc['failure']} recipient devices, validate all tokens.");
        // TODO: Validate all registrations
      }
    }
  }

/*
  Future<void> _pushApplicantChatSeen(int accountId, DataApplicantChat chat) async {
    // TODO: Push Locally
    // TODO: Push Remote Server
  }
  */

  /////////////////////////////////////////////////////////////////////////////
  // Hooks
  /////////////////////////////////////////////////////////////////////////////

  void accountConnected(RemoteApp remoteApp) {
    _accountToRemoteApps.add(remoteApp.account.state.accountId, remoteApp);

    // TODO: Signal remote servers (if only first device for account here)
  }

  void accountDisconnected(RemoteApp remoteApp) {
    if (_accountToRemoteApps.remove(
        remoteApp.account.state.accountId, remoteApp)) {
      // TODO: Signal remote servers (if no more devices for account here)
    }
  }

  void accountFirebaseTokensChanged(RemoteApp remoteApp) {
    // TODO: Signal remote servers
    _dirtyAccountFirebaseTokens(remoteApp.account.state.accountId);
  }

  Future<void> applicantPosted(int senderDeviceId, DataApplicant applicant,
      DataAccount influencerAccount) async {
    // Store cache
    _applicantToInfluencerBusiness[applicant.applicantId] =
        new _CachedApplicant(
            applicant.influencerAccountId, applicant.businessAccountId);

    // Push notifications
    await _pushApplicantPosted(
        senderDeviceId, applicant.influencerAccountId, applicant);
    await _pushApplicantPosted(
        senderDeviceId, applicant.businessAccountId, applicant);

    devLog.fine(
        "Pushed applicant ${applicant.applicantId}: '${influencerAccount.summary.name}'");
  }

  Future<void> applicantChanged(
      int senderDeviceId, DataApplicant applicant) async {
    // Store cache
    _applicantToInfluencerBusiness[applicant.applicantId] =
        new _CachedApplicant(
            applicant.influencerAccountId, applicant.businessAccountId);

    // Push notifications
    await _pushApplicantChanged(
        senderDeviceId, applicant.influencerAccountId, applicant);
    await _pushApplicantChanged(
        senderDeviceId, applicant.businessAccountId, applicant);
  }

  Future<void> applicantChatPosted(int senderDeviceId, DataApplicantChat chat,
      DataAccount senderAccount) async {
    // Get cache
    _CachedApplicant applicant = await _getApplicant(chat.applicantId);
    if (applicant == null) return; // Ignore

    // Push notifications
    await _pushApplicantChatPosted(
        senderDeviceId, applicant.influencerAccountId, chat);
    await _pushApplicantChatPosted(
        senderDeviceId, applicant.businessAccountId, chat);
    if (chat.senderId != applicant.influencerAccountId &&
        chat.senderId != applicant.businessAccountId)
      // Unusual case, sender is neither of influencer or business...
      await _pushApplicantChatPosted(senderDeviceId, chat.senderId, chat);

    devLog.fine(
        "Pushed applicant '${senderAccount.summary.name}' chat '${chat.text}'");
  }

/*
  Future<void> applicantChatSeen(int senderId, DataApplicantChat chat) async {
    // Get cache
    _CachedApplicant applicant = await _getApplicant(chat.applicantId);
    if (applicant == null) return; // Ignore
    
    // Push notifications
    if (applicant.senderId != senderId)
      _pushApplicantChatPosted(applicant.influencerAccountId, chat);
    if (applicant.businessAccountId != senderId)
      _pushApplicantChatPosted(applicant.businessAccountId, chat);
  }
  */

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
}

/* end of file */
