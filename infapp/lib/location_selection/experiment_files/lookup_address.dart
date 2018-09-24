import 'dart:async';
import 'package:latlong/latlong.dart';

import 'package:http/http.dart';

Future<LatLng> getCoordinates(String address) async {
  // Mapbox endpoint for reverse geocoding
  // /geocoding/v5/{mode}/{address}.json
  String url = "https://api.mapbox.com/geocoding/v5/"
      "mapbox.places/$address.json?"
      "autocomplete=true&"
      "access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA";
 
}
