import 'package:inf_api_client/inf_api_client.dart';

class Location {
  final String name;

  final double latitude;
  final double longitude;

  Location.fromDto(LocationDto dto)
      : name = dto.name,
        latitude = dto.latitude,
        longitude = dto.longitude;

  LocationDto toDto()
  {
    return LocationDto()
      ..name = name
      ..latitude = latitude
      ..longitude = longitude;
  }


  Location({
    this.name,
    this.latitude,
    this.longitude,
  });
}
