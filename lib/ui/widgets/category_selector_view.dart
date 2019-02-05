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
    this.padding,
    this.readOnly = false,
    @required this.categories,
    this.label,
  }) : super(key: key);

  final EdgeInsets padding;
  final bool readOnly;
  final SelectionSet<Category> categories;
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
        buildCategoryRow(),
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

  Widget buildCategoryRow() {
    var categories = widget.categories;
    return ListenableBuilder(
      listenable: categories,
      builder: (context, widget) {
        final topLevelCategories = backend.get<ConfigService>().categories.where((item) => item.parentId == -1);
        final rowItems = <Widget>[];

        for (var topLevelCategory in topLevelCategories) {
          rowItems.add(
            CategoryButton(
              onTap: () => setState(() {
                    activeTopLevelCategory.value = topLevelCategory;
                  }),
              radius: 64.0,
              child: InfMemoryImage(
                topLevelCategory.iconData,
                color: Colors.white,
                width: 32.0,
                height: 32.0,
              ),
              selectedSubCategories:
                  categories.values.where((category) => category.parentId == topLevelCategory.id).length,
              label: topLevelCategory.name,
            ),
          );
        }
        return new OverflowRow(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 96.0,
          childrenWidth: 64.0,
          children: rowItems,
        );
      },
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32, 16, 8),
                child: ListenableBuilder(
                  listenable: activeTopLevelCategory,
                  builder: (contex, child) => CategorySelector(
                        topLevelCategory: activeTopLevelCategory.value,
                        selectedCategories: widget.categories,
                        readOnly: widget.readOnly,
                      ),
                )),
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
