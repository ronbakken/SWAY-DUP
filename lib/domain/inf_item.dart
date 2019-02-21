import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

enum InfItemType {user, offer, map}

class InfItem {
  final InfItemType type;
  /// Only one of them will be set according to [type]
  final BusinessOffer offer;
  final User user;
  final MapMarker mapMarker;

  InfItem({
    this.type,
    this.offer,
    this.user,
    this.mapMarker,
  });

  static InfItem fromDto(ItemDto dto) {
    if (dto.hasOffer()) {
      return InfItem(type: InfItemType.offer, offer: BusinessOffer.fromDto(dto.offer));
    }
    if (dto.hasUser()) {
      return InfItem(type: InfItemType.user, user: User.fromDto(dto.user));
    }
    if (dto.hasMapItem()) {
      return InfItem(type: InfItemType.map, mapMarker: null);
    }
    assert(false, 'Should never get here');
    return null;
  }
}
