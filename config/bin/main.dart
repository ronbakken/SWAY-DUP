////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

import 'dart:io';
import 'dart:async';

import 'dart:typed_data';
import "package:ini/ini.dart" as ini;
import 'package:fixnum/fixnum.dart';

// import 'package:config/config.dart' as config;
import 'package:config/protobuf/enum_protobuf.pb.dart';
import 'package:config/protobuf/config_protobuf.pb.dart';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<ConfigCategories> generateConfigCategories(bool server) async {
  List<String> lines = await new File("categories.ini").readAsLines();
  ConfigCategories categories = new ConfigCategories();
  ini.Config iniCategories = new ini.Config.fromStrings(lines);

  int nbCategories = 0;
  var categoryMap = new Map<int, String>();
  for (String section in iniCategories.sections()) {
    print(section);
    int id = int.parse(iniCategories.get(section, "id"));
    if (id > nbCategories) nbCategories = id;
    categoryMap[id] = section;
  }
  ++nbCategories;

  for (int main = 0; main < nbCategories; ++main) {
    ConfigSubCategories subCategories = new ConfigSubCategories();
    if (!categoryMap.containsKey(main)) {
      // subCategories.label.add("");
      categories.sub.add(subCategories);
      continue;
    }

    int nbSubCategories = 0;
    String section = categoryMap[main];
    for (var item in iniCategories.options(section)) {
      if (item != "id") {
        int id = int.parse(item);
        if (id > nbSubCategories) nbSubCategories = id;
      }
    }
    ++nbSubCategories;

    subCategories.labels.add(section);

    for (int sub = 1; sub < nbSubCategories; ++sub) {
      if (iniCategories.hasOption(section, sub.toString())) {
        subCategories.labels.add(iniCategories.get(section, sub.toString()));
      } else {
        subCategories.labels.add("");
      }
    }

    categories.sub.add(subCategories);
  }

  return categories;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<ConfigOAuthProviders> generateConfigOAuthProviders(bool server) async {
  List<String> lines = await new File("oauth_providers.ini").readAsLines();
  ConfigOAuthProviders res = new ConfigOAuthProviders();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  int nbEntries = 0;
  var entryMap = new Map<int, String>();
  for (String section in cfg.sections()) {
    print(section);
    int id = int.parse(cfg.get(section, "id"));
    if (id > nbEntries) nbEntries = id;
    entryMap[id] = section;
  }
  ++nbEntries;

  for (int i = 0; i < nbEntries; ++i) {
    ConfigOAuthProvider entry = new ConfigOAuthProvider();
    if (!entryMap.containsKey(i)) {
      res.all.add(entry);
      continue;
    }

    String section = entryMap[i];
    if (cfg.hasOption(section, 'visible'))
      entry.visible = (int.parse(cfg.get(section, 'visible')) == 1);
    if (cfg.hasOption(section, 'enabled'))
      entry.enabled = (int.parse(cfg.get(section, 'enabled')) == 1);
    entry.label = section;
    if (cfg.hasOption(section, 'fontAwesomeBrand'))
      entry.fontAwesomeBrand = int.parse(cfg.get(section, 'fontAwesomeBrand'));
    if (cfg.hasOption(section, 'mechanism'))
      entry.mechanism =
          OAuthMechanism.valueOf(int.parse(cfg.get(section, 'mechanism')));
    if (server) {
      switch (entry.mechanism) {
        case OAuthMechanism.OAM_OAUTH1:
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
            break;
          }
        case OAuthMechanism.OAM_OAUTH2:
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
            break;
          }
      }
    }
    if (cfg.hasOption(section, 'whitelistHosts')) {
      String whitelistHosts = cfg.get(section, 'whitelistHosts');
      entry.whitelistHosts.addAll(whitelistHosts.split(','));
    }

    res.all.add(entry);
  }

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<ConfigServices> generateConfigServices(bool server) async {
  List<String> lines = await new File("services.ini").readAsLines();
  ConfigServices res = new ConfigServices();
  ini.Config cfg = new ini.Config.fromStrings(lines);

  for (String section in cfg.sections()) {
    if (section == "Common" ||
        (section == "Server" && server) ||
        (section == "Client" && !server)) {
      if (cfg.hasOption(section, 'domain'))
        res.domain = cfg.get(section, 'domain');
      if (cfg.hasOption(section, 'apiHosts'))
        res.apiHosts.addAll(cfg.get(section, 'apiHosts').split(','));
      if (cfg.hasOption(section, 'configUrl'))
        res.configUrl = cfg.get(section, 'configUrl');
      if (cfg.hasOption(section, 'termsOfServiceUrl'))
        res.termsOfServiceUrl = cfg.get(section, 'termsOfServiceUrl');
      if (cfg.hasOption(section, 'privacyPolicyUrl'))
        res.privacyPolicyUrl = cfg.get(section, 'privacyPolicyUrl');
      if (cfg.hasOption(section, 'connectionFailedUrl'))
        res.connectionFailedUrl = cfg.get(section, 'connectionFailedUrl');

      if (cfg.hasOption(section, 'mapboxApi'))
        res.mapboxApi = cfg.get(section, 'mapboxApi');
      if (cfg.hasOption(section, 'mapboxUrlTemplateDark'))
        res.mapboxUrlTemplateDark = cfg.get(section, 'mapboxUrlTemplateDark');
      if (cfg.hasOption(section, 'mapboxUrlTemplateLight'))
        res.mapboxUrlTemplateLight = cfg.get(section, 'mapboxUrlTemplateLight');
      if (cfg.hasOption(section, 'mapboxToken'))
        res.mapboxToken = cfg.get(section, 'mapboxToken');

      if (cfg.hasOption(section, 'spacesRegion'))
        res.spacesRegion = cfg.get(section, 'spacesRegion');
      if (cfg.hasOption(section, 'spacesKey'))
        res.spacesKey = cfg.get(section, 'spacesKey');
      if (cfg.hasOption(section, 'spacesSecret'))
        res.spacesSecret = cfg.get(section, 'spacesSecret');
      if (cfg.hasOption(section, 'spacesBucket'))
        res.spacesBucket = cfg.get(section, 'spacesBucket');

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

      if (cfg.hasOption(section, 'freshdeskApi'))
        res.freshdeskApi = cfg.get(section, 'freshdeskApi');
      if (cfg.hasOption(section, 'freshdeskKey'))
        res.freshdeskKey = cfg.get(section, 'freshdeskKey');

      if (cfg.hasOption(section, 'firebaseServerKey'))
        res.firebaseServerKey = cfg.get(section, 'firebaseServerKey');
      if (cfg.hasOption(section, 'firebaseSenderId'))
        res.firebaseSenderId = cfg.get(section, 'firebaseSenderId');
      if (cfg.hasOption(section, 'firebaseLegacyApi'))
        res.firebaseLegacyApi = cfg.get(section, 'firebaseLegacyApi');
      if (cfg.hasOption(section, 'firebaseLegacyServerKey'))
        res.firebaseLegacyServerKey =
            cfg.get(section, 'firebaseLegacyServerKey');
    }
  }

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

generateConfig(bool server) async {
  ConfigData config = new ConfigData();
  config.clientVersion = 2;
  config.timestamp =
      new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch);
  config.categories = await generateConfigCategories(server);
  config.oauthProviders = await generateConfigOAuthProviders(server);
  config.services = await generateConfigServices(server);
  print(config.writeToJson());
  Uint8List configBuffer = config.writeToBuffer();
  new File(server ? "config_server.bin" : "config.bin")
      .writeAsBytes(configBuffer, flush: true);
}

main(List<String> arguments) {
  generateConfig(false);
  generateConfig(true);
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* end of file */
