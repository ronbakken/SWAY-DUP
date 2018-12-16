import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/main/offer_list_tile.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/offers/offer_details_page.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf_common/inf_common.dart';

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

class _MainActivitiesSectionState extends State<MainActivitiesSection>
    with SingleTickerProviderStateMixin {
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
      padding: EdgeInsets.only(
          top: mediaQuery.padding.top, bottom: widget.padding.bottom),
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
                  indicatorPadding:
                      const EdgeInsets.only(left: 10.0, right: 10.0),
                  isScrollable: false,
                  controller: controller,
                  tabs: [
                    _TabBarItem(
                        text: 'APPLIED',
                        bottomPadding: kTabBarBottomPadding,
                        notifications:
                            0 // backend.get<OfferManager>().newAppliedOfferMessages,
                        ),
                    _TabBarItem(
                        text: 'DEALS',
                        bottomPadding: kTabBarBottomPadding,
                        notifications:
                            0 // backend.get<OfferManager>().newDealsOfferMessages,
                        ),
                    _TabBarItem(
                        text: 'DONE',
                        bottomPadding: kTabBarBottomPadding,
                        notifications:
                            0 // backend.get<OfferManager>().newDoneOfferMessages,
                        ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: AppTheme.listViewAndMenuBackground,
                child: TabBarView(
                  controller: controller,
                  children: [
                    _ActivitiesListView(
                      name: 'offers-applied',
                    ),
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

class _TabBarItem extends StatelessWidget {
  const _TabBarItem({
    Key key,
    @required this.text,
    @required this.bottomPadding,
    @required this.notifications,
  }) : super(key: key);

  final double bottomPadding;
  final String text;
  final int notifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(text),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            child: notifications != 0
                ? const NotificationMarker()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _ActivitiesListView extends StatefulWidget {
  final String name;
  final List<Int64> offers;
  final DataOffer Function(BuildContext cibtext, Int64 offerId) getOffer;
  final ConfigData config;

  final void Function(Int64 offerId) onOfferPressed;

  const _ActivitiesListView({
    @required this.name,
    Key key,
    @required this.offers,
    @required this.getOffer,
    @required this.config,
    @required this.onOfferPressed,
  }) : super(key: key);

  @override
  _ActivitiesListViewState createState() => _ActivitiesListViewState();
}

class _ActivitiesListViewState extends State<_ActivitiesListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _tileBuilder(BuildContext context, int index) {
    final Int64 offerId = widget.offers[index];
    final DataOffer offer = widget.getOffer(context, offerId);
    final String tag = '${widget.name}-${offer.offerId}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: OfferListTile(
        key: Key(tag),
        config: widget.config,
        backGroundColor: AppTheme.listViewItemBackground,
        offer: offer,
        onPressed: widget.onOfferPressed == null
            ? null
            : () {
                widget.onOfferPressed(offerId);
              },
        heroTag: tag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.0, 8, 16.0, 0.0),
      itemCount: widget.offers.length,
      itemBuilder: _tileBuilder,
    );
  }
}
