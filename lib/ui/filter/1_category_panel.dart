import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/ui/filter/filter_confirmation.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/category_selector.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';

class CategoryFilterPanel extends StatefulWidget {
  const CategoryFilterPanel({
    Key key,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;

  @override
  _CategoryFilterPanelState createState() => _CategoryFilterPanelState();
}

class _CategoryFilterPanelState extends State<CategoryFilterPanel> {
  final _selectedCategories = CategorySet();
  Category _topLevel;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_topLevel == null) {
      child = _TopLevelCategories(
        selectedCategories: _selectedCategories,
        onTopLevelCategoryPressed: _onTopLevelSelected,
        padding: widget.padding,
      );
    } else {
      child = Padding(
        padding: widget.padding + const EdgeInsets.only(top: 24.0),
        child: _SubCategoryGrid(
          parentCategory: _topLevel,
          selectedCategories: _selectedCategories,
        ),
      );
    }
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: child,
    );
  }

  void _onTopLevelSelected(Category category) {
    setState((){
      _topLevel = category;
      FilterConfirmationButton.of(context).icon = AppIcons.close;
    });
  }
}

class _TopLevelCategories extends StatelessWidget {
  const _TopLevelCategories({
    Key key,
    @required this.selectedCategories,
    this.onTopLevelCategoryPressed,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final CategorySet selectedCategories;
  final ValueChanged<Category> onTopLevelCategoryPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final topLevelCategories = backend<ConfigService>().topLevelCategories;
    return GridView.builder(
      padding: padding + const EdgeInsets.only(top: 12.0),
      itemCount: topLevelCategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        final topLevelCategory = topLevelCategories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: CategoryButton(
            onTap: onTopLevelCategoryPressed != null ? () => onTopLevelCategoryPressed(topLevelCategory) : null,
            selectedSubCategories: selectedCategories.onlyWithParent(topLevelCategory).length,
            radius: 32.0,
            label: topLevelCategory.name,
            child: InfMemoryImage(
              topLevelCategory.iconData,
              color: Colors.white,
              width: 24.0,
              height: 24.0,
            ),
          ),
        );
      },
    );
  }
}

class _SubCategoryGrid extends StatelessWidget {
  const _SubCategoryGrid({
    Key key,
    this.parentCategory,
    @required this.selectedCategories,
  }) : super(key: key);

  final Category parentCategory;
  final CategorySet selectedCategories;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: CategorySelector(
        parentCategory: parentCategory,
        selectedSubCategories: selectedCategories,
      ),
    );
  }
}
