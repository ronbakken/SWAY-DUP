///
//  Generated code. Do not modify.
//  source: net_profile_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'data_protobuf.pb.dart' as $4;

class NetGetProfile extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetGetProfile',
      package: const $pb.PackageName('inf_common'))
    ..aInt64(1, 'accountId')
    ..hasRequiredFields = false;

  NetGetProfile() : super();
  NetGetProfile.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetGetProfile.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetGetProfile clone() => new NetGetProfile()..mergeFromMessage(this);
  NetGetProfile copyWith(void Function(NetGetProfile) updates) =>
      super.copyWith((message) => updates(message as NetGetProfile));
  $pb.BuilderInfo get info_ => _i;
  static NetGetProfile create() => new NetGetProfile();
  static $pb.PbList<NetGetProfile> createRepeated() =>
      new $pb.PbList<NetGetProfile>();
  static NetGetProfile getDefault() => _defaultInstance ??= create()..freeze();
  static NetGetProfile _defaultInstance;
  static void $checkItem(NetGetProfile v) {
    if (v is! NetGetProfile) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Int64 get accountId => $_getI64(0);
  set accountId(Int64 v) {
    $_setInt64(0, v);
  }

  bool hasAccountId() => $_has(0);
  void clearAccountId() => clearField(1);
}

class NetProfile extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetProfile',
      package: const $pb.PackageName('inf_common'))
    ..a<$4.DataAccount>(1, 'account', $pb.PbFieldType.OM,
        $4.DataAccount.getDefault, $4.DataAccount.create)
    ..aOB(3, 'summary')
    ..aOB(4, 'detail')
    ..hasRequiredFields = false;

  NetProfile() : super();
  NetProfile.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetProfile.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetProfile clone() => new NetProfile()..mergeFromMessage(this);
  NetProfile copyWith(void Function(NetProfile) updates) =>
      super.copyWith((message) => updates(message as NetProfile));
  $pb.BuilderInfo get info_ => _i;
  static NetProfile create() => new NetProfile();
  static $pb.PbList<NetProfile> createRepeated() =>
      new $pb.PbList<NetProfile>();
  static NetProfile getDefault() => _defaultInstance ??= create()..freeze();
  static NetProfile _defaultInstance;
  static void $checkItem(NetProfile v) {
    if (v is! NetProfile) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  $4.DataAccount get account => $_getN(0);
  set account($4.DataAccount v) {
    setField(1, v);
  }

  bool hasAccount() => $_has(0);
  void clearAccount() => clearField(1);

  bool get summary => $_get(1, false);
  set summary(bool v) {
    $_setBool(1, v);
  }

  bool hasSummary() => $_has(1);
  void clearSummary() => clearField(3);

  bool get detail => $_get(2, false);
  set detail(bool v) {
    $_setBool(2, v);
  }

  bool hasDetail() => $_has(2);
  void clearDetail() => clearField(4);
}
