/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
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

  RemoteAppHaggleActions(this._r) {
    _subscriptions.add(_r.saferListen(
        "CH_PLAIN", GlobalAccountState.GAS_READ_WRITE, true, netChatPlain));
    _subscriptions.add(_r.saferListen(
        "CH_HAGGL", GlobalAccountState.GAS_READ_WRITE, true, netChatHaggle));
    _subscriptions.add(_r.saferListen(
        "CH_IMAGE", GlobalAccountState.GAS_READ_WRITE, true, netChatImageKey));
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
              "SET `haggle_chat_id` = ? "
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
    }
  }

  Future<void> _publishChat(DataApplicantChat chat) async {
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

  final Function(DataApplicantChat haggleChat) onWantDeal; -- not yet defined -- only succeeds if picked chat is the current one

  final Function() onReject; -- AP_R_COM, NetApplicantCommonRes - reason
  final Function() onBeginReport; -- not yet defined -- posts to freshdesk // FCM email verification service?
  final Function() onBeginMarkCompleted; -> AP_COMPL
  */

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Common actions
  //////////////////////////////////////////////////////////////////////////////
}
