import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';

import 'package:inf/utils/selection_set.dart';
import 'package:inf_api_client/inf_api_client.dart';

class CategorySelector extends StatefulWidget {
  final Category topLevelCategory;

  final SelectionSet<Category> selectedCategories;

  const CategorySelector({
    Key key,
    @required this.topLevelCategory,
    @required this.selectedCategories,
  }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<Category> subCategories;

  @override
  void initState() {
    if (widget.topLevelCategory != null) {
      subCategories = backend
          .get<ResourceService>()
          .categories
          .where((category) => category.parentId == widget.topLevelCategory.id)
          .toList();
    } else {
      subCategories = <Category>[];
    }
    super.initState();
  }

  @override
  void didUpdateWidget(CategorySelector oldWidget) {
    if (widget.topLevelCategory != null) {
      subCategories = backend
          .get<ResourceService>()
          .categories
          .where((category) => category.parentId == widget.topLevelCategory.id)
          .toList();
    } else {
      subCategories = <Category>[];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.topLevelCategory == null)
    {
      return SizedBox();
    }

    var chips = <Widget>[];

    for (var category in subCategories) {
      chips.add(
        ToggleChip(
          onTap: () {
            setState(() => widget.selectedCategories.toggle(category));
          },
          text: category.name,
          isSelected: widget.selectedCategories.contains(category),
        ),
      );
    }

    chips.add(
      ToggleChip(
        onTap: () {
          setState(() {
            widget.selectedCategories.addAll(subCategories.toSet());
          });
        },
        text: 'Select all',
        isSelected: widget.selectedCategories.values
                .where((cat) => cat.parentId == widget.topLevelCategory.id)
                .length ==
            subCategories.length,
      ),
    );

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
