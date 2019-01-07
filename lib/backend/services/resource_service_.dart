
import 'package:inf_api_client/inf_api_client.dart';

abstract class ResourceService {

  List<Category> categories;
  List<DeliverableIcon> deliverableIcons; 
  List<SocialNetworkProvider> socialNetworkProviders; 


  Stream<WelcomePageImages> getWelcomePageProfileImages();

  String getMapApiKey();
  String getMapUrlTemplate();

  Future init();

  SocialNetworkProvider getSocialNetworkProviderById(int id); 

}

class WelcomePageImages {
  final List<String> images;

  WelcomePageImages(this.images);
}
