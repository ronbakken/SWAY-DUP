import 'package:inf_api_client/inf_api_client.dart';

class Location {
  final String name;

  final double latitude;
  final double longitude;

  Location.fromDto(LocationDto dto)
      : name = dto.name,
        latitude = dto.geoPoint.latitude,
        longitude = dto.geoPoint.longitude;

  LocationDto toDto() {
    return LocationDto()
      ..name = name
      ..geoPoint = (GeoPointDto()
        ..latitude = latitude
        ..longitude = longitude);
  }

  Location({
    this.name,
    this.latitude,
    this.longitude,
  });

  Location copyWidth({
    String name,
    double latitude,
    double longitude,
  }) {
    return Location(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
