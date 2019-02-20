import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';

class InfItem {
  final ItemDto_Type type;

  /// Only one of them will be set according to [type]
  final BusinessOffer offer;
  final User user;
  final MapMarker mapMarker;
 

  InfItem({
    this.type,
    this.offer,
    this.user,
    this.mapMarker,}
  );

  static InfItem fromDto(ItemDto dto)
  {
    switch (dto.type) {
      case ItemDto_Type.offerItem:
        assert(dto.hasOffer());
        return InfItem(type: ItemDto_Type.offerItem, offer: BusinessOffer.fromDto(dto.offer));
      case ItemDto_Type.userItem:
        assert(dto.hasUser());
        return InfItem(type: ItemDto_Type.userItem, user: User.fromDto(dto.user));
      case ItemDto_Type.map:
        assert(dto.hasMapItem());
        return InfItem(type: ItemDto_Type.map, mapMarker: null);        
      default:
        assert(false, 'Should never get here');
        return null;
    }
  }
}
