import 'dart:async';

import 'package:inf/domain/category.dart';
import 'package:inf/domain/deliverable.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class AppMustUpdateException implements Exception {}

abstract class ConfigService {
  List<DeliverableIcon> deliverableIcons;
  List<SocialNetworkProvider> socialNetworkProviders;

  Stream<List<String>> getWelcomePageProfileImages();

  String getMapApiKey();
  String getMapUrlTemplate();

  Future init();

  SocialNetworkProvider getSocialNetworkProviderById(String id);

  DeliverableIcon getDeliveryIconFromType(DeliverableType type);

  List<Category> getCategoriesFromIds(List<String> ids);

  List<Category> getSubCategories(Category parent);

  List<Category> get topLevelCategories;
}
