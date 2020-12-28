/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'package:logging/logging.dart';
//import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:sway_common/inf_common.dart';

class ApiChannelHaggleActions {
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  int nextFakeGhostId;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = Logger('InfOps.ApiChannelOAuth');
  static final Logger devLog = Logger('InfDev.ApiChannelOAuth');

  ApiChannelHaggleActions();

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // Common actions
  //////////////////////////////////////////////////////////////////////////////

/*
  Future<void> netProposalRejectReq(TalkMessage message) async {
    final NetProposalReject pb = NetProposalReject()
      ..mergeFromBuffer(message.data);

    final Int64 proposalId = pb.proposalId;
    final String reason = pb.reason.toString();

    DataProposalChat markerChat; // Set upon success

    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account wants a deal
      channel.replyExtend(message);
      final String accountAccountId =
          account.accountType == AccountType.influencer
              ? 'influencer_account_id' // Cancel
              : 'business_account_id'; // Reject
      final String updateWants = 'UPDATE `proposals` '
          'SET `state` = ${ProposalState.rejected.value} '
          'WHERE `proposal_id` = ? '
          'AND `$accountAccountId` = ?'
          'AND `state` = ${ProposalState.negotiating.value}';
      final sqljocky.Results resultWants = await transaction
          .prepareExecute(updateWants, <dynamic>[proposalId, accountId]);
      if (resultWants.affectedRows == null || resultWants.affectedRows == 0) {
        devLog.warning(
            'Invalid reject attempt by account "$accountId" on proposal "$proposalId"');
        return;
      }

      // 2. Insert marker chat
      channel.replyExtend(message);
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = ProposalChatMarker.rejected;
      Uri.encodeQueryComponent(reason);
      chat.plainText = reason;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, 'Not Handled');
    } else {
      final NetProposal res = NetProposal();
      try {
        channel.replyExtend(message);
      } catch (error, stackTrace) {
        devLog.severe('Exception occured', error, stackTrace);
      }
      final DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, 'AP_R_COM', res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe('Exception occured', error, stackTrace);
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);
    }
  }

  Future<void> netProposalReportReq(TalkMessage message) async {
    final NetProposalReport pb = NetProposalReport()
      ..mergeFromBuffer(message.data);

    final Int64 proposalId = pb.proposalId;

    if (!await _verifySender(proposalId, accountId, ProposalChatType.marker)) {
      channel.replyAbort(message, 'Verification Failed');
      return;
    }

    opsLog.severe('Report: ${pb.text}');

    // Post to freshdesk
    final DataProposal proposal = await _r.getProposal(proposalId);

    final HttpClient httpClient = HttpClient();
    final HttpClientRequest httpRequest = await httpClient
        .postUrl(Uri.parse(config.services.freshdeskApi + '/api/v2/tickets'));
    httpRequest.headers.add('Content-Type', 'application/json');
    httpRequest.headers.add(
        'Authorization',
        'Basic ' +
            base64.encode(utf8.encode(config.services.freshdeskKey + ':X')));

    final Map<String, dynamic> doc = <String, dynamic>{};
    doc['name'] = account.name;
    doc['email'] = account.email;
    doc['subject'] = 'Proposal Report (Ap. $proposalId)';
    doc['type'] = 'Problem';
    doc['description'] =
        '<h1>Message</h1><p>${htmlEscape.convert(pb.text)}</p><hr><h1>Proposal</h1>$proposal';
    doc['priority'] = 2;
    doc['status'] = 2;

    channel.replyExtend(message);
    httpRequest.write(json.encode(doc));
    await httpRequest.flush();
    final HttpClientResponse httpResponse = await httpRequest.close();
    final BytesBuilder responseBuilder = BytesBuilder(copy: false);
    await httpResponse.forEach(responseBuilder.add);
    if (httpResponse.statusCode != 200 && httpResponse.statusCode != 201) {
      devLog.severe(
          'Report post failed: ${utf8.decode(responseBuilder.toBytes())}');
      channel.replyAbort(message, 'Post Failed');
      return;
    }

    final NetProposal res = NetProposal();
    channel.replyMessage(message, 'AP_R_COM', res.writeToBuffer());
  }

  Future<void> netProposalCompletionReq(TalkMessage message) async {
    final NetProposalCompletion pb = NetProposalCompletion()
      ..mergeFromBuffer(message.data);

    final Int64 proposalId = pb.proposalId;

    DataProposalChat markerChat; // Set upon successful action

    // Completion or dispute
    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Update deal to reflect the account marked completion
      channel.replyExtend(message);
      final String accountAccountId =
          account.accountType == AccountType.influencer
              ? 'influencer_account_id'
              : 'business_account_id';
      final String accountMarkedDelivered =
          account.accountType == AccountType.influencer
              ? 'influencer_marked_delivered'
              : 'business_marked_delivered';
      final String accountMarkedRewarded =
          account.accountType == AccountType.influencer
              ? 'influencer_marked_rewarded'
              : 'business_marked_rewarded';
      final String accountGaveRating =
          account.accountType == AccountType.influencer
              ? 'influencer_gave_rating'
              : 'business_gave_rating';
      // final String accountDisputed =
      //     account.accountType == AccountType.influencer
      //         ? 'influencer_disputed'
      //         : 'business_disputed';
      final String updateMarkings = 'UPDATE `proposals` '
          'SET `$accountMarkedDelivered` = 1, `$accountMarkedRewarded` = 1 ' +
          (pb.rating > 0
              ? ', `$accountGaveRating` = ?'
              : '') + // TODO(kaetemi): Always rating
          'WHERE `proposal_id` = ? '
          'AND `$accountAccountId` = ?'
          'AND `state` = ${ProposalState.deal.value} OR `state` = ${ProposalState.dispute.value}';
      final List<dynamic> parameters = <
          dynamic>[]; // TODO(kaetemi): [pb.delivered ? 1 : 0, pb.rewarded ? 1 : 0];
      if (pb.rating > 0) {
        parameters.add(pb.rating);
      }
      parameters.addAll(<dynamic>[proposalId, accountId]);
      final sqljocky.Results resultMarkings =
          await transaction.prepareExecute(updateMarkings, parameters);
      if (resultMarkings.affectedRows == null ||
          resultMarkings.affectedRows == 0) {
        devLog.warning(
            'Invalid completion or invalid dispute attempt by account "$accountId" on proposal "$proposalId"');
        return;
      }

      bool dealCompleted;
      // TODO(kaetemi): if (!pb.dispute) {
      // 2. Check for deal completion
      channel.replyExtend(message);
      final String updateCompletion = 'UPDATE `proposals` '
          'SET `state` = ${ProposalState.complete.value} '
          'WHERE `proposal_id` = ? '
          'AND `influencer_marked_delivered` > 0 AND `influencer_marked_rewarded` > 0 '
          'AND `business_marked_delivered` > 0 AND `business_marked_rewarded` > 0 '
          'AND `influencer_gave_rating` > 0 AND `business_gave_rating` > 0 '
          'AND `state` = ${ProposalState.deal.value}';
      final sqljocky.Results resultCompletion = await transaction
          .prepareExecute(updateCompletion, <dynamic>[proposalId]);
      dealCompleted = resultCompletion.affectedRows != null &&
          resultCompletion.affectedRows != 0;
      // }

      // ProposalChatMarker marker = pb.dispute
      //     ? ProposalChatMarker.markedDispute
      //     : (dealCompleted
      //         ? ProposalChatMarker.complete
      //         : ProposalChatMarker.markedComplete);
      final ProposalChatMarker marker = dealCompleted
          ? ProposalChatMarker.complete
          : ProposalChatMarker.markedComplete;

      // 2. Insert marker chat
      channel.replyExtend(message);
      final DataProposalChat chat = DataProposalChat();
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      chat.senderAccountId = accountId;
      chat.proposalId = proposalId;
      chat.senderSessionId = account.sessionId;
      chat.senderSessionGhostId = ++nextFakeGhostId;
      chat.type = ProposalChatType.marker;
      chat.marker = marker;
      if (await _insertChat(transaction, chat)) {
        channel.replyExtend(message);
        // if (pb.dispute) {
        //   DataProposal proposal =
        //       await _r.apiChannelHaggle.getProposal(proposalId);
// 
        //   HttpClient httpClient = HttpClient();
        //   HttpClientRequest httpRequest = await httpClient.postUrl(
        //       Uri.parse(config.services.freshdeskApi + '/api/v2/tickets'));
        //   httpRequest.headers.add('Content-Type', 'application/json');
        //   httpRequest.headers.add(
        //       'Authorization',
        //       'Basic ' +
        //           base64.encode(
        //               utf8.encode(config.services.freshdeskKey + ':X')));
// 
        //   Map<String, dynamic> doc = Map<String, dynamic>();
        //   doc['name'] = account.name;
        //   doc['email'] = account.email;
        //   doc['subject'] = 'Proposal Dispute (Ap. $proposalId)';
        //   doc['type'] = 'Incident';
        //   doc['description'] =
        //       '<h1>Message</h1><p>${htmlEscape.convert(pb.disputeDescription)}</p><hr><h1>Proposal</h1>${proposal}';
        //   doc['priority'] = 3;
        //   doc['status'] = 2;
// 
        //   channel.replyExtend(message);
        //   httpRequest.write(json.encode(doc));
        //   await httpRequest.flush();
        //   HttpClientResponse httpResponse = await httpRequest.close();
        //   BytesBuilder responseBuilder = BytesBuilder(copy: false);
        //   await httpResponse.forEach(responseBuilder.add);
        //   if (httpResponse.statusCode != 200) {
        //     devLog.severe(
        //         'Report post failed: ${utf8.decode(responseBuilder.toBytes())}');
        //     channel.replyAbort(message, 'Post Failed');
        //     return;
        //   }
        // }
        markerChat = chat;
        transaction.commit();
      }
    });

    if (markerChat == null) {
      channel.replyAbort(message, 'Not handled.');
    } else {
      final NetProposal res = NetProposal();
      try {
        channel.replyExtend(message);
      } catch (error, stackTrace) {
        devLog.severe('Exception occured', error, stackTrace);
      }
      final DataProposal proposal = await _r.getProposal(proposalId);
      res.updateProposal = proposal;
      res.newChats.add(markerChat);
      try {
        // Send to current user
        channel.replyMessage(message, 'AP_R_COM', res.writeToBuffer());
      } catch (error, stackTrace) {
        devLog.severe('Exception occured', error, stackTrace);
      }
      // Publish!
      _r.bc.proposalChanged(account.sessionId, proposal);
      _r.bc.proposalChatPosted(account.sessionId, markerChat, account);
    }
  }
  */
}

/* end of file */
