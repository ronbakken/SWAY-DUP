import 'dart:async';

import 'package:inf/backend/backend.dart';
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
        id: dto.offer.id,
        type: InfItemType.offer,
        offer: BusinessOffer.fromDto(dto.offer),
        revision: dto.offer.revision,
        latitude: dto.offer.location.geoPoint.latitude,
        longitude: dto.offer.location.geoPoint.longitude,
      );
    } else if (dto.hasUser()) {
      return InfItem(
        id: dto.user.id,
        type: InfItemType.user,
        user: User.fromDto(dto.user),
        revision: dto.user.revision,
        latitude: dto.user.list.location.geoPoint.latitude,
        longitude: dto.user.list.location.geoPoint.longitude,
      );
    } else if (dto.hasMapItem()) {
      String id;
      if (dto.mapItem.hasUser()) {
        id = dto.mapItem.user.userId;
      } else if (dto.mapItem.hasOffer()) {
        id = dto.mapItem.offer.offerId;
      } else {
        throw StateError('Invalid MapItem id');
      }
      return InfItem(
        id: id,
        type: InfItemType.map,
        mapMarker: MapMarker.fromDto(dto.mapItem),
        latitude: dto.mapItem.geoPoint.latitude,
        longitude: dto.mapItem.geoPoint.longitude,
      );
    }
    throw StateError('Should never get here');
  }
}
