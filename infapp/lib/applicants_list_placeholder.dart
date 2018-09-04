/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

import 'network/inf.pb.dart';

class ApplicantsListPlaceholder extends StatelessWidget {
  final Iterable<DataApplicant> applicants;

  final Function(DataApplicant applicant) onApplicantPressed;

  ApplicantsListPlaceholder({
    @required this.applicants,
    @required this.onApplicantPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Improve sorting by latest change?
    List<DataApplicant> applicantsSorted = applicants.toList();
    applicantsSorted.sort((a, b) => a.applicantId.compareTo(b.applicantId));
    return new ListView.builder(
      padding: kMaterialListPadding,
      itemCount: applicantsSorted.length,
      itemBuilder: (BuildContext context, int index) {
        return new RaisedButton(
          child: new Text(applicantsSorted[index].applicantId.toString()),
          onPressed: () {
            onApplicantPressed(applicantsSorted[index]);
          }
        );
      },
    );
  }
}

/* end of file */
