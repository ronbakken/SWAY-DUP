///
//  Generated code. Do not modify.
//  source: net_storage_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

class NetUploadImageReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetUploadImageReq',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'fileName')
    ..a<int>(2, 'contentLength', $pb.PbFieldType.O3)
    ..a<List<int>>(3, 'contentSha256', $pb.PbFieldType.OY)
    ..aOS(4, 'contentType')
    ..hasRequiredFields = false;

  NetUploadImageReq() : super();
  NetUploadImageReq.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadImageReq.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadImageReq clone() => new NetUploadImageReq()..mergeFromMessage(this);
  NetUploadImageReq copyWith(void Function(NetUploadImageReq) updates) =>
      super.copyWith((message) => updates(message as NetUploadImageReq));
  $pb.BuilderInfo get info_ => _i;
  static NetUploadImageReq create() => new NetUploadImageReq();
  static $pb.PbList<NetUploadImageReq> createRepeated() =>
      new $pb.PbList<NetUploadImageReq>();
  static NetUploadImageReq getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetUploadImageReq _defaultInstance;
  static void $checkItem(NetUploadImageReq v) {
    if (v is! NetUploadImageReq) $pb.checkItemFailed(v, _i.messageName);
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

class NetUploadImageRes extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetUploadImageRes',
      package: const $pb.PackageName('inf'))
    ..aOS(1, 'requestMethod')
    ..aOS(2, 'requestUrl')
    ..aOB(9, 'fileExists')
    ..aOS(10, 'uploadKey')
    ..aOS(11, 'coverUrl')
    ..aOS(12, 'thumbnailUrl')
    ..hasRequiredFields = false;

  NetUploadImageRes() : super();
  NetUploadImageRes.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetUploadImageRes.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetUploadImageRes clone() => new NetUploadImageRes()..mergeFromMessage(this);
  NetUploadImageRes copyWith(void Function(NetUploadImageRes) updates) =>
      super.copyWith((message) => updates(message as NetUploadImageRes));
  $pb.BuilderInfo get info_ => _i;
  static NetUploadImageRes create() => new NetUploadImageRes();
  static $pb.PbList<NetUploadImageRes> createRepeated() =>
      new $pb.PbList<NetUploadImageRes>();
  static NetUploadImageRes getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetUploadImageRes _defaultInstance;
  static void $checkItem(NetUploadImageRes v) {
    if (v is! NetUploadImageRes) $pb.checkItemFailed(v, _i.messageName);
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
