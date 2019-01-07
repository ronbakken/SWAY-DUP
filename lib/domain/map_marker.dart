import 'dart:typed_data';

import 'package:inf_api_client/inf_api_client.dart';

enum MapMarkerType { cluster, user, offer }

class MapMarker {
  final int id;
  final MapMarkerType type;

  // this will not be set for clusters
  final Uint8List iconData;
  final bool isVectorIcon;
  
  final double latitude;
  final double longitude;

  // only valid for type cluster
  final int clusterCount;
  final double clusterBounderyNorthWestLatitude;
  final double clusterBounderyNorthWestlongitude;
  final double clusterBounderySouthEasrLatitude;
  final double clusterBounderySouthEasrlongitude;

  // In case of clustering we need the ids of the clustered markers so that we can animate
  // From the clusterMarker to the individual markers
  final List<int> clusteredMapMarkerIds;
 
  // only valid for type offer
  final int offerId;
  final bool isDirectOffer;

  // only valid for type user
  final int userId;
  final UserType userType;

  MapMarker({
    this.id,
    this.type,
    this.iconData,
    this.isVectorIcon,
    this.latitude,
    this.longitude,
    this.clusterCount,
    this.clusteredMapMarkerIds,
    this.clusterBounderyNorthWestLatitude,
    this.clusterBounderyNorthWestlongitude,
    this.clusterBounderySouthEasrLatitude,
    this.clusterBounderySouthEasrlongitude,
    this.offerId,
    this.isDirectOffer,
    this.userId,
    this.userType,
  }) : assert((type == MapMarkerType.cluster &&
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
