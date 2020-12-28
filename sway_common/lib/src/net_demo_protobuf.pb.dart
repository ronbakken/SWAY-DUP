///
//  Generated code. Do not modify.
//  source: net_demo_protobuf.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class NetDemoAllOffers extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NetDemoAllOffers',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'inf'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  NetDemoAllOffers._() : super();
  factory NetDemoAllOffers() => create();
  factory NetDemoAllOffers.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NetDemoAllOffers.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NetDemoAllOffers clone() => NetDemoAllOffers()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NetDemoAllOffers copyWith(void Function(NetDemoAllOffers) updates) =>
      super.copyWith((message) => updates(
          message as NetDemoAllOffers)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NetDemoAllOffers create() => NetDemoAllOffers._();
  NetDemoAllOffers createEmptyInstance() => create();
  static $pb.PbList<NetDemoAllOffers> createRepeated() =>
      $pb.PbList<NetDemoAllOffers>();
  @$core.pragma('dart2js:noInline')
  static NetDemoAllOffers getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetDemoAllOffers>(create);
  static NetDemoAllOffers _defaultInstance;
}
