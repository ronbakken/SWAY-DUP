/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:quiver/collection.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'inf.pb.dart';
import 'remote_app.dart';

class _CachedApplicant {
  final int influencerAccountId;
  final int businessAccountId;
  _CachedApplicant(this.influencerAccountId, this.businessAccountId);
}

class BroadcastCenter {
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  final ConfigData config;
  final sqljocky.ConnectionPool sql;
  final dospace.Bucket bucket;

  Multimap<int, RemoteApp> _accountToRemoteApps =
      new Multimap<int, RemoteApp>();
  Map<int, _CachedApplicant> _applicantToInfluencerBusiness =
      new Map<int, _CachedApplicant>();

  static final Logger opsLog = new Logger('InfOps.BroadcastCenter');
  static final Logger devLog = new Logger('InfDev.BroadcastCenter');

  BroadcastCenter(this.config, this.sql, this.bucket) {}

  /////////////////////////////////////////////////////////////////////////////
  // Caches
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
    await _push(senderDeviceId, receiverAccountId, _applicantPosted,
        applicant.writeToBuffer());

    // TODO: Push Firebase (only if not sent directly?)
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

    // TODO: Push Firebase (only if not sent directly?)
  }

/*
  Future<void> _pushApplicantChatSeen(int accountId, DataApplicantChat chat) async {
    // TODO: Push Locally
    // TODO: Push Remote Server
    // TODO: Push Firebase
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

  Future<void> applicantPosted(
      int senderDeviceId, DataApplicant applicant) async {
    // Store cache
    _applicantToInfluencerBusiness[applicant.applicantId] =
        new _CachedApplicant(
            applicant.influencerAccountId, applicant.businessAccountId);

    // Push notifications
    await _pushApplicantPosted(
        senderDeviceId, applicant.influencerAccountId, applicant);
    await _pushApplicantPosted(
        senderDeviceId, applicant.businessAccountId, applicant);

    devLog.fine("Pushed applicant ${applicant.applicantId}");
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

  Future<void> applicantChatPosted(
      int senderDeviceId, DataApplicantChat chat) async {
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

    devLog.fine("Pushed applicant chat ${chat.text}");
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
