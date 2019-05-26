import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/filter/bottom_nav.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/offer_views/offer_short_summary_tile.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class OfferSummaryListView extends StatefulWidget {
  const OfferSummaryListView({
    Key key,
  }) : super(key: key);

  @override
  _OfferSummaryListViewState createState() => _OfferSummaryListViewState();
}

class _OfferSummaryListViewState extends State<OfferSummaryListView> {
  Stream<List<BusinessOffer>> dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = backend<OfferManager>().myOffers;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return StreamBuilder<List<BusinessOffer>>(
      stream: dataSource,
      builder: (BuildContext context, AsyncSnapshot<List<BusinessOffer>> snapshot) {
        if (snapshot.hasError) {
          // TODO
          return const Center(child: Text('Here has to be an Error message'));
        } else if (!snapshot.hasData) {
          return emptyWidget;
        }
        final offers = snapshot.data;
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, mediaQuery.padding.bottom + kBottomNavHeight),
          itemCount: offers.length,
          itemBuilder: (BuildContext context, int index) {
            final offer = offers[index];
            final tag = 'offers-list-${offer.id}';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: OfferShortSummaryTile(
                offer: offer,
                tag: tag,
                onPressed: () => _onShowDetails(offer, tag),
              ),
            );
          },
        );
      },
    );
  }

  void _onShowDetails(BusinessOffer partialOffer, String tag) {
    Navigator.of(context).push(
      OfferDetailsPage.route(
        Stream.fromFuture(backend.get<OfferManager>().getFullOffer(partialOffer.id)),
        initialOffer: partialOffer,
        tag: tag,
      ),
    );
  }
}
