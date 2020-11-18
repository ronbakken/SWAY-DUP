import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/ui/main/offer_list_tile.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf_common/inf_common.dart';

class MainActivitiesSection extends StatefulWidget {
  const MainActivitiesSection({
    Key key,
    this.accountType,
    this.offersBuilder,
    this.directBuilder,
    this.appliedBuilder,
    this.dealsBuilder,
  }) : super(key: key);

  final AccountType accountType;

  final Widget Function(BuildContext context) offersBuilder;
  final Widget Function(BuildContext context) directBuilder;
  final Widget Function(BuildContext context) appliedBuilder;
  final Widget Function(BuildContext context) dealsBuilder;

  @override
  _MainActivitiesSectionState createState() => _MainActivitiesSectionState();
}

class _MainActivitiesSectionState extends State<MainActivitiesSection>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 4, vsync: this);
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
      padding: EdgeInsets.only(top: mediaQuery.padding.top),
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
                  tabs: <Widget>[
                    _TabBarItem(
                        text: widget.accountType == AccountType.influencer
                            ? 'MY SOLICITATIONS'
                            : 'MY OFFERS',
                        bottomPadding: kTabBarBottomPadding,
                        notifications:
                            0 // backend.get<OfferManager>().newAppliedOfferMessages,
                        ),
                    _TabBarItem(
                        text: 'DIRECT',
                        bottomPadding: kTabBarBottomPadding,
                        notifications:
                            0 // backend.get<OfferManager>().newAppliedOfferMessages,
                        ),
                    _TabBarItem(
                        text: widget.accountType == AccountType.influencer
                            ? 'APPLIED'
                            : 'APPLICANTS',
                        bottomPadding: kTabBarBottomPadding,
                        notifications:
                            0 // backend.get<OfferManager>().newDealsOfferMessages,
                        ),
                    _TabBarItem(
                        text: 'DEALS',
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
                  children: <Widget>[
                    Builder(builder: widget.offersBuilder),
                    Builder(builder: widget.directBuilder),
                    Builder(builder: widget.appliedBuilder),
                    Builder(builder: widget.dealsBuilder),
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
            padding: const EdgeInsets
                .only(), // const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
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
