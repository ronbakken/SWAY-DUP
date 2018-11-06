enum DeliverableType {
  post,
  mention,
  video,
  custom,
}

enum DeliverableChannels {
  instagramm,
  facebook,
  twitter,
  youtube,
  blog,
  custom,
}

class Deliverable {
  final int id;
  final DeliverableType type;
  final DeliverableChannels channel;
  final String description;

  Deliverable({this.id, this.type, this.channel, this.description});
}
