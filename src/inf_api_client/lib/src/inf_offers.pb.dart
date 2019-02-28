///
//  Generated code. Do not modify.
//  source: inf_offers.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'offer.pb.dart' as $9;

class UpdateOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateOfferRequest', package: const $pb.PackageName('api'))
    ..a<$9.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $9.OfferDto.getDefault, $9.OfferDto.create)
    ..hasRequiredFields = false
  ;

  UpdateOfferRequest() : super();
  UpdateOfferRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateOfferRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateOfferRequest clone() => new UpdateOfferRequest()..mergeFromMessage(this);
  UpdateOfferRequest copyWith(void Function(UpdateOfferRequest) updates) => super.copyWith((message) => updates(message as UpdateOfferRequest));
  $pb.BuilderInfo get info_ => _i;
  static UpdateOfferRequest create() => new UpdateOfferRequest();
  UpdateOfferRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferRequest> createRepeated() => new $pb.PbList<UpdateOfferRequest>();
  static UpdateOfferRequest getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateOfferRequest _defaultInstance;
  static void $checkItem(UpdateOfferRequest v) {
    if (v is! UpdateOfferRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $9.OfferDto get offer => $_getN(0);
  set offer($9.OfferDto v) { setField(1, v); }
  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class UpdateOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UpdateOfferResponse', package: const $pb.PackageName('api'))
    ..a<$9.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $9.OfferDto.getDefault, $9.OfferDto.create)
    ..hasRequiredFields = false
  ;

  UpdateOfferResponse() : super();
  UpdateOfferResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UpdateOfferResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UpdateOfferResponse clone() => new UpdateOfferResponse()..mergeFromMessage(this);
  UpdateOfferResponse copyWith(void Function(UpdateOfferResponse) updates) => super.copyWith((message) => updates(message as UpdateOfferResponse));
  $pb.BuilderInfo get info_ => _i;
  static UpdateOfferResponse create() => new UpdateOfferResponse();
  UpdateOfferResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateOfferResponse> createRepeated() => new $pb.PbList<UpdateOfferResponse>();
  static UpdateOfferResponse getDefault() => _defaultInstance ??= create()..freeze();
  static UpdateOfferResponse _defaultInstance;
  static void $checkItem(UpdateOfferResponse v) {
    if (v is! UpdateOfferResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $9.OfferDto get offer => $_getN(0);
  set offer($9.OfferDto v) { setField(1, v); }
  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

class GetOfferRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetOfferRequest', package: const $pb.PackageName('api'))
    ..aOS(1, 'id')
    ..hasRequiredFields = false
  ;

  GetOfferRequest() : super();
  GetOfferRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetOfferRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetOfferRequest clone() => new GetOfferRequest()..mergeFromMessage(this);
  GetOfferRequest copyWith(void Function(GetOfferRequest) updates) => super.copyWith((message) => updates(message as GetOfferRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetOfferRequest create() => new GetOfferRequest();
  GetOfferRequest createEmptyInstance() => create();
  static $pb.PbList<GetOfferRequest> createRepeated() => new $pb.PbList<GetOfferRequest>();
  static GetOfferRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetOfferRequest _defaultInstance;
  static void $checkItem(GetOfferRequest v) {
    if (v is! GetOfferRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);
}

class GetOfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetOfferResponse', package: const $pb.PackageName('api'))
    ..a<$9.OfferDto>(1, 'offer', $pb.PbFieldType.OM, $9.OfferDto.getDefault, $9.OfferDto.create)
    ..hasRequiredFields = false
  ;

  GetOfferResponse() : super();
  GetOfferResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetOfferResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetOfferResponse clone() => new GetOfferResponse()..mergeFromMessage(this);
  GetOfferResponse copyWith(void Function(GetOfferResponse) updates) => super.copyWith((message) => updates(message as GetOfferResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetOfferResponse create() => new GetOfferResponse();
  GetOfferResponse createEmptyInstance() => create();
  static $pb.PbList<GetOfferResponse> createRepeated() => new $pb.PbList<GetOfferResponse>();
  static GetOfferResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetOfferResponse _defaultInstance;
  static void $checkItem(GetOfferResponse v) {
    if (v is! GetOfferResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $9.OfferDto get offer => $_getN(0);
  set offer($9.OfferDto v) { setField(1, v); }
  bool hasOffer() => $_has(0);
  void clearOffer() => clearField(1);
}

