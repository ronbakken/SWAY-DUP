import 'package:inf/domain/domain.dart';

abstract class ResourceService {
  Stream<WelcomePageImages> getWelcomePageProfileImages();

  String getMapApiKey();
  String getMapUrlTemplate();

  Future<List<Category>> getCategories();

  Future<List<DeliverableIcon>> getDeliverableIcons(); 

}

class WelcomePageImages {
  final List<String> images;

  WelcomePageImages(this.images);
}
