import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/add_offer/add_business_offer_page.dart';
import 'package:inf/ui/main/activities_section.dart';
import 'package:inf/ui/main/bottom_nav.dart';
import 'package:inf/ui/main/browse_section.dart';
import 'package:inf/ui/main/menu_drawer.dart';
import 'package:inf/ui/main/page_mode.dart';
import 'package:inf/ui/widgets/auth_state_listener_mixin.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';

const kBottomNavHeight = 72.0;
const kMenuIconSize = 48.0;

class MainPage extends PageWidget {
  static Route<dynamic> route(AccountType userType) {
    return FadePageRoute(
      builder: (BuildContext context) => MainPage(userType: userType),
    );
  }

  const MainPage({
    Key key,
    @required this.userType,
  }) : super(key: key);

  final AccountType userType;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends PageState<MainPage> with AuthStateMixin<MainPage>, TickerProviderStateMixin {
  AnimationController _drawerController;
  Animation<Offset> _drawerSlideAnim;
  Animation<double> _drawerAnim;
  Animation<RelativeRect> _menuIconAnim;
  AnimationController _sectionController;
  Animation<double> _browseAnim;
  Animation<double> _activitiesAnim;

  MainPageMode _mode = MainPageMode.browse;
  bool _menuVisible = false;

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _drawerController = AnimationController(duration: const Duration(milliseconds: 450), vsync: this);
    // TODO: Add curves
    _drawerAnim = Tween(begin: 0.0, end: 1.0).animate(_drawerController);
    _drawerSlideAnim = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero).animate(_drawerController);
    _sectionController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    // TODO: Add curves
    _browseAnim = Tween(begin: 1.0, end: 0.0).animate(_sectionController);
    _activitiesAnim = Tween(begin: 0.0, end: 1.0).animate(_sectionController);

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _sectionController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sectionPadding = EdgeInsets.only(bottom: mediaQuery.padding.bottom + kBottomNavHeight);
    final menuWidth = mediaQuery.size.shortestSide * 0.8;

    final menuIconRect = Rect.fromLTWH(0.0, 0.0, kMenuIconSize, mediaQuery.padding.top + kMenuIconSize);
    final menuIconBegin = RelativeRect.fromSize(menuIconRect, mediaQuery.size);
    final menuIconEnd = menuIconBegin.shift(Offset(menuWidth + 16.0, 0.0));
    _menuIconAnim = RelativeRectTween(begin: menuIconBegin, end: menuIconEnd).animate(_drawerController);

    return Material(
      child: Stack(
        children: [
          RepaintBoundary(
            child: Stack(
              children: [

                /// BrowseSection
                IgnorePointer(
                  ignoring: _mode != MainPageMode.browse,
                  child: FadeTransition(
                    opacity: _browseAnim,
                    child: MainBrowseSection(
                      padding: sectionPadding,
                    ),
                  ),
                ),

                /// ActivitySection
                IgnorePointer(
                  ignoring: _mode != MainPageMode.activities,
                  child: FadeTransition(
                    opacity: _activitiesAnim,
                    child: MainActivitiesSection(
                      padding: sectionPadding,
                    ),
                  ),
                ),
                MainBottomNav(
                  height: kBottomNavHeight,
                  initialValue: _mode,
                  onBottomNavChanged: (MainPageMode value) {
                    if (value == MainPageMode.browse) {
                      _sectionController.reverse();
                    } else {
                      _sectionController.forward();
                    }

                    setState(() => _mode = value);
                  },
                  onSearchPressed: () {
                    // TODO:
                  },
                ),

                /*
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final height = constraints.maxHeight;
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(top: height),
                      child: Container(
                        color: AppTheme.darkGrey,
                        height: height * 0.5,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 96.0,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TabBar(
                                      controller: _tabController,
                                      indicatorColor: Colors.transparent,
                                      tabs: <Widget>[
                                        _buildTab(Icon(Icons.inbox)),
                                        _buildTab(Icon(Icons.message)),
                                        _buildTab(Icon(Icons.list)),
                                        _buildTab(Icon(Icons.forward)),
                                      ],
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {},
                                    child: Icon(Icons.clear),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: <Widget>[
                                  Container(
                                    color: Colors.red,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.search),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.green,
                                  ),
                                  Container(
                                    color: Colors.blue,
                                  ),
                                  Container(
                                    color: Colors.yellow,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                */
              ],
            ),
          ),

          Positioned(
            bottom: 300.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: () { Navigator.of(context).push(AddBusinessOfferPage.route(widget.userType));},
              backgroundColor: AppTheme.lightBlue,
              mini: false,
              child: Icon(Icons.add, color: Colors.white,),
            ),
          ),

          /// Main Menu Drawer
          IgnorePointer(
            ignoring: _menuVisible,
            child: AnimatedBuilder(
              animation: _drawerAnim,
              builder: (BuildContext context, Widget navigationDrawer) {
                final value = _drawerAnim.value;
                final blur = 12.0 * value;
                return BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6 * value),
                    ),
                    child: navigationDrawer,
                  ),
                );
              },
              child: RepaintBoundary(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SlideTransition(
                    position: _drawerSlideAnim,
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: menuWidth,
                      ),
                      child: MainNavigationDrawer(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          PositionedTransition(
            rect: _menuIconAnim,
            child: _MainMenuIcon(
              animation: _drawerAnim,
              onPressed: () {
                _menuVisible = !_menuVisible;
                if (_menuVisible) {
                  _drawerController.forward();
                } else {
                  _drawerController.reverse();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Tab _buildTab(Widget icon) {
    return Tab(
      child: Material(
        shape: CircleBorder(),
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: icon,
        ),
      ),
    );
  }
}

class _MainMenuIcon extends StatelessWidget {
  const _MainMenuIcon({
    Key key,
    @required this.onPressed,
    @required this.animation,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.padding.top),
      child: IconButton(
        // kMenuIconSize
        onPressed: onPressed,
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: animation,
        ),
      ),
    );
  }
}
