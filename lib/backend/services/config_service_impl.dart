import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/config_service_.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/deliverable.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigServiceImplementation implements ConfigService {
  final logger = Logger('ConfigService');

  @override
  List<Category> categories;

  @override
  List<DeliverableIcon> deliverableIcons;

  @override
  List<SocialNetworkProvider> socialNetworkProviders;

  AppConfigDto configData;

  @override
  Stream<List<String>> getWelcomePageProfileImages() {
    return backend
        .get<InfApiClientsService>()
        .configClient
        .getWelcomeImages(Empty())
        .map<List<String>>((msg) => msg.imageUrls);
  }

  @override
  String getMapApiKey() {
    return configData.serviceConfig.mapboxToken;
  }

  @override
  String getMapUrlTemplate() {
    return configData.serviceConfig.mapboxUrlTemplateDark;
  }

  @override
  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get locally stored AppConfig
    //disabled while API is still fluent
    // var configJson = prefs.getString('config');
    // if (configJson != null) {
    //   configData = AppConfigDto.fromJson(configJson);
    // }

    // Get current Config and API version from server
    var versionInformationFromServer = await backend<InfApiClientsService>().configClient.getVersions(
          Empty(),
          options: CallOptions(
            timeout: const Duration(seconds: 5),
          ),
        );

    logger.log(Level.INFO, versionInformationFromServer.toString());

    // if the API version that the server sends is newer than the one stored on this device
    // TODO This is not optimal because it the user installls the app and starts it the first time after
    // we rolled a new API version this could lead to problems
    // better would be an in the App itself embedded API version that is set by the CI server

    /// While the API is still not fixed we don't use the stores ApiConfig
    ///
    // var currentApiVersion = prefs.getInt('API_VERSION');
    // if (currentApiVersion != null && currentApiVersion < versionInformationFromServer.versionInfo.apiVersion) {
    //   throw AppMustUpdateException();
    // }

    // if (currentApiVersion == null) {
    //   await prefs.setInt('API_VERSION', versionInformationFromServer.versionInfo.apiVersion);
    // }

    // local config does not exists or is outdated update from server
    if (configData == null || configData.configVersion < versionInformationFromServer.versionInfo.configVersion) {
      final client = backend<InfApiClientsService>();
      configData = (await client.configClient.getAppConfig(Empty())).appConfigData;
      await prefs.setString('config', configData.writeToJson());
    }

    logger.log(Level.INFO, '''
      ConfigData: { 
        configVersion: ${configData.configVersion},
        serviceConfig: {
          mapboxUrlTemplateDark: ${configData.serviceConfig.mapboxUrlTemplateDark},
          mapboxUrlTemplateLight: ${configData.serviceConfig.mapboxUrlTemplateLight},
          mapboxToken: ${configData.serviceConfig.mapboxToken},
        },
        categories: ${configData.categories.map((cat) => cat.name).toList()}
        socialNetworkProviders: ${configData.socialNetworkProviders.map((provider) => '${provider.id}: ${provider.name} }').toList()}
        termsOfServiceUrl: ${configData.termsOfServiceUrl}
        privacyPolicyUrl: ${configData.privacyPolicyUrl}
        userNeedInvitationToSignUp: ${configData.userNeedInvitationToSignUp}
      }
    ''');

    socialNetworkProviders = configData.socialNetworkProviders
        .map<SocialNetworkProvider>(
          (dto) => SocialNetworkProvider(dto),
        )
        .toList();
    deliverableIcons = configData.deliverableIcons
        .map<DeliverableIcon>(
          (dto) => DeliverableIcon(dto),
        )
        .toList();
    categories = configData.categories.map<Category>((dto) => Category(dto)).toList();
  }

  @override
  SocialNetworkProvider getSocialNetworkProviderById(String id) {
    return socialNetworkProviders.where((provider) => provider.id == id).first;
  }

  @override
  List<Category> getCategoriesFromIds(List<String> ids) =>
      categories.where((category) => ids.contains(category.id)).toList();

  @override
  DeliverableIcon getDeliveryIconFromType(DeliverableType type) =>
      deliverableIcons.firstWhere((icon) => icon.deliverableType == type);

  @override
  List<Category> get topLevelCategories => categories.where((item) => item.parentId.isEmpty).toList(growable: false);
}
