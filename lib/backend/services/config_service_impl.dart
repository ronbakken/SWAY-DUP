import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/config_service_.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/deliverable.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class ConfigServiceImplementation implements ConfigService {
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



    // Get curren Config and API version from server
    var versionInformationFromServer = await backend.get<InfApiClientsService>().configClient.getVersions(
          Empty(),
          options: CallOptions(
            timeout: Duration(seconds: 5),
          ),
        );

    // if the API version that the server sendes is newer than the one stored on this device
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
      configData = (await backend.get<InfApiClientsService>().configClient.getAppConfig(Empty())).appConfigData;
      await prefs.setString('config', configData.writeToJson());
    }

    socialNetworkProviders =
        configData.socialNetworkProviders.map<SocialNetworkProvider>((dto) => SocialNetworkProvider(dto)).toList();
    deliverableIcons = configData.deliverableIcons.map<DeliverableIcon>((dto) => DeliverableIcon(dto)).toList();
    categories = configData.categories.map<Category>((dto) => Category(dto)).toList();
    print(versionInformationFromServer);
  }

  @override
  SocialNetworkProvider getSocialNetworkProviderById(int id) {
    return socialNetworkProviders.where((provider) => provider.id == id).first;
  }

  @override
  List<Category> getCategoriesFromIds(List<int> ids) => categories
      .where(
        (category) => ids.contains(category.id),
      )
      .toList();
}
