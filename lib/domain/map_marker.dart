import 'package:inf/domain/user.dart';

enum MapMarkerType { cluster, user, offer }

class MapMarker {
  final MapMarkerType type;
  final double latitude;
  final double longitude;

  // only valid for type cluster
  final int clusterCount;

  // only valid for type offer
  final int offerId;
  final bool isDirectOffer;

  // only valid for type user
  final int userId;
  final UserType userType;

  MapMarker({
    this.type,
    this.latitude,
    this.longitude,
    this.clusterCount,
    this.offerId,
    this.isDirectOffer,
    this.userId,
    this.userType,}
  ) :
    assert((type == MapMarkerType.cluster &&
            clusterCount != null &&
            offerId == null &&
            isDirectOffer == null &&
            userId == null &&
            userType == null) ||
        (type == MapMarkerType.user &&
            clusterCount == null &&
            offerId == null &&
            isDirectOffer == null &&
            userId != null &&
            userType != null) ||
        (type == MapMarkerType.offer &&
            clusterCount == null &&
            offerId != null &&
            userId == null &&
            userType == null));
  
}
