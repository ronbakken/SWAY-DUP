import 'dart:typed_data';

import 'package:inf_api_client/inf_api_client.dart';

class SocialNetworkProvider {
  SocialNetworkProvider(this.dto)
      : _logoColoredData = Uint8List.fromList(dto.logoColoredData),
        _logoMonochromeData = Uint8List.fromList(dto.logoMonochromeData),
        _logoBackgroundData = Uint8List.fromList(dto.logoBackgroundData);

  final SocialNetworkProviderDto dto;
  final Uint8List _logoColoredData;
  final Uint8List _logoMonochromeData;
  final Uint8List _logoBackgroundData;

  String get id => dto.id;

  SocialNetworkProviderType get type => dto.type;

  String get name => dto.name;

  Uint8List get logoColoredData => _logoColoredData;
  Uint8List get logoMonochromeData => _logoMonochromeData;
  Uint8List get logoBackgroundData => _logoBackgroundData;
  int get logoBackGroundColor => dto.logoBackGroundColor;

  String get apiKey => dto.apiKey;

  String get apiKeySecret => dto.apiKeySecret;
}
