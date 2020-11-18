import 'dart:ui' as ui;

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/ui/offer_views/browse_carousel_item.dart';
import 'package:inf/ui/offer_views/offer_post_tile.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_toggle.dart';
import 'package:inf_common/inf_common.dart';

class BrowseCarouselView extends StatefulWidget {
  const BrowseCarouselView({
    Key key,
    @required this.config,
    @required this.offers,
    @required this.getOffer,
    @required this.onOfferPressed,
  }) : super(key: key);

  final ConfigData config;
  final List<Int64> offers;
  final DataOffer Function(BuildContext context, Int64 offerId) getOffer;
  final void Function(Int64 offerId) onOfferPressed;

  @override
  _BrowseCarouselViewState createState() => _BrowseCarouselViewState();
}

class _BrowseCarouselViewState extends State<BrowseCarouselView> {
  final _controller =
      PageController(viewportFraction: 1.0 / 2.5); // TODO: work out dimensions

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          assert(constraints.hasBoundedHeight);
          return Container(
            margin: EdgeInsets.only(bottom: 32.0),
            height: constraints.maxHeight / 5.0,
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              scrollDirection: Axis.horizontal,
              controller: _controller,
              physics: const PageScrollPhysics(),
              itemCount: widget.offers.length,
              itemBuilder: (BuildContext context, int index) {
                final Int64 offerId = widget.offers[index];
                final DataOffer offer = widget.getOffer(context, offerId);
                final String heroTag = 'browse-offer-carousel-$offerId';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: AspectRatio(
                    aspectRatio: 5.0 / 4.3,
                    child: BrowseCarouselItem(
                      offer: offer,
                      onPressed: () {
                        widget.onOfferPressed(offerId);
                      },
                      heroTag: heroTag,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
