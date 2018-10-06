/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:inf/network/build_network_image.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

class ApplicantCardInfluencer extends StatelessWidget {
  final DataApplicant applicant;
  final DataBusinessOffer businessOffer;
  final DataAccount businessAccount;
  final bool inner;
  final Function() onPressed;

  ApplicantCardInfluencer({
    Key key,
    this.applicant,
    this.businessOffer,
    this.businessAccount,
    this.onPressed,
    this.inner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = new ListTile(
      isThreeLine: true,
      leading: new CircleAvatar(
        child: new ClipOval(
          child: buildNetworkImage(
            url: businessOffer.thumbnailUrl,
            blurredUrl: businessOffer.blurredThumbnailUrl,
            placeholderAsset: 'assets/placeholder_photo.png',
          ),
        ),
        backgroundColor: Colors
            .primaries[businessOffer.title.hashCode % Colors.primaries.length]
            .shade300,
      ),
      title: new Text(businessAccount.summary.name),
      subtitle: new Text(businessOffer.title),
      onTap: onPressed,
    );
    return inner
        ? child
        : new Card(
            child: child,
          );
  }
}

/* end of file */
