import 'package:inf_api_client/inf_api_client.dart';

class Location {
  final String name;
  final String description;

  final double latitude;
  final double longitude;

  Location(LocationDto dto)
      : name = dto.name,
        description = dto.description,
        latitude = dto.latitude,
        longitude = dto.longitude;
}
