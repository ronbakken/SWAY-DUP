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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get locally stored AppConfig
    var configJson = prefs.getString('config');
    if (configJson != null) {
      configData = AppConfigData.fromJson(configJson);
    }

    // Get curren Config and API version from server
    var versionInformationFromSercer = await backend.get<InfApiClientsService>().configClient.getVersions(
          Empty(),
          options: CallOptions(
            timeout: Duration(seconds: 5),
          ),
        );

    // if the API version that the server sendes is newer than the one stored on this device
    // TODO This is not optimal because it the user installls the app and starts it the first time after
    // we rolled a new API version this could lead to problems
    // better would be an in the App itself embedded API version that is set by the CI server
    var currentApiVersion = prefs.getInt('API_VERSION');
    if (currentApiVersion != null && currentApiVersion < versionInformationFromSercer.apiVersion) {
      throw AppMustUpdateException();
    }

    if (currentApiVersion == null) {
      await prefs.setInt('API_VERSION', versionInformationFromSercer.apiVersion);
    }

    // local config does not exists or is outdated update from server
    if (configData == null || configData.configVersion < versionInformationFromSercer.configVersion) {
      configData = await backend.get<InfApiClientsService>().configClient.getAppConfig(Empty());
      await prefs.setString('config', configData.writeToJson());
    }

    socialNetworkProviders = configData.socialNetworkProviders;
    deliverableIcons = configData.deliverableIcons;
    categories = configData.categories;
    print(versionInformationFromSercer);
  }

  @override
  SocialNetworkProvider getSocialNetworkProviderById(int id) {
    return socialNetworkProviders.where((provider) => provider.id == id).first;
  }
}
