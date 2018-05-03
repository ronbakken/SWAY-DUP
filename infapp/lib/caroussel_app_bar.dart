import 'package:flutter/material.dart';

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
        /*images.length > 1 ? new TabBarView(
          children: images,
        ) :*/ images[0],
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
}
