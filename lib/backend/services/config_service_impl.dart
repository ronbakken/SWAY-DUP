import 'package:inf/backend/services/config_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';


class ResourceServiceImplementation implements ConfigService {
  @override
  List<Category> categories;

  @override
  List<DeliverableIcon> deliverableIcons;

  @override
  List<SocialNetworkProvider> socialNetworkProviders;

  @override
  Stream<WelcomePageImages> getWelcomePageProfileImages() {
    // TODO: implement getAllLinkedAccounts
    throw Exception('Not imnplemented');
  }

  @override
  String getMapApiKey() {
    // TODO: implement getMapApiKey
    throw Exception('Not imnplemented');
  }

  @override
  String getMapUrlTemplate() {
    // TODO: implement getMapApiKey
    throw Exception('Not imnplemented');
  }

  @override
  Future init() {
    // TODO: implement init
    return null;
  }

  @override
  SocialNetworkProvider getSocialNetworkProviderById(int id) {
    // TODO: implement getSocialNetworkProviderById
    return null;
  }
}
