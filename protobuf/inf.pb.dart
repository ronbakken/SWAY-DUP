///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf_inf;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

class ConfigCategories_SubCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigCategories_SubCategories')
    ..pPS(1, 'label')
    ..hasRequiredFields = false
  ;

  ConfigCategories_SubCategories() : super();
  ConfigCategories_SubCategories.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConfigCategories_SubCategories.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConfigCategories_SubCategories clone() => new ConfigCategories_SubCategories()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConfigCategories_SubCategories create() => new ConfigCategories_SubCategories();
  static PbList<ConfigCategories_SubCategories> createRepeated() => new PbList<ConfigCategories_SubCategories>();
  static ConfigCategories_SubCategories getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConfigCategories_SubCategories();
    return _defaultInstance;
  }
  static ConfigCategories_SubCategories _defaultInstance;
  static void $checkItem(ConfigCategories_SubCategories v) {
    if (v is! ConfigCategories_SubCategories) checkItemFailed(v, 'ConfigCategories_SubCategories');
  }

  List<String> get label => $_getList(0);
}

class _ReadonlyConfigCategories_SubCategories extends ConfigCategories_SubCategories with ReadonlyMessageMixin {}

class ConfigCategories extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConfigCategories')
    ..pp<ConfigCategories_SubCategories>(1, 'categories', PbFieldType.PM, ConfigCategories_SubCategories.$checkItem, ConfigCategories_SubCategories.create)
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

  List<ConfigCategories_SubCategories> get categories => $_getList(0);
}

class _ReadonlyConfigCategories extends ConfigCategories with ReadonlyMessageMixin {}

