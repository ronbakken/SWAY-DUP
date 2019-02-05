import 'dart:typed_data';

import 'package:inf/utils/selection_set.dart';
import 'package:inf_api_client/inf_api_client.dart';

class Category {
  final CategoryDto dto;

  int get id => dto.id;
  // for top level categories this is set to -1
  int get parentId => dto.parentId;
  String get name => dto.name;
  String get description => dto.description;
  Uint8List get iconData => _iconData;

  Uint8List _iconData;

  Category(this.dto) {
    _iconData = Uint8List.fromList(dto.iconData);
  }
}

class CategorySet extends SelectionSet<Category> {

  CategorySet() : super();

  CategorySet.fromIterable(Iterable<Category> iterable) : super.fromIterable(iterable);

  List<Category> onlyWithParent(Category parent) =>
    values.where((category) => category.parentId == parent.id);
}
