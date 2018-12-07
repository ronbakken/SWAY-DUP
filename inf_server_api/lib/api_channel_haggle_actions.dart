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
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelHaggleActions {
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  int nextFakeGhostId;

  ApiChannel _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkChannel get channel {
    return _r.channel;
  }

  dospace.Bucket get bucket {
    return _r.bucket;
  }

  DataAccount get account {
    return _r.account;
  }

  Int64 get accountId {
    return _r.account.accountId;
  }

  GlobalAccountState get globalAccountState {
    return _r.account.globalAccountState;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.ApiChannelOAuth');
  static final Logger devLog = new Logger('InfDev.ApiChannelOAuth');

  ApiChannelHaggleActions(this._r) {
    /*
    _r.registerProcedure(
        "CH_PLAIN", GlobalAccountState.readWrite, netChatPlain);
    _r.registerProcedure(
        "CH_HAGGL", GlobalAccountState.readWrite, netChatHaggle);
    _r.registerProcedure(
        "CH_IMAGE", GlobalAccountState.readWrite, netChatImageKey);

    _r.registerProcedure(
        "AP_WADEA", GlobalAccountState.readWrite, netProposalWantDealReq);
    _r.registerProcedure(
        "AP_REJEC", GlobalAccountState.readWrite, netProposalRejectReq);
    _r.registerProcedure(
        "AP_REPOR", GlobalAccountState.readWrite, netProposalReportReq);
    _r.registerProcedure(
        "AP_COMPL", GlobalAccountState.readWrite, netProposalCompletionReq);
*/
  }

  void dispose() {
    /*
    _r.unregisterProcedure("CH_PLAIN");
    _r.unregisterProcedure("CH_HAGGL");
    _r.unregisterProcedure("CH_IMAGE");

    _r.unregisterProcedure("AP_WADEA");
    _r.unregisterProcedure("AP_REJEC");
    _r.unregisterProcedure("AP_REPOR");
    _r.unregisterProcedure("AP_COMPL");
*/
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // User actions
  //////////////////////////////////////////////////////////////////////////////

  // Response messages

  // Client should respond to live updates and posts from broadcast center
  // LN_APPLI, LN_A_CHA, LU_APPLI, LU_A_CHA
  // Also post to FCM

  /*
  final Function(String text) onSendPlain; -> NetChatPlain / CH_PLAIN
  final Function(String key) onSendImageKey; -> CH_IMAGE

  final Function(DataProposalChat haggleChat) onBeginHaggle; -> UI -> NetChatHaggle / CH_HAGGL
  final Function(DataProposalChat haggleChat) onWantDeal; -- not yet defined -- only succeeds if picked chat is the current one

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
  Future<bool> _verifySender(
      Int64 proposalId, Int64 senderId, ProposalChatType type) async {
    Int64 influencerAccountId;
    Int64 businessAccountId;
    ProposalState state;

    // Fetch proposal
    String query = "SELECT "
        "`influencer_account_id`, `business_account_id`, "
        "`state` "
        "FROM `proposals` "
        "WHERE `proposal_id` = ?";
    await for (sqljocky.Row row
        in await sql.prepareExecute(query, [proposalId])) {
      influencerAccountId = new Int64(row[0]);
      businessAccountId = new Int64(row[1]);
      state = ProposalState.valueOf(row[2].toInt());
    }

    // Authorize
    if (businessAccountId == null || influencerAccountId == null) {
      opsLog.severe(
          "Attempt to send message to invalid proposal chat by account '$senderId'");
      return false; // Not Found
    }
    if (account.accountType != AccountType.support &&
        accountId != businessAccountId &&
        accountId != influencerAccountId) {
      opsLog.severe(
          "Attempt to send message to unauthorized proposal chat by account '$senderId'");
      return false; // Not Authorized
    }

    switch (state) {
      case ProposalState.proposing:
        if (type != ProposalChatType.negotiate && type != ProposalChatType.marker) {
          devLog
              .warning("Attempt to send message to $state deal by '$senderId");
          return false;
        }
        break;
      case ProposalState.negotiating:
      case ProposalState.deal:
      case ProposalState.dispute:
        break;
      case ProposalState.rejected:
      case ProposalState.complete:
      case ProposalState.resolved:
        devLog.warning("Attempt to send message to $state deal by '$senderId");
        return false;
    }

    return true;
  }

/*
  int64 chatId = 7; // Sequential identifier in the chat stream
  int64 sent = 10; // Sent timestamp
  int32 senderId = 2; // Account which sent
  int32 proposalId = 1; // One chat per proposal
  
  int32 sessionId = 11; // Cleared upon forwarding
  int32 sessionGhostId = 6; // Deduplication client-side (ghost entry)
  
  ProposalChatType type = 8;
  string text = 5; // The written text
  int64 seen = 9; // 0 if not seen
*/

  Future<bool> _insertChat(
      sqljocky.QueriableConnection connection, DataProposalChat chat) async {
    // Store in database
    String insertChat = "INSERT INTO `proposal_chats`("
        "`sender_account_id`, `proposal_id`, "
        "`session_id`, `session_ghost_id`, "
        "`type`, `text`) "
        "VALUES (?, ?, ?, ?, ?, ?)";
    sqljocky.Results resultHaggle =
        await connection.prepareExecute(insertChat, [
      chat.senderAccountId,
      chat.proposalId,
      chat.sessionId,
      chat.sessionGhostId
          .toInt(), // Not actually used for apply chat, but need it for consistency
      chat.type.value.toInt(),
      chat.plainText.toString(), // TODO: Insert the right fields!
    ]);
    int termsChatId = resultHaggle.insertId;
    if (termsChatId == null || termsChatId == 0) {
      return false;
    }
    chat.chatId = new Int64(termsChatId);
    return true;
  }

  Future<void> _enterChat(DataProposalChat chat) async {
    bool publish = false;
    if (chat.type == ProposalChatType.negotiate) {
      await sql.startTransaction((transaction) async {
        if (await _insertChat(transaction, chat)) {
          // Update haggle on proposal
          String updateHaggleChatId = "UPDATE `proposals` "
              "SET `terms_chat_id` = ?, `influencer_wants_deal` = 0, `business_wants_deal` = 0 "
              "WHERE `proposal_id` = ? AND `state` = ${ProposalState.negotiating.value}";
          sqljocky.Results resultUpdateHaggleChatId =
              await transaction.prepareExecute(updateHaggleChatId, [
            chat.chatId,
            chat.proposalId,
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
      if (chat.type == ProposalChatType.negotiate) {
        await _changedProposal(chat.proposalId);
      }
    } else {
      // Send placeholder message to erase the ghost id to current session.
      // This is an unusual race condition case that shouldn't happen.
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.messageDropped.value;
      channel.sendMessage("LN_A_CHA", chat.writeToBuffer());
    }
  }

  Future<void> _publishChat(DataProposalChat chat) async {
    if (chat.imageKey != null) {
      chat.imageKey = null;
      chat.imageUrl = _r.makeCloudinaryCoverUrl(chat.imageKey);
    }

    if (chat.imageUrl != null && chat.imageBlurred == null) {
      devLog.warning("Chat image blurred missing.");
    }

    // Publish to me
    channel.sendMessage("LN_A_CHA", chat.writeToBuffer());

    // Clear private information from broadcast
    chat.sessionId = Int64.ZERO;
    chat.sessionGhostId = 0;

    // Publish to all else
    // TODO: Deduplicate chat.writeToBuffer() calls on publishing
    _r.bc.proposalChatPosted(account.sessionId, chat, account);
  }

  Future<void> _changedProposal(Int64 proposalId) async {
    // DataProposal proposal) {
    DataProposal proposal = await _r.getProposal(proposalId);
    channel.sendMessage("LU_APPLI", proposal.writeToBuffer()); // TODO: Filter sensitive info from business and influencer
    _r.bc.proposalChanged(account.sessionId, proposal);
  }

  Future<void> netChatPlain(TalkMessage message) async {
    NetChatPlain pb = new NetChatPlain();
    pb.mergeFromBuffer(message.data);

    if (!await _verifySender(pb.proposalId, accountId, ProposalChatType.plain))
      return;

    DataProposalChat chat = new DataProposalChat();
    chat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = accountId;
    chat.proposalId = pb.proposalId;
    chat.sessionId = account.sessionId;
    chat.sessionGhostId = pb.sessionGhostId;
    chat.type = ProposalChatType.plain;
    chat.plainText = pb.text;

    await _enterChat(chat);
  }

  Future<void> netChatHaggle(TalkMessage message) async {
    NetChatNegotiate pb = new NetChatNegotiate();
    pb.mergeFromBuffer(message.data);

    /*

    int influencerAccountId;
    int businessAccountId;
    String deliverables;
    String reward;

    // Fetch proposal
    String query = "SELECT "
        "`proposals`.`influencer_account_id`, `proposals`.`business_account_id`, "
        "`offers`.`deliverables`, `offers`.`reward` "
        "FROM `proposals` "
        "INNER JOIN `offers` ON `offers`.`offer_id` = `proposals`.`offer_id` "
        "WHERE `proposal_id` = ?";
    await for (sqljocky.Row row
        in await sql.prepareExecute(query, [pb.proposalId])) {
      influencerAccountId = new Int64(row[0]);
      businessAccountId = new Int64(row[1]);
      deliverables = row[2].toString();
      reward = row[3].toString();
    }

    if (!await _verifySenderMatches(influencerAccountId, businessAccountId, accountId))
      return;

    */

    if (!await _verifySender(pb.proposalId, accountId, ProposalChatType.negotiate))
      return;

    DataProposalChat chat = new DataProposalChat();
    chat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = accountId;
    chat.proposalId = pb.proposalId;
    chat.sessionId = account.sessionId;
    chat.sessionGhostId = pb.sessionGhostId;
    chat.type = ProposalChatType.negotiate;
    chat.plainText = pb.remarks;
    chat.terms = pb.terms;

    await _enterChat(chat);
  }

  Future<void> netChatImageKey(TalkMessage message) async {
    NetChatImageKey pb = new NetChatImageKey();
    pb.mergeFromBuffer(message.data);

    if (!await _verifySender(
        pb.proposalId, accountId, ProposalChatType.imageKey)) return;

    DataProposalChat chat = new DataProposalChat();
    chat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    chat.senderAccountId = accountId;
    chat.proposalId = pb.proposalId;
    chat.sessionId = account.sessionId;
    chat.sessionGhostId = pb.sessionGhostId;
    chat.type = ProposalChatType.imageKey;
    chat.imageKey = pb.imageKey;
    // TODO: imageBlurred

    await _enterChat(chat);
  }

  // Client should respond to live updates and posts from broadcast center
  // LN_APPLI, LN_A_CHA, LU_APPLI, LU_A_CHA
  // Also post to FCM

  /*

  final Function(DataProposalChat haggleChat) onWantDeal; -- AP_WADEA -- NetProposalCommonRes (Id: AP_R_COM), proposal update + marker-- only succeeds if picked chat is the current one

  final Function() onReject; -- AP_R_COM, NetProposalCommonRes (Id: AP_R_COM), proposal update + marker
  final Function() onBeginReport; AP_REPOR -- NetProposalCommonRes (Id: AP_R_COM), null, null -- posts to freshdesk // FCM email verification service?

  final Function() onBeginDispute; AP_COMPL -- NetProposalCommonRes (Id: AP_R_COM), proposal update + marker (silent) -- posts to freshdesk // FCM email verification service?
  final Function() onBeginMarkCompleted; -> AP_COMPL, NetProposalCommonRes
  */

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Common actions
  //////////////////////////////////////////////////////////////////////////////

  Future<void> netProposalWantDealReq(TalkMessage message) async {
    NetProposalWantDeal pb = new NetProposalWantDeal();
    pb.mergeFromBuffer(message.data);

    Int64 proposalId = pb.proposalId;
    Int64 termsChatId = pb.termsChatId;

    /* No need, already verified by first UPDATE
    if (!await _verifySender(proposalId, accountId)) {
      channel.sendException("Verification Failed", message);
      return;
    } */

    DataProposalChat markerChat; // Set upon success

    await sql.startTransaction((transaction) async {
      // 1. Update deal to reflect the account wants a deal
      channel.replyExtend(message);
      String accountWantsDeal = account.accountType == AccountType.influencer
          ? 'influencer_wants_deal'
          : 'business_wants_deal';
      String accountAccountId = account.accountType == AccountType.influencer
          ? 'influencer_account_id'
          : 'business_account_id';
      String updateWants = "UPDATE `proposals` "
          "SET `$accountWantsDeal` = 1 "
          "WHERE `proposal_id` = ? "
          "AND `terms_chat_id` = ? "
          "AND `$accountAccountId` = ? "
          "AND `state` = ${ProposalState.negotiating.value} "
          "AND `$accountWantsDeal` = 0";
      sqljocky.Results resultWants = await transaction
          .prepareExecute(updateWants, [proposalId, termsChatId, accountId]);
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            "Invalid want deal attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      // 2. Try to see if we're can complete the deal or if it's just one sided
      channel.replyExtend(message);
      String updateDeal = "UPDATE `proposals` "
          "SET `state` = ${ProposalState.deal.value} "
          "WHERE `proposal_id` = ? "
          "AND `influencer_wants_deal` = 1 "
          "AND `business_wants_deal` = 1 "
          "AND `state` = ${ProposalState.negotiating.value}";
      sqljocky.Results resultDeal =
          await transaction.prepareExecute(updateDeal, [proposalId]);
      bool dealMade =
          (resultDeal.affectedRows != null && resultDeal.affectedRows > 0);

      // 3. Insert marker chat
      channel.replyExtend(message);
      DataProposalChat chat = new DataProposalChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.sessionId = account.sessionId;
      chat.sessionGhostId = ++nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = 
          (dealMade
              ? ProposalChatMarker.dealMade.value
              : ProposalChatMarker.wantDeal.value);
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, "Not Handled");
    } else {
      NetProposal res = new NetProposal();
      DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, "AP_R_COM", res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);
    }
  }

  Future<void> netProposalRejectReq(TalkMessage message) async {
    NetProposalReject pb = new NetProposalReject();
    pb.mergeFromBuffer(message.data);

    Int64 proposalId = pb.proposalId;
    String reason = pb.reason.toString();

    DataProposalChat markerChat; // Set upon success

    await sql.startTransaction((transaction) async {
      // 1. Update deal to reflect the account wants a deal
      channel.replyExtend(message);
      String accountAccountId = account.accountType == AccountType.influencer
          ? 'influencer_account_id' // Cancel
          : 'business_account_id'; // Reject
      String updateWants = "UPDATE `proposals` "
          "SET `state` = ${ProposalState.rejected.value} "
          "WHERE `proposal_id` = ? "
          "AND `$accountAccountId` = ?"
          "AND `state` = ${ProposalState.negotiating.value}";
      sqljocky.Results resultWants = await transaction
          .prepareExecute(updateWants, [proposalId, accountId]);
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            "Invalid reject attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      // 2. Insert marker chat
      channel.replyExtend(message);
      DataProposalChat chat = new DataProposalChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.sessionId = account.sessionId;
      chat.sessionGhostId = ++nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.rejected.value;
          Uri.encodeQueryComponent(reason);
      chat.plainText = reason;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, "Not Handled");
    } else {
      NetProposal res = new NetProposal();
      try {
        channel.replyExtend(message);
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, "AP_R_COM", res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);
    }
  }

  Future<void> netProposalReportReq(TalkMessage message) async {
    NetProposalReport pb = new NetProposalReport();
    pb.mergeFromBuffer(message.data);

    Int64 proposalId = pb.proposalId;

    if (!await _verifySender(proposalId, accountId, ProposalChatType.marker)) {
      channel.replyAbort(message, "Verification Failed");
      return;
    }

    opsLog.severe("Report: ${pb.text}");

    // Post to freshdesk
    DataProposal proposal = await _r.getProposal(proposalId);

    HttpClient httpClient = new HttpClient();
    HttpClientRequest httpRequest = await httpClient
        .postUrl(Uri.parse(config.services.freshdeskApi + '/api/v2/tickets'));
    httpRequest.headers.add('Content-Type', 'application/json');
    httpRequest.headers.add(
        'Authorization',
        'Basic ' +
            base64.encode(utf8.encode(config.services.freshdeskKey + ':X')));

    Map<String, dynamic> doc = new Map<String, dynamic>();
    doc['name'] = account.name;
    doc['email'] = account.email;
    doc['subject'] = "Proposal Report (Ap. $proposalId)";
    doc['type'] = "Problem";
    doc['description'] =
        "<h1>Message</h1><p>${htmlEscape.convert(pb.text)}</p><hr><h1>Proposal</h1>${proposal}";
    doc['priority'] = 2;
    doc['status'] = 2;

    channel.replyExtend(message);
    httpRequest.write(json.encode(doc));
    await httpRequest.flush();
    HttpClientResponse httpResponse = await httpRequest.close();
    BytesBuilder responseBuilder = new BytesBuilder(copy: false);
    await httpResponse.forEach(responseBuilder.add);
    if (httpResponse.statusCode != 200 && httpResponse.statusCode != 201) {
      devLog.severe(
          "Report post failed: ${utf8.decode(responseBuilder.toBytes())}");
      channel.replyAbort(message, "Post Failed");
      return;
    }

    NetProposal res = new NetProposal();
    channel.replyMessage(message, "AP_R_COM", res.writeToBuffer());
  }

  Future<void> netProposalCompletionReq(TalkMessage message) async {
    NetProposalCompletion pb = new NetProposalCompletion();
    pb.mergeFromBuffer(message.data);

    Int64 proposalId = pb.proposalId;

    DataProposalChat markerChat; // Set upon successful action

    // Completion or dispute
    await sql.startTransaction((transaction) async {
      // 1. Update deal to reflect the account marked completion
      channel.replyExtend(message);
      String accountAccountId = account.accountType == AccountType.influencer
          ? 'influencer_account_id'
          : 'business_account_id';
      String accountMarkedDelivered =
          account.accountType == AccountType.influencer
              ? 'influencer_marked_delivered'
              : 'business_marked_delivered';
      String accountMarkedRewarded =
          account.accountType == AccountType.influencer
              ? 'influencer_marked_rewarded'
              : 'business_marked_rewarded';
      String accountGaveRating = account.accountType == AccountType.influencer
          ? 'influencer_gave_rating'
          : 'business_gave_rating';
      String accountDisputed = account.accountType == AccountType.influencer
          ? 'influencer_disputed'
          : 'business_disputed';
      String updateMarkings = "UPDATE `proposals` "
          "SET `$accountMarkedDelivered` = 1, `$accountMarkedRewarded` = 1 " +
          (pb.rating > 0 ? ", `$accountGaveRating` = ?" : '') + // TODO: Always rating
          "WHERE `proposal_id` = ? "
          "AND `$accountAccountId` = ?"
          "AND `state` = ${ProposalState.deal.value} OR `state` = ${ProposalState.dispute.value}";
      List<dynamic> parameters = []; // TODO: [pb.delivered ? 1 : 0, pb.rewarded ? 1 : 0];
      if (pb.rating > 0) parameters.add(pb.rating);
      parameters.addAll([proposalId, accountId]);
      sqljocky.Results resultMarkings =
          await transaction.prepareExecute(updateMarkings, parameters);
      if (resultMarkings.affectedRows == null ||
          resultMarkings.affectedRows == 0) {
        devLog.warning(
            "Invalid completion or invalid dispute attempt by account '$accountId' on proposal '$proposalId'");
        return;
      }

      bool dealCompleted;
      // TODO: if (!pb.dispute) {
        // 2. Check for deal completion
        channel.replyExtend(message);
        String updateCompletion = "UPDATE `proposals` "
            "SET `state` = ${ProposalState.complete.value} "
            "WHERE `proposal_id` = ? "
            "AND `influencer_marked_delivered` > 0 AND `influencer_marked_rewarded` > 0 "
            "AND `business_marked_delivered` > 0 AND `business_marked_rewarded` > 0 "
            "AND `influencer_gave_rating` > 0 AND `business_gave_rating` > 0 "
            "AND `state` = ${ProposalState.deal.value}";
        sqljocky.Results resultCompletion =
            await transaction.prepareExecute(updateCompletion, [proposalId]);
        dealCompleted = resultCompletion.affectedRows != null &&
            resultCompletion.affectedRows != 0;
      // }

/*
      ProposalChatMarker marker = pb.dispute
          ? ProposalChatMarker.markedDispute
          : (dealCompleted
              ? ProposalChatMarker.complete
              : ProposalChatMarker.markedComplete);
              */
      ProposalChatMarker marker=dealCompleted
              ? ProposalChatMarker.complete
              : ProposalChatMarker.markedComplete;

      // 2. Insert marker chat
      channel.replyExtend(message);
      DataProposalChat chat = new DataProposalChat();
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.sessionId = account.sessionId;
      chat.sessionGhostId = ++nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = marker.value;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        /*
        if (pb.dispute) {
          DataProposal proposal =
              await _r.apiChannelHaggle.getProposal(proposalId);

          HttpClient httpClient = new HttpClient();
          HttpClientRequest httpRequest = await httpClient.postUrl(
              Uri.parse(config.services.freshdeskApi + '/api/v2/tickets'));
          httpRequest.headers.add('Content-Type', 'application/json');
          httpRequest.headers.add(
              'Authorization',
              'Basic ' +
                  base64.encode(
                      utf8.encode(config.services.freshdeskKey + ':X')));

          Map<String, dynamic> doc = new Map<String, dynamic>();
          doc['name'] = account.name;
          doc['email'] = account.email;
          doc['subject'] = "Proposal Dispute (Ap. $proposalId)";
          doc['type'] = "Incident";
          doc['description'] =
              "<h1>Message</h1><p>${htmlEscape.convert(pb.disputeDescription)}</p><hr><h1>Proposal</h1>${proposal}";
          doc['priority'] = 3;
          doc['status'] = 2;

          channel.replyExtend(message);
          httpRequest.write(json.encode(doc));
          await httpRequest.flush();
          HttpClientResponse httpResponse = await httpRequest.close();
          BytesBuilder responseBuilder = new BytesBuilder(copy: false);
          await httpResponse.forEach(responseBuilder.add);
          if (httpResponse.statusCode != 200) {
            devLog.severe(
                "Report post failed: ${utf8.decode(responseBuilder.toBytes())}");
            channel.replyAbort(message, "Post Failed");
            return;
          }
        }
        */
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, "Not handled.");
    } else {
      NetProposal res = new NetProposal();
      try {
        channel.replyExtend(message);
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, "AP_R_COM", res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe("$error\n$stackTrace");
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);
    }
  }
}

/* end of file */