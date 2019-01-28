import 'package:inf/domain/category.dart';
import 'package:inf/domain/deliverable.dart';
import 'package:inf/domain/social_network_provider.dart';

class AppMustUpdateException implements Exception {}

abstract class ConfigService {
  List<Category> categories;
  List<DeliverableIcon> deliverableIcons;
  List<SocialNetworkProvider> socialNetworkProviders;

  Stream<List<String>> getWelcomePageProfileImages();

  String getMapApiKey();
  String getMapUrlTemplate();

  Future init();

  SocialNetworkProvider getSocialNetworkProviderById(int id);

  List<Category> getCategoriesFromIds(List<int> ids);
}
