///
//  Generated code. Do not modify.
//  source: image.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class ImageDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ImageDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'url')
    ..aOS(2, 'lowResUrl')
    ..hasRequiredFields = false
  ;

  ImageDto() : super();
  ImageDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ImageDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ImageDto clone() => ImageDto()..mergeFromMessage(this);
  ImageDto copyWith(void Function(ImageDto) updates) => super.copyWith((message) => updates(message as ImageDto));
  $pb.BuilderInfo get info_ => _i;
  static ImageDto create() => ImageDto();
  ImageDto createEmptyInstance() => create();
  static $pb.PbList<ImageDto> createRepeated() => $pb.PbList<ImageDto>();
  static ImageDto getDefault() => _defaultInstance ??= create()..freeze();
  static ImageDto _defaultInstance;

  $core.String get url => $_getS(0, '');
  set url($core.String v) { $_setString(0, v); }
  $core.bool hasUrl() => $_has(0);
  void clearUrl() => clearField(1);

  $core.String get lowResUrl => $_getS(1, '');
  set lowResUrl($core.String v) { $_setString(1, v); }
  $core.bool hasLowResUrl() => $_has(1);
  void clearLowResUrl() => clearField(2);
}

