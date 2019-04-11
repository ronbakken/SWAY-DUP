import 'package:inf_api_client/inf_api_client.dart';

enum MapMarkerStatus { inactive, active }
enum MapMarkerType { user, offer }

class MapMarker {
  final MapMarkerStatus status;
  final MapMarkerType type;
  final double latitude;
  final double longitude;

  // only valid for type offer
  final String offerId;

  // only valid for type user
  final String userId;

  MapMarker({
    this.status,
    this.type,
    this.latitude,
    this.longitude,
    this.offerId,
    this.userId,
  }) : assert((type == MapMarkerType.user && offerId == null && userId != null) ||
            (type == MapMarkerType.offer && offerId != null && userId == null));

  static MapMarker fromDto(MapItemDto dto) {
    switch (dto.whichPayload()) {
      case MapItemDto_Payload.user:
        return MapMarker(
          status: _markerStatus(dto),
          type: MapMarkerType.user,
          latitude: dto.geoPoint.latitude,
          longitude: dto.geoPoint.longitude,
          userId: dto.user.userId,
        );
      case MapItemDto_Payload.offer:
        return MapMarker(
          status: _markerStatus(dto),
          type: MapMarkerType.offer,
          latitude: dto.geoPoint.latitude,
          longitude: dto.geoPoint.longitude,
          offerId: dto.offer.offerId,
        );
      default:
        throw StateError('Bad MapItem payload type');
    }
  }

  static MapMarkerStatus _markerStatus(MapItemDto dto) {
    switch (dto.status) {
      case MapItemDto_MapItemStatus.inactive:
        return MapMarkerStatus.inactive;
      case MapItemDto_MapItemStatus.active:
        return MapMarkerStatus.active;
      default:
        throw StateError('Bad MapItem status');
    }
  }
}
