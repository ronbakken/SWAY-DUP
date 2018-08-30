/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';

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

  Multimap<int, RemoteApp> accountToRemoteApps = new Multimap<int, RemoteApp>();
  Map<int, _CachedApplicant> applicantToInfluencerBusiness =
      new Map<int, _CachedApplicant>();

  static final Logger opsLog = new Logger('InfOps.BroadcastCenter');
  static final Logger devLog = new Logger('InfDev.BroadcastCenter');

  BroadcastCenter(this.config, this.sql, this.bucket) {}

  /////////////////////////////////////////////////////////////////////////////
  // Caches
  /////////////////////////////////////////////////////////////////////////////

  Future<_CachedApplicant> _getApplicant(int applicantId) async {
    _CachedApplicant applicant = applicantToInfluencerBusiness[applicantId];
    if (applicant != null) return applicant;
    sqljocky.Results res = await sql.prepareExecute(
        "SELECT `influencer_account_id`, `business_account_id` "
        "FROM `applicants` WHERE `applicant_id` = ?",
        [applicantId.toInt()]);
    await for (sqljocky.Row row in res) {
      applicant = new _CachedApplicant(row[0].toInt(), row[1].toInt());
      applicantToInfluencerBusiness[applicantId] = applicant;
    }
    return applicant; // May be null if not found
  }

  /////////////////////////////////////////////////////////////////////////////
  // Senders
  /////////////////////////////////////////////////////////////////////////////
  
  Future<void> _pushApplicantPosted(int accountId, DataApplicant applicant) async {
    // TODO: Push Locally
    // TODO: Push Remote Server
    // TODO: Push Firebase
  }

  Future<void> _pushApplicantChatPosted(int accountId, DataApplicantChat chat) async {
    // TODO: Push Locally
    // TODO: Push Remote Server
    // TODO: Push Firebase
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
    accountToRemoteApps.add(remoteApp.account.state.accountId, remoteApp);
  }

  void accountDisconnected(RemoteApp remoteApp) {
    if (accountToRemoteApps.remove(
        remoteApp.account.state.accountId, remoteApp)) {
      // ...
    }
  }

  Future<void> applicantPosted(int senderId, DataApplicant applicant) async {
    // Store cache
    applicantToInfluencerBusiness[applicant.applicantId] = new _CachedApplicant(
        applicant.influencerAccountId, applicant.businessAccountId);

    // Push notifications
    if (applicant.influencerAccountId != senderId)
      await _pushApplicantPosted(applicant.influencerAccountId, applicant);
    if (applicant.businessAccountId != senderId)
      await _pushApplicantPosted(applicant.businessAccountId, applicant);
  }

  Future<void> applicantChatPosted(int senderId, DataApplicantChat chat) async {
    // Push notifications
    if (chat.senderId != senderId)
      await _pushApplicantChatPosted(chat.senderId, chat);

    // Get cache
    _CachedApplicant applicant = await _getApplicant(chat.applicantId);
    if (applicant == null) return; // Ignore
    
    // Push notifications
    if (applicant.influencerAccountId != senderId)
      await _pushApplicantChatPosted(applicant.influencerAccountId, chat);
    if (applicant.businessAccountId != senderId)
      await _pushApplicantChatPosted(applicant.businessAccountId, chat);
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
