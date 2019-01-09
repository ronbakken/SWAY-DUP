/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/broadcast_center.dart';
import 'package:inf_server_api/common_account.dart';
import 'package:inf_server_api/common_offers.dart';
import 'package:inf_server_api/common_storage.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:inf_server_api/elasticsearch_offer.dart';
import 'package:inf_server_api/sql_proposal.dart';
import 'package:logging/logging.dart';

import 'package:grpc/grpc.dart' as grpc;
import 'package:pedantic/pedantic.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:http/http.dart' as http;
import 'package:http_client/console.dart' as http_client;

import 'package:inf_common/inf_common.dart';

class ApiProposalsService extends ApiProposalsServiceBase {
  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  final Elasticsearch elasticsearch;
  final BroadcastCenter bc;
  static final Logger opsLog = Logger('InfOps.ApiProposalsService');
  static final Logger devLog = Logger('InfDev.ApiProposalsService');

  final http.Client httpClient = http.Client();
  final http_client.Client httpClientClient = http_client.ConsoleClient();

  ApiProposalsService(this.config, this.accountDb, this.proposalDb,
      this.elasticsearch, this.bc);

  @override
  Future<NetProposal> apply(
      grpc.ServiceCall call, NetApplyProposal request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    // Fetch some offer info
    final DataOffer offer =
        await getOffer(config, elasticsearch, request.offerId, auth.accountId);
    if (offer.senderAccountId == Int64.ZERO) {
      // Should not happen. Database issue likely
      opsLog.severe(
          'Request for offer "${request.offerId}" returned empty sender account id.');
      throw grpc.GrpcError.internal('Offer not valid.');
    }
    if (offer.state != OfferState.open) {
      throw grpc.GrpcError.failedPrecondition('Offer not open.');
    }
    if (offer.senderAccountType == auth.accountType) {
      throw grpc.GrpcError.failedPrecondition('Account type mismatch.');
    }
    if (request.hasTerms() && !offer.allowNegotiatingProposals) {
      throw grpc.GrpcError.failedPrecondition(
          'Cannot negotiate with this offer.');
    }

    final DataAccount account =
        await fetchSessionAccount(config, accountDb, auth.sessionId);
    if (account.accountId != auth.accountId) {
      throw grpc.GrpcError.dataLoss();
    }

    // TODO: Forbid negotiate when not allowed
    final DataProposal proposal = DataProposal();
    proposal.offerId = request.offerId;
    proposal.senderAccountId = auth.accountId;
    proposal.offerAccountId = offer.senderAccountId;
    if (offer.senderAccountType == AccountType.business) {
      proposal.influencerAccountId = auth.accountId;
      proposal.businessAccountId = offer.senderAccountId;
      proposal.influencerName = account.name;
      proposal.businessName = offer.senderName;
    } else {
      proposal.influencerAccountId = offer.senderAccountId;
      proposal.businessAccountId = auth.accountId;
      proposal.influencerName = offer.senderName;
      proposal.businessName = account.name;
    }
    proposal.offerTitle = offer.title;
    proposal.state = // Accept matching proposals automatically
        (!request.hasTerms() && offer.acceptMatchingProposals)
            ? ProposalState.deal
            : ProposalState.proposing;
    final DataProposalChat chat = DataProposalChat();
    chat.senderAccountId = auth.accountId;
    chat.senderSessionId = account.sessionId;
    chat.senderSessionGhostId = request.sessionGhostId;
    chat.type = ProposalChatType.negotiate;
    chat.plainText = request.remarks;
    if (request.hasTerms()) {
      chat.terms = request.terms;
    } else {
      chat.terms = offer.terms;
    }

    await proposalDb.startTransaction((sqljocky.Transaction transaction) async {
      // 1. Insert into proposals
      final sqljocky.Results resultProposal = await transaction.prepareExecute(
        SqlProposal.insertProposalQuery,
        SqlProposal.makeInsertProposalParameters(proposal),
      );
      final Int64 proposalId = Int64(resultProposal.insertId);
      if (proposalId == Int64.ZERO) {
        throw Exception('Proposal not inserted.');
      }
      proposal.proposalId = proposalId;
      chat.proposalId = proposalId;

      // 2. Insert terms into chat
      final sqljocky.Results resultNegotiate = await transaction.prepareExecute(
        SqlProposal.insertNegotiateChatQuery,
        SqlProposal.makeInsertNegotiateChatParameters(chat),
      );
      final Int64 termsChatId = Int64(resultNegotiate.insertId);
      if (termsChatId == Int64.ZERO) {
        throw Exception('Terms chat not inserted.');
      }
      proposal.termsChatId = termsChatId;
      chat.chatId = termsChatId;
      chat.sent = Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
      if (account.accountType == AccountType.business) {
        proposal.businessWantsDeal = true;
      } else {
        proposal.influencerWantsDeal = true;
      }

      // 3. Update haggle on proposal
      // On automatic accept we're not updating business_wants_deal here, it's not necessary
      final String updateTermsChatId = 'UPDATE `proposals` '
          'SET `terms_chat_id` = ?, '
          '`${account.accountType == AccountType.business ? 'business_wants_deal' : 'influencer_wants_deal'}` = 1 '
          'WHERE `proposal_id` = ?';
      final sqljocky.Results resultUpdateTermsChatId =
          await transaction.prepareExecute(
        updateTermsChatId,
        <dynamic>[
          termsChatId,
          proposalId,
        ],
      );
      if (resultUpdateTermsChatId.affectedRows == null ||
          resultUpdateTermsChatId.affectedRows == 0) {
        throw Exception('Failed to update terms chat id.');
      }

      await transaction.commit();
    });

    final NetProposal result = NetProposal();
    result.proposal = proposal;
    result.chats.add(chat);
    result.freeze();
    devLog.finest('Applied for offer successfully: $result');

    unawaited(() async {
      // Clear private information from broadcast
      final DataProposalChat publicChat = DataProposalChat()..mergeFromMessage(chat);
      publicChat.clearSenderSessionId();
      publicChat.clearSenderSessionGhostId();

      // Broadcast
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = result.proposal;
      await bc.proposalChanged(account.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = publicChat;
      publishChat.freeze();
      await bc.proposalChatPosted(account.sessionId, publishChat, account);

      // TODO: Update offer proposal count
      // TODO: Add to proposal_sender_account_ids lookup
    }());

    return result;
  }

  @override
  Future<NetProposal> direct(grpc.ServiceCall call, NetDirectProposal request) {
    // TODO: implement direct
    return null;
  }

  @override
  Stream<NetProposal> list(grpc.ServiceCall call, NetListProposals request) {
    // TODO: implement list
    return null;
  }

  @override
  Future<NetProposal> get(grpc.ServiceCall call, NetGetProposal request) {
    // TODO: implement get
    return null;
  }

  @override
  Stream<NetProposalChat> listChats(
      grpc.ServiceCall call, NetGetProposal request) {
    // TODO: implement listChats
    return null;
  }
}

/* end of file */
