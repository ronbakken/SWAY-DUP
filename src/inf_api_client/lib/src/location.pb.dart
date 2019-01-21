///
//  Generated code. Do not modify.
//  source: location.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class LocationDto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('LocationDto', package: const $pb.PackageName('api'))
    ..aOS(1, 'name')
    ..aOS(2, 'description')
    ..a<double>(3, 'latitude', $pb.PbFieldType.OD)
    ..a<double>(4, 'longitude', $pb.PbFieldType.OD)
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

  String get description => $_getS(1, '');
  set description(String v) { $_setString(1, v); }
  bool hasDescription() => $_has(1);
  void clearDescription() => clearField(2);

  double get latitude => $_getN(2);
  set latitude(double v) { $_setDouble(2, v); }
  bool hasLatitude() => $_has(2);
  void clearLatitude() => clearField(3);

  double get longitude => $_getN(3);
  set longitude(double v) { $_setDouble(3, v); }
  bool hasLongitude() => $_has(3);
  void clearLongitude() => clearField(4);
}

