import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/ui/filter/expand_transition.dart';
import 'package:inf/ui/main/bottom_nav.dart';
import 'package:inf/ui/main/page_mode.dart';
import 'package:inf/ui/offer_add/add_business_offer_page.dart';
import 'package:inf/ui/widgets/category_selector_view.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/ui/widgets/swipe_detector.dart';
import 'package:inf/utils/animation_choreographer.dart';
import 'package:inf/utils/trim_path.dart';
import 'package:inf_api_client/inf_api_client.dart';

const kBottomNavHeight = 84.0;

class BottomNavPanel extends StatefulWidget {
  const BottomNavPanel({
    Key key,
    @required this.userType,
    @required this.initialValue,
    @required this.onBottomNavChanged,
  }) : super(key: key);

  final UserType userType;
  final MainPageMode initialValue;
  final ValueChanged<MainPageMode> onBottomNavChanged;

  @override
  BottomNavPanelState createState() => BottomNavPanelState();
}

class BottomNavPanelState extends State<BottomNavPanel> with SingleTickerProviderStateMixin {
  LocalHistoryEntry _panelHistoryEntry;
  AnimationController _controller;
  Animation<Offset> _panel1;
  Animation<Offset> _panel2;

  double height1;
  double height2;

  FocusNode _bottomNavFocus;

  MainPageMode _pageMode;

  @override
  void initState() {
    super.initState();

    _pageMode = widget.initialValue;

    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);

    _panel1 = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _panel2 = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _bottomNavFocus = FocusNode();
  }

  @override
  void dispose() {
    _bottomNavFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SlideTransition(
          position: _panel1,
          child: Container(
            height: mediaQuery.padding.bottom + kBottomNavHeight + 12.0,
            child: MainNavPanel(
              userType: widget.userType,
              initialValue: widget.initialValue,
              onFabPressed: _onFabPressed,
              onBottomNavChanged: (mode) {
                _pageMode = mode;
                widget.onBottomNavChanged(mode);
              },
            ),
          ),
        ),
        AnimationChoreographer(
          animation: _controller,
          child: SlideTransition(
            position: _panel2,
            child: SwipeDetector(
              onSwipeDown: _hideSearchPanel,
              slopAmount: 24.0,
              child: FilterPanel(
                closePanel: _hideSearchPanel,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onFabPressed() {
    if (widget.userType == UserType.influencer || _pageMode == MainPageMode.browse) {
      _showSearchPanel();
    } else {
      Navigator.of(context).push(AddBusinessOfferPage.route(widget.userType));
    }
  }

  void _showSearchPanel() {
    _controller.forward();
    _panelHistoryEntry = LocalHistoryEntry(onRemove: () {
      _panelHistoryEntry = null;
      _hideSearchPanel();
    });
    ModalRoute.of(context).addLocalHistoryEntry(_panelHistoryEntry);
    FocusScope.of(context).requestFocus(_bottomNavFocus);
  }

  void _hideSearchPanel() {
    if (_panelHistoryEntry != null) {
      ModalRoute.of(context).removeLocalHistoryEntry(_panelHistoryEntry);
    }
    FocusScope.of(context).requestFocus(_bottomNavFocus);
    _controller.reverse();
  }
}

enum FilterButton {
  None,
  Category,
  Value,
  Deliverable,
  Location,
}

class FilterPanel extends StatefulWidget {
  const FilterPanel({
    Key key,
    this.closePanel,
  }) : super(key: key);

  final VoidCallback closePanel;

  @override
  FilterPanelState createState() => FilterPanelState();
}

class FilterPanelState extends State<FilterPanel> with SingleTickerProviderStateMixin {
  static const _frontPanelHeight = 230.0;
  static const _backPanelHeight = _frontPanelHeight + 208.0;

  AnimationController _controller;
  Animation<double> curveAmount;
  Animation<double> frontPanelCloseAnim;
  Animation<double> backPanelLeaveAnim;

  FilterButton _button = FilterButton.None;

  CategorySet _selectedCategories = CategorySet();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 250), vsync: this);

    curveAmount = Tween<double>(begin: 0.8, end: 2.0).animate(_controller);
    frontPanelCloseAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    backPanelLeaveAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openBackPanel() {
    return _controller.forward();
  }

  Future<void> _closeBackPanel() {
    return _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom;

    final frontPanelAnim = Tween<double>(
      begin: _frontPanelHeight,
      end: _frontPanelHeight + 64.0,
    ).animate(_controller);

    final backPanelAnim = Tween<double>(
      begin: _frontPanelHeight - 48.0,
      end: _backPanelHeight,
    ).animate(_controller);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: backPanelAnim,
          builder: (BuildContext context, Widget child) {
            return Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              height: backPanelAnim.value + bottomInset,
              child: child,
            );
          },
          child: Column(
            children: <Widget>[
              RawMaterialButton(
                onPressed: _closeBackPanel,
                fillColor: const Color(0xFF222226),
                constraints: BoxConstraints(minWidth: double.infinity, minHeight: 0.0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const Border(),
                padding: const EdgeInsets.all(4.0),
                child: InfIcon(AppIcons.arrowDown, size: 18.0),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 8.0),
                  alignment: Alignment.topCenter,
                  color: const Color(0xFF17161A),
                  child: ListenableBuilder(
                    listenable: _selectedCategories,
                    builder: (BuildContext context, Widget child) {
                      return CategoryRow(
                        selectedSubCategories: _selectedCategories,
                        onCategoryPressed: (category) {
                          final topLevelCategories = backend.get<ConfigService>().topLevelCategories;
                          final subCats =
                              topLevelCategories.where((cat) => cat.parentId == category.id).toList(growable: false);
                          if (_selectedCategories.containsAll(subCats)) {
                            _selectedCategories.removeAll(subCats);
                          } else {
                            _selectedCategories.addAll(subCats);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: frontPanelAnim,
          builder: (BuildContext context, Widget child) {
            return Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              height: frontPanelAnim.value + bottomInset,
              child: child,
            );
          },
          child: AnimatedBuilder(
            animation: curveAmount,
            builder: (BuildContext context, Widget child) {
              return CurvedBox(
                curveFactor: curveAmount.value,
                color: AppTheme.darkGrey,
                top: true,
                child: CurvedBoxClip(
                  curveFactor: curveAmount.value,
                  top: true,
                  child: child,
                ),
              );
            },
            child: PageView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
                  alignment: Alignment.topCenter,
                  child: SearchFilterPanel(
                    buttons: <Widget>[
                      FilterPanelButton(
                        iconAsset: AppIcons.category,
                        title: 'Category',
                        onTap: () => _onFilterButtonPressed(FilterButton.Category),
                      ),
                      FilterPanelButton(
                        iconAsset: AppIcons.value,
                        title: 'Value',
                        onTap: () => _onFilterButtonPressed(FilterButton.Value),
                      ),
                      FilterPanelButton(
                        iconAsset: AppIcons.deliverable,
                        title: 'Deliverable',
                        onTap: () => _onFilterButtonPressed(FilterButton.Deliverable),
                      ),
                      FilterPanelButton(
                        iconAsset: AppIcons.location,
                        title: 'Location',
                        onTap: () => _onFilterButtonPressed(FilterButton.Location),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: _frontPanelHeight - 16.0 + bottomInset,
          child: ScaleTransition(
            scale: frontPanelCloseAnim,
            child: RawMaterialButton(
              onPressed: widget.closePanel,
              fillColor: AppTheme.lightBlue,
              constraints: BoxConstraints(minWidth: 32.0, minHeight: 32.0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              padding: const EdgeInsets.only(top: 2.0),
              child: InfIcon(AppIcons.arrowDown, size: 14.0),
            ),
          ),
        ),
        Positioned(
          bottom: 24.0 + bottomInset,
          child: ScaleTransition(
            scale: backPanelLeaveAnim,
            child: RawMaterialButton(
              onPressed: _closeBackPanel,
              fillColor: AppTheme.lightBlue,
              constraints: BoxConstraints(minWidth: 64.0, minHeight: 64.0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: const CircleBorder(),
              padding: const EdgeInsets.only(top: 4.0),
              child: InfIcon(AppIcons.tick, size: 32.0),
            ),
          ),
        ),
      ],
    );
  }

  void _onFilterButtonPressed(FilterButton button) {
    setState(() => _button = button);
    if (button == FilterButton.None) {
      _closeBackPanel();
    } else {
      _openBackPanel();
    }
  }
}

class SearchFilterPanel extends StatefulWidget {
  const SearchFilterPanel({
    Key key,
    @required this.buttons,
  })  : assert(buttons != null),
        super(key: key);

  final List<Widget> buttons;

  @override
  _SearchFilterPanelState createState() => _SearchFilterPanelState();
}

class _SearchFilterPanelState extends State<SearchFilterPanel> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Decoration> _backgroundAnim;
  Animation<double> _expandAnim;
  Animation<double> _inputAnim;

  FocusNode _panelFocus;
  FocusNode _searchFocus;

  bool _expanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      setState(() => _expanded = (status != AnimationStatus.dismissed));
    });

    _backgroundAnim = DecorationTween(
      begin: BoxDecoration(
        color: Colors.transparent,
      ),
      end: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
    ).animate(_controller);

    _expandAnim = CurvedAnimation(
      parent: AnimationChoreographer.of(context),
      curve: Interval(0.4, 1.0),
    );

    _inputAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc,
    );

    _panelFocus = FocusNode();
    _searchFocus = FocusNode();
    _searchFocus.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _panelFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    if (!_expanded) {
      _controller.forward();
    }
  }

  void _hideSearch() {
    FocusScope.of(context).requestFocus(_panelFocus);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;
    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: 16.0,
          bottom: bottomPadding + 48.0,
          child: FadeTransition(
            opacity: _expandAnim,
            child: ExpandTransition(
              distance: _expandAnim,
              startAngle: 210.0,
              tickAngle: 40.0,
              children: widget.buttons,
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !_expanded,
          child: Material(
            type: MaterialType.transparency,
            child: DecoratedBoxTransition(
              decoration: _backgroundAnim,
              child: InkWell(
                onTap: _hideSearch,
                child: SizedBox.expand(),
              ),
            ),
          ),
        ),
        Positioned(
          left: 24.0,
          right: 24.0,
          bottom: bottomPadding + 8.0,
          height: 42.0,
          child: CustomSingleChildLayout(
            delegate: _SearchDelegate(_controller),
            child: CustomPaint(
              painter: _SearchBorderPainter(_inputAnim),
              child: TextField(
                focusNode: _searchFocus,
                decoration: InputDecoration(
                  prefixIcon: InfIcon(AppIcons.search, size: 16.0),
                  contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 24.0, 12.0),
                  border: InputBorder.none,
                  hintText: 'Keyword search',
                  hintMaxLines: 1,
                ),
                keyboardAppearance: Brightness.dark,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: bottomPadding + 20.0,
          right: 0.0,
          child: IgnorePointer(
            ignoring: !_expanded,
            child: FadeTransition(
              opacity: _inputAnim,
              child: RawMaterialButton(
                onPressed: _hideSearch,
                fillColor: AppTheme.lightBlue,
                constraints: BoxConstraints(minWidth: 20.0, minHeight: 20.0),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.close, size: 16.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterPanelButton extends StatelessWidget {
  const FilterPanelButton({
    Key key,
    @required this.iconAsset,
    @required this.title,
    this.onTap,
  }) : super(key: key);

  final AppAsset iconAsset;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 72.0,
          height: 72.0,
          child: Material(
            type: MaterialType.circle,
            color: AppTheme.buttonHalo,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Center(
                child: InfAssetImage(
                  iconAsset,
                  width: iconTheme.size,
                  height: iconTheme.size,
                  color: iconTheme.color,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(title),
      ],
    );
  }
}

class _SearchDelegate extends SingleChildLayoutDelegate {
  Animation<double> expanded;

  _SearchDelegate(this.expanded) : super(relayout: expanded);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final height = constraints.maxHeight;
    final width = height + ((constraints.maxWidth - height) * expanded.value);
    return BoxConstraints.tight(Size(width, height));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width - childSize.width, 0.0);
  }

  @override
  bool shouldRelayout(_SearchDelegate old) => old.expanded != expanded;
}

class _SearchBorderPainter extends CustomPainter {
  _SearchBorderPainter(this.expanded) : super(repaint: expanded);

  final Animation<double> expanded;

  final borderSide = const BorderSide(color: Colors.white, width: 2.0);
  final borderRadius = const BorderRadius.all(Radius.circular(4.0));

  @override
  void paint(Canvas canvas, Size size) {
    final roundRect = borderRadius.toRRect(Offset.zero & size);

    final Rect brCorner = Rect.fromLTWH(
      roundRect.right - roundRect.brRadiusX * 2.0,
      roundRect.bottom - roundRect.brRadiusY * 2.0,
      roundRect.brRadiusX * 2.0,
      roundRect.brRadiusY * 2.0,
    );

    const double cornerArcSweep = math.pi / 2.0;

    final path = Path()
      ..moveTo(roundRect.right, roundRect.top + (roundRect.height * 0.5))
      ..lineTo(roundRect.right, roundRect.bottom - roundRect.brRadiusY)
      ..addArc(brCorner, 0.0, cornerArcSweep)
      ..lineTo(roundRect.left + roundRect.blRadiusX, roundRect.bottom);

    canvas.drawPath(trimPath(path, expanded.value), borderSide.toPaint());
  }

  @override
  bool shouldRepaint(_SearchBorderPainter old) => true;
}
