import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
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
  Filter _filter = Filter();
  static const _frontHeight = 242.0;
  static const _backHeight = _frontHeight + 208.0;

  AnimationController _controller;
  Animation<double> curveAmount;
  Animation<double> frontPanelCloseAnim;
  Animation<double> backPanelLeaveAnim;
  Animation<double> frontPanelAnim;
  Animation<double> backPanelAnim;

  final button = ValueNotifier<FilterButton>(FilterButton.Search);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    curveAmount = Tween<double>(begin: 0.8, end: 2.0).animate(_controller);
    frontPanelCloseAnim = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    backPanelLeaveAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    frontPanelAnim = Tween<double>(begin: _frontHeight, end: _frontHeight + 64.0).animate(_controller);
    backPanelAnim = Tween<double>(begin: _frontHeight - 48.0, end: _backHeight).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom;
    return Stack(
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
                  listenable: button,
                  builder: (BuildContext context, Widget child) {
                    return FilterConfirmationButton(
                      showHideAnimation: backPanelLeaveAnim,
                      initialIcon: AppIcons.tick,
                      child: AnimatedSwitcher(
                        duration: _controller.duration,
                        child: KeyedSubtree(
                          key: ValueKey<FilterButton>(button.value),
                          child: _buttonPanel(context),
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
        /*

         */
      ],
    );
  }

  Widget _buttonPanel(BuildContext context) {
    switch (button.value) {
      case FilterButton.Search:
        return SearchFilterPanel(
          onButtonPressed: _onFilterButtonPressed,
        );
      case FilterButton.Category:
        return const CategoryFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
        );
      case FilterButton.Value:
        return const ValueFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
        );
      case FilterButton.Deliverable:
        return DeliverableFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
        );
      case FilterButton.Location:
        return const LocationFilterPanel(
          padding: const EdgeInsets.only(bottom: 124.0),
        );
      default:
        throw StateError('Invalid button type: ${button.value}');
    }
  }

  void deselectFilterPanel() => _onFilterButtonPressed(FilterButton.Search);

  void _onFilterButtonPressed(FilterButton item) {
    button.value = item;
    if (item == FilterButton.Search) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}

class _BackFilterPanel extends StatelessWidget {
  const _BackFilterPanel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterPanelState _state = context.ancestorStateOfType(const TypeMatcher<FilterPanelState>());
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
            child: Container(
              alignment: Alignment.center,
              height: 96.0,
              child: ListenableBuilder(
                listenable: _state.button,
                builder: (BuildContext context, Widget child) {
                  return CategoryButton(
                    label: _state.button.value.title,
                    radius: 64.0,
                    selected: true,
                    child: InfIcon(_state.button.value.icon, size: 32.0),
                  );
                },
              ),
            ),
            /*
            child: ListenableBuilder(
              listenable: _selectedCategories,
              builder: (BuildContext context, Widget child) {
                return CategoryRow(
                  selectedSubCategories: _selectedCategories,
                  onCategoryPressed: (category) {
                    final categories = backend<ConfigService>().categories;
                    final subCats = categories
                      .where((cat) => cat.parentId == category.id)
                      .toList(growable: false);
                    if (_selectedCategories.containsAll(subCats)) {
                      _selectedCategories.removeAll(subCats);
                    } else {
                      _selectedCategories.addAll(subCats);
                    }
                  },
                );
              },
            ),
            */
          ),
        ),
      ],
    );
  }
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
