import 'package:inf/domain/domain.dart';
import 'package:inf/network_streaming/network_streaming.dart';

abstract class ResourceService {

  List<Category> categories;
  List<DeliverableIcon> deliverableIcons; 
  List<SocialNetworkProvider> socialNetworkProviders; 


  Stream<WelcomePageImages> getWelcomePageProfileImages();

  Future init(NetworkStreaming networkStreaming);

  String getMapApiKey();
  String getMapUrlTemplate();

}

class WelcomePageImages {
  final List<String> images;

  WelcomePageImages(this.images);
}
