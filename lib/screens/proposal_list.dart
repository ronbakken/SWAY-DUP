/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/cards/proposal_card.dart';
import 'package:inf/styling_constants.dart';

import 'package:inf_common/inf_common.dart';

class ProposalList extends StatelessWidget {
  ProposalList({
    @required this.account,
    @required this.proposals,
    @required this.getProfileSummary,
    @required this.getOffer,
    @required this.onProposalPressed,
  });

  final DataAccount account;

  final Iterable<DataProposal> proposals;

  final DataAccount Function(BuildContext context, Int64 accountId)
      getProfileSummary;
  final DataOffer Function(BuildContext context, Int64 offerId) getOffer;

  final Function(Int64 proposalId) onProposalPressed;

  @override
  Widget build(BuildContext context) {
    List<DataProposal> proposalsSorted = proposals.toList();
    proposalsSorted.sort((a, b) => a.proposalId.compareTo(b.proposalId));
    if (proposalsSorted.length == 0) {
      return Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Nothing here",
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          vertical:
              kInfPaddingHalf), // kMaterialListPadding, // const EdgeInsets.only(), // kMaterialListPadding,
      itemCount: proposalsSorted.length,
      itemBuilder: (BuildContext context, int index) {
        DataProposal proposal = proposalsSorted[index];
        Int64 partnerAccountId = proposal.senderAccountId;
        if (partnerAccountId == account.accountId) {
          partnerAccountId = proposal.businessAccountId;
        }
        if (partnerAccountId == account.accountId) {
          partnerAccountId = proposal.influencerAccountId;
        }
        return ProposalCard(
          key: Key('ProposalCard[${proposal.proposalId}]'),
          account: account,
          proposal: proposal,
          partnerProfile: getProfileSummary(context, partnerAccountId),
          businessOffer: getOffer(context, proposal.offerId),
          onPressed: () {
            onProposalPressed(proposal.proposalId);
          },
        );
      },
      //itemExtent: 96.0,
    );
  }
}

/* end of file */
