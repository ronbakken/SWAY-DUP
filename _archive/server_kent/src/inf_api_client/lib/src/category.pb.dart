///
//  Generated code. Do not modify.
//  source: category.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class CategoryDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CategoryDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..aOS(2, 'parentId')
    ..aOS(3, 'name')
    ..aOS(4, 'description')
    ..a<$core.List<$core.int>>(5, 'iconData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CategoryDto() : super();
  CategoryDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CategoryDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CategoryDto clone() => CategoryDto()..mergeFromMessage(this);
  CategoryDto copyWith(void Function(CategoryDto) updates) => super.copyWith((message) => updates(message as CategoryDto));
  $pb.BuilderInfo get info_ => _i;
  static CategoryDto create() => CategoryDto();
  CategoryDto createEmptyInstance() => create();
  static $pb.PbList<CategoryDto> createRepeated() => $pb.PbList<CategoryDto>();
  static CategoryDto getDefault() => _defaultInstance ??= create()..freeze();
  static CategoryDto _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get parentId => $_getS(1, '');
  set parentId($core.String v) { $_setString(1, v); }
  $core.bool hasParentId() => $_has(1);
  void clearParentId() => clearField(2);

  $core.String get name => $_getS(2, '');
  set name($core.String v) { $_setString(2, v); }
  $core.bool hasName() => $_has(2);
  void clearName() => clearField(3);

  $core.String get description => $_getS(3, '');
  set description($core.String v) { $_setString(3, v); }
  $core.bool hasDescription() => $_has(3);
  void clearDescription() => clearField(4);

  $core.List<$core.int> get iconData => $_getN(4);
  set iconData($core.List<$core.int> v) { $_setBytes(4, v); }
  $core.bool hasIconData() => $_has(4);
  void clearIconData() => clearField(5);
}

