///
//  Generated code. Do not modify.
//  source: social_network_provider.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class SocialNetworkProviderType extends $pb.ProtobufEnum {
  static const SocialNetworkProviderType INSTAGRAM = SocialNetworkProviderType._(0, 'INSTAGRAM');
  static const SocialNetworkProviderType FACEBOOK = SocialNetworkProviderType._(1, 'FACEBOOK');
  static const SocialNetworkProviderType TWITTER = SocialNetworkProviderType._(2, 'TWITTER');
  static const SocialNetworkProviderType YOU_TUBE = SocialNetworkProviderType._(3, 'YOU_TUBE');
  static const SocialNetworkProviderType SNAPCHAT = SocialNetworkProviderType._(4, 'SNAPCHAT');
  static const SocialNetworkProviderType CUSTOM_SOCIALNET_WORK_PROVIDER = SocialNetworkProviderType._(5, 'CUSTOM_SOCIALNET_WORK_PROVIDER');

  static const $core.List<SocialNetworkProviderType> values = <SocialNetworkProviderType> [
    INSTAGRAM,
    FACEBOOK,
    TWITTER,
    YOU_TUBE,
    SNAPCHAT,
    CUSTOM_SOCIALNET_WORK_PROVIDER,
  ];

  static final $core.Map<$core.int, SocialNetworkProviderType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SocialNetworkProviderType valueOf($core.int value) => _byValue[value];

  const SocialNetworkProviderType._($core.int v, $core.String n) : super(v, n);
}

