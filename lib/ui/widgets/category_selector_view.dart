import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/category_button.dart';
import 'package:inf/ui/widgets/category_selector.dart';
import 'package:inf/ui/widgets/column_separator.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/help_button.dart';
import 'package:inf/ui/widgets/inf_memory_image.dart';
import 'package:inf/ui/widgets/listenable_builder.dart';
import 'package:inf/ui/widgets/overflow_row.dart';
import 'package:inf/utils/selection_set.dart';

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
              Padding(
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
              selectedCategories: widget.selectedCategories,
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
          child: activeTopLevelCategory.value == null ? ColumnSeparator() : buildCategorySelector(),
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
                  child: Padding(
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
    @required this.selectedCategories,
    this.onCategoryPressed,
  }) : super(key: key);

  final CategorySet selectedCategories;
  final ValueChanged<Category> onCategoryPressed;

  @override
  Widget build(BuildContext context) {
    final topLevelCategories = backend.get<ConfigService>().topLevelCategories;
    return OverflowRow(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 96.0,
      childrenWidth: 64.0,
      children: topLevelCategories.map((topLevelCategory) {
        return CategoryButton(
          onTap: () => onCategoryPressed(topLevelCategory),
          selectedSubCategories:
              selectedCategories.values.where((category) => category.parentId == topLevelCategory.id).length,
          label: topLevelCategory.name,
          radius: 64.0,
          child: InfMemoryImage(
            topLevelCategory.iconData,
            color: Colors.white,
            width: 32.0,
            height: 32.0,
          ),
        );
      }).toList(growable: false),
    );
  }
}
