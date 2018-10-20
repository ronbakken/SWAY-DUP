/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'dart:async';
import 'package:latlong/latlong.dart';
import 'dart:convert';
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

  // Decode json
  dynamic doc = json.decode(response.body);

  // Get 'features' from info
  dynamic features = doc['features'];

  // Get coordinated from the first feature
  dynamic coordinates = features[0]['center'];

  print(coordinates[1]);
  print(coordinates[0]);

  // return the coordinates
  // Note the json format is (long, lat), we want to return (lat, long)
  return new LatLng(coordinates[1], coordinates[0]);
}

/* end of file */
