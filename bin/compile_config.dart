////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'dart:typed_data';
import "package:ini/ini.dart" as ini;
import 'package:fixnum/fixnum.dart';
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<ConfigServices> generateConfigServices(bool server) async {
  List<String> lines = await new File("config/services.ini").readAsLines();
  ConfigServices res = new ConfigServices();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  for (String section in cfg.sections()) {
    if (section == "Common" ||
        (section == "Server" && server) ||
        (section == "Client" && !server)) {
      if (cfg.hasOption(section, 'domain'))
        res.domain = cfg.get(section, 'domain');
      if (cfg.hasOption(section, 'endPoint'))
        res.endPoint = cfg.get(section, 'endPoint');
      if (cfg.hasOption(section, 'service'))
        res.service = cfg.get(section, 'service');
      if (cfg.hasOption(section, 'configUrl'))
        res.configUrl = cfg.get(section, 'configUrl');
      if (cfg.hasOption(section, 'termsOfServiceUrl'))
        res.termsOfServiceUrl = cfg.get(section, 'termsOfServiceUrl');
      if (cfg.hasOption(section, 'privacyPolicyUrl'))
        res.privacyPolicyUrl = cfg.get(section, 'privacyPolicyUrl');
      if (cfg.hasOption(section, 'connectionFailedUrl'))
        res.connectionFailedUrl = cfg.get(section, 'connectionFailedUrl');
      if (cfg.hasOption(section, 'salt'))
        res.salt = utf8.encode(cfg.get(section, 'salt'));

      if (cfg.hasOption(section, 'spacesRegion'))
        res.spacesRegion = cfg.get(section, 'spacesRegion');
      if (cfg.hasOption(section, 'spacesKey'))
        res.spacesKey = cfg.get(section, 'spacesKey');
      if (cfg.hasOption(section, 'spacesSecret'))
        res.spacesSecret = cfg.get(section, 'spacesSecret');
      if (cfg.hasOption(section, 'spacesBucket'))
        res.spacesBucket = cfg.get(section, 'spacesBucket');

      if (cfg.hasOption(section, 'mariadbHost'))
        res.mariadbHost = cfg.get(section, 'mariadbHost');
      if (cfg.hasOption(section, 'mariadbPort'))
        res.mariadbPort = int.parse(cfg.get(section, 'mariadbPort'));
      if (cfg.hasOption(section, 'mariadbUser'))
        res.mariadbUser = cfg.get(section, 'mariadbUser');
      if (cfg.hasOption(section, 'mariadbPassword'))
        res.mariadbPassword = cfg.get(section, 'mariadbPassword');
      if (cfg.hasOption(section, 'mariadbDatabase'))
        res.mariadbDatabase = cfg.get(section, 'mariadbDatabase');

      if (cfg.hasOption(section, 'elasticsearchApi'))
        res.elasticsearchApi = cfg.get(section, 'elasticsearchApi');
      if (cfg.hasOption(section, 'elasticsearchBasicAuth'))
        res.elasticsearchBasicAuth = cfg.get(section, 'elasticsearchBasicAuth');

      if (cfg.hasOption(section, 'oneSignalAppId'))
        res.oneSignalAppId = cfg.get(section, 'oneSignalAppId');
      if (cfg.hasOption(section, 'oneSignalApiKey'))
        res.oneSignalApiKey = cfg.get(section, 'oneSignalApiKey');
      if (cfg.hasOption(section, 'oneSignalApi'))
        res.oneSignalApi = cfg.get(section, 'oneSignalApi');

      if (cfg.hasOption(section, 'firebaseServerKey'))
        res.firebaseServerKey = cfg.get(section, 'firebaseServerKey');
      if (cfg.hasOption(section, 'firebaseSenderId'))
        res.firebaseSenderId = cfg.get(section, 'firebaseSenderId');
      if (cfg.hasOption(section, 'firebaseLegacyApi'))
        res.firebaseLegacyApi = cfg.get(section, 'firebaseLegacyApi');
      if (cfg.hasOption(section, 'firebaseLegacyServerKey'))
        res.firebaseLegacyServerKey =
            cfg.get(section, 'firebaseLegacyServerKey');

      if (cfg.hasOption(section, 'mapboxApi'))
        res.mapboxApi = cfg.get(section, 'mapboxApi');
      if (cfg.hasOption(section, 'mapboxUrlTemplateDark'))
        res.mapboxUrlTemplateDark = cfg.get(section, 'mapboxUrlTemplateDark');
      if (cfg.hasOption(section, 'mapboxUrlTemplateLight'))
        res.mapboxUrlTemplateLight = cfg.get(section, 'mapboxUrlTemplateLight');
      if (cfg.hasOption(section, 'mapboxToken'))
        res.mapboxToken = cfg.get(section, 'mapboxToken');

      if (cfg.hasOption(section, 'cloudinaryUrl'))
        res.cloudinaryUrl = cfg.get(section, 'cloudinaryUrl');
      if (cfg.hasOption(section, 'cloudinaryThumbnailUrl'))
        res.cloudinaryThumbnailUrl = cfg.get(section, 'cloudinaryThumbnailUrl');
      if (cfg.hasOption(section, 'cloudinaryBlurredThumbnailUrl'))
        res.cloudinaryBlurredThumbnailUrl =
            cfg.get(section, 'cloudinaryBlurredThumbnailUrl');
      if (cfg.hasOption(section, 'cloudinaryCoverUrl'))
        res.cloudinaryCoverUrl = cfg.get(section, 'cloudinaryCoverUrl');
      if (cfg.hasOption(section, 'cloudinaryBlurredCoverUrl'))
        res.cloudinaryBlurredCoverUrl =
            cfg.get(section, 'cloudinaryBlurredCoverUrl');

      if (cfg.hasOption(section, 'ipstackApi'))
        res.ipstackApi = cfg.get(section, 'ipstackApi');
      if (cfg.hasOption(section, 'ipstackKey'))
        res.ipstackKey = cfg.get(section, 'ipstackKey');

      if (cfg.hasOption(section, 'freshdeskApi'))
        res.freshdeskApi = cfg.get(section, 'freshdeskApi');
      if (cfg.hasOption(section, 'freshdeskKey'))
        res.freshdeskKey = cfg.get(section, 'freshdeskKey');
    }
  }

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<List<ConfigAsset>> generateConfigAssets(bool server) async {
  List<ConfigAsset> res = new List<ConfigAsset>();
  res.add(new ConfigAsset());
  await for (FileSystemEntity fse in new Directory("assets").list()) {
    print(fse.path);
    ConfigAsset asset = new ConfigAsset();
    asset.name =
        fse.path.replaceFirst("assets\\", "").replaceFirst("assets/", "");
    if (fse.path.toLowerCase().endsWith(".svg")) {
      asset.svg = true;
    }
    if (!server) {
      asset.data =
          new Uint8List.fromList(await new File(fse.path).readAsBytes());
    }
    res.add(asset);
  }
  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<ConfigContent> generateConfigContent(bool server) async {
  List<String> lines = await new File("config/content.ini").readAsLines();
  ConfigContent res = new ConfigContent();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  String spacesRegion = cfg.get("Storage", 'spacesRegion');
  String spacesKey = cfg.get("Storage", 'spacesKey');
  String spacesSecret = cfg.get("Storage", 'spacesSecret');
  String spacesBucket = cfg.get("Storage", 'spacesBucket');

  String welcomeCloudinaryUrl = cfg.get("Welcome", 'cloudinaryUrl');
  String welcomeSpacesPrefix = cfg.get("Welcome", 'spacesPrefix');

  var spaces = new dospace.Spaces(
    region: spacesRegion,
    accessKey: spacesKey,
    secretKey: spacesSecret,
  );
  var bucket = spaces.bucket(spacesBucket);
  if (!server) {
    await for (dospace.BucketContent content
        in bucket.listContents(prefix: welcomeSpacesPrefix)) {
      // print(content.key);
      res.welcomeImageUrls
          .add(welcomeCloudinaryUrl.replaceAll('{key}', content.key));
    }
  }

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<List<ConfigOAuthProvider>> generateConfigOAuthProviders(
    Map<String, int> assets, bool server) async {
  List<String> lines =
      await new File("config/oauth_providers.ini").readAsLines();
  List<ConfigOAuthProvider> res = new List<ConfigOAuthProvider>();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  int nbEntries = 0;
  var entryMap = new Map<int, String>();
  for (String section in cfg.sections()) {
    int id = int.parse(cfg.get(section, "id"));
    print("$id: $section");
    if (id > nbEntries) nbEntries = id;
    entryMap[id] = section;
  }
  ++nbEntries;

  for (int i = 0; i < nbEntries; ++i) {
    ConfigOAuthProvider entry = new ConfigOAuthProvider();
    if (!entryMap.containsKey(i)) {
      res.add(entry);
      continue;
    }

    String section = entryMap[i];
    if (cfg.hasOption(section, 'visible'))
      entry.visible = (int.parse(cfg.get(section, 'visible')) == 1);
    if (cfg.hasOption(section, 'canConnect'))
      entry.canConnect = (int.parse(cfg.get(section, 'canConnect')) == 1);
    if (cfg.hasOption(section, 'canAlwaysAuthenticate'))
      entry.canAlwaysAuthenticate =
          (int.parse(cfg.get(section, 'canAlwaysAuthenticate')) == 1);
    if (cfg.hasOption(section, 'showInProfile'))
      entry.showInProfile = (int.parse(cfg.get(section, 'showInProfile')) == 1);
    entry.label = section;
    if (!server) {
      if (cfg.hasOption(section, 'foregroundImage')) {
        entry.foregroundImageId = assets[cfg.get(section, 'foregroundImage')];
      }
      if (cfg.hasOption(section, 'backgroundImage')) {
        entry.backgroundImageId = assets[cfg.get(section, 'backgroundImage')];
      }
      if (cfg.hasOption(section, 'foregroundFlat')) {
        entry.foregroundFlatId = assets[cfg.get(section, 'foregroundFlat')];
      }
      if (cfg.hasOption(section, 'backgroundFlat')) {
        entry.backgroundFlatId = assets[cfg.get(section, 'backgroundFlat')];
      }
    }
    if (cfg.hasOption(section, 'fontAwesomeBrand'))
      entry.fontAwesomeBrand = int.parse(cfg.get(section, 'fontAwesomeBrand'));
    if (cfg.hasOption(section, 'mechanism'))
      entry.mechanism =
          OAuthMechanism.valueOf(int.parse(cfg.get(section, 'mechanism')));
    if (server) {
      switch (entry.mechanism) {
        case OAuthMechanism.oauth1:
          {
            if (cfg.hasOption(section, 'host'))
              entry.host = cfg.get(section, 'host');
            if (cfg.hasOption(section, 'callbackUrl'))
              entry.callbackUrl = cfg.get(section, 'callbackUrl');
            if (cfg.hasOption(section, 'requestTokenUrl'))
              entry.requestTokenUrl = cfg.get(section, 'requestTokenUrl');
            if (cfg.hasOption(section, 'authenticateUrl'))
              entry.authenticateUrl = cfg.get(section, 'authenticateUrl');
            if (cfg.hasOption(section, 'accessTokenUrl'))
              entry.accessTokenUrl = cfg.get(section, 'accessTokenUrl');
            if (cfg.hasOption(section, 'consumerKey'))
              entry.consumerKey = cfg.get(section, 'consumerKey');
            if (cfg.hasOption(section, 'consumerSecret'))
              entry.consumerSecret = cfg.get(section, 'consumerSecret');
            if (cfg.hasOption(section, 'consumerKeyExposed'))
              entry.consumerKeyExposed =
                  (int.parse(cfg.get(section, 'consumerKeyExposed')) == 1);
            if (cfg.hasOption(section, 'consumerSecretExposed'))
              entry.consumerSecretExposed =
                  (int.parse(cfg.get(section, 'consumerSecretExposed')) == 1);
            break;
          }
        case OAuthMechanism.oauth2:
          {
            if (cfg.hasOption(section, 'host'))
              entry.host = cfg.get(section, 'host');
            if (cfg.hasOption(section, 'callbackUrl'))
              entry.callbackUrl = cfg.get(section, 'callbackUrl');
            if (cfg.hasOption(section, 'accessTokenUrl'))
              entry.accessTokenUrl = cfg.get(section, 'accessTokenUrl');
            if (cfg.hasOption(section, 'authUrl'))
              entry.authUrl = cfg.get(section, 'authUrl');
            if (cfg.hasOption(section, 'authQuery'))
              entry.authQuery = cfg.get(section, 'authQuery');
            if (cfg.hasOption(section, 'clientId'))
              entry.clientId = cfg.get(section, 'clientId');
            if (cfg.hasOption(section, 'clientSecret'))
              entry.clientSecret = cfg.get(section, 'clientSecret');
            if (cfg.hasOption(section, 'clientIdExposed'))
              entry.clientIdExposed =
                  (int.parse(cfg.get(section, 'clientIdExposed')) == 1);
            break;
          }
      }
    }
    if (cfg.hasOption(section, 'whitelistHosts')) {
      String whitelistHosts = cfg.get(section, 'whitelistHosts');
      entry.whitelistHosts.addAll(whitelistHosts.split(','));
    }
    if (server) {
      if (cfg.hasOption(section, 'keywords')) {
        String keywords = cfg.get(section, 'keywords');
        entry.keywords.addAll(keywords.split(','));
      }
    }

    res.add(entry);
  }

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<List<ConfigCategory>> generateConfigCategories(
    Map<String, int> assets, bool server) async {
  List<String> lines = await new File("config/categories.ini").readAsLines();
  List<ConfigCategory> categories = new List<ConfigCategory>();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  int nbEntries = 0;
  var categoryMap = new Map<int, String>();
  for (String section in cfg.sections()) {
    int id = int.parse(cfg.get(section, "id"));
    print("$id: $section");
    if (id > nbEntries) nbEntries = id;
    categoryMap[id] = section;
  }
  ++nbEntries;

  for (int id = 0; id < nbEntries; ++id) {
    ConfigCategory entry = new ConfigCategory();
    if (!categoryMap.containsKey(id)) {
      categories.add(entry);
      continue;
    }
    String section = categoryMap[id];
    if (cfg.hasOption(section, "parentId")) {
      entry.parentId = int.parse(cfg.get(section, 'parentId'));
    }
    entry.label = section;
    if (cfg.hasOption(section, "sorting")) {
      entry.sorting = int.parse(cfg.get(section, 'sorting'));
    }
    if (server) {
      if (cfg.hasOption(section, 'keywords')) {
        String keywords = cfg.get(section, 'keywords');
        entry.keywords.addAll(keywords.split(','));
      }
    } else {
      if (cfg.hasOption(section, 'foregroundImage')) {
        entry.foregroundImageId = assets[cfg.get(section, 'foregroundImage')];
      }
      if (cfg.hasOption(section, 'backgroundImage')) {
        entry.backgroundImageId = assets[cfg.get(section, 'backgroundImage')];
      }
      if (cfg.hasOption(section, 'foregroundFlat')) {
        entry.foregroundFlatId = assets[cfg.get(section, 'foregroundFlat')];
      }
      if (cfg.hasOption(section, 'backgroundFlat')) {
        entry.backgroundFlatId = assets[cfg.get(section, 'backgroundFlat')];
      }
    }
    if (cfg.hasOption(section, 'fontAwesomeIcon'))
      entry.fontAwesomeIcon = int.parse(cfg.get(section, 'fontAwesomeIcon'));

    categories.add(entry);
  }

  // Denormalize data for fast use
  for (int id = 0; id < nbEntries; ++id) {
    if (!categoryMap.containsKey(id)) {
      continue;
    }
    categories[categories[id].parentId].childIds.add(id);
  }

  // Sort
  for (int id = 0; id < nbEntries; ++id) {
    categories[id].childIds.sort((a, b) {
      if (categories[a].sorting != categories[b].sorting) {
        return categories[a].sorting.compareTo(categories[b].sorting);
      } else {
        return a.compareTo(b);
      }
    });
  }

  return categories;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<List<ConfigContentFormat>> generateConfigContentFormats(
    Map<String, int> assets, bool server) async {
  List<String> lines = await new File("config/content_formats.ini").readAsLines();
  List<ConfigContentFormat> res = new List<ConfigContentFormat>();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  int nbEntries = 0;
  var entryMap = new Map<int, String>();
  for (String section in cfg.sections()) {
    int id = int.parse(cfg.get(section, "id"));
    print("$id: $section");
    if (id > nbEntries) nbEntries = id;
    entryMap[id] = section;
  }
  ++nbEntries;

  for (int id = 0; id < nbEntries; ++id) {
    ConfigContentFormat entry = new ConfigContentFormat();
    if (!entryMap.containsKey(id)) {
      res.add(entry);
      continue;
    }
    String section = entryMap[id];
    entry.label = section;
    if (cfg.hasOption(section, "sorting")) {
      entry.sorting = int.parse(cfg.get(section, 'sorting'));
    }
    if (server) {
      if (cfg.hasOption(section, 'keywords')) {
        String keywords = cfg.get(section, 'keywords');
        entry.keywords.addAll(keywords.split(','));
      }
    } else {
      if (cfg.hasOption(section, 'foregroundImage')) {
        entry.foregroundImageId = assets[cfg.get(section, 'foregroundImage')];
      }
      if (cfg.hasOption(section, 'backgroundImage')) {
        entry.backgroundImageId = assets[cfg.get(section, 'backgroundImage')];
      }
      if (cfg.hasOption(section, 'foregroundFlat')) {
        entry.foregroundFlatId = assets[cfg.get(section, 'foregroundFlat')];
      }
      if (cfg.hasOption(section, 'backgroundFlat')) {
        entry.backgroundFlatId = assets[cfg.get(section, 'backgroundFlat')];
      }
    }
    if (cfg.hasOption(section, 'fontAwesomeIcon'))
      entry.fontAwesomeIcon = int.parse(cfg.get(section, 'fontAwesomeIcon'));

    res.add(entry);
  }

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<void> generateConfig(bool server) async {
  ConfigData config = new ConfigData();
  config.clientVersion = 3;
  config.timestamp =
      new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch);
  config.region = "US";
  config.language = "en";
  config.services = await generateConfigServices(server);
  config.assets.addAll(await generateConfigAssets(server));
  Map<String, int> assets = <String, int>{};
  for (int i = 0; i < config.assets.length; ++i) {
    assets[config.assets[i].name] = i;
  }
  config.content = await generateConfigContent(server);
  config.oauthProviders
      .addAll(await generateConfigOAuthProviders(assets, server));
  config.categories.addAll(await generateConfigCategories(assets, server));
  config.contentFormats.addAll(await generateConfigContentFormats(assets, server));
  print(config);
  Uint8List configBuffer = config.writeToBuffer();
  new File(server ? "config/config_server.bin" : "config/config.bin")
      .writeAsBytes(configBuffer, flush: true);
}

main(List<String> arguments) async {
  Future<void> f1 = generateConfig(false);
  Future<void> f2 = generateConfig(true);
  await f1;
  await f2;
  // exit(0);
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* end of file */
