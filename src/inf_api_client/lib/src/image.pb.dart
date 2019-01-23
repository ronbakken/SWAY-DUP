///
//  Generated code. Do not modify.
//  source: image.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class ImageDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ImageDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'url')
    ..a<List<int>>(2, 'lowResData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ImageDto() : super();
  ImageDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ImageDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ImageDto clone() => new ImageDto()..mergeFromMessage(this);
  ImageDto copyWith(void Function(ImageDto) updates) => super.copyWith((message) => updates(message as ImageDto));
  $pb.BuilderInfo get info_ => _i;
  static ImageDto create() => new ImageDto();
  ImageDto createEmptyInstance() => create();
  static $pb.PbList<ImageDto> createRepeated() => new $pb.PbList<ImageDto>();
  static ImageDto getDefault() => _defaultInstance ??= create()..freeze();
  static ImageDto _defaultInstance;
  static void $checkItem(ImageDto v) {
    if (v is! ImageDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get url => $_getS(0, '');
  set url(String v) { $_setString(0, v); }
  bool hasUrl() => $_has(0);
  void clearUrl() => clearField(1);

  List<int> get lowResData => $_getN(1);
  set lowResData(List<int> v) { $_setBytes(1, v); }
  bool hasLowResData() => $_has(1);
  void clearLowResData() => clearField(2);
}

