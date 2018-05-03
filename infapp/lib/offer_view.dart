
import 'package:flutter/material.dart';

import 'caroussel_app_bar.dart';

class OfferView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: [
        new CarouselAppBar(
          title: new Text("Fishing Season"),
          imageUrls: [
            'https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg',
            'https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg',
          ]
        ),
        /*new AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: new Stack(children: <Widget>[
            new AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: new FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder_photo.png',
                image: 'https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg',
                fit: BoxFit.cover
              ),
            ),
            new Column(
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
                          colors: <Color>[Colors.black87, Colors.transparent]
                        ),
                      ),
                    ),
                  ),
                ),
              ],  
            ),
            new AppBar(
              title: new Text("Fishing Season"),
              backgroundColor: new Color.fromARGB(0, 0, 0, 0),
              elevation: 0.0,
            ),
          ]),
        ),*/
        new ListTile(
          leading: new CircleAvatar(
            backgroundImage: new NetworkImage('https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg')
          ),
          title: new Text("Fried Willy"),
          subtitle: new Text("1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024"),
        ),
        new Divider(),
        new ListTile(
          title: new Text("Looking to catch more customers during the fishing season.", style: Theme.of(context).textTheme.body1 ),
        ),
        new ListTile(
          leading: new Icon(Icons.work),
          title: new Text("Posts with photography across social media.", style: Theme.of(context).textTheme.body1 ),
        ),
        new ListTile(
          leading: new Icon(Icons.redeem),
          title: new Text("Free dinner", style: Theme.of(context).textTheme.body1 ),
        ),
        new Divider(),
      ]
    );
  }
}

