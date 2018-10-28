/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/cards/proposal_card.dart';
import 'package:inf/styling_constants.dart';

import 'package:inf/protobuf/inf_protobuf.dart';

class ProposalList extends StatelessWidget {
  ProposalList({
    @required this.account,
    @required this.proposals,
    @required this.getProfileSummary,
    @required this.getBusinessOffer,
    @required this.onProposalPressed,
  });

  final DataAccount account;

  final Iterable<DataApplicant> proposals;

  final DataAccount Function(BuildContext context, Int64 accountId)
      getProfileSummary;
  final DataBusinessOffer Function(BuildContext context, Int64 offerId)
      getBusinessOffer;

  final Function(Int64 proposalId) onProposalPressed;

  @override
  Widget build(BuildContext context) {
    List<DataApplicant> proposalsSorted = proposals.toList();
    proposalsSorted.sort((a, b) => a.applicantId.compareTo(b.applicantId));
    if (proposalsSorted.length == 0) {
      return new Center(
        child: new Card(
          child: new Padding(
            padding: new EdgeInsets.all(16.0),
            child: new Text(
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
    return new ListView.builder(
      padding: const EdgeInsets.symmetric(
          vertical:
              kInfPaddingHalf), // kMaterialListPadding, // const EdgeInsets.only(), // kMaterialListPadding,
      itemCount: proposalsSorted.length,
      itemBuilder: (BuildContext context, int index) {
        DataApplicant proposal = proposalsSorted[index];
        Int64 partnerAccountId = new Int64(proposal.senderAccountId);
        if (partnerAccountId == new Int64(account.state.accountId)) {
          partnerAccountId = new Int64(proposal.businessAccountId);
        }
        if (partnerAccountId == new Int64(account.state.accountId)) {
          partnerAccountId = new Int64(proposal.influencerAccountId);
        }
        return new ProposalCard(
          key: Key('ProposalCard[${proposal.applicantId}]'),
          account: account,
          proposal: proposal,
          partnerProfile: getProfileSummary(context, partnerAccountId),
          businessOffer: getBusinessOffer(context, new Int64(proposal.offerId)),
          onPressed: () {
            onProposalPressed(new Int64(proposal.applicantId));
          },
        );
      },
      //itemExtent: 96.0,
    );
  }
}

/* end of file */
