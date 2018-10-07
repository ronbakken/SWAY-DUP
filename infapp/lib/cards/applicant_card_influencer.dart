/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:inf/profile/profile_avatar.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/widgets/blurred_network_image.dart';

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
    ThemeData theme = Theme.of(context);
    /*Widget child = new ListTile(
      isThreeLine: true,
      leading: new CircleAvatar(
        child: new ClipOval(
          child: new BlurredNetworkImage(
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
          );*/
    /*Widget tile = new ListTile(
      isThreeLine: true,
      leading: new CircleAvatar(
        child: new ClipOval(
          child: new BlurredNetworkImage(
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
    );*/
    Widget tile = new Material(
      color: theme.cardColor,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            width: 112.0, // 72.0,
            height: 112.0,
            child: new BlurredNetworkImage(
              url: businessOffer.thumbnailUrl,
              blurredUrl: businessOffer.blurredThumbnailUrl,
              placeholderAsset: 'assets/placeholder_photo.png',
            ),
          ),
          new Flexible(
            fit: FlexFit.loose,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Material(
                  color: theme.backgroundColor,
                  elevation: 1.0,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new SizedBox(height: 8.0),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(width: 8.0),
                          new ProfileAvatar(
                              size: 40.0,
                              account: businessAccount,
                              tag: '${businessOffer.offerId}'),
                          new SizedBox(width: 8.0),
                          new Flexible(
                            fit: FlexFit.loose,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // new Text(businessAccount.summary.name),
                                new SizedBox(height: 4.0),
                                /*new Text(businessOffer.locationName,
                            overflow: TextOverflow.ellipsis),
                      new Text(businessOffer.location,
                            overflow: TextOverflow.ellipsis),*/
                                new Text(
                                  businessOffer.locationName,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.body1,
                                ),
                                new SizedBox(height: 4.0),
                                new Text(
                                  businessOffer.location,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          new SizedBox(width: 8.0),
                        ],
                      ),
                      new SizedBox(height: 8.0),
                    ],
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SizedBox(width: 8.0),
                    new Flexible(
                      fit: FlexFit.loose,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Must have .spaceBetween same as .start
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new SizedBox(height: 8.0),
                          new Text(
                            businessOffer.title,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.subhead,
                          ),
                          new SizedBox(height: 4.0),
                          // TODO: Support for fetching last chat message!
                          /*
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              / *new Icon(
                                Icons.photo_camera,
                                size: 16.0,
                              ),
                              new SizedBox(width: 4.0),* /
                              new Flexible(
                                fit: FlexFit.loose,
                                child: new Text("Hi! This is a proposal!",
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
                          */
                          new SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                    new SizedBox(width: 8.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return inner
        ? tile
        : /*new Card(
            child: new ClipRRect(
              borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
              child: new InkWell(
                child: tile,
                onTap: onPressed,
              ),
            ),
          )*/
        new Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Material(
              type: MaterialType.card,
              elevation: 2.0,
              child: new InkWell(
                child: tile,
                onTap: onPressed,
              ),
            ),
          );
  }
}

/* end of file */
