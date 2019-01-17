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

import 'package:inf_common/inf_backend.dart';

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

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> apply(
      grpc.ServiceCall call, NetApplyProposal request) async {
    final DataAuth auth = authFromJwtPayload(call);
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

    try {
      await proposalDb
          .startTransaction((sqljocky.Transaction transaction) async {
        // 1. Insert into proposals
        final sqljocky.Results resultProposal =
            await transaction.prepareExecute(
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
        final sqljocky.Results resultNegotiate =
            await transaction.prepareExecute(
          SqlProposal.insertNegotiateChatQuery,
          SqlProposal.makeInsertNegotiateChatParameters(chat),
        );
        final Int64 termsChatId = Int64(resultNegotiate.insertId);
        if (termsChatId == Int64.ZERO) {
          throw Exception('Terms chat not inserted.');
        }
        proposal.termsChatId = termsChatId;
        proposal.lastChatId = termsChatId;
        chat.chatId = termsChatId;
        chat.sent =
            Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
        if (account.accountType == AccountType.business) {
          proposal.businessWantsDeal = true;
        } else {
          proposal.influencerWantsDeal = true;
        }

        // 3. Update haggle on proposal
        // On automatic accept we're not updating business_wants_deal here, it's not necessary
        final String updateTermsChatId = 'UPDATE `proposals` '
            'SET `terms_chat_id` = ?, `last_chat_id` = ?, '
            '`${account.accountType == AccountType.business ? 'business_wants_deal' : 'influencer_wants_deal'}` = 1 '
            'WHERE `proposal_id` = ?';
        final sqljocky.Results resultUpdateTermsChatId =
            await transaction.prepareExecute(
          updateTermsChatId,
          <dynamic>[
            termsChatId,
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
    } catch (error, _) {
      if (error is sqljocky.MySqlException) {
        devLog.fine('Failed apply transaction.', error);
        // Might be double call
        final NetProposal response = await _getProposal(
          auth.sessionId,
          auth.accountId,
          auth.accountType,
          offerId: request.offerId,
        );
        if (!response.hasProposal()) {
          throw grpc.GrpcError.failedPrecondition('Failed apply.');
        }
        return response;
      } else {
        rethrow;
      }
    }

    final NetProposal response = NetProposal();
    response.proposal = proposal;
    response.chats.add(chat);
    response.freeze();
    devLog.finest('Applied for offer successfully: $response');

    unawaited(() async {
      // Clear private information from broadcast
      final DataProposalChat publicChat = DataProposalChat()
        ..mergeFromMessage(chat);
      publicChat.clearSenderSessionId();
      publicChat.clearSenderSessionGhostId();

      // Broadcast
      final NetProposal publishProposal = NetProposal();
      publishProposal.proposal = response.proposal;
      await bc.proposalChanged(account.sessionId, publishProposal);
      final NetProposalChat publishChat = NetProposalChat();
      publishChat.chat = publicChat;
      publishChat.freeze();
      await bc.proposalChatPosted(account.sessionId, publishChat, account);

      // TODO: Update offer proposal count
      // TODO: Add to proposal_sender_account_ids lookup
    }());

    return response;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<NetProposal> direct(
      grpc.ServiceCall call, NetDirectProposal request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    throw grpc.GrpcError.unimplemented();
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Stream<NetProposal> list(
      grpc.ServiceCall call, NetListProposals request) async* {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }
    devLog.finest('NetListProposals: $request');

    final sqljocky.RetainedConnection connection =
        await proposalDb.getConnection();
    try {
      // Fetch proposal
      // TODO: Limit result count
      final String query = SqlProposal.getSelectProposalsQuery(
              auth.accountType) +
          ' WHERE `${auth.accountType == AccountType.business ? 'business_account_id' : 'influencer_account_id'}` = ?';
      await for (sqljocky.Row row in await connection
          .prepareExecute(query, <dynamic>[auth.accountId])) {
        final NetProposal response = NetProposal();
        response.proposal = SqlProposal.proposalFromRow(row, auth.accountType);
        yield response;
      }
    } finally {
      await connection.release();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  // Get proposal by proposalId, or with the applicant's accountId by offerId
  Future<NetProposal> _getProposal(
    Int64 sessionId,
    Int64 accountId,
    AccountType accountType, {
    Int64 proposalId,
    Int64 offerId,
  }) async {
    NetProposal response;
    final sqljocky.RetainedConnection connection =
        await proposalDb.getConnection();
    try {
      // Fetch proposal
      final String query = SqlProposal.getSelectProposalsQuery(accountType) +
          (proposalId != null
              ? ' WHERE `proposal_id` = ?'
                  ' AND `${accountType == AccountType.business ? 'business_account_id' : 'influencer_account_id'}` = ?'
              : ' WHERE `offer_id` = ?'
              ' AND `sender_account_id` = ?');
      await for (sqljocky.Row row in await connection.prepareExecute(
        query,
        <dynamic>[(proposalId != null ? proposalId : offerId), accountId],
      )) {
        response = NetProposal();
        response.proposal = SqlProposal.proposalFromRow(row, accountType);
      }

      if (response != null) {
        // Fetch latest chat
        DataProposalChat latestChat;
        const String chatQuery = 'SELECT ' +
            _selectChatQuery +
            'FROM `proposal_chats` '
            'WHERE `proposal_id` = ? '
            'ORDER BY `chat_id` DESC '
            'LIMIT 1';
        await for (sqljocky.Row row
            in await connection.prepareExecute(chatQuery, <dynamic>[
          response.proposal.proposalId,
        ])) {
          latestChat =
              _chatFromRow(sessionId, response.proposal.proposalId, row);
        }
        if (latestChat != null) {
          response.chats.add(latestChat);
        }

        if (latestChat != null &&
            response.proposal.termsChatId != latestChat.chatId &&
            response.proposal.termsChatId != Int64.ZERO) {
          // Fetch terms chat
          DataProposalChat termsChat;
          const String chatQuery = 'SELECT ' +
              _selectChatQuery +
              'FROM `proposal_chats` '
              'WHERE `chat_id` = ?';
          await for (sqljocky.Row row
              in await connection.prepareExecute(chatQuery, <dynamic>[
            response.proposal.termsChatId,
          ])) {
            termsChat =
                _chatFromRow(sessionId, response.proposal.proposalId, row);
          }
          if (termsChat != null) {
            response.chats.add(termsChat);
          }
        }
      }
    } finally {
      await connection.release();
    }
    return response;
  }

  @override
  Future<NetProposal> get(grpc.ServiceCall call, NetGetProposal request) async {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    NetProposal response = await _getProposal(
      auth.sessionId,
      auth.accountId,
      auth.accountType,
      proposalId: request.proposalId,
    );

    if (response == null) {
      throw grpc.GrpcError.failedPrecondition(
          'Proposal not found, or not authorized.');
    }

    return response;
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  @override
  Stream<NetProposalChat> listChats(
      grpc.ServiceCall call, NetListChats request) async* {
    final DataAuth auth = authFromJwtPayload(call);
    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readOnly.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    Int64 influencerAccountId;
    Int64 businessAccountId;
    ProposalState state;

    final sqljocky.RetainedConnection connection =
        await proposalDb.getConnection();
    try {
      // Fetch proposal access
      const String query = 'SELECT '
          '`influencer_account_id`, `business_account_id`, `state` '
          'FROM `proposals` '
          'WHERE `proposal_id` = ?';
      await for (sqljocky.Row row in await connection
          .prepareExecute(query, <dynamic>[request.proposalId])) {
        influencerAccountId = Int64(row[0]);
        businessAccountId = Int64(row[1]);
        state = ProposalState.valueOf(row[2].toInt());
      }
      devLog.finest('$influencerAccountId $businessAccountId');

      // Authorize
      if (businessAccountId == null || influencerAccountId == null) {
        opsLog.severe(
            'Attempt to request invalid proposal chat by account "${auth.accountId}".');
        throw grpc.GrpcError.failedPrecondition('Not found.');
      }
      final bool supportAccess = auth.accountType == AccountType.support &&
          state == ProposalState.dispute;
      if (!supportAccess &&
          auth.accountId != businessAccountId &&
          auth.accountId != influencerAccountId) {
        opsLog.severe(
            'Attempt to request unauthorized proposal chat by account "${auth.accountId}".');
        throw grpc.GrpcError.failedPrecondition('Not authorized.');
      }

      // Fetch
      const String chatQuery = 'SELECT ' +
          _selectChatQuery +
          'FROM `proposal_chats` '
          'WHERE `proposal_id` = ? '
          'ORDER BY `chat_id` DESC';
      await for (sqljocky.Row row
          in await connection.prepareExecute(chatQuery, <dynamic>[
        request.proposalId,
      ])) {
        final DataProposalChat chat =
            _chatFromRow(auth.sessionId, request.proposalId, row);
        final NetProposalChat response = NetProposalChat();
        response.chat = chat;
        yield response;
      }
    } finally {
      await connection.release();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  static const String _selectChatQuery =
      '`chat_id`, UNIX_TIMESTAMP(`sent`) AS `sent`, ' // 0 1
      '`sender_account_id`, `sender_session_id`, `sender_session_ghost_id`, ' // 2 3 4
      '`type`, `plain_text`, `terms`, ' // 5 6 7
      '`image_key`, `image_blurred`, ' // 8 9
      '`marker` '; // 10

  DataProposalChat _chatFromRow(
      Int64 sessionId, Int64 proposalId, sqljocky.Row row) {
    final DataProposalChat chat = DataProposalChat();
    chat.proposalId = proposalId;
    chat.chatId = Int64(row[0]);
    chat.sent = Int64(row[1]);
    chat.senderAccountId = Int64(row[2]);
    final Int64 chatSessionId = Int64(row[3]);
    if (chatSessionId == sessionId) {
      chat.senderSessionId = sessionId;
      chat.senderSessionGhostId = row[4].toInt();
    }
    chat.type = ProposalChatType.valueOf(row[5].toInt());
    if (row[6] != null) {
      chat.plainText = row[6].toString();
    }
    if (row[7] != null) {
      chat.terms = DataTerms()..mergeFromBuffer(row[7].toBytes());
    }
    if (row[8] != null) {
      chat.imageUrl =
          _makeImageUrl(config.services.galleryCoverUrl, row[8].toString());
    }
    if (row[9] != null) {
      chat.imageBlurred = row[9].toBytes();
    }
    if (row[10] != null) {
      chat.marker = ProposalChatMarker.valueOf(row[10].toInt());
    }
    return chat;
  }

  String _makeImageUrl(String template, String key) {
    final int lastIndex = key.lastIndexOf('.');
    final String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return template.replaceAll('{key}', key).replaceAll('{keyNoExt}', keyNoExt);
  }
}

/* end of file */
