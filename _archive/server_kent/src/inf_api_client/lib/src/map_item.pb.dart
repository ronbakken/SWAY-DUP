///
//  Generated code. Do not modify.
//  source: map_item.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'location.pb.dart' as $2;

import 'map_item.pbenum.dart';

export 'map_item.pbenum.dart';

enum MapItemDto_Payload {
  offer, 
  user, 
  notSet
}

class MapItemDto extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, MapItemDto_Payload> _MapItemDto_PayloadByTag = {
    4 : MapItemDto_Payload.offer,
    5 : MapItemDto_Payload.user,
    0 : MapItemDto_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MapItemDto', package: const $pb.PackageName('api'))
    ..a<$2.GeoPointDto>(1, 'geoPoint', $pb.PbFieldType.OM, $2.GeoPointDto.getDefault, $2.GeoPointDto.create)
    ..e<MapItemDto_MapItemStatus>(2, 'status', $pb.PbFieldType.OE, MapItemDto_MapItemStatus.inactive, MapItemDto_MapItemStatus.valueOf, MapItemDto_MapItemStatus.values)
    ..a<OfferMapItemDto>(4, 'offer', $pb.PbFieldType.OM, OfferMapItemDto.getDefault, OfferMapItemDto.create)
    ..a<UserMapItemDto>(5, 'user', $pb.PbFieldType.OM, UserMapItemDto.getDefault, UserMapItemDto.create)
    ..oo(0, [4, 5])
    ..hasRequiredFields = false
  ;

  MapItemDto() : super();
  MapItemDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MapItemDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MapItemDto clone() => MapItemDto()..mergeFromMessage(this);
  MapItemDto copyWith(void Function(MapItemDto) updates) => super.copyWith((message) => updates(message as MapItemDto));
  $pb.BuilderInfo get info_ => _i;
  static MapItemDto create() => MapItemDto();
  MapItemDto createEmptyInstance() => create();
  static $pb.PbList<MapItemDto> createRepeated() => $pb.PbList<MapItemDto>();
  static MapItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static MapItemDto _defaultInstance;

  MapItemDto_Payload whichPayload() => _MapItemDto_PayloadByTag[$_whichOneof(0)];
  void clearPayload() => clearField($_whichOneof(0));

  $2.GeoPointDto get geoPoint => $_getN(0);
  set geoPoint($2.GeoPointDto v) { setField(1, v); }
  $core.bool hasGeoPoint() => $_has(0);
  void clearGeoPoint() => clearField(1);

  MapItemDto_MapItemStatus get status => $_getN(1);
  set status(MapItemDto_MapItemStatus v) { setField(2, v); }
  $core.bool hasStatus() => $_has(1);
  void clearStatus() => clearField(2);

  OfferMapItemDto get offer => $_getN(2);
  set offer(OfferMapItemDto v) { setField(4, v); }
  $core.bool hasOffer() => $_has(2);
  void clearOffer() => clearField(4);

  UserMapItemDto get user => $_getN(3);
  set user(UserMapItemDto v) { setField(5, v); }
  $core.bool hasUser() => $_has(3);
  void clearUser() => clearField(5);
}

class OfferMapItemDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OfferMapItemDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'offerId')
    ..hasRequiredFields = false
  ;

  OfferMapItemDto() : super();
  OfferMapItemDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferMapItemDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferMapItemDto clone() => OfferMapItemDto()..mergeFromMessage(this);
  OfferMapItemDto copyWith(void Function(OfferMapItemDto) updates) => super.copyWith((message) => updates(message as OfferMapItemDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferMapItemDto create() => OfferMapItemDto();
  OfferMapItemDto createEmptyInstance() => create();
  static $pb.PbList<OfferMapItemDto> createRepeated() => $pb.PbList<OfferMapItemDto>();
  static OfferMapItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferMapItemDto _defaultInstance;

  $core.String get offerId => $_getS(0, '');
  set offerId($core.String v) { $_setString(0, v); }
  $core.bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);
}

class UserMapItemDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UserMapItemDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'userId')
    ..hasRequiredFields = false
  ;

  UserMapItemDto() : super();
  UserMapItemDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UserMapItemDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UserMapItemDto clone() => UserMapItemDto()..mergeFromMessage(this);
  UserMapItemDto copyWith(void Function(UserMapItemDto) updates) => super.copyWith((message) => updates(message as UserMapItemDto));
  $pb.BuilderInfo get info_ => _i;
  static UserMapItemDto create() => UserMapItemDto();
  UserMapItemDto createEmptyInstance() => create();
  static $pb.PbList<UserMapItemDto> createRepeated() => $pb.PbList<UserMapItemDto>();
  static UserMapItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static UserMapItemDto _defaultInstance;

  $core.String get userId => $_getS(0, '');
  set userId($core.String v) { $_setString(0, v); }
  $core.bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);
}

