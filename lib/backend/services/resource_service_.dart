abstract class ResourceService {
  Stream<WelcomePageImages> getWelcomePageProfileImages();
}

class WelcomePageImages {
  final List<String> images;

  WelcomePageImages(this.images);
}
