///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

class Config_SubCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Config_SubCategories')
    ..pPS(1, 'label')
    ..hasRequiredFields = false
  ;

  Config_SubCategories() : super();
  Config_SubCategories.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Config_SubCategories.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Config_SubCategories clone() => new Config_SubCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Config_SubCategories create() => new Config_SubCategories();
  static PbList<Config_SubCategories> createRepeated() => new PbList<Config_SubCategories>();
  static Config_SubCategories getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfig_SubCategories();
    return _defaultInstance;
  }
  static Config_SubCategories _defaultInstance;
  static void $checkItem(Config_SubCategories v) {
    if (v is! Config_SubCategories) checkItemFailed(v, 'Config_SubCategories');
  }

  List<String> get label => $_getList(0);
}

class _ReadonlyConfig_SubCategories extends Config_SubCategories with ReadonlyMessageMixin {}

class Config_Categories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Config_Categories')
    ..pp<Config_SubCategories>(1, 'sub', PbFieldType.PM, Config_SubCategories.$checkItem, Config_SubCategories.create)
    ..hasRequiredFields = false
  ;

  Config_Categories() : super();
  Config_Categories.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Config_Categories.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Config_Categories clone() => new Config_Categories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Config_Categories create() => new Config_Categories();
  static PbList<Config_Categories> createRepeated() => new PbList<Config_Categories>();
  static Config_Categories getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfig_Categories();
    return _defaultInstance;
  }
  static Config_Categories _defaultInstance;
  static void $checkItem(Config_Categories v) {
    if (v is! Config_Categories) checkItemFailed(v, 'Config_Categories');
  }

  List<Config_SubCategories> get sub => $_getList(0);
}

class _ReadonlyConfig_Categories extends Config_Categories with ReadonlyMessageMixin {}

class Config extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Config')
    ..a<Config_Categories>(1, 'categories', PbFieldType.OM, Config_Categories.getDefault, Config_Categories.create)
    ..hasRequiredFields = false
  ;

  Config() : super();
  Config.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Config.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Config clone() => new Config()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Config create() => new Config();
  static PbList<Config> createRepeated() => new PbList<Config>();
  static Config getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfig();
    return _defaultInstance;
  }
  static Config _defaultInstance;
  static void $checkItem(Config v) {
    if (v is! Config) checkItemFailed(v, 'Config');
  }

  Config_Categories get categories => $_getN(0);
  set categories(Config_Categories v) { setField(1, v); }
  bool hasCategories() => $_has(0);
  void clearCategories() => clearField(1);
}

class _ReadonlyConfig extends Config with ReadonlyMessageMixin {}

