import 'dart:typed_data';

enum DeliverableType {
  post,
  mention,
  video,
  custom,
}

enum DeliverableChannels {
  instagram,
  facebook,
  twitter,
  youtube,
  blog,
  custom,
}

class DeliverableIcon
{
   final DeliverableType deliverableType;
   final Uint8List iconData;
   final String name;

  DeliverableIcon({this.deliverableType, this.iconData,this.name, });
}


class Deliverable {
  final int id;
  final DeliverableType type;
  final DeliverableChannels channel;
  final String description;

  Deliverable({this.id, this.type, this.channel, this.description});
}
