import 'dart:typed_data';

import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class DeliverableIcon {
  final DeliverableIconDto dto;

  DeliverableType get deliverableType => dto.deliverableType;
  AppAsset get iconAsset => _iconAsset;
  String get name => dto.name;

  AppAsset _iconAsset;

  DeliverableIcon(this.dto) {
    _iconAsset = AppAsset.raw(Uint8List.fromList(dto.iconData));
  }
}

class Deliverable {
  final List<DeliverableType> types;
  final List<SocialNetworkProvider> channels;
  final String description;

  Deliverable({this.types, this.description, this.channels});

  Deliverable copyWith({
    int id,
    List<DeliverableType> types,
    String description,
  }) {
    return Deliverable(
      description: description ?? this.description,
      types: types ?? this.types,
    );
  }

  static Deliverable fromDto(DeliverableDto dto) {
    return Deliverable(
      description: dto.description,
      types: dto.deliverableTypes,
      channels: dto.socialNetworkProviderIds
          .map<SocialNetworkProvider>((id) => backend<ConfigService>().getSocialNetworkProviderById(id))
          .toList(),
    );
  }

  DeliverableDto toDto()
  {
    assert (description !=null);
    assert(channels != null && channels.isNotEmpty);
    assert(types != null && types.isNotEmpty);
    return DeliverableDto()
    ..description =description
    ..socialNetworkProviderIds.addAll(channels.map<String>( (channel) => channel.id ))
    ..deliverableTypes.addAll(types);    
  }
}
