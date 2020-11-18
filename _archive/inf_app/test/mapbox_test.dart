import 'package:flutter_test/flutter_test.dart';
import 'package:inf/backend/services/location_service_mock.dart';

void main() {
  test('Simple Geocoding', () async {
      LocationServiceMock locationService = LocationServiceMock();

      var response = await locationService.lookupMapBoxPlaces(null,'Bonn; Friesdorfer Straße 70');
      print(response);
  });

  test('Simple ReverseGeocoding', () async {
      LocationServiceMock locationService = LocationServiceMock();

      var response = await locationService.lookupMapBoxCoordinates(locationService.lastLocation);
      print(response);
  });
}
