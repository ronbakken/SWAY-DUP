/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf_server_api/sql_util.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;

class SqlProposal {
  static final String insertProposalQuery =
      SqlUtil.makeInsertQuery('proposals', <String>[
    'offer_id',
    'sender_account_id',
    'offer_account_id',
    'influencer_account_id',
    'business_account_id',
    'influencer_name',
    'business_name',
    'offer_title',
    'state',
  ]);

  static List<dynamic> makeInsertProposalParameters(DataProposal proposal) {
    return <dynamic>[
      proposal.offerId,
      proposal.senderAccountId,
      proposal.offerAccountId,
      proposal.influencerAccountId,
      proposal.businessAccountId,
      proposal.influencerName.isEmpty ? null : proposal.influencerName,
      proposal.businessName.isEmpty ? null : proposal.businessName,
      proposal.offerTitle.isEmpty ? null : proposal.offerTitle,
      proposal.state.value,
    ];
  }

  static final String insertNegotiateChatQuery =
      SqlUtil.makeInsertQuery('proposal_chats', <String>[
    'sender_account_id',
    'proposal_id',
    'sender_session_id',
    'sender_session_ghost_id',
    'type',
    'plain_text',
    'terms',
  ]);

  static List<dynamic> makeInsertNegotiateChatParameters(
      DataProposalChat chat) {
    assert(chat.senderAccountId != Int64.ZERO);
    assert(chat.proposalId != Int64.ZERO);
    assert(chat.senderSessionId != Int64.ZERO);
    assert(chat.senderSessionGhostId != 0);
    assert(chat.type == ProposalChatType.negotiate);
    assert(chat.hasTerms());
    return <dynamic>[
      chat.senderAccountId,
      chat.proposalId,
      chat.senderSessionId,
      chat.senderSessionGhostId,
      chat.type.value,
      chat.plainText.isEmpty ? null : chat.plainText,
      chat.terms.writeToBuffer(),
    ];
  }

  static final List<String> selectProposalColumnsInfluencer = <String>[
    'proposal_id',
    'offer_id',
    'sender_account_id',
    'offer_account_id',
    'influencer_account_id',
    'business_account_id',
    'influencer_name',
    'business_name',
    'offer_title',
    'last_chat_id',
    'influencer_seen_chat_id',
    'influencer_seen_time',
    'business_seen_chat_id',
    'business_seen_time',
    'terms_chat_id',
    'influencer_wants_deal',
    'business_wants_deal',
    'rejecting_account_id',
    'influencer_marked_delivered',
    'influencer_marked_rewarded',
    // 'business_marked_delivered',
    // 'business_marked_rewarded',
    'influencer_gave_rating',
    // 'business_gave_rating',
    'influencer_disputed',
    // 'business_disputed',
    'state',
    'influencer_archived',
    // 'business_archived',
  ];

  static final List<String> selectProposalColumnsBusiness = <String>[
    'proposal_id', // 0
    'offer_id',
    'sender_account_id',
    'offer_account_id',
    'influencer_account_id',
    'business_account_id', // 5
    'influencer_name',
    'business_name',
    'offer_title', // 8
    'last_chat_id',
    'influencer_seen_chat_id', // 10
    'influencer_seen_time',
    'business_seen_chat_id',
    'business_seen_time', // 13
    'terms_chat_id',
    'influencer_wants_deal',
    'business_wants_deal', // 16
    'rejecting_account_id', // 17
    // 'influencer_marked_delivered',
    // 'influencer_marked_rewarded',
    'business_marked_delivered',
    'business_marked_rewarded',
    // 'influencer_gave_rating',
    'business_gave_rating',
    // 'influencer_disputed',
    'business_disputed', // 21
    'state', // 22
    // 'influencer_archived',
    'business_archived', // 23
  ];

  static final List<String> selectProposalColumns = <String>[
    'proposal_id', // 0
    'offer_id',
    'sender_account_id',
    'offer_account_id',
    'influencer_account_id',
    'business_account_id', // 5
    'influencer_name',
    'business_name',
    'offer_title', // 8
    'last_chat_id',
    'influencer_seen_chat_id', // 10
    'influencer_seen_time',
    'business_seen_chat_id',
    'business_seen_time', // 13
    'terms_chat_id',
    'influencer_wants_deal',
    'business_wants_deal', // 16
    'rejecting_account_id', // 17
    'influencer_marked_delivered', // 18
    'influencer_marked_rewarded',
    'business_marked_delivered', // 20
    'business_marked_rewarded',
    'influencer_gave_rating', // 22
    'business_gave_rating',
    'influencer_disputed', // 24
    'business_disputed',
    'state', // 26
    'influencer_archived', // 27
    'business_archived', // 28
  ];

  static DataProposal proposalFromRow(
      sqljocky.Row row, AccountType receiverAccountType) {
    final DataProposal proposal = DataProposal();
    proposal.proposalId = Int64(row[0]);
    proposal.offerId = Int64(row[1]);
    proposal.senderAccountId = Int64(row[2]);
    proposal.offerAccountId = Int64(row[3]);
    proposal.influencerAccountId = Int64(row[4]);
    proposal.businessAccountId = Int64(row[5]);
    if (row[6] != null) {
      proposal.influencerName = row[6].toString();
    }
    if (row[7] != null) {
      proposal.businessName = row[7].toString();
    }
    if (row[8] != null) {
      proposal.offerTitle = row[8].toString();
    }
    proposal.lastChatId = Int64(row[9]);
    proposal.influencerSeenChatId = Int64(row[10]);
    if (row[11] != null) {
      proposal.influencerSeenTime = Int64(row[11]);
    }
    proposal.businessSeenChatId = Int64(row[12]);
    if (row[13] != null) {
      proposal.businessSeenTime = Int64(row[13]);
    }
    proposal.termsChatId = Int64(row[14]);
    proposal.influencerWantsDeal = row[15].toInt() == 1;
    proposal.businessWantsDeal = row[16].toInt() == 1;
    proposal.rejectingAccountId = Int64(row[17]);
    if (receiverAccountType == AccountType.influencer) {
      proposal.influencerMarkedDelivered = row[18].toInt() == 1;
      proposal.influencerMarkedRewarded = row[19].toInt() == 1;
      proposal.influencerGaveRating = row[20].toInt();
      proposal.influencerDisputed = row[21].toInt() == 1;
      proposal.state = ProposalState.valueOf(row[22].toInt());
      proposal.influencerArchived = row[23].toInt() == 1;
    } else if (receiverAccountType == AccountType.business) {
      proposal.businessMarkedDelivered = row[18].toInt() == 1;
      proposal.businessMarkedRewarded = row[19].toInt() == 1;
      proposal.businessGaveRating = row[20].toInt();
      proposal.businessDisputed = row[21].toInt() == 1;
      proposal.state = ProposalState.valueOf(row[22].toInt());
      proposal.businessArchived = row[23].toInt() == 1;
    } else {
      proposal.influencerMarkedDelivered = row[18].toInt() == 1;
      proposal.influencerMarkedRewarded = row[19].toInt() == 1;
      proposal.businessMarkedDelivered = row[20].toInt() == 1;
      proposal.businessMarkedRewarded = row[21].toInt() == 1;
      proposal.influencerGaveRating = row[22].toInt();
      proposal.businessGaveRating = row[23].toInt();
      proposal.influencerDisputed = row[24].toInt() == 1;
      proposal.businessDisputed = row[25].toInt() == 1;
      proposal.state = ProposalState.valueOf(row[26].toInt());
      proposal.influencerArchived = row[27].toInt() == 1;
      proposal.businessArchived = row[28].toInt() == 1;
    }

    return proposal;
  }

  static final String selectProposalsQueryInfluencer =
      SqlUtil.makeSelectQuery('proposals', selectProposalColumnsInfluencer);
  static final String selectProposalsQueryBusiness =
      SqlUtil.makeSelectQuery('proposals', selectProposalColumnsBusiness);
  static final String selectProposalsQuery =
      SqlUtil.makeSelectQuery('proposals', selectProposalColumns);
  static String getSelectProposalsQuery(AccountType receiverAccountType) {
    switch (receiverAccountType) {
      case AccountType.influencer:
        return selectProposalsQueryInfluencer;
      case AccountType.business:
        return selectProposalsQueryBusiness;
      default:
        return selectProposalsQuery;
    }
  }
}

/* end of file */
