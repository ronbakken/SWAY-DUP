///
//  Generated code. Do not modify.
//  source: social_network_provider.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class SocialNetworkProviderType extends $pb.ProtobufEnum {
  static const SocialNetworkProviderType instagram = const SocialNetworkProviderType._(0, 'instagram');
  static const SocialNetworkProviderType facebook = const SocialNetworkProviderType._(1, 'facebook');
  static const SocialNetworkProviderType twitter = const SocialNetworkProviderType._(2, 'twitter');
  static const SocialNetworkProviderType youtube = const SocialNetworkProviderType._(3, 'youtube');
  static const SocialNetworkProviderType snapchat = const SocialNetworkProviderType._(4, 'snapchat');
  static const SocialNetworkProviderType customSocialNetworkProvider = const SocialNetworkProviderType._(5, 'customSocialNetworkProvider');

  static const List<SocialNetworkProviderType> values = const <SocialNetworkProviderType> [
    instagram,
    facebook,
    twitter,
    youtube,
    snapchat,
    customSocialNetworkProvider,
  ];

  static final Map<int, SocialNetworkProviderType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SocialNetworkProviderType valueOf(int value) => _byValue[value];
  static void $checkItem(SocialNetworkProviderType v) {
    if (v is! SocialNetworkProviderType) $pb.checkItemFailed(v, 'SocialNetworkProviderType');
  }

  const SocialNetworkProviderType._(int v, String n) : super(v, n);
}

