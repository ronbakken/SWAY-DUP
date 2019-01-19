import 'dart:typed_data';

import 'package:inf_api_client/inf_api_client.dart';
import 'package:meta/meta.dart';

class SocialNetworkProvider {
  final SocialNetworkProviderDto dto;

  int get id => dto.id;
  SocialNetworkProviderType get type => dto.type;
  String get name => dto.name;
  Uint8List get logoColoredData => _logoColoredData;
  Uint8List get logoMonochromeData => _logoMonochromeData;
  int get logoBackGroundColor => dto.logoBackGroundColor;
  Uint8List get logoBackgroundData => _logoBackgroundData;
  String get apiKey => dto.apiKey;
  String get apiKeySecret => dto.apiKeySecret;

  Uint8List _logoColoredData;
  Uint8List _logoMonochromeData;
  Uint8List _logoBackgroundData;

  SocialNetworkProvider(this.dto) {
    _logoColoredData = Uint8List.fromList(dto.logoColoredData);
    _logoMonochromeData = Uint8List.fromList(dto.logoMonochromeData);
    _logoBackgroundData = Uint8List.fromList(dto.logoBackgroundData);
  }
}
