///
//  Generated code. Do not modify.
//  source: inf_api.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class HelloRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HelloRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'name')
    ..hasRequiredFields = false
  ;

  HelloRequest() : super();
  HelloRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  HelloRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  HelloRequest clone() => HelloRequest()..mergeFromMessage(this);
  HelloRequest copyWith(void Function(HelloRequest) updates) => super.copyWith((message) => updates(message as HelloRequest));
  $pb.BuilderInfo get info_ => _i;
  static HelloRequest create() => HelloRequest();
  HelloRequest createEmptyInstance() => create();
  static $pb.PbList<HelloRequest> createRepeated() => $pb.PbList<HelloRequest>();
  static HelloRequest getDefault() => _defaultInstance ??= create()..freeze();
  static HelloRequest _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) { $_setString(0, v); }
  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);
}

class HelloReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HelloReply', package: const $pb.PackageName('api'))
    ..aOS(1, 'message')
    ..hasRequiredFields = false
  ;

  HelloReply() : super();
  HelloReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  HelloReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  HelloReply clone() => HelloReply()..mergeFromMessage(this);
  HelloReply copyWith(void Function(HelloReply) updates) => super.copyWith((message) => updates(message as HelloReply));
  $pb.BuilderInfo get info_ => _i;
  static HelloReply create() => HelloReply();
  HelloReply createEmptyInstance() => create();
  static $pb.PbList<HelloReply> createRepeated() => $pb.PbList<HelloReply>();
  static HelloReply getDefault() => _defaultInstance ??= create()..freeze();
  static HelloReply _defaultInstance;

  $core.String get message => $_getS(0, '');
  set message($core.String v) { $_setString(0, v); }
  $core.bool hasMessage() => $_has(0);
  void clearMessage() => clearField(1);
}

