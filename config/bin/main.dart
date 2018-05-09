
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

import 'dart:io';
import 'dart:async';

import 'dart:typed_data';
import "package:ini/ini.dart" as ini;

// import 'package:config/config.dart' as config;
import 'package:config/inf.pb.dart';

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Future<ConfigCategories> generateConfigCategories() async {
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

  for (int main = 0; main < nbCategories; ++main)
	{
    ConfigSubCategories subCategories = new ConfigSubCategories();
    if (!categoryMap.containsKey(main))
    {
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

Future<ConfigCategories> generateConfigOAuthProviders() async {
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
  
  for (int i = 0; i < nbEntries; ++i)
	{
    ConfigOAuthProvider entry = new ConfigOAuthProvider();
    if (!entryMap.containsKey(i))
    {
      res.all.add(entry);
      continue;
    }
    
    String section = entryMap[i];
    if (cfg.hasOption(section, 'visible')) entry.visible = (int.parse(cfg.get(section, 'visible')) == 1);
    if (cfg.hasOption(section, 'enabled')) entry.enabled = (int.parse(cfg.get(section, 'enabled')) == 1);
    entry.label = section;
    if (cfg.hasOption(section, 'fontAwesomeBrand')) entry.fontAwesomeBrand = int.parse(cfg.get(section, 'fontAwesomeBrand'));
    if (cfg.hasOption(section, 'host')) entry.host = cfg.get(section, 'host');
    if (cfg.hasOption(section, 'requestTokenUrl')) entry.requestTokenUrl = cfg.get(section, 'requestTokenUrl');
    if (cfg.hasOption(section, 'authenticateUrl')) entry.authenticateUrl = cfg.get(section, 'authenticateUrl');
    if (cfg.hasOption(section, 'authUrl')) entry.authUrl = cfg.get(section, 'authUrl');
    if (cfg.hasOption(section, 'authQuery')) entry.authQuery = cfg.get(section, 'authQuery');
    if (cfg.hasOption(section, 'callbackUrl')) entry.callbackUrl = cfg.get(section, 'callbackUrl');
    if (cfg.hasOption(section, 'consumerKey')) entry.consumerKey = cfg.get(section, 'consumerKey');
    if (cfg.hasOption(section, 'consumerSecret')) entry.consumerSecret = cfg.get(section, 'consumerSecret');
    if (cfg.hasOption(section, 'clientId')) entry.clientId = cfg.get(section, 'clientId');
    if (cfg.hasOption(section, 'nativeAuth')) entry.nativeAuth = cfg.get(section, 'nativeAuth');
    
    res.all.add(entry);
	}

  return res;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

generateConfig() async {
  Config config = new Config();
  config.clientVersion = 2;
  config.categories = await generateConfigCategories();
  config.oauthProviders = await generateConfigOAuthProviders();
  print(config.writeToJson());
  Uint8List configBuffer = config.writeToBuffer();
  new File("config.bin").writeAsBytes(configBuffer, flush: true);
}

main(List<String> arguments) {
  generateConfig();
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/* end of file */
