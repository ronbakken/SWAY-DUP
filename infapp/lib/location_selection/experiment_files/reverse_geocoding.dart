import 'dart:async';

Future<String> coordinatesToAddress(double latitude, double longitude) async {
  // Mapbox endpoint for forward and reverse geocoding
  // /geocoding/v5/{mode}/{longitude},{latitude}.json
  // /geocoding/v5/{mode}/{query}.json
  String url = "https://api.mapbox.com/geocoding/v5/"
      "mapbox.places/$longitude,$latitude.json?"
      "access_token=pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqazRwN3h4ODBjM2QzcHA2N2ZzbHoyYm0ifQ.vpwrdXRoCU-nBm-E1KNKdA";
}
