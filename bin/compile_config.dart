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

Future<ConfigServices> generateConfigServices(
    String fileName, bool server) async {
  List<String> lines = await new File(fileName).readAsLines();
  ConfigServices res = new ConfigServices();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  for (String section in cfg.sections()) {
    if (section == "Common" ||
        (section == "Server" && server) ||
        (section == "Client" && !server)) {
      if (cfg.hasOption(section, 'domain'))
        res.domain = cfg.get(section, 'domain');
      if (cfg.hasOption(section, 'endPoints'))
        res.endPoints.addAll(cfg.get(section, 'endPoints').split(','));
      if (cfg.hasOption(section, 'applicationToken'))
        res.applicationToken = cfg.get(section, 'applicationToken');
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

      if (cfg.hasOption(section, 'backendPush'))
        res.backendPush = cfg.get(section, 'backendPush');
      if (cfg.hasOption(section, 'backendExplore'))
        res.backendExplore = cfg.get(section, 'backendExplore');
      if (cfg.hasOption(section, 'backendJwt'))
        res.backendJwt = cfg.get(section, 'backendJwt');

      if (cfg.hasOption(section, 'spacesRegion'))
        res.spacesRegion = cfg.get(section, 'spacesRegion');
      if (cfg.hasOption(section, 'spacesKey'))
        res.spacesKey = cfg.get(section, 'spacesKey');
      if (cfg.hasOption(section, 'spacesSecret'))
        res.spacesSecret = cfg.get(section, 'spacesSecret');
      if (cfg.hasOption(section, 'spacesBucket'))
        res.spacesBucket = cfg.get(section, 'spacesBucket');

      if (cfg.hasOption(section, 'accountDbHost'))
        res.accountDbHost = cfg.get(section, 'accountDbHost');
      if (cfg.hasOption(section, 'accountDbPort'))
        res.accountDbPort = int.parse(cfg.get(section, 'accountDbPort'));
      if (cfg.hasOption(section, 'accountDbUser'))
        res.accountDbUser = cfg.get(section, 'accountDbUser');
      if (cfg.hasOption(section, 'accountDbPassword'))
        res.accountDbPassword = cfg.get(section, 'accountDbPassword');
      if (cfg.hasOption(section, 'accountDbDatabase'))
        res.accountDbDatabase = cfg.get(section, 'accountDbDatabase');

      if (cfg.hasOption(section, 'proposalDbHost'))
        res.proposalDbHost = cfg.get(section, 'proposalDbHost');
      if (cfg.hasOption(section, 'proposalDbPort'))
        res.proposalDbPort = int.parse(cfg.get(section, 'proposalDbPort'));
      if (cfg.hasOption(section, 'proposalDbUser'))
        res.proposalDbUser = cfg.get(section, 'proposalDbUser');
      if (cfg.hasOption(section, 'proposalDbPassword'))
        res.proposalDbPassword = cfg.get(section, 'proposalDbPassword');
      if (cfg.hasOption(section, 'proposalDbDatabase'))
        res.proposalDbDatabase = cfg.get(section, 'proposalDbDatabase');

      if (cfg.hasOption(section, 'generalDbHost'))
        res.generalDbHost = cfg.get(section, 'generalDbHost');
      if (cfg.hasOption(section, 'generalDbPort'))
        res.generalDbPort = int.parse(cfg.get(section, 'generalDbPort'));
      if (cfg.hasOption(section, 'generalDbUser'))
        res.generalDbUser = cfg.get(section, 'generalDbUser');
      if (cfg.hasOption(section, 'generalDbPassword'))
        res.generalDbPassword = cfg.get(section, 'generalDbPassword');
      if (cfg.hasOption(section, 'generalDbDatabase'))
        res.generalDbDatabase = cfg.get(section, 'generalDbDatabase');

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

      if (cfg.hasOption(section, 'galleryUrl'))
        res.galleryUrl = cfg.get(section, 'galleryUrl');
      if (cfg.hasOption(section, 'galleryThumbnailUrl'))
        res.galleryThumbnailUrl = cfg.get(section, 'galleryThumbnailUrl');
      if (cfg.hasOption(section, 'galleryThumbnailBlurredUrl'))
        res.galleryThumbnailBlurredUrl =
            cfg.get(section, 'galleryThumbnailBlurredUrl');
      if (cfg.hasOption(section, 'galleryCoverUrl'))
        res.galleryCoverUrl = cfg.get(section, 'galleryCoverUrl');
      if (cfg.hasOption(section, 'galleryCoverBlurredUrl'))
        res.galleryCoverBlurredUrl = cfg.get(section, 'galleryCoverBlurredUrl');
      if (cfg.hasOption(section, 'galleryPictureUrl'))
        res.galleryPictureUrl = cfg.get(section, 'galleryPictureUrl');
      if (cfg.hasOption(section, 'galleryPictureBlurredUrl'))
        res.galleryPictureBlurredUrl =
            cfg.get(section, 'galleryPictureBlurredUrl');

      if (cfg.hasOption(section, 'ipstackApi'))
        res.ipstackApi = cfg.get(section, 'ipstackApi');
      if (cfg.hasOption(section, 'ipstackKey'))
        res.ipstackKey = cfg.get(section, 'ipstackKey');

      if (cfg.hasOption(section, 'freshdeskApi'))
        res.freshdeskApi = cfg.get(section, 'freshdeskApi');
      if (cfg.hasOption(section, 'freshdeskKey'))
        res.freshdeskKey = cfg.get(section, 'freshdeskKey');

      if (cfg.hasOption(section, 'pexelsApi'))
        res.pexelsApi = cfg.get(section, 'pexelsApi');
      if (cfg.hasOption(section, 'pexelsKey'))
        res.pexelsKey = cfg.get(section, 'pexelsKey');
    }
  }

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<ConfigFeatureSwitches> generateConfigFeatureSwitches(bool server) async {
  List<String> lines = await new File("config/services.ini").readAsLines();
  ConfigFeatureSwitches res = new ConfigFeatureSwitches();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  for (String section in cfg.sections()) {
    if (cfg.hasOption(section, 'createProposal'))
      res.createProposal = int.parse(cfg.get(section, 'createProposal')) != 1;

    if (cfg.hasOption(section, 'createSession'))
      res.createSession = int.parse(cfg.get(section, 'createSession')) != 1;
    if (cfg.hasOption(section, 'createAccount'))
      res.createAccount = int.parse(cfg.get(section, 'createAccount')) != 1;
    if (cfg.hasOption(section, 'removeAccount'))
      res.removeAccount = int.parse(cfg.get(section, 'removeAccount')) != 1;
    if (cfg.hasOption(section, 'removeSession'))
      res.removeSession = int.parse(cfg.get(section, 'removeSession')) != 1;
    if (cfg.hasOption(section, 'connectSocialMedia'))
      res.connectSocialMedia =
          int.parse(cfg.get(section, 'connectSocialMedia')) != 1;
    if (cfg.hasOption(section, 'removeSocialMedia'))
      res.removeSocialMedia =
          int.parse(cfg.get(section, 'removeSocialMedia')) != 1;
    if (cfg.hasOption(section, 'updateProfile'))
      res.updateProfile = int.parse(cfg.get(section, 'updateProfile')) != 1;

    if (cfg.hasOption(section, 'createOffer'))
      res.createOffer = int.parse(cfg.get(section, 'createOffer')) != 1;
    if (cfg.hasOption(section, 'updateOffer'))
      res.updateOffer = int.parse(cfg.get(section, 'updateOffer')) != 1;
    if (cfg.hasOption(section, 'closeOffer'))
      res.closeOffer = int.parse(cfg.get(section, 'closeOffer')) != 1;
    if (cfg.hasOption(section, 'archiveOffer'))
      res.archiveOffer = int.parse(cfg.get(section, 'archiveOffer')) != 1;

    if (cfg.hasOption(section, 'sendChat'))
      res.sendChat = int.parse(cfg.get(section, 'sendChat')) != 1;
    if (cfg.hasOption(section, 'makeDeal'))
      res.makeDeal = int.parse(cfg.get(section, 'makeDeal')) != 1;
    if (cfg.hasOption(section, 'reportProposal'))
      res.reportProposal = int.parse(cfg.get(section, 'reportProposal')) != 1;
    if (cfg.hasOption(section, 'disputeDeal'))
      res.disputeDeal = int.parse(cfg.get(section, 'disputeDeal')) != 1;

    if (cfg.hasOption(section, 'uploadImage'))
      res.uploadImage = int.parse(cfg.get(section, 'uploadImage')) != 1;
    if (cfg.hasOption(section, 'makeImagePublic'))
      res.makeImagePublic = int.parse(cfg.get(section, 'makeImagePublic')) != 1;
    if (cfg.hasOption(section, 'listImages'))
      res.listImages = int.parse(cfg.get(section, 'listImages')) != 1;
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

  String welcomeCloudinaryUrl = cfg.get("Welcome", 'galleryUrl');
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
  await spaces.close();

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
    entry.providerId = i;
    if (cfg.hasOption(section, 'key')) entry.key = cfg.get(section, 'key');
    if (cfg.hasOption(section, 'visible'))
      entry.visible = (int.parse(cfg.get(section, 'visible')) == 1);
    if (cfg.hasOption(section, 'canConnect'))
      entry.canConnect = (int.parse(cfg.get(section, 'canConnect')) == 1);
    if (cfg.hasOption(section, 'canAlwaysAuthenticate'))
      entry.canAlwaysAuthenticate =
          (int.parse(cfg.get(section, 'canAlwaysAuthenticate')) == 1);
    if (cfg.hasOption(section, 'showInProfile'))
      entry.showInProfile = (int.parse(cfg.get(section, 'showInProfile')) == 1);
    if (cfg.hasOption(section, 'deliverablesChannel'))
      entry.deliverablesChannel =
          int.parse(cfg.get(section, 'deliverablesChannel'));
    entry.label = section;
    if (!server) {
      if (cfg.hasOption(section, 'foregroundImage')) {
        entry.foregroundImageId = assets[cfg.get(section, 'foregroundImage')];
      }
      if (cfg.hasOption(section, 'backgroundImage')) {
        entry.backgroundImageId = assets[cfg.get(section, 'backgroundImage')];
      }
      if (cfg.hasOption(section, 'monochromeForegroundImage')) {
        entry.monochromeForegroundImageId =
            assets[cfg.get(section, 'monochromeForegroundImage')];
      }
      if (cfg.hasOption(section, 'monochromeBackgroundImage')) {
        entry.monochromeBackgroundImageId =
            assets[cfg.get(section, 'monochromeBackgroundImage')];
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
    entry.categoryId = id;
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
      if (cfg.hasOption(section, 'monochromeForegroundImage')) {
        entry.monochromeForegroundImageId =
            assets[cfg.get(section, 'monochromeForegroundImage')];
      }
      if (cfg.hasOption(section, 'monochromeBackgroundImage')) {
        entry.monochromeBackgroundImageId =
            assets[cfg.get(section, 'monochromeBackgroundImage')];
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
  List<String> lines =
      await new File("config/content_formats.ini").readAsLines();
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
    entry.formatId = id;
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
      if (cfg.hasOption(section, 'monochromeForegroundImage')) {
        entry.monochromeForegroundImageId =
            assets[cfg.get(section, 'monochromeForegroundImage')];
      }
      if (cfg.hasOption(section, 'monochromeBackgroundImage')) {
        entry.monochromeBackgroundImageId =
            assets[cfg.get(section, 'monochromeBackgroundImage')];
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

Future<void> generateConfig(Int64 timestamp, bool server) async {
  ConfigData config = new ConfigData();
  config.clientVersion = 3;
  config.timestamp = timestamp;
  config.region = "US";
  config.language = "en";
  config.services = await generateConfigServices("config/services.ini", server);
  config.featureSwitches = await generateConfigFeatureSwitches(server);
  config.assets.addAll(await generateConfigAssets(server));
  Map<String, int> assets = <String, int>{};
  for (int i = 0; i < config.assets.length; ++i) {
    assets[config.assets[i].name] = i;
  }
  config.content = await generateConfigContent(server);
  config.oauthProviders
      .addAll(await generateConfigOAuthProviders(assets, server));
  config.categories.addAll(await generateConfigCategories(assets, server));
  config.contentFormats
      .addAll(await generateConfigContentFormats(assets, server));
  // print(config.content);
  Uint8List configBuffer = config.writeToBuffer();
  new File(server ? "build/config_server.bin" : "build/config.bin")
      .writeAsBytes(configBuffer, flush: true);
}

Future<void> adjustConfig(String suffix, bool server) async {
  ConfigData config = ConfigData()
    ..mergeFromBuffer(
        await new File(server ? "build/config_server.bin" : "build/config.bin")
            .readAsBytes());
  ConfigServices services = await generateConfigServices(
      "config_" + suffix + "/services.ini", server);
  if (services.endPoints.isNotEmpty)
    config.services.endPoints.clear();
  if (services.elasticsearchApi.isNotEmpty)
    config.services.clearElasticsearchBasicAuth();
  config.services.mergeFromMessage(services);
  new File(server
          ? "build/config_" + suffix + "_server.bin"
          : "build/config_" + suffix + ".bin")
      .writeAsBytes(config.writeToBuffer(), flush: true);
}

main(List<String> arguments) async {
  Int64 timestamp =
      new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch);
  Future<void> f1 = generateConfig(timestamp, false);
  Future<void> f2 = generateConfig(timestamp, true);
  await f1;
  await f2;
  await adjustConfig("local", false);
  await adjustConfig("local", true);
  await adjustConfig("ats3", false);
  await adjustConfig("ats3", true);
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* end of file */
