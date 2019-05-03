import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/messaging/conversation_list_view.dart';
import 'package:inf/ui/offer_views/offer_summary_list_view.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

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
  List<Widget> _tabs;
  List<Widget> _tabViews;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    final userManager = backend<UserManager>();
    if (userManager.currentUser.userType == UserType.business) {
      _tabs = const <Widget>[
        _TabBarItem(text: 'MY OFFERS'),
        _TabBarItem(text: 'CONVERSATIONS'),
      ];
      _tabViews = [
        const OfferSummaryListView(),
        const ConversationListView(),
      ];
    } else {
      _tabs = const <Widget>[
        _TabBarItem(text: 'CONVERSATIONS'),
      ];
      _tabViews = [
        const ConversationListView(),
      ];
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const double kTabIndicatorWeight = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
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
                    tabCount: _tabController.length,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorWeight: kTabIndicatorWeight,
                    indicatorColor: AppTheme.tabIndicator,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 0.5),
                    labelPadding: EdgeInsets.zero,
                    isScrollable: false,
                    tabs: _tabs,
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
              controller: _tabController,
              children: _tabViews,
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
                    child: ifWidget(
                      !snapshot.hasData || snapshot.data == 0,
                      then: verticalMargin12,
                      orElse: NotificationMarker(
                        margin: const EdgeInsets.only(top: 2.5, right: 5.0),
                      ),
                    ),
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
