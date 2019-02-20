import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class DeliverableIcon {
  final DeliverableIconDto dto;

  DeliverableType get deliverableType => dto.deliverableType;
  Uint8List get iconData => _iconData;
  String get name => dto.name;

  Uint8List _iconData;

  DeliverableIcon(this.dto) {
    _iconData = Uint8List.fromList(dto.iconData);
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
          .map<SocialNetworkProvider>((id) => backend.get<ConfigService>().getSocialNetworkProviderById(id))
          .toList(),
    );
  }
}
