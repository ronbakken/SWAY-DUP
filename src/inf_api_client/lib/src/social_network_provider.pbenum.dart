///
//  Generated code. Do not modify.
//  source: social_network_provider.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class SocialNetworkProviderType extends $pb.ProtobufEnum {
  static const SocialNetworkProviderType INSTAGRAM = const SocialNetworkProviderType._(0, 'INSTAGRAM');
  static const SocialNetworkProviderType FACEBOOK = const SocialNetworkProviderType._(1, 'FACEBOOK');
  static const SocialNetworkProviderType TWITTER = const SocialNetworkProviderType._(2, 'TWITTER');
  static const SocialNetworkProviderType YOU_TUBE = const SocialNetworkProviderType._(3, 'YOU_TUBE');
  static const SocialNetworkProviderType SNAPCHAT = const SocialNetworkProviderType._(4, 'SNAPCHAT');
  static const SocialNetworkProviderType CUSTOM_SOCIALNET_WORK_PROVIDER = const SocialNetworkProviderType._(5, 'CUSTOM_SOCIALNET_WORK_PROVIDER');

  static const List<SocialNetworkProviderType> values = const <SocialNetworkProviderType> [
    INSTAGRAM,
    FACEBOOK,
    TWITTER,
    YOU_TUBE,
    SNAPCHAT,
    CUSTOM_SOCIALNET_WORK_PROVIDER,
  ];

  static final Map<int, SocialNetworkProviderType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SocialNetworkProviderType valueOf(int value) => _byValue[value];
  static void $checkItem(SocialNetworkProviderType v) {
    if (v is! SocialNetworkProviderType) $pb.checkItemFailed(v, 'SocialNetworkProviderType');
  }

  const SocialNetworkProviderType._(int v, String n) : super(v, n);
}

