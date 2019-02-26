///
//  Generated code. Do not modify.
//  source: category.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class CategoryDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('CategoryDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..aOS(2, 'parentId')
    ..aOS(3, 'name')
    ..aOS(4, 'description')
    ..a<List<int>>(5, 'iconData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CategoryDto() : super();
  CategoryDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CategoryDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CategoryDto clone() => new CategoryDto()..mergeFromMessage(this);
  CategoryDto copyWith(void Function(CategoryDto) updates) => super.copyWith((message) => updates(message as CategoryDto));
  $pb.BuilderInfo get info_ => _i;
  static CategoryDto create() => new CategoryDto();
  CategoryDto createEmptyInstance() => create();
  static $pb.PbList<CategoryDto> createRepeated() => new $pb.PbList<CategoryDto>();
  static CategoryDto getDefault() => _defaultInstance ??= create()..freeze();
  static CategoryDto _defaultInstance;
  static void $checkItem(CategoryDto v) {
    if (v is! CategoryDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  String get parentId => $_getS(1, '');
  set parentId(String v) { $_setString(1, v); }
  bool hasParentId() => $_has(1);
  void clearParentId() => clearField(2);

  String get name => $_getS(2, '');
  set name(String v) { $_setString(2, v); }
  bool hasName() => $_has(2);
  void clearName() => clearField(3);

  String get description => $_getS(3, '');
  set description(String v) { $_setString(3, v); }
  bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);

  List<int> get iconData => $_getN(4);
  set iconData(List<int> v) { $_setBytes(4, v); }
  bool hasIconData() => $_has(4);
  void clearIconData() => clearField(5);
}

