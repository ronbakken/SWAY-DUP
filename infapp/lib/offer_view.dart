
import 'package:flutter/material.dart';

import 'carousel_app_bar.dart';
import 'dark_container.dart';

class OfferView extends StatelessWidget {
  const OfferView({
    Key key,
    this.offerTitle = "Fishing Season",
    this.offerImageUrls = const [
      'https://inf-dev.nyc3.digitaloceanspaces.com/demo/friedfish.jpg',
      'https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg',
    ],
    this.offerDescription = "Looking to catch more customers during the fishing season.",
    this.offerDeliverables = "Posts with photography across social media.",
    this.offerRewards = "Free dinner",
    this.businessName = "Big Kahuna",
    this.businessAvatarUrl = 'https://inf-dev.nyc3.digitaloceanspaces.com/demo/kahuna.jpg',
    this.businessLocation = "1100 Glendon Avenue, 17th Floor, Los Angeles CA 90024",
  }) : super(key: key);

  final String offerTitle;
  final List<String> offerImageUrls;
  final String offerDescription;
  final String offerDeliverables;
  final String offerRewards;

  final String businessName;
  final String businessAvatarUrl;
  final String businessLocation;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new CarouselAppBar(
            context: context,
            title: new Text(offerTitle),
            imageUrls: offerImageUrls,
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
              new DarkContainer(
                child: new ListTile(
                  //enabled: true,
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage(businessAvatarUrl)
                  ),
                  title: new Text(businessName),
                  subtitle: new Text(businessLocation),
                ),
              ),
              new Divider(),
              new ListTile(
                title: new Text(offerDescription, style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.work),
                title: new Text(offerDeliverables, style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text(offerRewards, style: Theme.of(context).textTheme.body1 ),
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

