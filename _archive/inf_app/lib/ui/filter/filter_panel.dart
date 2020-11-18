import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/filters.dart';
import 'package:inf/ui/filter/0_search_panel.dart';
import 'package:inf/ui/filter/1_category_panel.dart';
import 'package:inf/ui/filter/2_value_panel.dart';
import 'package:inf/ui/filter/3_deliverable_panel.dart';
import 'package:inf/ui/filter/4_location_panel.dart';
import 'package:inf/ui/filter/filter_button.dart';
import 'package:inf/ui/filter/filter_confirmation.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:provider/provider.dart';

class FilterPanel extends StatefulWidget {
  const FilterPanel({
    Key key,
    this.closePanel,
  }) : super(key: key);

  final VoidCallback closePanel;

  @override
  FilterPanelState createState() => FilterPanelState();

  static ValueNotifier<Filter> of(BuildContext context) {
    return Provider.of<ValueNotifier<Filter>>(context);
  }
}

class FilterPanelState extends State<FilterPanel> with SingleTickerProviderStateMixin {
  static const _frontHeight = 242.0;
  static const _backHeight = _frontHeight + 208.0;

  ListManager _listManager;
  AnimationController _controller;
  Animation<double> curveAmount;
  Animation<double> frontPanelCloseAnim;
  Animation<double> backPanelLeaveAnim;
  Animation<double> frontPanelAnim;
  Animation<double> backPanelAnim;

  final _button = ValueNotifier<FilterButton>(FilterButton.Search);

  final _filter = ValueNotifier<Filter>(null);

  @override
  void initState() {
    super.initState();

    _listManager = backend<ListManager>();
    _filter.value = _listManager.filter;
    _filter.addListener(_onFilterChanged);

    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    curveAmount = Tween<double>(begin: 0.8, end: 2.0).animate(_controller);
    frontPanelCloseAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    backPanelLeaveAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    frontPanelAnim = Tween<double>(begin: _frontHeight, end: _frontHeight + 64.0).animate(_controller);
    backPanelAnim = Tween<double>(begin: _frontHeight - 48.0, end: _backHeight).animate(_controller);
  }

  void _onFilterChanged() {
    _listManager.filter = _filter.value;
  }

  @override
  void dispose() {
    _filter.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom;
    return Provider<ValueNotifier<Filter>>.value(
      value: _filter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AnimatedPanel(
            height: backPanelAnim,
            child: const _BackFilterPanel(),
          ),
          AnimatedPanel(
            height: frontPanelAnim,
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
              child: RepaintBoundary(
                child: Container(
                  margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
                  alignment: Alignment.topCenter,
                  child: ListenableBuilder(
                    listenable: _button,
                    builder: (BuildContext context, Widget child) {
                      return FilterConfirmButton(
                        showHideAnimation: backPanelLeaveAnim,
                        initialDelegate: const FilterConfirmButtonDelegate(AppIcons.tick),
                        child: AnimatedSwitcher(
                          duration: _controller.duration,
                          child: KeyedSubtree(
                            key: ValueKey<FilterButton>(_button.value),
                            child: Builder(builder: _buttonPanel),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: _frontHeight - 16.0 + bottomInset,
            child: ScaleTransition(
              scale: frontPanelCloseAnim,
              child: RawMaterialButton(
                onPressed: widget.closePanel,
                fillColor: AppTheme.lightBlue,
                constraints: const BoxConstraints(minWidth: 32.0, minHeight: 32.0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const CircleBorder(),
                padding: const EdgeInsets.only(top: 2.0),
                child: const InfIcon(AppIcons.arrowDown, size: 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonPanel(BuildContext context) {
    switch (_button.value) {
      case FilterButton.Search:
        return SearchFilterPanel(
          onButtonPressed: _onFilterButtonPressed,
        );
      case FilterButton.Category:
        return CategoryFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
          closePanel: deselectFilterPanel,
        );
      case FilterButton.Value:
        return ValueFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
          closePanel: deselectFilterPanel,
        );
      case FilterButton.Deliverable:
        return DeliverableFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
          closePanel: deselectFilterPanel,
        );
      case FilterButton.Location:
        return LocationFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
          closePanel: deselectFilterPanel,
        );
      default:
        throw StateError('Invalid button type: ${_button.value}');
    }
  }

  void deselectFilterPanel() => _onFilterButtonPressed(FilterButton.Search);

  void _onFilterButtonPressed(FilterButton item) {
    _button.value = item;
    if (item == FilterButton.Search) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}

class _BackFilterPanel extends StatefulWidget {
  const _BackFilterPanel({Key key}) : super(key: key);

  @override
  _BackFilterPanelState createState() => _BackFilterPanelState();
}

class _BackFilterPanelState extends State<_BackFilterPanel> {
  final _categoryController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final FilterPanelState _state = context.ancestorStateOfType(const TypeMatcher<FilterPanelState>());
    final filterNotifier = FilterPanel.of(context);
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: _state.deselectFilterPanel,
          fillColor: const Color(0xFF222226),
          constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 0.0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const Border(),
          padding: const EdgeInsets.all(4.0),
          child: const InfIcon(AppIcons.arrowDown, size: 18.0),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 8.0),
            alignment: Alignment.topCenter,
            color: const Color(0xFF17161A),
            child: SizedBox(
              width: double.infinity,
              height: 96.0,
              child: ListenableBuilder(
                listenable: Listenable.merge([_state._button, filterNotifier]),
                builder: (BuildContext context, Widget child) {
                  /*CategorySet categorySet;
                  final filter = filterNotifier.value;
                  if (filter is UserFilter) {
                    categorySet = filter.categorySet;
                  } else if (filter is OfferFilter) {
                    categorySet = filter.categorySet;
                  }*/
                  return LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        controller: _categoryController,
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: constraints.copyWith(
                            minWidth: constraints.maxWidth,
                            maxWidth: double.infinity,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CategoryButton(
                                  label: _state._button.value.title,
                                  radius: 32.0,
                                  selected: true,
                                  child: InfIcon(_state._button.value.icon, size: 32.0),
                                ),
                              ),
                              /*
                              if (_state._button.value == FilterButton.Category)
                                ListenableBuilder(
                                  listenable: categorySet,
                                  builder: (BuildContext context, Widget child) {
                                    final topLevelCats = backend<ConfigService>().getCategoriesFromIds(
                                        categorySet.map((cat) => cat.parentId).toSet().toList(growable: false));
                                    return AnimatedSwitcher(
                                      duration: kThemeChangeDuration,
                                      transitionBuilder: _categoryTransitionBuilder,
                                      layoutBuilder: _categoryLayoutBuilder,
                                      switchInCurve: Curves.fastOutSlowIn,
                                      switchOutCurve: Curves.linearToEaseOut,
                                      child: Row(
                                        key: Key(topLevelCats.fold('', (prev, cat) => prev + cat.id)),
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          for (final topLevelCategory in topLevelCats)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: CategoryButton(
                                                label: topLevelCategory.name,
                                                radius: 32.0,
                                                selected: true,
                                                selectedSubCategories:
                                                    categorySet.onlyWithParent(topLevelCategory).length,
                                                child: InfIcon(topLevelCategory.iconAsset, size: 32.0),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              */
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*
  Widget _categoryTransitionBuilder(Widget child, Animation<double> animation) {
    AnimationStatusListener listener;
    listener = (status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        animation.removeStatusListener(listener);
        _categoryController.animateTo(
          _categoryController.position.maxScrollExtent,
          duration: kThemeChangeDuration,
          curve: Curves.easeOut,
        );
      }
    };
    animation.addStatusListener(listener);
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: const Interval(0.5, 1.0)),
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        axisAlignment: -1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: child,
        ),
      ),
    );
  }

  Widget _categoryLayoutBuilder(Widget currentChild, List<Widget> previousChildren) {
    return Stack(
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
      alignment: Alignment.centerLeft,
    );
  }
  */
}

class AnimatedPanel extends AnimatedBuilder {
  AnimatedPanel({
    Key key,
    Animation<double> height,
    Widget child,
  }) : super(
          key: key,
          animation: height,
          builder: (BuildContext context, Widget child) {
            final mediaQuery = MediaQuery.of(context);
            return Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              height: height.value + mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom,
              child: child,
            );
          },
          child: child,
        );
}
