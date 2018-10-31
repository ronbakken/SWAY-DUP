import 'dart:typed_data';

class Location {
  int id;
  
  String name;
  String avatarUrl;
  Uint8List avatarLowRes;

  String description;

  double latitude;
  double longitude;

  int activeOfferCount; // Number of offers at the same location

}