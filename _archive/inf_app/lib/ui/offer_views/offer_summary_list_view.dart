import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/filter/bottom_nav.dart';
import 'package:inf/ui/main/empty_tab.dart';
import 'package:inf/ui/offer_add/add_business_offer_page.dart';
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
        if (snapshot.connectionState != ConnectionState.active) {
          return loadingWidget;
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Sorry!, ${snapshot.error}'),
          );
        } else {
          final offers = snapshot.data;
          if (offers == null || offers.isEmpty) {
            final currentUser = backend<UserManager>().currentUser;
            return EmptyTab(
              contentText: 'Hey ${currentUser.name}, it looks like you have not created any offers…\n\nLet’s get started!',
              ctaText: 'CREATE AN OFFER',
              onCtaPressed: () {
                Navigator.of(context).push(AddBusinessOfferPage.route(currentUser.userType));
              },
            );
          } else {
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
          }
        }
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
