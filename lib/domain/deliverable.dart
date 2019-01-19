import 'dart:typed_data';

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
  final int id;
  final DeliverableType type;
  final String description;

  Deliverable({this.id, this.type, this.description});
}
