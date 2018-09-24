import 'dart:async';
import 'package:latlong/latlong.dart';

import 'package:http/http.dart';

Future<LatLng> getCoordinates(String address) async {
  // Mapbox endpoint for forward geocoding
  // /geocoding/v5/{mode}/{address}.json
  String url = "https://api.mapbox.com/geocoding/v5/"
      "mapbox.places/$address.json?"
      "autocomplete=false&"
      "access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA";

  // Get Response from Forward Geocode Request 'GET'
  Response response = await get(url);

  // Check if connection is successful
  if (response.statusCode != 200) {
    // If that call was not successful, throw an error.
    throw Exception('Failed to retrieve location');
  }
}
