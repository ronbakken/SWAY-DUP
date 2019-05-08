///
//  Generated code. Do not modify.
//  source: inf_offers.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'offer.pb.dart' as $11;

class UpdateOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateOfferRequest', package: const $pb.PackageName('api'))
    ..a<$11.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $11.OfferDto.getDefault, $11.OfferDto.create)
    ..hasRequiredFields = false
  ;

  UpdateOfferRequest() : super();
  UpdateOfferRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateOfferRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateOfferRequest clone() => UpdateOfferRequest()..mergeFromMessage(this);
  UpdateOfferRequest copyWith(void Function(UpdateOfferRequest) updates) => super.copyWith((message) => updates(message as UpdateOfferRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateOfferRequest create() => UpdateOfferRequest();
  UpdateOfferRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferRequest> createRepeated() => $pb.PbList<UpdateOfferRequest>();
  static UpdateOfferRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateOfferRequest _defaultInstance;

  $11.OfferDto get offer => $_getN(0);
  set offer($11.OfferDto v) { setField(1, v); }
  $core.bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class UpdateOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateOfferResponse', package: const $pb.PackageName('api'))
    ..a<$11.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $11.OfferDto.getDefault, $11.OfferDto.create)
    ..hasRequiredFields = false
  ;

  UpdateOfferResponse() : super();
  UpdateOfferResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateOfferResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateOfferResponse clone() => UpdateOfferResponse()..mergeFromMessage(this);
  UpdateOfferResponse copyWith(void Function(UpdateOfferResponse) updates) => super.copyWith((message) => updates(message as UpdateOfferResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateOfferResponse create() => UpdateOfferResponse();
  UpdateOfferResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferResponse> createRepeated() => $pb.PbList<UpdateOfferResponse>();
  static UpdateOfferResponse getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateOfferResponse _defaultInstance;

  $11.OfferDto get offer => $_getN(0);
  set offer($11.OfferDto v) { setField(1, v); }
  $core.bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class GetOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetOfferRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..hasRequiredFields = false
  ;

  GetOfferRequest() : super();
  GetOfferRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetOfferRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetOfferRequest clone() => GetOfferRequest()..mergeFromMessage(this);
  GetOfferRequest copyWith(void Function(GetOfferRequest) updates) => super.copyWith((message) => updates(message as GetOfferRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetOfferRequest create() => GetOfferRequest();
  GetOfferRequest createEmptyInstance() => create();
  static $pb.PbList<GetOfferRequest> createRepeated() => $pb.PbList<GetOfferRequest>();
  static GetOfferRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetOfferRequest _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);
}

class GetOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetOfferResponse', package: const $pb.PackageName('api'))
    ..a<$11.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $11.OfferDto.getDefault, $11.OfferDto.create)
    ..hasRequiredFields = false
  ;

  GetOfferResponse() : super();
  GetOfferResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetOfferResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetOfferResponse clone() => GetOfferResponse()..mergeFromMessage(this);
  GetOfferResponse copyWith(void Function(GetOfferResponse) updates) => super.copyWith((message) => updates(message as GetOfferResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetOfferResponse create() => GetOfferResponse();
  GetOfferResponse createEmptyInstance() => create();
  static $pb.PbList<GetOfferResponse> createRepeated() => $pb.PbList<GetOfferResponse>();
  static GetOfferResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetOfferResponse _defaultInstance;

  $11.OfferDto get offer => $_getN(0);
  set offer($11.OfferDto v) { setField(1, v); }
  $core.bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

