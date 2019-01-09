import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/config_service_.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigServiceImplementation implements ConfigService {
  @override
  List<Category> categories;

  @override
  List<DeliverableIcon> deliverableIcons;

  @override
  List<SocialNetworkProvider> socialNetworkProviders;


  AppConfigData configData;

  @override
  Stream<WelcomePageImages> getWelcomePageProfileImages() {
    // TODO: implement getAllLinkedAccounts
    throw Exception('Not imnplemented');
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
      SharedPreferences  prefs = await SharedPreferences.getInstance();

      // Get locally stored AppConfig
      var configJson = prefs.getString('config');
      if (configJson != null)
      {
        configData = AppConfigData.fromJson(configJson);
      }

      // Get curren Config and API version from server
      var version = await backend.get<InfApiClientsService>().configClient.getVersions(Empty());

      // TODO throw exception if API version is outdated so that UI can display a message.

      // local config does not exists or is outdated update from server
      if (configData == null || configData.configVersion < version.configVersion)
      {
        configData = await backend.get<InfApiClientsService>().configClient.getAppConfig(Empty());
        await prefs.setString('config', configData.writeToJson());

      }

      socialNetworkProviders = configData.socialNetworkProviders;
      deliverableIcons = configData.deliverableIcons;
      categories = configData.categories;
      print(version);
  }

  @override
  SocialNetworkProvider getSocialNetworkProviderById(int id) {
      return socialNetworkProviders.where((provider) => provider.id == id).first;
  }
}
