/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'package:sway_common/inf_common.dart';

class Categories {
  static List<int> getLeafCategories(ConfigData config, List<int> categories) {
    final Set<int> res = Set<int>();
    res.addAll(categories);
    for (int category in categories) {
      int parent = config.categories[category].parentId;
      while (parent != 0) {
        res.remove(parent);
        parent = config.categories[parent].parentId;
      }
    }
    return res.toList();
  }

  static List<int> getRootCategories(ConfigData config, List<int> categories) {
    final Set<int> res = Set<int>();
    for (int category in categories) {
      int current = category;
      int parent = config.categories[category].parentId;
      while (parent != 0) {
        current = parent;
        parent = config.categories[parent].parentId;
      }
      res.add(current);
    }
    return res.toList();
  }

  static List<int> getExtendedCategories(
      ConfigData config, List<int> categories) {
    final Set<int> res = Set<int>();
    res.addAll(categories);
    for (int category in categories) {
      int parent = config.categories[category].parentId;
      while (parent != 0) {
        res.add(parent);
        parent = config.categories[parent].parentId;
      }
    }
    return res.toList();
  }

  static List<String> getKeywords(ConfigData config, List<int> categories) {
    final Set<String> res = Set<String>();
    for (int category in categories)
      res.addAll(config.categories[category].keywords);
    return res.toList();
  }
}

/* end of file */
