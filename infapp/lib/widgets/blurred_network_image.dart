/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlurredNetworkImage extends StatefulWidget {
  const BlurredNetworkImage({
    this.url,
    this.blurredUrl,
    this.blurredData,
    this.placeholderAsset = 'assets/placeholder_photo_select.png',
    this.fit = BoxFit.cover,
    // this.spinner = false,
    this.fadeInDuration = const Duration(milliseconds: 700),
    this.fadeInCurve = Curves.easeIn,
  });

  final String url;
  final String blurredUrl;
  final Uint8List blurredData;
  final String placeholderAsset;
  final BoxFit fit;
  // final bool spinner;

  /// The duration of the fade-in animation for the [image].
  final Duration fadeInDuration;

  /// The curve of the fade-in animation for the [image].
  final Curve fadeInCurve;

  @override
  State<StatefulWidget> createState() {
    return new _BlurredNetworkImageState();
  }
}

typedef void _ImageProviderResolverListener();

/// From fade_in_image.dart
class _ImageProviderResolver {
  _ImageProviderResolver({
    @required this.state,
    @required this.listener,
  });

  final _BlurredNetworkImageState state;
  final _ImageProviderResolverListener listener;

  ImageStream _imageStream;
  ImageInfo _imageInfo;

  void resolve(ImageProvider provider) {
    final ImageStream oldImageStream = _imageStream;
    _imageStream = provider.resolve(createLocalImageConfiguration(
      state.context,
    ));
    assert(_imageStream != null);

    if (_imageStream.key != oldImageStream?.key) {
      oldImageStream?.removeListener(_handleImageChanged);
      _imageStream.addListener(_handleImageChanged);
    }
  }

  void _handleImageChanged(ImageInfo imageInfo, bool synchronousCall) {
    _imageInfo = imageInfo;
    listener();
  }

  void stopListening() {
    _imageStream?.removeListener(_handleImageChanged);
  }
}

enum _BlurredNetworkImagePhase {
  /// Widget just created, or waiting for blurred image
  start,

  /// Waiting for the blurred image
  placeholder,

  /// Blurred image is available
  // blurred,

  /// Waiting for the final image
  waiting,

  /// Fading into the final image
  fading,

  /// Fade complete
  completed,
}

class _BlurredNetworkImageState extends State<BlurredNetworkImage>
    with TickerProviderStateMixin {
  // bool _blurredUrlLoaded = false;

  ImageProvider<dynamic> _placeholderImageProvider;
  ImageProvider<dynamic> _blurredImageProvider;
  ImageProvider<dynamic> _imageProvider;

  _ImageProviderResolver _blurredImageResolver;
  _ImageProviderResolver _imageResolver;

  AnimationController _controller;
  Animation<double> _animation;

  // bool _loadingBlurred = false;
  // bool _loadingFinal = false;
  // bool _finalImage = false;

  _BlurredNetworkImagePhase _phase = _BlurredNetworkImagePhase.start;

  @override
  void initState() {
    super.initState();
    _blurredImageResolver = new _ImageProviderResolver(
        state: this, listener: _blurredImageResolved);
    _imageResolver =
        new _ImageProviderResolver(state: this, listener: _imageResolved);
    _controller = new AnimationController(
      value: 1.0,
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {
        // Trigger rebuild to update opacity value.
      });
    });
    _controller.addStatusListener((AnimationStatus status) {
      _updatePhase();
    });
  }

  @override
  void didChangeDependencies() {
    if (_phase == _BlurredNetworkImagePhase.start) {
      if (widget.placeholderAsset != null) {
        _placeholderImageProvider = new AssetImage(widget.placeholderAsset);
      }
      if (widget.blurredData != null) {
        _blurredImageProvider = new MemoryImage(widget.blurredData);
      } else if (widget.blurredUrl != null) {
        _blurredImageProvider = new CachedNetworkImageProvider(widget.blurredUrl);
      }
      if (_blurredImageProvider == null) {
        _blurredImageProvider = _placeholderImageProvider;
      }
      if (widget.url != null) {
        _imageProvider = new CachedNetworkImageProvider(widget.url);
      }
      _resolveImage();
    }
  }

  @override
  void didUpdateWidget(BlurredNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_phase != _BlurredNetworkImagePhase.completed) {
      if (widget.placeholderAsset != oldWidget.placeholderAsset) {
        if (widget.placeholderAsset != null) {
          _placeholderImageProvider = new AssetImage(widget.placeholderAsset);
        } else {
          _placeholderImageProvider = null;
        }
        if (_phase != _BlurredNetworkImagePhase.completed) {
          _phase = _BlurredNetworkImagePhase.start;
        }
      }
      if (widget.blurredUrl != oldWidget.blurredUrl ||
          !const ListEquality()
              .equals(widget.blurredData, oldWidget.blurredData)) {
        if (widget.blurredData != null) {
          _blurredImageProvider = new MemoryImage(widget.blurredData);
        } else if (widget.blurredUrl != null) {
          _blurredImageProvider =
              new CachedNetworkImageProvider(widget.blurredUrl);
        } else {
          _blurredImageProvider = null;
        }
        if (_phase != _BlurredNetworkImagePhase.completed) {
          _phase = _BlurredNetworkImagePhase.start;
        }
      }
      if (_blurredImageProvider == null) {
        _blurredImageProvider = _placeholderImageProvider;
      }
    }
    if (widget.url != oldWidget.url) {
      if (widget.url != null) {
        if (_phase == _BlurredNetworkImagePhase.completed) {
          _blurredImageProvider = _imageProvider;
        }
        _imageProvider = new CachedNetworkImageProvider(widget.url);
      } else {
        _imageProvider = null;
      }
      _phase = _BlurredNetworkImagePhase.start;
    }
    _resolveImage();
  }

  @override
  void reassemble() {
    _resolveImage(); // in case the image cache was flushed
    super.reassemble();
  }

  void _resolveImage() {
    if (_phase != _BlurredNetworkImagePhase.completed) {
      _blurredImageResolver.resolve(_blurredImageProvider);
    }
    _resolveFinalImage();
  }

  void _resolveFinalImage() {
    if (_blurredImageResolver._imageInfo != null ||
        _phase == _BlurredNetworkImagePhase.completed) {
      _imageResolver.resolve(_imageProvider);
    }
    if (_phase == _BlurredNetworkImagePhase.start ||
        _phase == _BlurredNetworkImagePhase.placeholder) {
      _updatePhase();
    }
  }

  void _blurredImageResolved() {
    _resolveFinalImage();
  }

  void _imageResolved() {
    _updatePhase();
  }

  void _updatePhase() {
    setState(() {
      switch (_phase) {
        case _BlurredNetworkImagePhase.start:
          if (_imageResolver._imageInfo != null)
            _phase = _BlurredNetworkImagePhase.completed;
          else if (_blurredImageResolver._imageInfo != null ||
              _blurredImageProvider == null)
            _phase = _BlurredNetworkImagePhase.waiting;
          else
            _phase = _BlurredNetworkImagePhase.placeholder;
          break;
        case _BlurredNetworkImagePhase.placeholder:
          if (_imageResolver._imageInfo != null)
            _phase = _BlurredNetworkImagePhase.completed;
          else if (_blurredImageResolver._imageInfo != null ||
              _blurredImageProvider == null)
            _phase = _BlurredNetworkImagePhase.waiting;
          break;
        case _BlurredNetworkImagePhase.waiting:
          if (_imageResolver._imageInfo != null) {
            // Received image data. Begin placeholder fade-out.
            _controller.duration = widget.fadeInDuration;
            _animation = new CurvedAnimation(
              parent: _controller,
              curve: widget.fadeInCurve,
            );
            _phase = _BlurredNetworkImagePhase.fading;
            _controller.forward(from: 0.0);
          }
          break;
        case _BlurredNetworkImagePhase.fading:
          if (_controller.status == AnimationStatus.completed) {
            // Done finding in new image.
            _phase = _BlurredNetworkImagePhase.completed;
          }
          break;
        case _BlurredNetworkImagePhase.completed:
          // Nothing to do.
          break;
      }
    });
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (_placeholderImageProvider != null) {
      return new Image(image: _placeholderImageProvider, fit: widget.fit);
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  Widget _buildBlurred(BuildContext context) {
    if (_blurredImageProvider != null) {
      return new Image(image: _blurredImageProvider, fit: widget.fit);
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  Widget _buildFadingImage(BuildContext context) {
    return new RawImage(
      image: _imageResolver._imageInfo.image,
      scale: _imageResolver._imageInfo.scale,
      color: new Color.fromRGBO(255, 255, 255, _animation?.value ?? 1.0),
      colorBlendMode: BlendMode.modulate,
      fit: widget.fit,
      /*alignment: widget.alignment,
      repeat: widget.repeat,
      matchTextDirection: widget.matchTextDirection,*/
    );
  }

  Widget _buildImage(BuildContext context) {
    return new RawImage(
      image: _imageResolver._imageInfo.image,
      scale: _imageResolver._imageInfo.scale,
      fit: widget.fit,
      /*alignment: widget.alignment,
      repeat: widget.repeat,
      matchTextDirection: widget.matchTextDirection,*/
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _BlurredNetworkImagePhase.start:
        return new ErrorWidget(
            new Exception("case _BlurredNetworkImagePhase.start"));
      case _BlurredNetworkImagePhase.placeholder:
        return _buildPlaceholder(context);
      case _BlurredNetworkImagePhase.waiting:
        return _buildBlurred(context);
      case _BlurredNetworkImagePhase.fading:
        return new Stack(fit: StackFit.expand, children: <Widget>[
          _buildBlurred(context),
          _buildFadingImage(context),
        ]);
      case _BlurredNetworkImagePhase.completed:
        return _buildImage(context);
    }
    return new ErrorWidget(new Exception("switch (_phase)"));
  }
}

/* end of file */
