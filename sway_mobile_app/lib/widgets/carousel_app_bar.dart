import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:circle_indicator/circle_indicator.dart';
import 'package:sway_mobile_app/widgets/blurred_network_image.dart';

class CarouselAppBar extends SliverAppBar {
  CarouselAppBar({
    Key key,
    BuildContext context,
    Widget title,
    List<Widget> actions,
    List<String> imageUrls,
    List<Uint8List> imagesBlurred,
    Uint8List fallbackBlurred,
  }) : super(
          key: key,
          pinned: true,
          title: title,
          expandedHeight:
              (MediaQuery.of(context).size.width * 9.0 / 16.0) ~/ 4 * 4.0,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildBackground(PageController(), context, imageUrls,
                imagesBlurred, fallbackBlurred),
          ),
          actions: actions,
        );

  static Widget _buildBackground(
    PageController controller,
    BuildContext context,
    List<String> imageUrls,
    List<Uint8List> imagesBlurred,
    Uint8List fallbackBlurred,
  ) {
    final List<Widget> images = <Widget>[];
    if ((imageUrls == null || imageUrls.isEmpty) &&
        fallbackBlurred != null &&
        fallbackBlurred.isNotEmpty) {
      // Fallback to blurred fallback image
      images.add(Image.memory(
        fallbackBlurred,
        fit: BoxFit.cover,
      ));
    } else if (imagesBlurred == null ||
        imagesBlurred.length < imageUrls.length) {
      // Show only images without blur
      for (String imageUrl in imageUrls) {
        images.add(BlurredNetworkImage(
            url: imageUrl, placeholderAsset: 'assets/placeholder_photo.png'));
      }
    } else {
      // Show images with blur fade
      for (int i = 0; i < imageUrls.length; ++i) {
        images.add(BlurredNetworkImage(
          url: imageUrls[i],
          blurredData: imagesBlurred[i].isNotEmpty ? imagesBlurred[i] : null,
          placeholderAsset:
              imagesBlurred[i].isEmpty ? 'assets/placeholder_photo.png' : null,
        ));
      }
    }
    return Container(
      // color: Theme.of(context).primaryColor,
      child: Stack(children: [
        Positioned.fill(
          child: images.length == 1
              ? images[0]
              : Stack(
                  alignment: FractionalOffset.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: controller,
                      itemCount: images.length,
                      itemBuilder: (_, int i) => images[i],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 16.0,
                        bottom: 16.0,
                      ),
                      child: CircleIndicator(controller, images.length, 3.0,
                          Colors.white70, Colors.white),
                    ),
                  ],
                ),
        ),
        AspectRatio(
          aspectRatio: 16.0 / 4.0,
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.black45, Colors.transparent]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/*
class CarouselAppBar extends StatelessWidget {
  const CarouselAppBar({
    Key key,
    this.imageUrls,
    this.title,
  }) : super(key: key);

  final List<String> imageUrls;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    List<Widget> images = new List<Widget>();
    if (imageUrls != null) {
      for (String imageUrl in imageUrls) {
        images.add(new AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: new FadeInImage.assetNetwork(
            placeholder: 'assets/placeholder_photo.png',
            image: imageUrl,
            fit: BoxFit.cover
          ),
        ));
      }
    }
    if (images.length == 0) {
      return new AppBar(
        title: title,
      );
    }
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: new Stack(children: <Widget>[
        / *images.length > 1 ? new TabBarView(
          children: images,
        ) :* / images[0],
        new IgnorePointer(
          child: new Column(
            children: <Widget>[
              new AspectRatio(
                aspectRatio: 16.0 / 4.0,
                child: new ConstrainedBox(
                  constraints: new BoxConstraints.expand(),
                  child: new DecoratedBox(
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.black45, Colors.transparent]
                      ),
                    ),
                  ),
                ),
              ),
            ],  
          ),
        ),
        new Column(
          children: <Widget>[
            new AppBar(
              title: title,
              backgroundColor: new Color.fromARGB(0, 0, 0, 0),
              elevation: 0.0,
            ),
          ],
        )
      ]),
    );
  }
}*/
