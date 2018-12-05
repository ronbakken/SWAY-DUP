/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inf/widgets/profile_avatar.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/styling_constants.dart';
import 'package:inf/widgets/blurred_network_image.dart';

class ProposalCard extends StatelessWidget {
  final DataAccount account;
  final DataProposal proposal;
  final DataOffer businessOffer;
  final DataAccount partnerProfile;
  //final bool inner;
  final Function() onPressed;

  const ProposalCard({
    Key key,
    @required this.account,
    @required this.proposal,
    @required this.businessOffer,
    @required this.partnerProfile,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Prefer the location name over the business name for businesses
    final String partnerName =
        (partnerProfile.accountType == AccountType.business)
            ? businessOffer.senderName
            : partnerProfile.name;
    // Prefer the offer location over the business location for businesses
    final String partnerLocation =
        (partnerProfile.accountType == AccountType.business)
            ? businessOffer.locationAddress
            : partnerProfile.location;
    final String offerName = businessOffer.title;
    // final String offerLocation = businessOffer.locationAddress;
    final Widget tile = Material(
      color: theme.cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          account.accountType == AccountType.influencer
              ? SizedBox(
                  width: 112.0, // 72.0,
                  height: 112.0,
                  child: Padding(
                    padding: const EdgeInsets.all(kInfPadding),
                    child: Material(
                      type: MaterialType.card,
                      elevation: 1.0,
                      borderRadius: kInfImageThumbnailBorder,
                      child: ClipRRect(
                        borderRadius: kInfImageThumbnailBorder,
                        child: BlurredNetworkImage(
                          url: businessOffer.thumbnailUrl,
                          blurredData: Uint8List.fromList(
                              businessOffer.thumbnailBlurred),
                          placeholderAsset: 'assets/placeholder_photo.png',
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(kInfPadding),
                  child: ProfileAvatar(
                      size: 112.0 - kInfPadding - kInfPadding,
                      account: partnerProfile,
                      tag: '/${proposal.proposalId}'),
                ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  color: theme.backgroundColor,
                  type: MaterialType.canvas,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          (account.accountType == AccountType.influencer)
                              ? kInfAvatarSmallPaddedRadius
                              : 11.0)),
                  elevation: 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: kInfPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(width: kInfPadding),
                          account.accountType == AccountType.influencer
                              ? ProfileAvatar(
                                  size: 40.0,
                                  account: partnerProfile,
                                  tag: '/${proposal.proposalId}')
                              : SizedBox(
                                  width: 40.0, // 72.0,
                                  height: 40.0,
                                  child: Material(
                                    type: MaterialType.card,
                                    elevation: 1.0,
                                    borderRadius: kInfImageThumbnailBorder,
                                    child: ClipRRect(
                                      borderRadius: kInfImageThumbnailBorder,
                                      child: BlurredNetworkImage(
                                        url: businessOffer.thumbnailUrl,
                                        blurredData: Uint8List.fromList(
                                            businessOffer.thumbnailBlurred),
                                        placeholderAsset:
                                            'assets/placeholder_photo.png',
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(width: kInfPadding),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // new Text(businessAccount.name),
                                const SizedBox(height: kInfPaddingText),
                                /*new Text(businessOffer.locationName,
                            overflow: TextOverflow.ellipsis),
                      new Text(businessOffer.location,
                            overflow: TextOverflow.ellipsis),*/
                                Text(
                                  account.accountType == AccountType.influencer
                                      ? partnerName
                                      : offerName,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.body1,
                                ),
                                const SizedBox(height: kInfPaddingText),
                                Text(
                                  account.accountType == AccountType.influencer
                                      ? partnerLocation
                                      : "", // Something else to go here. .. offerLocation,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: kInfPadding),
                        ],
                      ),
                      const SizedBox(height: kInfPadding),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: kInfPadding),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Must have .spaceBetween same as .start
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: kInfPadding),
                          Text(
                            account.accountType == AccountType.influencer
                                ? offerName
                                : partnerName,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.subhead,
                          ),
                          const SizedBox(height: kInfPaddingText),
                          // TODO: Support for fetching last chat message!
                          // TODO: Bold REJECTED / COMPLETED
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              /*new Icon(
                                Icons.photo_camera,
                                size: 16.0,
                              ),
                              new SizedBox(width: 4.0),*/
                              Flexible(
                                fit: FlexFit.loose,
                                child: Text("You: Hi! This is a proposal!",
                                    style: theme.textTheme.body1.copyWith(
                                        color: theme.textTheme.body1.color
                                            .withAlpha(192)),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: 4.0),
                              Material(
                                  type: MaterialType.card,
                                  color: theme.canvasColor,
                                  shape: const StadiumBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0),
                                    child: Text("new proposal",
                                        style: theme.textTheme.body1.copyWith(
                                            color: theme.textTheme.body1.color
                                                .withAlpha(192))),
                                  )),
                              const SizedBox(width: 4.0),
                              Text("1d", style: theme.textTheme.caption),
                            ],
                          ),
                          const SizedBox(height: kInfPadding),
                        ],
                      ),
                    ),
                    const SizedBox(width: kInfPadding),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kInfPaddingHalf),
      child: Material(
        type: MaterialType.card,
        elevation: 1.0,
        child: InkWell(
          child: tile,
          onTap: onPressed,
        ),
      ),
    );
  }
}

/* end of file */
