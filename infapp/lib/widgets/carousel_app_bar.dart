import 'package:flutter/material.dart';
import 'package:circle_indicator/circle_indicator.dart';

class CarouselAppBar extends SliverAppBar {
  CarouselAppBar({ 
    Key key, 
    BuildContext context, 
    Widget title, 
    List<Widget> actions,
    List<String> imageUrls }) : 
  super(
    key: key,
    pinned: true,
    title: title,
    expandedHeight: (MediaQuery.of(context).size.width * 9.0 / 16.0) ~/ 4 * 4.0,
    flexibleSpace: new FlexibleSpaceBar(
      background: _buildBackground(new PageController(), context, imageUrls),
    ),
    actions: actions,
  );

  static Widget _buildBackground(controller, BuildContext context, List<String> imageUrls) {
    List<Widget> images = new List<Widget>();
    for (String imageUrl in imageUrls) {
      images.add(new FadeInImage.assetNetwork(
          placeholder: 'assets/placeholder_photo.png',
          image: imageUrl,
          fit: BoxFit.cover
      ));
    }
    return new Container(
      // color: Theme.of(context).primaryColor,
      child: new Stack(
        children: [
          new Positioned.fill(
            child: images.length == 1 ? images[0] : new Stack(
              alignment: FractionalOffset.bottomCenter,
              children: [
                new PageView.builder(
                  controller: controller,
                  itemCount: images.length,
                  itemBuilder: (_, int i) => images[i],
                ),
                new Container(
                  margin: new EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0,
                  ),
                  child: new CircleIndicator(
                    controller, images.length, 
                    3.0, Colors.white70, Colors.white
                  ),
                ),
              ],
            ),
          ),
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
        ]
      ),
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
