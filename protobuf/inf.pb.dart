///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

class ConfigSubCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigSubCategories')
    ..pPS(1, 'labels')
    ..hasRequiredFields = false
  ;

  ConfigSubCategories() : super();
  ConfigSubCategories.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigSubCategories.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigSubCategories clone() => new ConfigSubCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigSubCategories create() => new ConfigSubCategories();
  static PbList<ConfigSubCategories> createRepeated() => new PbList<ConfigSubCategories>();
  static ConfigSubCategories getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigSubCategories();
    return _defaultInstance;
  }
  static ConfigSubCategories _defaultInstance;
  static void $checkItem(ConfigSubCategories v) {
    if (v is! ConfigSubCategories) checkItemFailed(v, 'ConfigSubCategories');
  }

  List<String> get labels => $_getList(0);
}

class _ReadonlyConfigSubCategories extends ConfigSubCategories with ReadonlyMessageMixin {}

class ConfigCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigCategories')
    ..pp<ConfigSubCategories>(1, 'sub', PbFieldType.PM, ConfigSubCategories.$checkItem, ConfigSubCategories.create)
    ..hasRequiredFields = false
  ;

  ConfigCategories() : super();
  ConfigCategories.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigCategories.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigCategories clone() => new ConfigCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigCategories create() => new ConfigCategories();
  static PbList<ConfigCategories> createRepeated() => new PbList<ConfigCategories>();
  static ConfigCategories getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigCategories();
    return _defaultInstance;
  }
  static ConfigCategories _defaultInstance;
  static void $checkItem(ConfigCategories v) {
    if (v is! ConfigCategories) checkItemFailed(v, 'ConfigCategories');
  }

  List<ConfigSubCategories> get sub => $_getList(0);
}

class _ReadonlyConfigCategories extends ConfigCategories with ReadonlyMessageMixin {}

class Config extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Config')
    ..a<ConfigCategories>(1, 'categories', PbFieldType.OM, ConfigCategories.getDefault, ConfigCategories.create)
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

  ConfigCategories get categories => $_getN(0);
  set categories(ConfigCategories v) { setField(1, v); }
  bool hasCategories() => $_has(0);
  void clearCategories() => clearField(1);
}

class _ReadonlyConfig extends Config with ReadonlyMessageMixin {}

class CategoryId extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CategoryId')
    ..a<int>(1, 'main', PbFieldType.O3)
    ..a<int>(2, 'sub', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  CategoryId() : super();
  CategoryId.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CategoryId.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CategoryId clone() => new CategoryId()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CategoryId create() => new CategoryId();
  static PbList<CategoryId> createRepeated() => new PbList<CategoryId>();
  static CategoryId getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCategoryId();
    return _defaultInstance;
  }
  static CategoryId _defaultInstance;
  static void $checkItem(CategoryId v) {
    if (v is! CategoryId) checkItemFailed(v, 'CategoryId');
  }

  int get main => $_get(0, 0);
  set main(int v) { $_setUnsignedInt32(0, v); }
  bool hasMain() => $_has(0);
  void clearMain() => clearField(1);

  int get sub => $_get(1, 0);
  set sub(int v) { $_setUnsignedInt32(1, v); }
  bool hasSub() => $_has(1);
  void clearSub() => clearField(2);
}

class _ReadonlyCategoryId extends CategoryId with ReadonlyMessageMixin {}

class CategoryIdSet extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CategoryIdSet')
    ..pp<CategoryId>(1, 'ids', PbFieldType.PM, CategoryId.$checkItem, CategoryId.create)
    ..hasRequiredFields = false
  ;

  CategoryIdSet() : super();
  CategoryIdSet.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CategoryIdSet.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CategoryIdSet clone() => new CategoryIdSet()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CategoryIdSet create() => new CategoryIdSet();
  static PbList<CategoryIdSet> createRepeated() => new PbList<CategoryIdSet>();
  static CategoryIdSet getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCategoryIdSet();
    return _defaultInstance;
  }
  static CategoryIdSet _defaultInstance;
  static void $checkItem(CategoryIdSet v) {
    if (v is! CategoryIdSet) checkItemFailed(v, 'CategoryIdSet');
  }

  List<CategoryId> get ids => $_getList(0);
}

class _ReadonlyCategoryIdSet extends CategoryIdSet with ReadonlyMessageMixin {}

