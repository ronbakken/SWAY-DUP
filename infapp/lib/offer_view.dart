
import 'package:flutter/material.dart';

import 'network/inf.pb.dart';
import 'widgets/carousel_app_bar.dart';
import 'widgets/dark_container.dart';

class OfferView extends StatelessWidget {
  const OfferView({
    Key key,
    @required this.businessOffer,
    @required this.businessAccount,
    @required this.account,
  }) : super(key: key);

  final DataBusinessOffer businessOffer;
  final DataAccount businessAccount;
  final DataAccount account;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new CarouselAppBar(
            context: context,
            title: new Text(businessOffer.title),
            imageUrls: businessOffer.coverUrls,
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
              new DarkContainer(
                child: new ListTile(
                  //enabled: true,
                  leading: new CircleAvatar(
                    backgroundImage: businessAccount.summary.avatarUrl.length > 0
                      ? new NetworkImage(businessAccount.summary.avatarUrl) : null
                  ),
                  title: new Text(businessAccount.summary.name),
                  subtitle: new Text(businessAccount.summary.description.length > 0
                    ? businessAccount.summary.description : businessAccount.summary.location),
                ),
              ),
              new ListTile(
                title: new Text(businessOffer.description, style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.work),
                title: new Text(businessOffer.deliverables, style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text(businessOffer.reward, style: Theme.of(context).textTheme.body1 ),
              ),
              new ListTile(
                leading: new Icon(Icons.pin_drop),
                title: new Text(businessOffer.location, style: Theme.of(context).textTheme.body1 ),
              ),
              /*new Divider(),
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
              ),*/
            ]),
          ),
        ],
      ),
    );
  }
}

