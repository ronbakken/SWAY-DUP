///
//  Generated code. Do not modify.
//  source: net_storage_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class NetUploadImage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetUploadImage',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'fileName')
    ..a<int>(2, 'contentLength', $pb.PbFieldType.O3)
    ..a<List<int>>(3, 'contentSha256', $pb.PbFieldType.OY)
    ..aOS(4, 'contentType')
    ..hasRequiredFields = false;

  NetUploadImage() : super();
  NetUploadImage.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadImage.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadImage clone() => new NetUploadImage()..mergeFromMessage(this);
  NetUploadImage copyWith(void Function(NetUploadImage) updates) =>
      super.copyWith((message) => updates(message as NetUploadImage));
  $pb.BuilderInfo get info_ => _i;
  static NetUploadImage create() => new NetUploadImage();
  NetUploadImage createEmptyInstance() => create();
  static $pb.PbList<NetUploadImage> createRepeated() =>
      new $pb.PbList<NetUploadImage>();
  static NetUploadImage getDefault() => _defaultInstance ??= create()..freeze();
  static NetUploadImage _defaultInstance;
  static void $checkItem(NetUploadImage v) {
    if (v is! NetUploadImage) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get fileName => $_getS(0, '');
  set fileName(String v) {
    $_setString(0, v);
  }

  bool hasFileName() => $_has(0);
  void clearFileName() => clearField(1);

  int get contentLength => $_get(1, 0);
  set contentLength(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasContentLength() => $_has(1);
  void clearContentLength() => clearField(2);

  List<int> get contentSha256 => $_getN(2);
  set contentSha256(List<int> v) {
    $_setBytes(2, v);
  }

  bool hasContentSha256() => $_has(2);
  void clearContentSha256() => clearField(3);

  String get contentType => $_getS(3, '');
  set contentType(String v) {
    $_setString(3, v);
  }

  bool hasContentType() => $_has(3);
  void clearContentType() => clearField(4);
}

class NetUploadSigned extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetUploadSigned',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'requestMethod')
    ..aOS(2, 'requestUrl')
    ..aOB(9, 'fileExists')
    ..aOS(10, 'uploadKey')
    ..aOS(11, 'coverUrl')
    ..aOS(12, 'thumbnailUrl')
    ..hasRequiredFields = false;

  NetUploadSigned() : super();
  NetUploadSigned.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadSigned.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadSigned clone() => new NetUploadSigned()..mergeFromMessage(this);
  NetUploadSigned copyWith(void Function(NetUploadSigned) updates) =>
      super.copyWith((message) => updates(message as NetUploadSigned));
  $pb.BuilderInfo get info_ => _i;
  static NetUploadSigned create() => new NetUploadSigned();
  NetUploadSigned createEmptyInstance() => create();
  static $pb.PbList<NetUploadSigned> createRepeated() =>
      new $pb.PbList<NetUploadSigned>();
  static NetUploadSigned getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetUploadSigned _defaultInstance;
  static void $checkItem(NetUploadSigned v) {
    if (v is! NetUploadSigned) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get requestMethod => $_getS(0, '');
  set requestMethod(String v) {
    $_setString(0, v);
  }

  bool hasRequestMethod() => $_has(0);
  void clearRequestMethod() => clearField(1);

  String get requestUrl => $_getS(1, '');
  set requestUrl(String v) {
    $_setString(1, v);
  }

  bool hasRequestUrl() => $_has(1);
  void clearRequestUrl() => clearField(2);

  bool get fileExists => $_get(2, false);
  set fileExists(bool v) {
    $_setBool(2, v);
  }

  bool hasFileExists() => $_has(2);
  void clearFileExists() => clearField(9);

  String get uploadKey => $_getS(3, '');
  set uploadKey(String v) {
    $_setString(3, v);
  }

  bool hasUploadKey() => $_has(3);
  void clearUploadKey() => clearField(10);

  String get coverUrl => $_getS(4, '');
  set coverUrl(String v) {
    $_setString(4, v);
  }

  bool hasCoverUrl() => $_has(4);
  void clearCoverUrl() => clearField(11);

  String get thumbnailUrl => $_getS(5, '');
  set thumbnailUrl(String v) {
    $_setString(5, v);
  }

  bool hasThumbnailUrl() => $_has(5);
  void clearThumbnailUrl() => clearField(12);
}
