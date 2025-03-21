import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class CategorySelector extends StatefulWidget {
  final Category parentCategory;

  final CategorySet selectedSubCategories;
  final bool readOnly;

  const CategorySelector({
    Key key,
    @required this.parentCategory,
    @required this.selectedSubCategories,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<Category> subCategories; // TODO: change to Set

  @override
  void initState() {
    super.initState();
    if (widget.parentCategory != null) {
      subCategories = backend.get<ConfigService>().getSubCategories(widget.parentCategory);
    } else {
      subCategories = <Category>[];
    }
  }

  @override
  void didUpdateWidget(CategorySelector oldWidget) {
    if (widget.parentCategory != null) {
      subCategories = backend.get<ConfigService>().getSubCategories(widget.parentCategory);
    } else {
      subCategories = <Category>[];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parentCategory == null) {
      return emptyWidget;
    }

    var chips = <Widget>[];

    for (var category in subCategories) {
      // if the widget is readonly we only show the selected subcategories
      if (!widget.readOnly || widget.selectedSubCategories.contains(category))
        chips.add(
          ToggleChip(
            onTap: !widget.readOnly
                ? () {
                    setState(() => widget.selectedSubCategories.toggle(category));
                  }
                : () {},
            text: category.name,
            isSelected: widget.selectedSubCategories.contains(category),
          ),
        );
    }

    // Add the 'Select all' button
    if (!widget.readOnly) {
      chips.add(
        ToggleChip(
          onTap: () {
            setState(() {
              if (widget.selectedSubCategories.containsAll(subCategories)) {
                widget.selectedSubCategories.removeAll(subCategories);
              } else {
                widget.selectedSubCategories.addAll(subCategories);
              }
            });
          },
          text: 'Select all',
          isSelected: widget.selectedSubCategories.onlyWithParent(widget.parentCategory).length == subCategories.length,
        ),
      );
    }

    return Container(
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8.0,
        runSpacing: 4.0,
        direction: Axis.horizontal,
        children: chips,
      ),
    );
  }
}

class ToggleChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleChip({
    Key key,
    @required this.text,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: isSelected ? AppTheme.lightBlue : AppTheme.blackTwo,
      shape: const StadiumBorder(),
      onPressed: this.onTap,
      child: Container(
        child: Text(
          this.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
