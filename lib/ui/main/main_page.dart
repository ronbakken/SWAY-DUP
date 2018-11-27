import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
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

class _MainPageState extends PageState<MainPage>
    with AuthStateMixin<MainPage>, TickerProviderStateMixin {
  AnimationController _drawerController;
  Animation<Offset> _drawerSlideAnim;
  Animation<double> _drawerAnim;
  Animation<RelativeRect> _menuIconAnim;
  AnimationController _sectionController;
  Animation<double> _browseAnim;
  Animation<double> _activitiesAnim;

  MainPageMode _mode = MainPageMode.browse;
  bool _menuVisible = false;

  @override
  void initState() {
    super.initState();

    _drawerController = AnimationController(
        duration: const Duration(milliseconds: 450), vsync: this);
    // TODO: Add curves
    _drawerAnim = Tween(begin: 0.0, end: 1.0).animate(_drawerController);
    _drawerSlideAnim = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .animate(_drawerController);
    _sectionController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // TODO: Add curves
    _browseAnim = Tween(begin: 1.0, end: 0.0).animate(_sectionController);
    _activitiesAnim = Tween(begin: 0.0, end: 1.0).animate(_sectionController);
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final sectionPadding =
        EdgeInsets.only(bottom: mediaQuery.padding.bottom + kBottomNavHeight);
    final menuWidth = mediaQuery.size.shortestSide * 0.8;

    final menuIconRect = Rect.fromLTWH(
        0.0, 0.0, kMenuIconSize, mediaQuery.padding.top + kMenuIconSize);
    final menuIconBegin = RelativeRect.fromSize(menuIconRect, mediaQuery.size);
    final menuIconEnd = menuIconBegin.shift(Offset(menuWidth + 16.0, 0.0));
    _menuIconAnim = RelativeRectTween(begin: menuIconBegin, end: menuIconEnd)
        .animate(_drawerController);

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
