/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inf/styling_constants.dart';

import 'package:inf/widgets/blurred_network_image.dart';
import 'package:inf_common/inf_common.dart';

class OffersShowcase extends StatefulWidget {
  const OffersShowcase({
    Key key,
    @required this.onOfferPressed,
    @required this.onOfferCenter,
    @required this.getOffer,
    @required this.getAccount,
    @required this.offerIds,
  }) : super(key: key);

  final Function(DataOffer offer) onOfferPressed;
  final Function(DataOffer offer) onOfferCenter;
  final DataOffer Function(BuildContext context, int offerId) getOffer;
  final DataAccount Function(BuildContext context, int accountId) getAccount;
  final List<int> offerIds;

  @override
  _OffersShowcaseState createState() => _OffersShowcaseState();
}

class _OffersShowcaseState extends State<OffersShowcase> {
  Widget _buildCard(BuildContext context, int offerIdx) {
    ThemeData theme = Theme.of(context);
    int offerId = widget.offerIds[offerIdx];
    // print("[INF] Showcase $offerId");
    DataOffer offer = widget.getOffer(context, offerId);
    /*DataAccount account = offer.accountId != 0
        ? widget.getAccount(context, offer.accountId)
        : new DataAccount();*/
    Widget image = BlurredNetworkImage(
        url: offer.thumbnailUrl,
        blurredData: Uint8List.fromList(offer.thumbnailBlurred));
    Widget text = Text(
      offer.title.toString(),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.subhead,
    );
    Widget sender = Text(
      offer.senderName, // account.summary?.name.toString(),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.caption,
    );
    Card card = Card(
      shape:
          const RoundedRectangleBorder(borderRadius: kInfImageThumbnailBorder),
      child: ClipRRect(
        borderRadius: kInfImageThumbnailBorder,
        child: Stack(
          fit: StackFit.expand, // Important
          children: <Widget>[
            image,
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 3.0 / 1.0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[
                              Colors.black45,
                              Colors.transparent
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text,
                  sender,
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onOfferPressed(offer);
                },
                onLongPress: () {
                  widget.onOfferCenter(offer);
                },
              ),
            ),
          ],
        ),
      ),
    );
    /*return new AspectRatio(
      key: new Key('OfferShowcase[$offerId]'),
      aspectRatio: 1.0,
      child: card,
    );*/
    return SizedBox(
      key: Key('OfferShowcase[$offerId]'),
      width: 96.0,
      height: 96.0,
      child:
          card, /*new InkWell(
        onTap: widget.onOfferPressed(offer),
        child: card,
      ),*/
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text("Near you now",
                  textAlign: TextAlign.left, style: theme.textTheme.caption),
            ),
            SizedBox(
              height: 132.0,
              width: MediaQuery.of(context).size.width,
              // width: MediaQueryData.fromWindow(window),
              child: ListView.builder(
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.offerIds.length,
                itemBuilder: _buildCard,
                itemExtent: 132.0,
                padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
              ),
            ),
          ],
        ),
      ],
    );
    /*return */
  }
}

/* end of file */
