import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

enum InfItemType { user, offer, map }

// FIXME: Should be removed?
class InfItem {
  final String id;
  final int revision;
  final InfItemType type;
  final double latitude;
  final double longitude;

  /// Only one of them will be set according to [type]
  final BusinessOffer offer;
  final User user;
  final MapMarker mapMarker;

  InfItem({
    this.id,
    this.revision,
    this.type,
    this.offer,
    this.user,
    this.mapMarker,
    this.latitude,
    this.longitude,
  });

  static InfItem fromDto(ItemDto dto) {
    if (dto.hasOffer()) {
      return InfItem(
        type: InfItemType.offer,
        offer: BusinessOffer.fromDto(dto.offer),
        id: dto.offer.id,
        revision: dto.offer.revision,
        latitude: dto.offer.location.geoPoint.latitude,
        longitude: dto.offer.location.geoPoint.longitude,
      );
    } else if (dto.hasUser()) {
      return InfItem(
        type: InfItemType.user,
        user: User.fromDto(dto.user),
        id: dto.user.id,
        revision: dto.user.revision,
        latitude: dto.user.list.location.geoPoint.latitude,
        longitude: dto.user.list.location.geoPoint.longitude,
      );
    } else if (dto.hasMapItem()) {
      return InfItem(
        type: InfItemType.map,
        mapMarker: null,
      );
    }
    assert(false, 'Should never get here');
    return null;
  }
}
