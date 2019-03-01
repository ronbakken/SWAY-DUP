import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/filter/bottom_nav.dart';

import 'package:inf/ui/main/activities_section.dart';
import 'package:inf/ui/main/browse_section.dart';
import 'package:inf/ui/main/menu_drawer.dart';
import 'package:inf/ui/main/page_mode.dart';
import 'package:inf/ui/widgets/inf_loader.dart';
import 'package:inf/ui/widgets/page_widget.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';

const kMenuIconSize = kToolbarHeight;

class MainPage extends PageWidget {
  static Route<dynamic> route() {
    return FadePageRoute(
      builder: (BuildContext context) => MainPage(),
    );
  }

  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends PageState<MainPage> with TickerProviderStateMixin {
  TabController _tabController;
  AnimationController _drawerController;
  Animation<Offset> _drawerSlideAnim;
  Animation<double> _drawerAnim;
  Animation<RelativeRect> _menuIconAnim;
  AnimationController _sectionController;
  Animation<double> _browseAnim;
  Animation<double> _activitiesAnim;

  MainPageMode _mode = MainPageMode.activities;
  bool _menuVisible = false;
  UserType userType;
  RxCommandListener<LoginProfile, void> switchUserListener;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _drawerController = AnimationController(duration: const Duration(milliseconds: 450), vsync: this);
    // TODO: Add curves
    _drawerAnim = Tween(begin: 0.0, end: 1.0).animate(_drawerController);
    _drawerSlideAnim = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero).animate(_drawerController);
    _sectionController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    // TODO: Add curves
    _browseAnim = Tween(begin: 1.0, end: 0.0).animate(_sectionController);
    _activitiesAnim = Tween(begin: 0.0, end: 1.0).animate(_sectionController);

    final userManager = backend<UserManager>();
    assert(userManager.currentUser != null);

    userType = userManager.currentUser.userType;
    backend<ListManager>().setFilter(Filter());
    if (userType == UserType.influencer) {
      _setMode(MainPageMode.browse);
    } else {
      _setMode(MainPageMode.activities);
    }

    switchUserListener = RxCommandListener(
      userManager.switchUserCommand,
      onValue: onUserSwitched,
      onIsBusy: () => InfLoader.show(context),
      onNotBusy: () => InfLoader.hide(),
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _sectionController.dispose();
    _tabController.dispose();
    switchUserListener?.dispose();
    super.dispose();
  }

  void _setMode(MainPageMode value) {
    if (value == MainPageMode.browse) {
      _sectionController.reverse();
    } else {
      _sectionController.forward();
    }
    setState(() => _mode = value);
  }

  void onUserSwitched(void _) {
    setState(() => userType = backend<UserManager>().currentUser.userType);
    if (userType == UserType.influencer) {
      _setMode(MainPageMode.browse);
    } else {
      _setMode(MainPageMode.activities);
    }
    backend<ListManager>().setFilter(Filter());
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
                BottomNavPanel(
                  userType: userType,
                  initialValue: _mode,
                  onBottomNavChanged: _setMode,
                ),
              ],
            ),
          ),

          /// Main Menu Drawer
          IgnorePointer(
            ignoring: _menuVisible,
            child: AnimatedBuilder(
              animation: _drawerAnim,
              builder: (BuildContext context, Widget navigationDrawer) {
                final value = _drawerAnim.value;
                if (value <= 0.0) {
                  return SizedBox();
                } else {
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
                }
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
