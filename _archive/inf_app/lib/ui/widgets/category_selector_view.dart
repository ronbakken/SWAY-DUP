import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/category_selector.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/ui/widgets/overflow_row.dart';

class CategorySelectorView extends StatefulWidget {
  const CategorySelectorView({
    Key key,
    this.padding = EdgeInsets.zero,
    this.readOnly = false,
    @required this.selectedCategories,
    this.label,
  }) : super(key: key);

  final EdgeInsets padding;
  final bool readOnly;
  final CategorySet selectedCategories;
  final String label;

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelectorView> {
  ValueNotifier<Category> activeTopLevelCategory = ValueNotifier<Category>(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                textAlign: TextAlign.left,
                style: AppTheme.formFieldLabelStyle,
              ),
              const Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: HelpButton(),
              ),
            ],
          ),
        ),
        ListenableBuilder(
          listenable: widget.selectedCategories,
          builder: (context, child) {
            return CategoryRow(
              selectedSubCategories: widget.selectedCategories,
              onCategoryPressed: (category) => setState(() => activeTopLevelCategory.value = category),
            );
          },
        ),
        AnimatedSwitcher(
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                axis: Axis.vertical,
                axisAlignment: -1.0,
                sizeFactor: animation,
                child: child,
              ),
            );
          },
          duration: const Duration(milliseconds: 500),
          child: activeTopLevelCategory.value == null ? const ColumnSeparator() : buildCategorySelector(),
        ),
      ],
    );
  }

  Widget buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: CurvedBox(
        curveFactor: 1.5,
        bottom: false,
        top: true,
        color: AppTheme.grey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 8.0),
              child: ListenableBuilder(
                listenable: activeTopLevelCategory,
                builder: (context, child) {
                  return CategorySelector(
                    parentCategory: activeTopLevelCategory.value,
                    selectedSubCategories: widget.selectedCategories,
                    readOnly: widget.readOnly,
                  );
                },
              ),
            ),
            Container(
              color: AppTheme.darkGrey2,
              child: Center(
                child: InkWell(
                  onTap: () => setState(() => activeTopLevelCategory.value = null),
                  child: const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Close'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    Key key,
    @required this.selectedSubCategories,
    this.onCategoryPressed,
  }) : super(key: key);

  final CategorySet selectedSubCategories;
  final ValueChanged<Category> onCategoryPressed;

  @override
  Widget build(BuildContext context) {
    final topLevelCategories = backend<ConfigService>().topLevelCategories;
    return OverflowRow( // ignore: prefer_const_constructors
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 96.0,
      childrenWidth: 64.0,
      children: <Widget>[
        for (final topLevelCategory in topLevelCategories)
          CategoryButton(
            onTap: onCategoryPressed != null ? () => onCategoryPressed(topLevelCategory) : null,
            selectedSubCategories: selectedSubCategories.onlyWithParent(topLevelCategory).length,
            label: topLevelCategory.name,
            radius: 64.0,
            child: InfAssetImage(
              topLevelCategory.iconAsset,
              color: Colors.white,
              width: 32.0,
              height: 32.0,
            ),
          ),
      ],
    );
  }
}
