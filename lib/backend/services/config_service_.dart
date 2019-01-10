
import 'package:inf_api_client/inf_api_client.dart';


class AppMustUpdateException implements Exception
{
}


abstract class ConfigService {

  List<Category> categories;
  List<DeliverableIcon> deliverableIcons; 
  List<SocialNetworkProvider> socialNetworkProviders; 


  Stream<WelcomeImages> getWelcomePageProfileImages();

  String getMapApiKey();
  String getMapUrlTemplate();

  Future init();

  SocialNetworkProvider getSocialNetworkProviderById(int id);
}

