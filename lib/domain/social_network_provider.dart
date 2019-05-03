import 'dart:typed_data';

import 'package:flutter/material.dart' show Color, Colors, ImageProvider, MemoryImage;
import 'package:inf/app/assets.dart';
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


  String get apiKey => dto.apiKey;

  String get apiKeySecret => dto.apiKeySecret;

  Color get logoBackgroundColor => dto.hasLogoBackGroundColor() ? Color(dto.logoBackGroundColor) : Colors.transparent;

  bool get hasLogoBackgroundImage => dto.hasLogoBackgroundData() && _logoBackgroundData.isNotEmpty;

  ImageProvider get logoBackgroundImage => MemoryImage(_logoBackgroundData);

  AppAsset get logoRawAsset {
    if(dto.hasLogoColoredData() && _logoColoredData.isNotEmpty){
      return AppAsset.raw(_logoColoredData);
    }
    return logoRawAssetMonochrome;
  }

  AppAsset get logoRawAssetMonochrome {
    if(dto.hasLogoMonochromeData() && _logoMonochromeData.isNotEmpty){
      return AppAsset.raw(_logoMonochromeData);
    }
    return null;
  }
}
