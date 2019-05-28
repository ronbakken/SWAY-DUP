import 'dart:async';

import 'package:inf/domain/category.dart';
import 'package:inf/domain/deliverable.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class AppMustUpdateException implements Exception {}

abstract class ConfigService {
  Future init();

  List<DeliverableIcon> get deliverableIcons;

  List<SocialNetworkProvider> get socialNetworkProviders;

  Stream<List<String>> get welcomePageProfileImages;

  String get mapApiKey;

  String get mapUrlTemplate;


  List<Category> get topLevelCategories;

  SocialNetworkProvider getSocialNetworkProviderById(String id);

  DeliverableIcon getDeliveryIconFromType(DeliverableType type);

  List<Category> getCategoriesFromIds(List<String> ids);

  List<Category> getSubCategories(Category parent);
}
