/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';

import 'package:inf/network/build_network_image.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

class OffersShowcase extends StatefulWidget {
  const OffersShowcase({
    Key key,
    @required this.onOfferPressed,
    @required this.onOfferCenter,
    @required this.getOffer,
    @required this.offerIds,
  }) : super(key: key);

  final Function(DataBusinessOffer offer) onOfferPressed;
  final Function(DataBusinessOffer offer) onOfferCenter;
  final DataBusinessOffer Function(int offerId) getOffer;
  final List<int> offerIds;

  @override
  _OffersShowcaseState createState() => new _OffersShowcaseState();
}

class _OffersShowcaseState extends State<OffersShowcase> {
  Widget _buildCard(BuildContext context, int offerIdx) {
    ThemeData theme = Theme.of(context);
    int offerId = widget.offerIds[offerIdx];
    print("[INF] Showcase $offerId");
    DataBusinessOffer offer = widget.getOffer(offerId);
    Widget image = buildNetworkImage(
        url: offer.thumbnailUrl, blurredUrl: offer.blurredThumbnailUrl);
    Widget text = new Text(offer.title.toString(),
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.subhead);
    Card card = new Card(
      child: new Stack(
        fit: StackFit.expand, // Important
        children: <Widget>[
          new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            child: image,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(8.0),
                child:
                    text, /*new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: text,
                ),*/
              )
            ],
          ),
          new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            child: new Material(
              color: Colors.transparent,
              child: new InkWell(
                onTap: () {
                  widget.onOfferPressed(offer);
                },
                onLongPress: () {
                  widget.onOfferCenter(offer);
                },
              ),
            ),
          ),
        ],
      ),
    );
    /*return new AspectRatio(
      key: new Key('OfferShowcase[$offerId]'),
      aspectRatio: 1.0,
      child: card,
    );*/
    return new SizedBox(
      key: new Key('OfferShowcase[$offerId]'),
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
    return new Row(
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: new Text("Near you now",
                  textAlign: TextAlign.left, style: theme.textTheme.caption),
            ),
            new SizedBox(
              height: 132.0,
              width: MediaQuery.of(context).size.width,
              // width: MediaQueryData.fromWindow(window),
              child: new ListView.builder(
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.offerIds.length,
                itemBuilder: _buildCard,
                itemExtent: 132.0,
                padding: new EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
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
