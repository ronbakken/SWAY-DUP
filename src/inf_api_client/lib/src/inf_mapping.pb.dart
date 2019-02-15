///
//  Generated code. Do not modify.
//  source: inf_mapping.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'location.pb.dart' as $1;

import 'inf_mapping.pbenum.dart';

export 'inf_mapping.pbenum.dart';

class SearchRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SearchRequest', package: const $pb.PackageName('api'))
    ..pp<SearchRequest_ItemType>(1, 'itemTypes', $pb.PbFieldType.PE, SearchRequest_ItemType.$checkItem, null, SearchRequest_ItemType.valueOf, SearchRequest_ItemType.values)
    ..a<int>(2, 'mapLevel', $pb.PbFieldType.O3)
    ..a<$1.GeoPointDto>(3, 'northWest', $pb.PbFieldType.OM, $1.GeoPointDto.getDefault, $1.GeoPointDto.create)
    ..a<$1.GeoPointDto>(4, 'southEast', $pb.PbFieldType.OM, $1.GeoPointDto.getDefault, $1.GeoPointDto.create)
    ..hasRequiredFields = false
  ;

  SearchRequest() : super();
  SearchRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SearchRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SearchRequest clone() => new SearchRequest()..mergeFromMessage(this);
  SearchRequest copyWith(void Function(SearchRequest) updates) => super.copyWith((message) => updates(message as SearchRequest));
  $pb.BuilderInfo get info_ => _i;
  static SearchRequest create() => new SearchRequest();
  SearchRequest createEmptyInstance() => create();
  static $pb.PbList<SearchRequest> createRepeated() => new $pb.PbList<SearchRequest>();
  static SearchRequest getDefault() => _defaultInstance ??= create()..freeze();
  static SearchRequest _defaultInstance;
  static void $checkItem(SearchRequest v) {
    if (v is! SearchRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<SearchRequest_ItemType> get itemTypes => $_getList(0);

  int get mapLevel => $_get(1, 0);
  set mapLevel(int v) { $_setSignedInt32(1, v); }
  bool hasMapLevel() => $_has(1);
  void clearMapLevel() => clearField(2);

  $1.GeoPointDto get northWest => $_getN(2);
  set northWest($1.GeoPointDto v) { setField(3, v); }
  bool hasNorthWest() => $_has(2);
  void clearNorthWest() => clearField(3);

  $1.GeoPointDto get southEast => $_getN(3);
  set southEast($1.GeoPointDto v) { setField(4, v); }
  bool hasSouthEast() => $_has(3);
  void clearSouthEast() => clearField(4);
}

class SearchResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SearchResponse', package: const $pb.PackageName('api'))
    ..pp<MapItemDto>(1, 'mapItems', $pb.PbFieldType.PM, MapItemDto.$checkItem, MapItemDto.create)
    ..hasRequiredFields = false
  ;

  SearchResponse() : super();
  SearchResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SearchResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SearchResponse clone() => new SearchResponse()..mergeFromMessage(this);
  SearchResponse copyWith(void Function(SearchResponse) updates) => super.copyWith((message) => updates(message as SearchResponse));
  $pb.BuilderInfo get info_ => _i;
  static SearchResponse create() => new SearchResponse();
  SearchResponse createEmptyInstance() => create();
  static $pb.PbList<SearchResponse> createRepeated() => new $pb.PbList<SearchResponse>();
  static SearchResponse getDefault() => _defaultInstance ??= create()..freeze();
  static SearchResponse _defaultInstance;
  static void $checkItem(SearchResponse v) {
    if (v is! SearchResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<MapItemDto> get mapItems => $_getList(0);
}

enum MapItemDto_Payload {
  offer, 
  user, 
  cluster, 
  notSet
}

class MapItemDto extends $pb.GeneratedMessage {
  static const Map<int, MapItemDto_Payload> _MapItemDto_PayloadByTag = {
    4 : MapItemDto_Payload.offer,
    5 : MapItemDto_Payload.user,
    6 : MapItemDto_Payload.cluster,
    0 : MapItemDto_Payload.notSet
  };
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MapItemDto', package: const $pb.PackageName('api'))
    ..a<$1.GeoPointDto>(1, 'geoPoint', $pb.PbFieldType.OM, $1.GeoPointDto.getDefault, $1.GeoPointDto.create)
    ..e<MapItemDto_MapItemStatus>(2, 'status', $pb.PbFieldType.OE, MapItemDto_MapItemStatus.inactive, MapItemDto_MapItemStatus.valueOf, MapItemDto_MapItemStatus.values)
    ..aOS(3, 'parentClusterId')
    ..a<OfferMapItemDto>(4, 'offer', $pb.PbFieldType.OM, OfferMapItemDto.getDefault, OfferMapItemDto.create)
    ..a<UserMapItemDto>(5, 'user', $pb.PbFieldType.OM, UserMapItemDto.getDefault, UserMapItemDto.create)
    ..a<ClusterMapItemDto>(6, 'cluster', $pb.PbFieldType.OM, ClusterMapItemDto.getDefault, ClusterMapItemDto.create)
    ..oo(0, [4, 5, 6])
    ..hasRequiredFields = false
  ;

  MapItemDto() : super();
  MapItemDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MapItemDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MapItemDto clone() => new MapItemDto()..mergeFromMessage(this);
  MapItemDto copyWith(void Function(MapItemDto) updates) => super.copyWith((message) => updates(message as MapItemDto));
  $pb.BuilderInfo get info_ => _i;
  static MapItemDto create() => new MapItemDto();
  MapItemDto createEmptyInstance() => create();
  static $pb.PbList<MapItemDto> createRepeated() => new $pb.PbList<MapItemDto>();
  static MapItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static MapItemDto _defaultInstance;
  static void $checkItem(MapItemDto v) {
    if (v is! MapItemDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  MapItemDto_Payload whichPayload() => _MapItemDto_PayloadByTag[$_whichOneof(0)];
  void clearPayload() => clearField($_whichOneof(0));

  $1.GeoPointDto get geoPoint => $_getN(0);
  set geoPoint($1.GeoPointDto v) { setField(1, v); }
  bool hasGeoPoint() => $_has(0);
  void clearGeoPoint() => clearField(1);

  MapItemDto_MapItemStatus get status => $_getN(1);
  set status(MapItemDto_MapItemStatus v) { setField(2, v); }
  bool hasStatus() => $_has(1);
  void clearStatus() => clearField(2);

  String get parentClusterId => $_getS(2, '');
  set parentClusterId(String v) { $_setString(2, v); }
  bool hasParentClusterId() => $_has(2);
  void clearParentClusterId() => clearField(3);

  OfferMapItemDto get offer => $_getN(3);
  set offer(OfferMapItemDto v) { setField(4, v); }
  bool hasOffer() => $_has(3);
  void clearOffer() => clearField(4);

  UserMapItemDto get user => $_getN(4);
  set user(UserMapItemDto v) { setField(5, v); }
  bool hasUser() => $_has(4);
  void clearUser() => clearField(5);

  ClusterMapItemDto get cluster => $_getN(5);
  set cluster(ClusterMapItemDto v) { setField(6, v); }
  bool hasCluster() => $_has(5);
  void clearCluster() => clearField(6);
}

class OfferMapItemDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OfferMapItemDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'offerId')
    ..aOS(2, 'userId')
    ..hasRequiredFields = false
  ;

  OfferMapItemDto() : super();
  OfferMapItemDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  OfferMapItemDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  OfferMapItemDto clone() => new OfferMapItemDto()..mergeFromMessage(this);
  OfferMapItemDto copyWith(void Function(OfferMapItemDto) updates) => super.copyWith((message) => updates(message as OfferMapItemDto));
  $pb.BuilderInfo get info_ => _i;
  static OfferMapItemDto create() => new OfferMapItemDto();
  OfferMapItemDto createEmptyInstance() => create();
  static $pb.PbList<OfferMapItemDto> createRepeated() => new $pb.PbList<OfferMapItemDto>();
  static OfferMapItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static OfferMapItemDto _defaultInstance;
  static void $checkItem(OfferMapItemDto v) {
    if (v is! OfferMapItemDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get offerId => $_getS(0, '');
  set offerId(String v) { $_setString(0, v); }
  bool hasOfferId() => $_has(0);
  void clearOfferId() => clearField(1);

  String get userId => $_getS(1, '');
  set userId(String v) { $_setString(1, v); }
  bool hasUserId() => $_has(1);
  void clearUserId() => clearField(2);
}

class UserMapItemDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UserMapItemDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'userId')
    ..hasRequiredFields = false
  ;

  UserMapItemDto() : super();
  UserMapItemDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UserMapItemDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UserMapItemDto clone() => new UserMapItemDto()..mergeFromMessage(this);
  UserMapItemDto copyWith(void Function(UserMapItemDto) updates) => super.copyWith((message) => updates(message as UserMapItemDto));
  $pb.BuilderInfo get info_ => _i;
  static UserMapItemDto create() => new UserMapItemDto();
  UserMapItemDto createEmptyInstance() => create();
  static $pb.PbList<UserMapItemDto> createRepeated() => new $pb.PbList<UserMapItemDto>();
  static UserMapItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static UserMapItemDto _defaultInstance;
  static void $checkItem(UserMapItemDto v) {
    if (v is! UserMapItemDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get userId => $_getS(0, '');
  set userId(String v) { $_setString(0, v); }
  bool hasUserId() => $_has(0);
  void clearUserId() => clearField(1);
}

class ClusterMapItemDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ClusterMapItemDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'clusterId')
    ..a<int>(2, 'itemCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ClusterMapItemDto() : super();
  ClusterMapItemDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ClusterMapItemDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ClusterMapItemDto clone() => new ClusterMapItemDto()..mergeFromMessage(this);
  ClusterMapItemDto copyWith(void Function(ClusterMapItemDto) updates) => super.copyWith((message) => updates(message as ClusterMapItemDto));
  $pb.BuilderInfo get info_ => _i;
  static ClusterMapItemDto create() => new ClusterMapItemDto();
  ClusterMapItemDto createEmptyInstance() => create();
  static $pb.PbList<ClusterMapItemDto> createRepeated() => new $pb.PbList<ClusterMapItemDto>();
  static ClusterMapItemDto getDefault() => _defaultInstance ??= create()..freeze();
  static ClusterMapItemDto _defaultInstance;
  static void $checkItem(ClusterMapItemDto v) {
    if (v is! ClusterMapItemDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get clusterId => $_getS(0, '');
  set clusterId(String v) { $_setString(0, v); }
  bool hasClusterId() => $_has(0);
  void clearClusterId() => clearField(1);

  int get itemCount => $_get(1, 0);
  set itemCount(int v) { $_setSignedInt32(1, v); }
  bool hasItemCount() => $_has(1);
  void clearItemCount() => clearField(2);
}

