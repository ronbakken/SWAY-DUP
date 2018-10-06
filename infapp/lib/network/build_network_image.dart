/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';

class BlurredNetworkImage extends StatefulWidget {
  const BlurredNetworkImage({
    this.url,
    this.blurredUrl,
    this.placeholderAsset = 'assets/placeholder_photo_select.png',
    this.fit = BoxFit.cover,
    this.spinner = false,
  });

  final String url;
  final String blurredUrl;
  final String placeholderAsset;
  final BoxFit fit;
  final bool spinner;

  @override
  State<StatefulWidget> createState() {
    return new _BlurredNetworkImageState();
  }
}

class _BlurredNetworkImageState extends State<BlurredNetworkImage> {
  bool _blurredUrlLoaded = false;

  @override
  Widget build(BuildContext context) {
    Widget placeholderWidget = new Image(
        image: new AssetImage(widget.placeholderAsset), fit: widget.fit);
    if (widget.blurredUrl == null || widget.blurredUrl.toString().isEmpty) {
      if (widget.url == null || widget.url.toString().isEmpty) {
        return placeholderWidget;
      }
      return new TransitionToImage(
        new AdvancedNetworkImage(widget.url.toString()),
        placeholder: placeholderWidget,
        loadingWidget: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            placeholderWidget,
          ],
        ),
        fit: widget.fit,
      );
    }
    AdvancedNetworkImage blurredImage = new AdvancedNetworkImage(
      widget.blurredUrl.toString(),
      useDiskCache: true,
      loadedCallback: _blurredUrlLoaded
          ? null
          : () {
              if (mounted) {
                print("[INF] Blurred -> Clear");
                setState(() {
                  _blurredUrlLoaded = true;
                });
              }
            },
    );
    Widget base = new TransitionToImage(
      blurredImage,
      duration: new Duration(),
      placeholder: placeholderWidget,
      loadingWidget: widget.spinner
          ? const CircularProgressIndicator()
          : new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                placeholderWidget,
              ],
            ),
      fit: widget.fit,
    );
    if (!_blurredUrlLoaded) {
      blurredImage.load(blurredImage);
      return base;
    }
    return new TransitionToImage(
      new AdvancedNetworkImage(widget.url.toString(), useDiskCache: true),
      placeholder: base,
      loadingWidget: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          base,
        ],
      ),
      fit: widget.fit,
    );
  }
}

Widget buildNetworkImage({
  String url,
  String blurredUrl,
  String placeholderAsset = 'assets/placeholder_photo_select.png',
  BoxFit fit = BoxFit.cover,
  bool spinner = false,
}) {
  return new BlurredNetworkImage(
    url: url,
    blurredUrl: blurredUrl,
    placeholderAsset: placeholderAsset,
    fit: fit,
    spinner: spinner,
  );
}

/* end of file */
