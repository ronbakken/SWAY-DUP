///
//  Generated code. Do not modify.
//  source: location.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class GeoPointDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GeoPointDto', package: const $pb.PackageName('api'))
    ..a<double>(1, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(2, 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  GeoPointDto() : super();
  GeoPointDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GeoPointDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GeoPointDto clone() => new GeoPointDto()..mergeFromMessage(this);
  GeoPointDto copyWith(void Function(GeoPointDto) updates) => super.copyWith((message) => updates(message as GeoPointDto));
  $pb.BuilderInfo get info_ => _i;
  static GeoPointDto create() => new GeoPointDto();
  GeoPointDto createEmptyInstance() => create();
  static $pb.PbList<GeoPointDto> createRepeated() => new $pb.PbList<GeoPointDto>();
  static GeoPointDto getDefault() => _defaultInstance ??= create()..freeze();
  static GeoPointDto _defaultInstance;
  static void $checkItem(GeoPointDto v) {
    if (v is! GeoPointDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  double get latitude => $_getN(0);
  set latitude(double v) { $_setDouble(0, v); }
  bool hasLatitude() => $_has(0);
  void clearLatitude() => clearField(1);

  double get longitude => $_getN(1);
  set longitude(double v) { $_setDouble(1, v); }
  bool hasLongitude() => $_has(1);
  void clearLongitude() => clearField(2);
}

class LocationDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LocationDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'name')
    ..a<GeoPointDto>(2, 'geoPoint', $pb.PbFieldType.OM, GeoPointDto.getDefault, GeoPointDto.create)
    ..hasRequiredFields = false
  ;

  LocationDto() : super();
  LocationDto.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LocationDto.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LocationDto clone() => new LocationDto()..mergeFromMessage(this);
  LocationDto copyWith(void Function(LocationDto) updates) => super.copyWith((message) => updates(message as LocationDto));
  $pb.BuilderInfo get info_ => _i;
  static LocationDto create() => new LocationDto();
  LocationDto createEmptyInstance() => create();
  static $pb.PbList<LocationDto> createRepeated() => new $pb.PbList<LocationDto>();
  static LocationDto getDefault() => _defaultInstance ??= create()..freeze();
  static LocationDto _defaultInstance;
  static void $checkItem(LocationDto v) {
    if (v is! LocationDto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) { $_setString(0, v); }
  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  GeoPointDto get geoPoint => $_getN(1);
  set geoPoint(GeoPointDto v) { setField(2, v); }
  bool hasGeoPoint() => $_has(1);
  void clearGeoPoint() => clearField(2);
}

