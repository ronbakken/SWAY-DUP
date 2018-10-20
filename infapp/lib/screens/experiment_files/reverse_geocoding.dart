/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

Future<String> coordinatesToAddress(double latitude, double longitude) async {
  // Mapbox endpoint for reverse geocoding
  // /geocoding/v5/{mode}/{longitude},{latitude}.json
  String url = "https://api.mapbox.com/geocoding/v5/"
      "mapbox.places/$longitude,$latitude.json?"
      "access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA";

  // Get Response from Geocode Request 'GET'
  Response response = await get(url);

  // Check if connection is successful
  if (response.statusCode == 200) {
    // If the request was successful, parse the JSON
    print('Success!');
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to retrieve location');
  }

  // Decode info from source
  dynamic doc = json.decode(response.body);

  // Get 'features' from info
  dynamic features = doc['features'];

  // Iterate through each 'feature'
  for (dynamic feature in features) {
    // Get place_name of each feature
    dynamic placeName = feature['place_name'];

    // print for test results
    print(placeName);

    // return the first place given by the feature
    return placeName;
  }
}

/* end of file */
