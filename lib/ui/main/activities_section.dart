import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/filter/bottom_nav.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/offer_views/offer_short_summary_tile.dart';
import 'package:inf/ui/proposal_views/proposal_list_view.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf/utils/stream_from_value_and_future.dart';
import 'package:pedantic/pedantic.dart';

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
    controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  static const double kTabIndicatorWeight = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final proposalManager = backend.get<ProposalManager>();
    return Column(
      children: [
        Container(
          color: AppTheme.menuUserNameBackground,
          padding: EdgeInsets.only(top: mediaQuery.padding.top),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: kMenuIconSize,
                alignment: Alignment.center,
                child: Text('ACTIVITIES', style: theme.textTheme.title),
              ),
              Container(
                height: kTextTabBarHeight,
                child: CustomPaint(
                  painter: _TabBarBackground(
                    inactiveIndicatorColor: AppTheme.tabIndicatorInactive,
                    indicatorWeight: kTabIndicatorWeight,
                    spacing: 1.0,
                    tabCount: controller.length,
                  ),
                  child: TabBar(
                    indicatorWeight: kTabIndicatorWeight,
                    indicatorColor: AppTheme.tabIndicator,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 0.5),
                    labelPadding: EdgeInsets.zero,
                    isScrollable: false,
                    controller: controller,
                    tabs: [
                      _TabBarItem(text: 'MY OFFERS'),
                      _TabBarItem(text: 'APPLIED'),
                      _TabBarItem(text: 'DEALS'),
                      _TabBarItem(text: 'DONE'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppTheme.listViewAndMenuBackground,
            child: TabBarView(
              controller: controller,
              children: [
                OfferSummeryListView(name: 'offers-applied'),
                ProposalListView(dataSource: proposalManager.appliedProposals),
                ProposalListView(dataSource: proposalManager.activeDeals),
                ProposalListView(dataSource: proposalManager.doneProposals),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabBarBackground extends CustomPainter {
  _TabBarBackground({
    @required Color inactiveIndicatorColor,
    this.indicatorWeight,
    this.spacing = 0.0,
    this.tabCount = 1,
  }) {
    _paint.color = inactiveIndicatorColor;
    _paint.strokeWidth = indicatorWeight;
  }

  final _paint = Paint();
  final double indicatorWeight;
  final double spacing;
  final int tabCount;

  @override
  void paint(Canvas canvas, Size size) {
    final bottom = size.height - (indicatorWeight / 2);
    final width = (size.width - (tabCount * spacing)) / tabCount;
    for (int i = 0; i < tabCount; i++) {
      final left = (spacing / 2) + (width + spacing) * i;
      final right = left + width;
      canvas.drawLine(Offset(left, bottom), Offset(right, bottom), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _TabBarItem extends StatefulWidget {
  const _TabBarItem({
    Key key,
    @required this.text,
    this.notifications,
  }) : super(key: key);

  final String text;
  final Stream<int> notifications;

  @override
  _TabBarItemState createState() => _TabBarItemState();
}

class _TabBarItemState extends State<_TabBarItem> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: nonNullChildren(<Widget>[
              StreamBuilder<int>(
                initialData: 0,
                stream: widget.notifications,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return AnimatedSize(
                    vsync: this,
                    duration: const Duration(milliseconds: 350),
                    alignment: Alignment.centerLeft,
                    child: ifWidget(!snapshot.hasData || snapshot.data == 0,
                        then: SizedBox(height: 12.0),
                        orElse: NotificationMarker(
                          margin: const EdgeInsets.only(top: 2.5, right: 5.0),
                        )),
                  );
                },
              ),
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class OfferSummeryListView extends StatefulWidget {
  final String name;

  const OfferSummeryListView({
    @required this.name,
    Key key,
  }) : super(key: key);

  @override
  _OfferSummeryListViewState createState() => _OfferSummeryListViewState();
}

class _OfferSummeryListViewState extends State<OfferSummeryListView> {
  Stream<List<InfItem>> dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = backend.get<ListManager>().userCreatedItems;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return StreamBuilder<List<InfItem>>(
        stream: dataSource,
        builder: (BuildContext context, AsyncSnapshot<List<InfItem>> snapShot) {
          if (!snapShot.hasData) {
            // TODO
            return Center(child: Text('Here has to be an Error message'));
          }
          final items = snapShot.data;
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, mediaQuery.padding.bottom + kBottomNavHeight),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              assert(items[index].type ==InfItemType.offer);
              final offer = items[index].offer;
              final tag = '${widget.name}-${offer.id}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: OfferShortSummaryTile(
                  backGroundColor: AppTheme.listViewItemBackground,
                  offer: offer,
                  onPressed: () => _onShowDetails(context, offer, tag),
                  tag: tag,
                ),
              );
            },
          );
        });
  }

  void _onShowDetails(BuildContext context, BusinessOffer partialOffer, String tag) async {
    try {
      unawaited(
        Navigator.of(context).push(
          OfferDetailsPage.route(
            streamFromValueAndFuture<BusinessOffer>(
                partialOffer, backend.get<OfferManager>().getFullOffer(partialOffer)),
            tag,
          ),
        ),
      );
    } catch (ex) {
      // TODO should this be done centralized?
      await showMessageDialog(context, 'Connection Problem', 'Sorry we cannot retrievd the Offer you want to view');
    }
  }
}
