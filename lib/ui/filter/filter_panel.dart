import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/ui/filter/0_search_panel.dart';
import 'package:inf/ui/filter/1_category_panel.dart';
import 'package:inf/ui/filter/2_value_panel.dart';
import 'package:inf/ui/filter/3_deliverable_panel.dart';
import 'package:inf/ui/filter/4_location_panel.dart';
import 'package:inf/ui/filter/filter_button.dart';
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
  static const _frontPanelHeight = 230.0;
  static const _backPanelHeight = _frontPanelHeight + 208.0;

  AnimationController _controller;
  Animation<double> curveAmount;
  Animation<double> frontPanelCloseAnim;
  Animation<double> backPanelLeaveAnim;

  final _button = ValueNotifier<FilterButton>(FilterButton.None);
  final _selectedCategories = CategorySet();

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
                onPressed: _deselectFilterPanel,
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
                  child: Container(
                    alignment: Alignment.center,
                    height: 96.0,
                    child: ListenableBuilder(
                      listenable: _button,
                      builder: (BuildContext context, Widget child) {
                        return CategoryButton(
                          label: _button.value.title,
                          radius: 64.0,
                          selected: true,
                          child: InfIcon(_button.value.icon, size: 32.0),
                        );
                      },
                    ),
                  ),
                  /*child: ListenableBuilder(
                    listenable: _selectedCategories,
                    builder: (BuildContext context, Widget child) {
                      return CategoryRow(
                        selectedSubCategories: _selectedCategories,
                        onCategoryPressed: (category) {
                          final categories = backend.get<ConfigService>().categories;
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
                  ),*/
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
            child: RepaintBoundary(
              child: Container(
                margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
                alignment: Alignment.topCenter,
                child: ListenableBuilder(
                  listenable: _button,
                  builder: (BuildContext context, Widget child) {
                    WidgetBuilder builder = (context) {
                      switch (_button.value) {
                        case FilterButton.None:
                          return SearchFilterPanel(
                            onButtonPressed: _onFilterButtonPressed,
                          );
                        case FilterButton.Category:
                          return CategoryFilterPanel();
                        case FilterButton.Value:
                          return ValueFilterPanel();
                        case FilterButton.Deliverable:
                          return DeliverableFilterPanel();
                        case FilterButton.Location:
                          return LocationFilterPanel();
                        default:
                          throw StateError('Invalid button type: ${_button.value}');
                      }
                    };
                    return AnimatedSwitcher(
                      duration: _controller.duration,
                      child: KeyedSubtree(
                        key: ValueKey<FilterButton>(_button.value),
                        child: builder(context),
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
              onPressed: _deselectFilterPanel,
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

  void _deselectFilterPanel() => _onFilterButtonPressed(FilterButton.None);

  void _onFilterButtonPressed(FilterButton button) {
    _button.value = button;
    if (button == FilterButton.None) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }
}
