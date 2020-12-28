/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:sway_mobile_app/styling_constants.dart';

import 'package:sway_mobile_app/widgets/blurred_network_image.dart';
import 'package:inf_common/inf_common.dart';

class OffersShowcase extends StatefulWidget {
  const OffersShowcase({
    Key key,
    @required this.offerBuilder,
    @required this.offerIds,
  }) : super(key: key);

  final Widget Function(BuildContext context, Int64 offerId) offerBuilder;
  final List<Int64> offerIds;

  @override
  _OffersShowcaseState createState() => _OffersShowcaseState();
}

class OfferShowcaseCard extends StatelessWidget {
  final DataOffer offer;
  final Function(DataOffer offerId) onPressed;
  final Function(DataOffer offerId) onCenter;

  const OfferShowcaseCard({Key key, this.offer, this.onPressed, this.onCenter})
      : super(key: key);

  void _onPressed() {
    onPressed(offer);
  }

  void _onCenter() {
    onCenter(offer);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget image = BlurredNetworkImage(
        url: offer.thumbnailUrl,
        blurredData: Uint8List.fromList(offer.thumbnailBlurred));
    final Widget text = Text(
      offer.title.toString(),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.subhead,
    );
    final Widget sender = Text(
      offer.senderName, // account.summary?.name.toString(),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.caption,
    );
    final Card card = Card(
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
                onTap: onPressed != null ? _onPressed : null,
                onLongPress: onCenter != null ? _onCenter : null,
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
      width: 96.0,
      height: 96.0,
      child: card,
    );
  }
}

class _OffersShowcaseState extends State<OffersShowcase> {
  Widget _buildCard(BuildContext context, int offerIdx) {
    final Int64 offerId = widget.offerIds[offerIdx];
    return widget.offerBuilder(context, offerId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text('Near you now',
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
