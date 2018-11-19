import 'package:inf/domain/user.dart';

enum MapMarkertype { cluster, user, offer }

class MapMarker {
  final MapMarkertype type;
  final double latitude;
  final double longitude;

  // only valid for type cluster
  final int clusterCount;

  // only valid for type offer
  final int offer;
  final bool isDirectOffer;

  // only valid for type user
  final int user;
  final UserType userType;

  MapMarker(
    this.type,
    this.latitude,
    this.longitude,
    this.clusterCount,
    this.offer,
    this.isDirectOffer,
    this.user,
    this.userType,
  ) {
    assert((type == MapMarkertype.cluster &&
            clusterCount != null &&
            offer == null &&
            isDirectOffer == null &&
            user == null &&
            userType == null) ||
        (type == MapMarkertype.user &&
            clusterCount == null &&
            offer == null &&
            isDirectOffer == null &&
            user != null &&
            userType != null) ||
        (type == MapMarkertype.offer &&
            clusterCount == null &&
            offer != null &&
            isDirectOffer != null &&
            user == null &&
            userType == null));
  }
}
