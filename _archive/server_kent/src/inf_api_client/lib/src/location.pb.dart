///
//  Generated code. Do not modify.
//  source: location.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class GeoPointDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GeoPointDto', package: const $pb.PackageName('api'))
    ..a<$core.double>(1, 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  GeoPointDto() : super();
  GeoPointDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GeoPointDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GeoPointDto clone() => GeoPointDto()..mergeFromMessage(this);
  GeoPointDto copyWith(void Function(GeoPointDto) updates) => super.copyWith((message) => updates(message as GeoPointDto));
  $pb.BuilderInfo get info_ => _i;
  static GeoPointDto create() => GeoPointDto();
  GeoPointDto createEmptyInstance() => create();
  static $pb.PbList<GeoPointDto> createRepeated() => $pb.PbList<GeoPointDto>();
  static GeoPointDto getDefault() => _defaultInstance ??= create()..freeze();
  static GeoPointDto _defaultInstance;

  $core.double get latitude => $_getN(0);
  set latitude($core.double v) { $_setDouble(0, v); }
  $core.bool hasLatitude() => $_has(0);
  void clearLatitude() => clearField(1);

  $core.double get longitude => $_getN(1);
  set longitude($core.double v) { $_setDouble(1, v); }
  $core.bool hasLongitude() => $_has(1);
  void clearLongitude() => clearField(2);
}

class LocationDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('LocationDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'name')
    ..a<GeoPointDto>(2, 'geoPoint', $pb.PbFieldType.OM, GeoPointDto.getDefault, GeoPointDto.create)
    ..hasRequiredFields = false
  ;

  LocationDto() : super();
  LocationDto.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  LocationDto.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  LocationDto clone() => LocationDto()..mergeFromMessage(this);
  LocationDto copyWith(void Function(LocationDto) updates) => super.copyWith((message) => updates(message as LocationDto));
  $pb.BuilderInfo get info_ => _i;
  static LocationDto create() => LocationDto();
  LocationDto createEmptyInstance() => create();
  static $pb.PbList<LocationDto> createRepeated() => $pb.PbList<LocationDto>();
  static LocationDto getDefault() => _defaultInstance ??= create()..freeze();
  static LocationDto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) { $_setString(0, v); }
  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  GeoPointDto get geoPoint => $_getN(1);
  set geoPoint(GeoPointDto v) { setField(2, v); }
  $core.bool hasGeoPoint() => $_has(1);
  void clearGeoPoint() => clearField(2);
}

