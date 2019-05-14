import 'dart:math';

class GeoPoint {
  GeoPoint(this.latitude, this.longitude)
      : assert(latitude != null),
        assert(longitude != null),
        assert(latitude >= -90 && latitude <= 90),
        assert(longitude >= -180 && longitude <= 180);

  final double latitude;
  final double longitude;

  @override
  String toString() => "($latitude, $longitude)";
}

class GeoBoundingBox {
  GeoBoundingBox({this.northWest, this.southEast}) : assert((northWest != null && southEast != null) || (northWest == null && southEast == null));

  factory GeoBoundingBox.empty() => GeoBoundingBox(
        northWest: null,
        southEast: null,
      );

  final GeoPoint northWest;
  final GeoPoint southEast;

  bool get isEmpty => northWest == null && southEast == null;

  bool get isNotEmpty => northWest != null && southEast != null;

  GeoBoundingBox intersect(GeoBoundingBox other) {
    assert(other != null);

    if (isEmpty || other.isEmpty) {
      return GeoBoundingBox.empty();
    }

    // TODO: account for crossing the meridian

    final rectangle = Rectangle<double>.fromPoints(
      Point<double>(
        northWest.longitude,
        northWest.latitude,
      ),
      Point<double>(
        southEast.longitude,
        southEast.latitude,
      ),
    );

    final otherRectangle = Rectangle<double>.fromPoints(
      Point<double>(
        other.northWest.longitude,
        other.northWest.latitude,
      ),
      Point<double>(
        other.southEast.longitude,
        other.southEast.latitude,
      ),
    );

    final intersection = rectangle.intersection(otherRectangle);

    if (intersection == null) {
      return GeoBoundingBox.empty();
    }

    final intersectingNorthWest = GeoPoint(
      max(intersection.top, intersection.bottom),
      min(intersection.left, intersection.right),
    );
    final intersectingSouthEast = GeoPoint(
      min(intersection.top, intersection.bottom),
      max(intersection.left, intersection.right),
    );

    return GeoBoundingBox(
      northWest: intersectingNorthWest,
      southEast: intersectingSouthEast,
    );
  }

  @override
  String toString() => isEmpty ? "(empty)" : "$northWest - $southEast";
}

class GeoArea {
  final GeoPoint center;
  final double radiusInKilometers;

  GeoArea(this.center, this.radiusInKilometers) : assert(radiusInKilometers >= 0);

  factory GeoArea.inMeters(GeoPoint gp, int radiusInMeters) => GeoArea(gp, radiusInMeters / 1000.0);

  factory GeoArea.inMiles(GeoPoint gp, int radiusMiles) => GeoArea(gp, radiusMiles * 1.60934);

  /// returns the distance in km of [point] to center
  double distanceToCenter(GeoPoint point) => distanceInKilometers(center, point);

  @override
  String toString() => "$center ($radiusInKilometers km)";
}

GeoBoundingBox getBoundingBoxFromArea(GeoArea area) {
  const KM_PER_DEGREE_LATITUDE = 110.574;

  final latitudeDegreeRange = area.radiusInKilometers / KM_PER_DEGREE_LATITUDE;
  final latitudeNorth = min(90.0, area.center.latitude + latitudeDegreeRange);
  final latitudeSouth = max(-90.0, area.center.latitude - latitudeDegreeRange);
  // calculate longitude based on current latitude
  final longDegsNorth = kilometersToLongitudeDegrees(area.radiusInKilometers * 2, latitudeNorth);
  final longDegsSouth = kilometersToLongitudeDegrees(area.radiusInKilometers * 2, latitudeSouth);
  final longDegs = max(longDegsNorth, longDegsSouth);
  return GeoBoundingBox(
      northWest: GeoPoint(latitudeNorth, wrapLongitude(area.center.longitude - longDegs)),
      southEast: GeoPoint(latitudeSouth, wrapLongitude(area.center.longitude + longDegs)));
}

GeoArea getAreaFromBoundingBox(GeoBoundingBox boundingBox) {
  const KM_PER_DEGREE_LATITUDE = 110.574;
  final latitudeDelta = (boundingBox.northWest.latitude - boundingBox.southEast.latitude).abs();
  final radius = latitudeDelta * KM_PER_DEGREE_LATITUDE / 2;
  final center = GeoPoint(
    (boundingBox.northWest.latitude + boundingBox.southEast.latitude) / 2,
    (boundingBox.northWest.longitude + boundingBox.southEast.longitude) / 2,
  );
  final area = GeoArea(center, radius);
  return area;
}

double wrapLongitude(double longitude) {
  if (longitude <= 180 && longitude >= -180) {
    return longitude;
  }

  final adjusted = longitude + 180;

  if (adjusted > 0) {
    return (adjusted % 360) - 180;
  }

  return 180 - (-adjusted % 360);
}

double distanceInKilometers(GeoPoint p1, GeoPoint p2) {
  final dlat = degreesToRadians(p2.latitude - p1.latitude);
  final dlon = degreesToRadians(p2.longitude - p1.longitude);
  final lat1 = degreesToRadians(p1.latitude);
  final lat2 = degreesToRadians(p2.latitude);

  final r = 6378.137; // WGS84 major axis
  double c = 2 * asin(sqrt(pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2)));
  return r * c;
}

double degreesToRadians(double degrees) => (degrees * pi) / 180;

double kilometersToLongitudeDegrees(double distance, double latitude) {
  const KM_PER_DEGREE_LATITUDE = 110.574;
  final latitudeRadians = degreesToRadians(latitude);
  final distancePerDegree = cos(latitudeRadians) * KM_PER_DEGREE_LATITUDE;
  return distance / distancePerDegree;
}
