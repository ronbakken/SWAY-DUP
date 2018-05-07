
import 'dart:io';
import 'dart:async';

import "package:ini/ini.dart" as ini;

// import 'package:config/config.dart' as config;
import 'package:config/inf.pb.dart';

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

    subCategories.label.add(section);

    for (int sub = 1; sub < nbSubCategories; ++sub) {
      if (iniCategories.hasOption(section, sub.toString())) {
        subCategories.label.add(iniCategories.get(section, sub.toString()));
      } else {
        subCategories.label.add("");
      }
    }

    categories.sub.add(subCategories);
  }

  return categories;
}

generateConfig() async {
  Config config = new Config();
  config.categories = await generateConfigCategories();
  print(config.writeToJson());
}

main(List<String> arguments) {
  // print('Hello world: ${config.calculate()}!');
  generateConfig();
}

/* end of file */
