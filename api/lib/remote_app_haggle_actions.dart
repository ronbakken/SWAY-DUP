/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'inf.pb.dart';
import 'remote_app.dart';

class RemoteAppHaggleActions {
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  RemoteApp _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkSocket get ts {
    return _r.ts;
  }

  dospace.Bucket get bucket {
    return _r.bucket;
  }

  DataAccount get account {
    return _r.account;
  }

  int get accountId {
    return _r.account.state.accountId;
  }

  GlobalAccountState get globalAccountState {
    return _r.account.state.globalAccountState;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.RemoteAppOAuth');
  static final Logger devLog = new Logger('InfDev.RemoteAppOAuth');
  final List<StreamSubscription<dynamic>> _subscriptions =
      new List<StreamSubscription<dynamic>>();
  int nextFakeGhostId;

  RemoteAppHaggleActions(this._r) {
    _subscriptions.add(_r.saferListen(
        "CH_PLAIN", GlobalAccountState.GAS_READ_WRITE, true, netChatPlain));
    _subscriptions.add(_r.saferListen(
        "CH_HAGGL", GlobalAccountState.GAS_READ_WRITE, true, netChatHaggle));
    _subscriptions.add(_r.saferListen(
        "CH_IMAGE", GlobalAccountState.GAS_READ_WRITE, true, netChatImageKey));

    _subscriptions.add(_r.saferListen("AP_WADEA",
        GlobalAccountState.GAS_READ_WRITE, true, netApplicantWantDealReq));
    _subscriptions.add(_r.saferListen("AP_REJEC",
        GlobalAccountState.GAS_READ_WRITE, true, netApplicantRejectReq));
    _subscriptions.add(_r.saferListen("AP_REPOR",
        GlobalAccountState.GAS_READ_WRITE, true, netApplicantReportReq));
    _subscriptions.add(_r.saferListen("AP_COMPL",
        GlobalAccountState.GAS_READ_WRITE, true, netApplicantCompletionReq));
    nextFakeGhostId =
        ((new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF) | 0x10000000;
  }

  void dispose() {
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
    _subscriptions.clear();
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // User actions
  //////////////////////////////////////////////////////////////////////////////

  // Response messages
  static int _netDataApplicantUpdate = TalkSocket.encode("LU_APPLI");
  // static int _netDataApplicantChatUpdate = TalkSocket.encode("LU_A_CHA");
  static int _netDataApplicantChatNew = TalkSocket.encode("LN_A_CHA");

  // Client should respond to live updates and posts from broadcast center
  // LN_APPLI, LN_A_CHA, LU_APPLI, LU_A_CHA
  // Also post to FCM

  /*
  final Function(String text) onSendPlain; -> NetChatPlain / CH_PLAIN
  final Function(String key) onSendImageKey; -> CH_IMAGE

  final Function(DataApplicantChat haggleChat) onBeginHaggle; -> UI -> NetChatHaggle / CH_HAGGL
  final Function(DataApplicantChat haggleChat) onWantDeal; -- not yet defined -- only succeeds if picked chat is the current one

  final Function() onReject; -- not yet defined
  final Function() onBeginReport; -- not yet defined -- posts to freshdesk // FCM email verification service?
  final Function() onBeginMarkCompleted; -> AP_COMPL
  */

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Chat messages
  //////////////////////////////////////////////////////////////////////////////

  // Chat messages don't have responses, since they have ghost instances on the client.
  // Client assumes a successful send-to-server is sent (since the server was online).
  // Ghost messages are always re-sent by the client upon reconnection to the server only.

  /// Verify if the sender is permitted to chat in this context
  Future<bool> _verifySender(int applicantId, int senderId) async {
    int influencerAccountId;
    int businessAccountId;
    ApplicantState state;

    // Fetch applicant
    String query = "SELECT "
        "`influencer_account_id`, `business_account_id`, "
        "`state` "
        "FROM `applicants` "
        "WHERE `applicant_id` = ?";
    await for (sqljocky.Row row
        in await sql.prepareExecute(query, [applicantId.toInt()])) {
      influencerAccountId = row[0].toInt();
      businessAccountId = row[1].toInt();
      state = ApplicantState.valueOf(row[2].toInt());
    }

    // Authorize
    if (businessAccountId == null || influencerAccountId == null) {
      opsLog.severe(
          "Attempt to send message to invalid applicant chat by account '$senderId'");
      return false; // Not Found
    }
    if (account.state.accountType != AccountType.AT_SUPPORT &&
        accountId != businessAccountId &&
        accountId != influencerAccountId) {
      opsLog.severe(
          "Attempt to send message to unauthorized applicant chat by account '$senderId'");
      return false; // Not Authorized
    }

    // if (state != ApplicantState.)
    switch (state) {
      case ApplicantState.AS_HAGGLING:
      case ApplicantState.AS_DEAL:
      case ApplicantState.AS_DISPUTE:
        break;
      case ApplicantState.AS_REJECTED:
      case ApplicantState.AS_COMPLETE:
      case ApplicantState.AS_RESOLVED:
        devLog.warning("Attempt to send message to $state deal by '$senderId");
        return false;
    }

    return true;
  }

/*
  int64 chatId = 7; // Sequential identifier in the chat stream
  int64 sent = 10; // Sent timestamp
  int32 senderId = 2; // Account which sent
  int32 applicantId = 1; // One chat per applicant
  
  int32 deviceId = 11; // Cleared upon forwarding
  int32 deviceGhostId = 6; // Deduplication client-side (ghost entry)
  
  ApplicantChatType type = 8;
  string text = 5; // The written text
  int64 seen = 9; // 0 if not seen
*/

  Future<bool> _insertChat(
      sqljocky.QueriableConnection connection, DataApplicantChat chat) async {
    // Store in database
    String insertChat = "INSERT INTO `applicant_haggling`("
        "`sender_id`, `applicant_id`, "
        "`device_id`, `device_ghost_id`, "
        "`type`, `text`) "
        "VALUES (?, ?, ?, ?, ?, ?)";
    sqljocky.Results resultHaggle =
        await connection.prepareExecute(insertChat, [
      chat.senderId.toInt(),
      chat.applicantId.toInt(),
      chat.deviceId.toInt(),
      chat.deviceGhostId
          .toInt(), // Not actually used for apply chat, but need it for consistency
      chat.type.value.toInt(),
      chat.text.toString(),
    ]);
    int haggleChatId = resultHaggle.insertId;
    if (haggleChatId == null || haggleChatId == 0) {
      return false;
    }
    chat.chatId = new Int64(haggleChatId);
    return true;
  }

  Future<void> _enterChat(DataApplicantChat chat) async {
    bool publish = false;
    if (chat.type == ApplicantChatType.ACT_HAGGLE) {
      await sql.startTransaction((transaction) async {
        if (await _insertChat(transaction, chat)) {
          // Update haggle on applicant
          String updateHaggleChatId = "UPDATE `applicants` "
              "SET `haggle_chat_id` = ?, `influencer_wants_deal` = 0, `business_wants_deal` = 0 "
              "WHERE `applicant_id` = ? AND `state` = ${ApplicantState.AS_HAGGLING.value.toInt()}";
          sqljocky.Results resultUpdateHaggleChatId =
              await transaction.prepareExecute(updateHaggleChatId, [
            chat.chatId.toInt(),
            chat.applicantId.toInt(),
          ]);
          if (resultUpdateHaggleChatId.affectedRows == null ||
              resultUpdateHaggleChatId.affectedRows == 0) {
            return; // rollback
          }
          // Commit
          transaction.commit();
          publish = true;
        } // else rollback
      });
    } else {
      if (await _insertChat(sql, chat)) {
        publish = true;
      }
    }
    if (publish) {
      await _publishChat(chat);
      if (chat.type == ApplicantChatType.ACT_HAGGLE) {
        await _changedApplicant(chat.applicantId);
      }
    } else {
      // Send placeholder message to erase the ghost id to current device.
      // This is an unusual race condition case that shouldn't happen.
      chat.type = ApplicantChatType.ACT_MARKER;
      chat.text = "marker=" + ApplicantChatMarker.ACM_MESSAGE_DROPPED.value;
      ts.sendMessage(_netDataApplicantChatNew, chat.writeToBuffer());
    }
  }

  Future<void> _publishChat(DataApplicantChat chat) async {
    if (chat.type == ApplicantChatType.ACT_IMAGE_KEY) {
      String key = Uri.splitQueryString(chat.text)['key'];
      if (key != null) {
        chat.text =
            'url=' + Uri.encodeQueryComponent(_r.makeCloudinaryCoverUrl(key));
      }
    }

    // Publish to me
    ts.sendMessage(_netDataApplicantChatNew, chat.writeToBuffer());

    // Clear private information from broadcast
    chat.deviceId = 0;
    chat.deviceGhostId = 0;

    // Publish to all else
    // TODO: Deduplicate chat.writeToBuffer() calls on publishing
    _r.bc.applicantChatPosted(account.state.deviceId, chat, account);
  }

  Future<void> _changedApplicant(int applicantId) async {
    // DataApplicant applicant) {
    DataApplicant applicant =
        await _r.remoteAppHaggle.getApplicant(applicantId);
    ts.sendMessage(_netDataApplicantUpdate, applicant.writeToBuffer());
    _r.bc.applicantChanged(account.state.deviceId, applicant);
  }

  Future<void> netChatPlain(TalkMessage message) async {
    NetChatPlain pb = new NetChatPlain();
    pb.mergeFromBuffer(message.data);

    if (!await _verifySender(pb.applicantId, accountId)) return;

    DataApplicantChat chat = new DataApplicantChat();
    chat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderId = accountId;
    chat.applicantId = pb.applicantId;
    chat.deviceId = account.state.deviceId;
    chat.deviceGhostId = pb.deviceGhostId;
    chat.type = ApplicantChatType.ACT_PLAIN;
    chat.text = pb.text;

    await _enterChat(chat);
  }

  Future<void> netChatHaggle(TalkMessage message) async {
    NetChatHaggle pb = new NetChatHaggle();
    pb.mergeFromBuffer(message.data);

    /*

    int influencerAccountId;
    int businessAccountId;
    String deliverables;
    String reward;

    // Fetch applicant
    String query = "SELECT "
        "`applicants`.`influencer_account_id`, `applicants`.`business_account_id`, "
        "`offers`.`deliverables`, `offers`.`reward` "
        "FROM `applicants` "
        "INNER JOIN `offers` ON `offers`.`offer_id` = `applicants`.`offer_id` "
        "WHERE `applicant_id` = ?";
    await for (sqljocky.Row row
        in await sql.prepareExecute(query, [pb.applicantId.toInt()])) {
      influencerAccountId = row[0].toInt();
      businessAccountId = row[1].toInt();
      deliverables = row[2].toString();
      reward = row[3].toString();
    }

    if (!await _verifySenderMatches(influencerAccountId, businessAccountId, accountId))
      return;

    */

    if (!await _verifySender(pb.applicantId, accountId)) return;

    DataApplicantChat chat = new DataApplicantChat();
    chat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderId = accountId;
    chat.applicantId = pb.applicantId;
    chat.deviceId = account.state.deviceId;
    chat.deviceGhostId = pb.deviceGhostId;
    chat.type = ApplicantChatType.ACT_HAGGLE;
    chat.text =
        'deliverables=${Uri.encodeQueryComponent(pb.deliverables.trim())}&'
        'reward=${Uri.encodeQueryComponent(pb.reward.trim())}&'
        'remarks=${Uri.encodeQueryComponent(pb.remarks.trim())}';

    await _enterChat(chat);
  }

  Future<void> netChatImageKey(TalkMessage message) async {
    NetChatImageKey pb = new NetChatImageKey();
    pb.mergeFromBuffer(message.data);

    if (!await _verifySender(pb.applicantId, accountId)) return;

    DataApplicantChat chat = new DataApplicantChat();
    chat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderId = accountId;
    chat.applicantId = pb.applicantId;
    chat.deviceId = account.state.deviceId;
    chat.deviceGhostId = pb.deviceGhostId;
    chat.type = ApplicantChatType.ACT_IMAGE_KEY;
    chat.text = 'key=${Uri.encodeQueryComponent(pb.imageKey.trim())}';

    await _enterChat(chat);
  }

  // Client should respond to live updates and posts from broadcast center
  // LN_APPLI, LN_A_CHA, LU_APPLI, LU_A_CHA
  // Also post to FCM

  /*

  final Function(DataApplicantChat haggleChat) onWantDeal; -- AP_WADEA -- NetApplicantCommonRes (Id: AP_R_COM), applicant update + marker-- only succeeds if picked chat is the current one

  final Function() onReject; -- AP_R_COM, NetApplicantCommonRes (Id: AP_R_COM), applicant update + marker
  final Function() onBeginReport; AP_REPOR -- NetApplicantCommonRes (Id: AP_R_COM), null, null -- posts to freshdesk // FCM email verification service?

  final Function() onBeginDispute; AP_COMPL -- NetApplicantCommonRes (Id: AP_R_COM), applicant update + marker (silent) -- posts to freshdesk // FCM email verification service?
  final Function() onBeginMarkCompleted; -> AP_COMPL, NetApplicantCommonRes
  */

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Common actions
  //////////////////////////////////////////////////////////////////////////////

  static int _netApplicantCommonRes = TalkSocket.encode("AP_R_COM");

  Future<void> netApplicantWantDealReq(TalkMessage message) async {
    NetApplicantWantDealReq pb = new NetApplicantWantDealReq();
    pb.mergeFromBuffer(message.data);

    int applicantId = pb.applicantId.toInt();
    int haggleChatId = pb.haggleChatId.toInt();

    /* No need, already verified by first UPDATE
    if (!await _verifySender(applicantId, accountId)) {
      ts.sendException("Verification Failed", message);
      return;
    } */

    DataApplicantChat markerChat; // Set upon success

    await sql.startTransaction((transaction) async {
      // 1. Update deal to reflect the account wants a deal
      ts.sendExtend(message);
      String accountWantsDeal =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_wants_deal'
              : 'business_wants_deal';
      String accountAccountId =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_account_id'
              : 'business_account_id';
      String updateWants = "UPDATE `applicants` "
          "SET `$accountWantsDeal` = 1 "
          "WHERE `applicant_id` = ? "
          "AND `haggle_chat_id` = ? "
          "AND `$accountAccountId` = ? "
          "AND `state` = ${ApplicantState.AS_HAGGLING.value} "
          "AND `$accountWantsDeal` = 0";
      sqljocky.Results resultWants = await transaction
          .prepareExecute(updateWants, [applicantId, haggleChatId, accountId]);
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '$accountId' on applicant '$applicantId'");
        return;
      }

      // 2. Try to see if we're can complete the deal or if it's just one sided
      ts.sendExtend(message);
      String updateDeal = "UPDATE `applicants` "
          "SET `state` = ${ApplicantState.AS_DEAL.value} "
          "WHERE `applicant_id` = ? "
          "AND `influencer_wants_deal` = 1 "
          "AND `business_wants_deal` = 1 "
          "AND `state` = ${ApplicantState.AS_HAGGLING.value}";
      sqljocky.Results resultDeal =
          await transaction.prepareExecute(updateDeal, [applicantId]);
      bool dealMade =
          (resultDeal.affectedRows != null && resultDeal.affectedRows > 0);

      // 3. Insert marker chat
      ts.sendExtend(message);
      DataApplicantChat chat = new DataApplicantChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderId = accountId;
      chat.applicantId = applicantId;
      chat.deviceId = account.state.deviceId;
      chat.deviceGhostId = ++nextFakeGhostId;
      chat.type = ApplicantChatType.ACT_MARKER;
      chat.text = 'marker=' +
          (dealMade
              ? ApplicantChatMarker.ACM_DEAL_MADE.value.toString()
              : ApplicantChatMarker.ACM_WANT_DEAL.value.toString());
      if (await _insertChat(transaction, chat)) {
        ts.sendExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      ts.sendException("Not Handled", message);
    } else {
      NetApplicantCommonRes res = new NetApplicantCommonRes();
      DataApplicant applicant =
          await _r.remoteAppHaggle.getApplicant(applicantId);
      res.updateApplicant = applicant;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        ts.sendMessage(_netApplicantCommonRes, res.writeToBuffer(),
            replying: message);
      } catch (error, stack) {
        devLog.severe("$error\n$stack");
      }
      // Publish!
      _r.bc.applicantChanged(account.state.deviceId, applicant);
      _r.bc.applicantChatPosted(account.state.deviceId, markerChat, account);
    }
  }

  Future<void> netApplicantRejectReq(TalkMessage message) async {
    NetApplicantRejectReq pb = new NetApplicantRejectReq();
    pb.mergeFromBuffer(message.data);

    int applicantId = pb.applicantId.toInt();
    String reason = pb.reason.toString();

    DataApplicantChat markerChat; // Set upon success

    await sql.startTransaction((transaction) async {
      // 1. Update deal to reflect the account wants a deal
      ts.sendExtend(message);
      String accountAccountId =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_account_id' // Cancel
              : 'business_account_id'; // Reject
      String updateWants = "UPDATE `applicants` "
          "SET `state` = ${ApplicantState.AS_REJECTED.value} "
          "WHERE `applicant_id` = ? "
          "AND `$accountAccountId` = ?"
          "AND `state` = ${ApplicantState.AS_HAGGLING.value}";
      sqljocky.Results resultWants = await transaction
          .prepareExecute(updateWants, [applicantId, accountId]);
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            "Invalid reject attempt by account '$accountId' on applicant '$applicantId'");
        return;
      }

      // 2. Insert marker chat
      ts.sendExtend(message);
      DataApplicantChat chat = new DataApplicantChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderId = accountId;
      chat.applicantId = applicantId;
      chat.deviceId = account.state.deviceId;
      chat.deviceGhostId = ++nextFakeGhostId;
      chat.type = ApplicantChatType.ACT_MARKER;
      chat.text = 'marker=' +
          ApplicantChatMarker.ACM_REJECTED.value.toString() +
          '&reason=' +
          Uri.encodeQueryComponent(reason);
      if (await _insertChat(transaction, chat)) {
        ts.sendExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      ts.sendException("Not Handled", message);
    } else {
      NetApplicantCommonRes res = new NetApplicantCommonRes();
      try {
        ts.sendExtend(message);
      } catch (error, stack) {
        devLog.severe("$error\n$stack");
      }
      DataApplicant applicant =
          await _r.remoteAppHaggle.getApplicant(applicantId);
      res.updateApplicant = applicant;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        ts.sendMessage(_netApplicantCommonRes, res.writeToBuffer(),
            replying: message);
      } catch (error, stack) {
        devLog.severe("$error\n$stack");
      }
      // Publish!
      _r.bc.applicantChanged(account.state.deviceId, applicant);
      _r.bc.applicantChatPosted(account.state.deviceId, markerChat, account);
    }
  }

  Future<void> netApplicantReportReq(TalkMessage message) async {
    NetApplicantReportReq pb = new NetApplicantReportReq();
    pb.mergeFromBuffer(message.data);

    int applicantId = pb.applicantId.toInt();

    if (!await _verifySender(applicantId, accountId)) {
      ts.sendException("Verification Failed", message);
      return;
    }

    opsLog.severe("Report: ${pb.text}");

    // Post to freshdesk
    DataApplicant applicant =
        await _r.remoteAppHaggle.getApplicant(applicantId);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest httpRequest = await httpClient
        .postUrl(Uri.parse(config.services.freshdeskApi + '/api/v2/tickets'));
    httpRequest.headers.add('Content-Type', 'application/json');
    httpRequest.headers.add(
        'Authorization',
        'Basic ' +
            base64.encode(utf8.encode(config.services.freshdeskKey + ':X')));

    Map<String, dynamic> doc = new Map<String, dynamic>();
    doc['name'] = account.summary.name;
    doc['email'] = account.detail.email;
    doc['subject'] = "Applicant Report (Ap. $applicantId)";
    doc['type'] = "Problem";
    doc['description'] =
        "<h1>Message</h1><p>${htmlEscape.convert(pb.text)}</p><hr><h1>Applicant</h1>${applicant}";
    doc['priority'] = 2;
    doc['status'] = 2;

    ts.sendExtend(message);
    httpRequest.write(json.encode(doc));
    await httpRequest.flush();
    HttpClientResponse httpResponse = await httpRequest.close();
    BytesBuilder responseBuilder = new BytesBuilder(copy: false);
    await httpResponse.forEach(responseBuilder.add);
    if (httpResponse.statusCode != 200 && httpResponse.statusCode != 201) {
      devLog.severe(
          "Report post failed: ${utf8.decode(responseBuilder.toBytes())}");
      ts.sendException("Post Failed", message);
      return;
    }

    NetApplicantCommonRes res = new NetApplicantCommonRes();
    ts.sendMessage(_netApplicantCommonRes, res.writeToBuffer(),
        replying: message);
  }

  Future<void> netApplicantCompletionReq(TalkMessage message) async {
    NetApplicantCompletionReq pb = new NetApplicantCompletionReq();
    pb.mergeFromBuffer(message.data);

    int applicantId = pb.applicantId.toInt();

    DataApplicantChat markerChat; // Set upon successful action

    // Completion or dispute
    await sql.startTransaction((transaction) async {
      // 1. Update deal to reflect the account wants a deal
      ts.sendExtend(message);
      String accountAccountId =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_account_id'
              : 'business_account_id';
      String accountMarkedDelivered =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_marked_delivered'
              : 'business_marked_delivered';
      String accountMarkedRewarded =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_marked_rewarded'
              : 'business_marked_rewarded';
      String accountGaveRating =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_gave_rating'
              : 'business_gave_rating';
      String accountDisputed =
          account.state.accountType == AccountType.AT_INFLUENCER
              ? 'influencer_disputed'
              : 'business_disputed';
      String updateMarkings = "UPDATE `applicants` "
          "SET `$accountMarkedDelivered` = ?, `$accountMarkedRewarded` = ?" +
          (pb.rating.toInt() > 0 ? ", `$accountGaveRating` = ?" : '') +
          (pb.dispute
              ? ", `$accountDisputed` = 1, `state` = ${ApplicantState.AS_DISPUTE.value}"
              : '') +
          " WHERE `applicant_id` = ? "
          "AND `$accountAccountId` = ?"
          "AND `state` = ${ApplicantState.AS_DEAL.value} OR `state` = ${ApplicantState.AS_DISPUTE.value}";
      List<dynamic> parameters = [pb.delivered ? 1 : 0, pb.rewarded ? 1 : 0];
      if (pb.rating.toInt() > 0) parameters.add(pb.rating.toInt());
      parameters.addAll([applicantId, accountId]);
      sqljocky.Results resultMarkings =
          await transaction.prepareExecute(updateMarkings, parameters);
      if (resultMarkings.affectedRows == null ||
          resultMarkings.affectedRows == 0) {
        devLog.warning(
            "Invalid reject attempt by account '$accountId' on applicant '$applicantId'");
        return;
      }

      bool dealCompleted;
      if (!pb.dispute) {
        // 2. Check for deal completion
        ts.sendExtend(message);
        String updateCompletion = "UPDATE `applicants` "
            "SET `state` = ${ApplicantState.AS_COMPLETE.value} "
            "WHERE `applicant_id` = ? "
            "AND `influencer_marked_delivered` > 0 AND `influencer_marked_rewarded` > 0 "
            "AND `business_marked_delivered` > 0 AND `business_marked_rewarded` > 0 "
            "AND `influencer_gave_rating` > 0 AND `business_gave_rating` > 0 "
            "AND `state` = ${ApplicantState.AS_DEAL.value}";
        sqljocky.Results resultCompletion =
            await transaction.prepareExecute(updateCompletion, [applicantId]);
        dealCompleted = resultCompletion.affectedRows != null &&
            resultCompletion.affectedRows != 0;
      }

      ApplicantChatMarker marker = pb.dispute
          ? ApplicantChatMarker.ACM_MARKED_DISPUTE
          : (dealCompleted
              ? ApplicantChatMarker.ACM_COMPLETE
              : ApplicantChatMarker.ACM_MARKED_COMPLETE);

      // 2. Insert marker chat
      ts.sendExtend(message);
      DataApplicantChat chat = new DataApplicantChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderId = accountId;
      chat.applicantId = applicantId;
      chat.deviceId = account.state.deviceId;
      chat.deviceGhostId = ++nextFakeGhostId;
      chat.type = ApplicantChatType.ACT_MARKER;
      chat.text = 'marker=' + marker.value.toString();
      if (await _insertChat(transaction, chat)) {
        ts.sendExtend(message);
        if (pb.dispute) {
          DataApplicant applicant =
              await _r.remoteAppHaggle.getApplicant(applicantId);

          HttpClient httpClient = new HttpClient();
          HttpClientRequest httpRequest = await httpClient.postUrl(
              Uri.parse(config.services.freshdeskApi + '/api/v2/tickets'));
          httpRequest.headers
              .add('Content-Type', 'application/json; charset=utf-8');
          httpRequest.headers.add(
              'Authorization',
              'Basic ' +
                  base64.encode(
                      utf8.encode(config.services.freshdeskKey + ':X')));

          Map<String, dynamic> doc = new Map<String, dynamic>();
          doc['name'] = account.summary.name;
          doc['email'] = account.detail.email;
          doc['subject'] = "Applicant Dispute (Ap. $applicantId)";
          doc['type'] = "Incident";
          doc['description'] =
              "<h1>Message</h1><p>${htmlEscape.convert(pb.disputeDescription)}</p><hr><h1>Applicant</h1>${applicant}";
          doc['priority'] = 3;
          doc['status'] = 2;

          ts.sendExtend(message);
          httpRequest.write(json.encode(doc));
          await httpRequest.flush();
          HttpClientResponse httpResponse = await httpRequest.close();
          BytesBuilder responseBuilder = new BytesBuilder(copy: false);
          await httpResponse.forEach(responseBuilder.add);
          if (httpResponse.statusCode != 200) {
            ts.sendException("Post Failed", message);
            return;
          }
        }
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      ts.sendException("Not Handled", message);
    } else {
      NetApplicantCommonRes res = new NetApplicantCommonRes();
      try {
        ts.sendExtend(message);
      } catch (error, stack) {
        devLog.severe("$error\n$stack");
      }
      DataApplicant applicant =
          await _r.remoteAppHaggle.getApplicant(applicantId);
      res.updateApplicant = applicant;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        ts.sendMessage(_netApplicantCommonRes, res.writeToBuffer(),
            replying: message);
      } catch (error, stack) {
        devLog.severe("$error\n$stack");
      }
      // Publish!
      _r.bc.applicantChanged(account.state.deviceId, applicant);
      _r.bc.applicantChatPosted(account.state.deviceId, markerChat, account);
    }
  }
}
