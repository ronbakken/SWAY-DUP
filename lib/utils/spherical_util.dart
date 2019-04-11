import 'dart:math' as math;

import 'package:latlong/latlong.dart';
import 'package:vector_math/vector_math_64.dart';

/// The earth's radius, in meters. Mean radius as defined by IUGG.
const double EARTH_RADIUS = 6371009;

class SphericalUtil {
  const SphericalUtil._();

  /// Returns the LatLng which lies the given fraction of the way between the
  ///     * origin LatLng and the destination LatLng.
  ///     * @param from     The LatLng from which to start.
  ///     * @param to       The LatLng toward which to travel.
  ///     * @param fraction A fraction of the distance to travel.
  ///     * @return The interpolated LatLng.
  static LatLng interpolate(LatLng from, LatLng to, double fraction) {
    // http://en.wikipedia.org/wiki/Slerp
    double fromLat = radians(from.latitude);
    double fromLng = radians(from.longitude);
    double toLat = radians(to.latitude);
    double toLng = radians(to.longitude);
    double cosFromLat = math.cos(fromLat);
    double cosToLat = math.cos(toLat);

    // Computes Spherical interpolation coefficients.
    double angle = computeAngleBetween(from, to);
    double sinAngle = math.sin(angle);
    if (sinAngle < 1E-6) {
      return LatLng(from.latitude + fraction * (to.latitude - from.latitude),
          from.longitude + fraction * (to.longitude - from.longitude));
    }
    double a = math.sin((1 - fraction) * angle) / sinAngle;
    double b = math.sin(fraction * angle) / sinAngle;

    // Converts from polar to vector and interpolate.
    double x = a * cosFromLat * math.cos(fromLng) + b * cosToLat * math.cos(toLng);
    double y = a * cosFromLat * math.sin(fromLng) + b * cosToLat * math.sin(toLng);
    double z = a * math.sin(fromLat) + b * math.sin(toLat);

    // Converts interpolated vector back to polar.
    double lat = math.atan2(z, math.sqrt(x * x + y * y));
    double lng = math.atan2(y, x);
    return LatLng(degrees(lat), degrees(lng));
  }

  /// Returns distance on the unit sphere; the arguments are in radians.
  static double distanceRadians(double lat1, double lng1, double lat2, double lng2) {
    return arcHav(havDistance(lat1, lat2, lng1 - lng2));
  }

  /// Returns the angle between two LatLngs, in radians. This is the same as the distance on the unit sphere.
  static double computeAngleBetween(LatLng from, LatLng to) {
    return distanceRadians(
        radians(from.latitude), radians(from.longitude), radians(to.latitude), radians(to.longitude));
  }

  /// Returns the distance between two LatLngs, in meters.
  static double computeDistanceBetween(LatLng from, LatLng to) {
    return computeAngleBetween(from, to) * EARTH_RADIUS;
  }

  /// Wraps the given value into the inclusive-exclusive interval between min and max.
  /// @param n   The value to wrap.
  /// @param min The minimum.
  /// @param max The maximum.
  static double wrap(double n, double min, double max) {
    return (n >= min && n < max) ? n : (mod(n - min, max - min) + min);
  }

  /// Returns the non-negative remainder of x / m.
  /// @param x The operand.
  /// @param m The modulus.
  static double mod(double x, double m) {
    return ((x % m) + m) % m;
  }

  /// Returns mercator Y corresponding to latitude.
  /// See http://en.wikipedia.org/wiki/Mercator_projection .
  static double mercator(double lat) {
    return math.log(math.tan(lat * 0.5 + PI / 4));
  }

  /// Returns latitude from mercator Y.
  static double inverseMercator(double y) {
    return 2 * math.atan(math.exp(y)) - PI / 2;
  }

  /// Returns haversine(angle-in-radians).
  /// hav(x) == (1 - cos(x)) / 2 == sin(x / 2)^2.
  static double hav(double x) {
    double sinHalf = math.sin(x * 0.5);
    return sinHalf * sinHalf;
  }

  /// Computes inverse haversine. Has good numerical stability around 0.
  /// arcHav(x) == acos(1 - 2 * x) == 2 * asin(sqrt(x)).
  /// The argument must be in [0, 1], and the result is positive.
  static double arcHav(double x) {
    return 2 * math.asin(math.sqrt(x));
  }

  /// Given h==hav(x), returns sin(abs(x)).
  static double sinFromHav(double h) {
    return 2 * math.sqrt(h * (1 - h));
  }

  /// Returns hav(asin(x)).
  static double havFromSin(double x) {
    double x2 = x * x;
    return x2 / (1 + math.sqrt(1 - x2)) * .5;
  }

  /// Returns sin(arcHav(x) + arcHav(y)).
  static double sinSumFromHav(double x, double y) {
    double a = math.sqrt(x * (1 - x));
    double b = math.sqrt(y * (1 - y));
    return 2 * (a + b - 2 * (a * y + b * x));
  }

  /// Returns hav() of distance from (lat1, lng1) to (lat2, lng2) on the unit sphere.
  static double havDistance(double lat1, double lat2, double dLng) {
    return hav(lat1 - lat2) + hav(dLng) * math.cos(lat1) * math.cos(lat2);
  }
}
