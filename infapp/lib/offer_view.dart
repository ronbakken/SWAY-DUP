
import 'package:flutter/material.dart';

import 'caroussel_app_bar.dart';

class OfferView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new CarouselAppBar(
            context: context,
            title: new Text("Fishing Season"),
            imageUrls: [
              'https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg',
              'https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg',
            ]
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
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
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner", style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner", style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner", style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner", style: Theme.of(context).textTheme.body1 ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

