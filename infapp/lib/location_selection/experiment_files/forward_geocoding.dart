import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

Future<List<String>> coordinatesToAddress(String address) async {
  // Mapbox endpoint for reverse geocoding
  // /geocoding/v5/{mode}/{address}.json
  String url = "https://api.mapbox.com/geocoding/v5/"
      "mapbox.places/$address.json?"
      "autocomplete=true&"
      "access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA";

  // Get Response from Forward Geocode Request 'GET'
  Response response = await get(url);

  // Check if connection is successful
  if (response.statusCode != 200) {
    // If that call was not successful, throw an error.
    throw Exception('Failed to retrieve location');
  }

  // Decode json
  dynamic doc = json.decode(response.body);

  // Get 'features' from info
  dynamic features = doc['features'];

  // Make a list of places for search results
  List<String> placeName = new List<String>();

  // Iterate through each 'feature'
  for (dynamic feature in features) {
    // Add each placename from features
    placeName.add(feature['place_name']);
  }

  // return list of places
  return placeName;
}
