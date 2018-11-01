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
  int id;
  DeliverableType type;
  DeliverableChannels channel;
  String description;
}
