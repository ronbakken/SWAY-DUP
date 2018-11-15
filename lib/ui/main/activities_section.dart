import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/browse_list_tile.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/offers/offer_details_page.dart';

class MainActivitiesSection extends StatefulWidget {
  const MainActivitiesSection({
    Key key,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;

  @override
  _MainActivitiesSectionState createState() => _MainActivitiesSectionState();
}

class _MainActivitiesSectionState extends State<MainActivitiesSection> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  static const double kTabBarBottomPadding = 16;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.padding.top, bottom: widget.padding.bottom),
      child: Container(
        color: AppTheme.darkGrey,
        child: Column(
          children: [
            SizedBox(
              height: kMenuIconSize + kTabBarBottomPadding,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: TabBar(
                  indicatorWeight: 4.0,
                  indicatorColor: AppTheme.tabIndicator,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  isScrollable: false,
                  controller: controller,
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: kTabBarBottomPadding),
                      child: Text('APPLIED'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: kTabBarBottomPadding),
                      child: Text('DEALS'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: kTabBarBottomPadding),
                      child: Text('DONE'),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: AppTheme.listViewBackground,
                child: TabBarView(
                  controller: controller,
                  children: [
                    _ActivitiesListView(name: 'offers-applied',),
                    _ActivitiesListView(name: 'offers-with-deal'),
                    _ActivitiesListView(name: 'offers-done'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivitiesListView extends StatefulWidget {

  final String name;

  const _ActivitiesListView({
    @required this.name,
    Key key,
  }) : super(key: key);

  @override
  _ActivitiesListViewState createState() => _ActivitiesListViewState();
}

class _ActivitiesListViewState extends State<_ActivitiesListView> {
  Stream<List<BusinessOffer>> dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = backend.get<OfferManager>().getBusinessOffers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BusinessOffer>>(
        stream: dataSource,
        builder: (BuildContext context, AsyncSnapshot<List<BusinessOffer>> snapShot) {
          if (snapShot.connectionState == ConnectionState.active) {
            // TODO
            return Center(child: Text('Here has to be an waiting spinner'));
          }
          if (!snapShot.hasData) {
            // TODO
            return Center(child: Text('Here has to be an Error message'));
          }
          final offers = snapShot.data;
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16.0, 8, 16.0, 0.0),
            itemCount: offers.length,
            itemBuilder: (BuildContext context, int index) {
              final offer = offers[index];
              final tag = '${widget.name}-${offer.offerId}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: BrowseListTile(
                  backGroundColor: AppTheme.listViewItemBackground,
                  offer: offer,
                  onPressed: () => Navigator.of(context).push(OfferDetailsPage.route(offer, tag)),
                  tag: tag,
                ),
              );
            },
          );
        });
  }
}
