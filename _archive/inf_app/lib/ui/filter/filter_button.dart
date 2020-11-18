import 'package:inf/app/assets.dart';

class FilterButton {
  static const Search = FilterButton._('Search');
  static const Category = FilterButton._('Category', AppIcons.category);
  static const Value = FilterButton._('Value', AppIcons.value);
  static const Deliverable = FilterButton._('Deliverable', AppIcons.deliverable);
  static const Location = FilterButton._('Location', AppIcons.location);

  const FilterButton._(this.title, [this.icon]);

  final String title;
  final AppAsset icon;

  static const searchPanel = <FilterButton>[
    FilterButton.Category,
    FilterButton.Value,
    FilterButton.Deliverable,
    FilterButton.Location,
  ];

  @override
  String toString() => 'FilterButton{$title}';
}
