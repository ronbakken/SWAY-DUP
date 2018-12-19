import 'package:inf/backend/services/auth_service_impl.dart';
import 'package:inf/backend/services/resource_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/network_streaming/network_streaming.dart';

class ResourceServiceImplementation implements ResourceService {
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
  Future init(NetworkStreaming networkStreaming) async {
    List<SocialNetworkProvider> result = <SocialNetworkProvider>[];
    List<ConfigOAuthProvider> oauthProviders =
        networkStreaming.config.oauthProviders;
    for (int providerId = 0; providerId < oauthProviders.length; ++providerId) {
      ConfigOAuthProvider oauthProvider = oauthProviders[providerId];
      if (oauthProvider.canConnect || oauthProvider.showInProfile) {
        result.add(providerFromProvider(providerId, oauthProvider));
      }
    }
   
    socialNetworkProviders = result;
  }
}
