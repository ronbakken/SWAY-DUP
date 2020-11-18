///
//  Generated code. Do not modify.
//  source: net_demo_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class NetDemoAllOffers extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('NetDemoAllOffers',
      package: const $pb.PackageName('inf'))
    ..hasRequiredFields = false;

  NetDemoAllOffers() : super();
  NetDemoAllOffers.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  NetDemoAllOffers.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  NetDemoAllOffers clone() => new NetDemoAllOffers()..mergeFromMessage(this);
  NetDemoAllOffers copyWith(void Function(NetDemoAllOffers) updates) =>
      super.copyWith((message) => updates(message as NetDemoAllOffers));
  $pb.BuilderInfo get info_ => _i;
  static NetDemoAllOffers create() => new NetDemoAllOffers();
  NetDemoAllOffers createEmptyInstance() => create();
  static $pb.PbList<NetDemoAllOffers> createRepeated() =>
      new $pb.PbList<NetDemoAllOffers>();
  static NetDemoAllOffers getDefault() =>
      _defaultInstance ??= create()..freeze();
  static NetDemoAllOffers _defaultInstance;
  static void $checkItem(NetDemoAllOffers v) {
    if (v is! NetDemoAllOffers) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }
}
