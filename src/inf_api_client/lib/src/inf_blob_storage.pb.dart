///
//  Generated code. Do not modify.
//  source: inf_blob_storage.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class GetUploadUrlRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetUploadUrlRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'fileName')
    ..hasRequiredFields = false
  ;

  GetUploadUrlRequest() : super();
  GetUploadUrlRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUploadUrlRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUploadUrlRequest clone() => new GetUploadUrlRequest()..mergeFromMessage(this);
  GetUploadUrlRequest copyWith(void Function(GetUploadUrlRequest) updates) => super.copyWith((message) => updates(message as GetUploadUrlRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetUploadUrlRequest create() => new GetUploadUrlRequest();
  GetUploadUrlRequest createEmptyInstance() => create();
  static $pb.PbList<GetUploadUrlRequest> createRepeated() => new $pb.PbList<GetUploadUrlRequest>();
  static GetUploadUrlRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetUploadUrlRequest _defaultInstance;
  static void $checkItem(GetUploadUrlRequest v) {
    if (v is! GetUploadUrlRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get fileName => $_getS(0, '');
  set fileName(String v) { $_setString(0, v); }
  bool hasFileName() => $_has(0);
  void clearFileName() => clearField(1);
}

class GetUploadUrlResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetUploadUrlResponse', package: const $pb.PackageName('api'))
    ..aOS(1, 'uploadUrl')
    ..aOS(2, 'publicUrl')
    ..hasRequiredFields = false
  ;

  GetUploadUrlResponse() : super();
  GetUploadUrlResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetUploadUrlResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetUploadUrlResponse clone() => new GetUploadUrlResponse()..mergeFromMessage(this);
  GetUploadUrlResponse copyWith(void Function(GetUploadUrlResponse) updates) => super.copyWith((message) => updates(message as GetUploadUrlResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetUploadUrlResponse create() => new GetUploadUrlResponse();
  GetUploadUrlResponse createEmptyInstance() => create();
  static $pb.PbList<GetUploadUrlResponse> createRepeated() => new $pb.PbList<GetUploadUrlResponse>();
  static GetUploadUrlResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetUploadUrlResponse _defaultInstance;
  static void $checkItem(GetUploadUrlResponse v) {
    if (v is! GetUploadUrlResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get uploadUrl => $_getS(0, '');
  set uploadUrl(String v) { $_setString(0, v); }
  bool hasUploadUrl() => $_has(0);
  void clearUploadUrl() => clearField(1);

  String get publicUrl => $_getS(1, '');
  set publicUrl(String v) { $_setString(1, v); }
  bool hasPublicUrl() => $_has(1);
  void clearPublicUrl() => clearField(2);
}

