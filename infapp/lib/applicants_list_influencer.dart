/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:inf/cards/applicant_card_influencer.dart';
import 'package:inf/styling_constants.dart';

import 'protobuf/inf_protobuf.dart';

class ApplicantsListInfluencer extends StatelessWidget {
  ApplicantsListInfluencer({
    @required this.applicants,
    @required this.getAccount,
    @required this.getBusinessOffer,
    @required this.onApplicantPressed,
  });

  final Iterable<DataApplicant> applicants;

  final DataAccount Function(BuildContext context, int accountId) getAccount;
  final DataBusinessOffer Function(BuildContext context, int offerId)
      getBusinessOffer;

  final Function(DataApplicant applicant) onApplicantPressed;

  @override
  Widget build(BuildContext context) {
    List<DataApplicant> applicantsSorted = applicants.toList();
    applicantsSorted.sort((a, b) => a.applicantId.compareTo(b.applicantId));
    if (applicantsSorted.length == 0) {
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
      padding: const EdgeInsets.symmetric(vertical: kInfPaddingHalf), // kMaterialListPadding, // const EdgeInsets.only(), // kMaterialListPadding,
      itemCount: applicantsSorted.length,
      itemBuilder: (BuildContext context, int index) {
        DataApplicant applicant = applicantsSorted[index];
        return new ApplicantCardInfluencer(
          key: Key('ApplicantCard[${applicant.applicantId}]'),
          applicant: applicant,
          businessAccount: getAccount(context, applicant.businessAccountId),
          businessOffer: getBusinessOffer(context, applicant.offerId),
          onPressed: () {
            onApplicantPressed(applicant);
          },
        );
      },
      //itemExtent: 96.0,
    );
  }
}

/* end of file */
