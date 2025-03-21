import 'dart:typed_data';

import 'package:inf/app/assets.dart';
import 'package:inf/utils/selection_set.dart';
import 'package:inf_api_client/inf_api_client.dart';

class Category {
  final CategoryDto dto;

  String get id => dto.id;

  // for top level categories this is set to an empty string
  String get parentId => dto.parentId;

  String get name => dto.name;

  String get description => dto.description;

  AppAsset get iconAsset => _appAsset;

  AppAsset _appAsset;

  Category(this.dto) : assert(dto != null) {
    _appAsset = AppAsset.raw(Uint8List.fromList(dto.iconData));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Category{$id: $name}';
}

class CategorySet extends SelectionSet<Category> {
  CategorySet() : super();

  CategorySet.fromIterable(Iterable<Category> iterable) : super.fromIterable(iterable);

  List<Category> onlyWithParent(Category parent) =>
      where((category) => category.parentId == parent.id).toList(growable: false);

  List<Category> get topLevelCategories {
    return where((item) => item.parentId.isEmpty).toList(growable: false);
  }
}
