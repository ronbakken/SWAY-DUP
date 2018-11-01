import 'dart:typed_data';

class Location {
  final int id;

  final String name;
  final String avatarUrl;
  final Uint8List avatarLowRes;

  final String description;

  final double latitude;
  final double longitude;

  final int activeOfferCount;

  Location({
    this.id,
    this.name,
    this.avatarUrl,
    this.avatarLowRes,
    this.description,
    this.latitude,
    this.longitude,
    this.activeOfferCount,
  }); // Number of offers at the same location

}
