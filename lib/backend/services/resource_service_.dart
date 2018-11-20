abstract class ResourceService {
  Stream<WelcomePageImages> getWelcomePageProfileImages();

  String getMapApiKey();
  String getMapUrlTemplate();
}

class WelcomePageImages {
  final List<String> images;

  WelcomePageImages(this.images);
}
