import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import '../../network/inf.pb.dart';

Future<String> coordinatesToAddress(double latitude, double longitude) async {
  // Mapbox endpoint for reverse geocoding
  // /geocoding/v5/{mode}/{longitude},{latitude}.json
  String url = "https://api.mapbox.com/geocoding/v5/"
      "mapbox.places/$longitude,$latitude.json?"
      "access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA";

  // Get Response from Geocode Request
  Response response = await get(url);

  if (response.statusCode == 200) {
    // If the request was successful, parse the JSON
    
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to retrieve location');
  }

  print(response.body);
}
