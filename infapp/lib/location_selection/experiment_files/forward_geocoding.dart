import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

Future<String> coordinatesToAddress(String address) async {
  // Mapbox endpoint for reverse geocoding
  // /geocoding/v5/{mode}/{address}.json
  String url = "https://api.mapbox.com/geocoding/v5/"
      "mapbox.places/$address.json?"
      "access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA";

  // Get Response from Geocode Request 'GET'
  Response response = await get(url);

  // Check if connection is successful
  if (response.statusCode != 200) {
    // If that call was not successful, throw an error.
    throw Exception('Failed to retrieve location');
  }

  // Decode info from source
  dynamic doc = json.decode(response.body);
}
