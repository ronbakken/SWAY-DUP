///
//  Generated code. Do not modify.
//  source: inf_blob_storage.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class GetUploadUrlRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetUploadUrlRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'fileName')
    ..hasRequiredFields = false
  ;

  GetUploadUrlRequest() : super();
  GetUploadUrlRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUploadUrlRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUploadUrlRequest clone() => GetUploadUrlRequest()..mergeFromMessage(this);
  GetUploadUrlRequest copyWith(void Function(GetUploadUrlRequest) updates) => super.copyWith((message) => updates(message as GetUploadUrlRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetUploadUrlRequest create() => GetUploadUrlRequest();
  GetUploadUrlRequest createEmptyInstance() => create();
  static $pb.PbList<GetUploadUrlRequest> createRepeated() => $pb.PbList<GetUploadUrlRequest>();
  static GetUploadUrlRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetUploadUrlRequest _defaultInstance;

  $core.String get fileName => $_getS(0, '');
  set fileName($core.String v) { $_setString(0, v); }
  $core.bool hasFileName() => $_has(0);
  void clearFileName() => clearField(1);
}

class GetUploadUrlResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetUploadUrlResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'uploadUrl')
    ..aOS(2, 'publicUrl')
    ..hasRequiredFields = false
  ;

  GetUploadUrlResponse() : super();
  GetUploadUrlResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUploadUrlResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUploadUrlResponse clone() => GetUploadUrlResponse()..mergeFromMessage(this);
  GetUploadUrlResponse copyWith(void Function(GetUploadUrlResponse) updates) => super.copyWith((message) => updates(message as GetUploadUrlResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetUploadUrlResponse create() => GetUploadUrlResponse();
  GetUploadUrlResponse createEmptyInstance() => create();
  static $pb.PbList<GetUploadUrlResponse> createRepeated() => $pb.PbList<GetUploadUrlResponse>();
  static GetUploadUrlResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetUploadUrlResponse _defaultInstance;

  $core.String get uploadUrl => $_getS(0, '');
  set uploadUrl($core.String v) { $_setString(0, v); }
  $core.bool hasUploadUrl() => $_has(0);
  void clearUploadUrl() => clearField(1);

  $core.String get publicUrl => $_getS(1, '');
  set publicUrl($core.String v) { $_setString(1, v); }
  $core.bool hasPublicUrl() => $_has(1);
  void clearPublicUrl() => clearField(2);
}

