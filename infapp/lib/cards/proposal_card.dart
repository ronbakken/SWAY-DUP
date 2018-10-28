/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:inf/widgets/profile_avatar.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/styling_constants.dart';
import 'package:inf/widgets/blurred_network_image.dart';

class ProposalCard extends StatelessWidget {
  final DataAccount account;
  final DataApplicant proposal;
  final DataBusinessOffer businessOffer;
  final DataAccount partnerProfile;
  //final bool inner;
  final Function() onPressed;

  ProposalCard({
    Key key,
    @required this.account,
    @required this.proposal,
    @required this.businessOffer,
    @required this.partnerProfile,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Prefer the location name over the business name for businesses
    String partnerName =
        (partnerProfile.state.accountType == AccountType.AT_BUSINESS)
            ? businessOffer.locationName
            : partnerProfile.summary.name;
    // Prefer the offer location over the business location for businesses
    String partnerLocation =
        (partnerProfile.state.accountType == AccountType.AT_BUSINESS)
            ? businessOffer.location
            : partnerProfile.summary.location;
    String offerName = businessOffer.title;
    String offerLocation = businessOffer.location;
    Widget tile = new Material(
      color: theme.cardColor,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          account.state.accountType == AccountType.AT_INFLUENCER
              ? new SizedBox(
                  width: 112.0, // 72.0,
                  height: 112.0,
                  child: new Padding(
                    padding: const EdgeInsets.all(kInfPadding),
                    child: new Material(
                      type: MaterialType.card,
                      elevation: 1.0,
                      borderRadius: kInfImageThumbnailBorder,
                      child: new ClipRRect(
                        borderRadius: kInfImageThumbnailBorder,
                        child: new BlurredNetworkImage(
                          url: businessOffer.thumbnailUrl,
                          blurredUrl: businessOffer.blurredThumbnailUrl,
                          placeholderAsset: 'assets/placeholder_photo.png',
                        ),
                      ),
                    ),
                  ),
                )
              : new Padding(
                  padding: const EdgeInsets.all(kInfPadding),
                  child: new ProfileAvatar(
                      size: 112.0 - kInfPadding - kInfPadding,
                      account: partnerProfile,
                      tag: '/${proposal.applicantId}'),
                ),
          new Flexible(
            fit: FlexFit.loose,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Material(
                  color: theme.backgroundColor,
                  type: MaterialType.canvas,
                  borderRadius: BorderRadius.only(
                      bottomLeft: new Radius.circular(
                          (account.state.accountType ==
                                  AccountType.AT_INFLUENCER)
                              ? kInfAvatarSmallPaddedRadius
                              : 11.0)),
                  elevation: 1.0,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new SizedBox(height: kInfPadding),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(width: kInfPadding),
                          account.state.accountType == AccountType.AT_INFLUENCER
                              ? new ProfileAvatar(
                                  size: 40.0,
                                  account: partnerProfile,
                                  tag: '/${proposal.applicantId}')
                              : new SizedBox(
                                  width: 40.0, // 72.0,
                                  height: 40.0,
                                  child: new Material(
                                    type: MaterialType.card,
                                    elevation: 1.0,
                                    borderRadius: kInfImageThumbnailBorder,
                                    child: new ClipRRect(
                                      borderRadius: kInfImageThumbnailBorder,
                                      child: new BlurredNetworkImage(
                                        url: businessOffer.thumbnailUrl,
                                        blurredUrl:
                                            businessOffer.blurredThumbnailUrl,
                                        placeholderAsset:
                                            'assets/placeholder_photo.png',
                                      ),
                                    ),
                                  ),
                                ),
                          new SizedBox(width: kInfPadding),
                          new Flexible(
                            fit: FlexFit.loose,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // new Text(businessAccount.summary.name),
                                new SizedBox(height: kInfPaddingText),
                                /*new Text(businessOffer.locationName,
                            overflow: TextOverflow.ellipsis),
                      new Text(businessOffer.location,
                            overflow: TextOverflow.ellipsis),*/
                                new Text(
                                  account.state.accountType ==
                                          AccountType.AT_INFLUENCER
                                      ? partnerName
                                      : offerName,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.body1,
                                ),
                                new SizedBox(height: kInfPaddingText),
                                new Text(
                                  account.state.accountType ==
                                          AccountType.AT_INFLUENCER
                                      ? partnerLocation
                                      : "", // Something else to go here. .. offerLocation,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          new SizedBox(width: kInfPadding),
                        ],
                      ),
                      new SizedBox(height: kInfPadding),
                    ],
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SizedBox(width: kInfPadding),
                    new Flexible(
                      fit: FlexFit.loose,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Must have .spaceBetween same as .start
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(height: kInfPadding),
                          new Text(
                            account.state.accountType ==
                                    AccountType.AT_INFLUENCER
                                ? offerName
                                : partnerName,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.subhead,
                          ),
                          new SizedBox(height: kInfPaddingText),
                          // TODO: Support for fetching last chat message!
                          // TODO: Bold REJECTED / COMPLETED
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              /*new Icon(
                                Icons.photo_camera,
                                size: 16.0,
                              ),
                              new SizedBox(width: 4.0),*/
                              new Flexible(
                                fit: FlexFit.loose,
                                child: new Text("You: Hi! This is a proposal!",
                                    style: theme.textTheme.body1.copyWith(
                                        color: theme.textTheme.body1.color
                                            .withAlpha(192)),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              new SizedBox(width: 4.0),
                              new Material(
                                  type: MaterialType.card,
                                  color: theme.canvasColor,
                                  shape: new StadiumBorder(),
                                  child: new Padding(
                                    padding: new EdgeInsets.symmetric(
                                        horizontal: 6.0),
                                    child: new Text("new proposal",
                                        style: theme.textTheme.body1.copyWith(
                                            color: theme.textTheme.body1.color
                                                .withAlpha(192))),
                                  )),
                              new SizedBox(width: 4.0),
                              new Text("1d", style: theme.textTheme.caption),
                            ],
                          ),
                          new SizedBox(height: kInfPadding),
                        ],
                      ),
                    ),
                    new SizedBox(width: kInfPadding),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: kInfPaddingHalf),
      child: Material(
        type: MaterialType.card,
        elevation: 1.0,
        child: new InkWell(
          child: tile,
          onTap: onPressed,
        ),
      ),
    );
  }
}

/* end of file */
