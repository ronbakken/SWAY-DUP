///
//  Generated code. Do not modify.
//  source: net_storage_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class NetUploadImage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetUploadImage',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileName',
        protoName: 'fileName')
    ..a<$core.int>(
        2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contentLength', $pb.PbFieldType.O3,
        protoName: 'contentLength')
    ..a<$core.List<$core.int>>(
        3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contentSha256', $pb.PbFieldType.OY,
        protoName: 'contentSha256')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contentType', protoName: 'contentType')
    ..hasRequiredFields = false;

  NetUploadImage._() : super();
  factory NetUploadImage() => create();
  factory NetUploadImage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetUploadImage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetUploadImage clone() => NetUploadImage()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetUploadImage copyWith(void Function(NetUploadImage) updates) =>
      super.copyWith((message) =>
          updates(message as NetUploadImage)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetUploadImage create() => NetUploadImage._();
  NetUploadImage createEmptyInstance() => create();
  static $pb.PbList<NetUploadImage> createRepeated() =>
      $pb.PbList<NetUploadImage>();
  @$core.pragma('dart2js:noInline')
  static NetUploadImage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetUploadImage>(create);
  static NetUploadImage _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileName => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileName($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasFileName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileName() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get contentLength => $_getIZ(1);
  @$pb.TagNumber(2)
  set contentLength($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasContentLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentLength() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get contentSha256 => $_getN(2);
  @$pb.TagNumber(3)
  set contentSha256($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasContentSha256() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentSha256() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getSZ(3);
  @$pb.TagNumber(4)
  set contentType($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => clearField(4);
}

class NetUploadSigned extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetUploadSigned',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requestMethod',
        protoName: 'requestMethod')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requestUrl',
        protoName: 'requestUrl')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileExists',
        protoName: 'fileExists')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uploadKey',
        protoName: 'uploadKey')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coverUrl', protoName: 'coverUrl')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'thumbnailUrl', protoName: 'thumbnailUrl')
    ..hasRequiredFields = false;

  NetUploadSigned._() : super();
  factory NetUploadSigned() => create();
  factory NetUploadSigned.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetUploadSigned.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetUploadSigned clone() => NetUploadSigned()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetUploadSigned copyWith(void Function(NetUploadSigned) updates) =>
      super.copyWith((message) =>
          updates(message as NetUploadSigned)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetUploadSigned create() => NetUploadSigned._();
  NetUploadSigned createEmptyInstance() => create();
  static $pb.PbList<NetUploadSigned> createRepeated() =>
      $pb.PbList<NetUploadSigned>();
  @$core.pragma('dart2js:noInline')
  static NetUploadSigned getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetUploadSigned>(create);
  static NetUploadSigned _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestMethod => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestMethod($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRequestMethod() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestMethod() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestUrl($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRequestUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestUrl() => clearField(2);

  @$pb.TagNumber(9)
  $core.bool get fileExists => $_getBF(2);
  @$pb.TagNumber(9)
  set fileExists($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasFileExists() => $_has(2);
  @$pb.TagNumber(9)
  void clearFileExists() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get uploadKey => $_getSZ(3);
  @$pb.TagNumber(10)
  set uploadKey($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasUploadKey() => $_has(3);
  @$pb.TagNumber(10)
  void clearUploadKey() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get coverUrl => $_getSZ(4);
  @$pb.TagNumber(11)
  set coverUrl($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasCoverUrl() => $_has(4);
  @$pb.TagNumber(11)
  void clearCoverUrl() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get thumbnailUrl => $_getSZ(5);
  @$pb.TagNumber(12)
  set thumbnailUrl($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasThumbnailUrl() => $_has(5);
  @$pb.TagNumber(12)
  void clearThumbnailUrl() => clearField(12);
}
