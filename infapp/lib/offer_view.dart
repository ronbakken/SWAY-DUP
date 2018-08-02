
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
            actions: [
              new IconButton(
                icon: new Icon(Icons.share),
                onPressed: () { },
              )
            ],
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
              new DarkContainer(
                child: new ListTile(
                  isThreeLine: true, //-------------------
                  //enabled: true,
                  leading: new CircleAvatar(
                    backgroundImage: businessAccount.summary.avatarUrl.length > 0
                      ? new NetworkImage(businessAccount.summary.avatarUrl) : null,
                      backgroundColor: Colors.primaries[businessAccount.summary.name.hashCode % Colors.primaries.length].shade300
                  ),
                  title: new Text(businessAccount.summary.name),
                  subtitle: new Text(businessAccount.summary.description.length > 0
                    ? businessAccount.summary.description : businessAccount.summary.location),
                ),
              ),
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new IconButton(
                      iconSize: 68.0,
                      highlightColor: Colors.transparent,
                      icon: new Column(
                        children: [
                          new Container(
                            padding: new EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                            child: new Icon(Icons.remove_circle, size: 24.0),
                          ),
                          new Text("End".toUpperCase()),
                        ],
                      ),
                      onPressed: () { },
                    ),
                    new IconButton(
                      iconSize: 68.0,
                      highlightColor: Colors.transparent,
                      icon: new Column(
                        children: [
                          new Container(
                            padding: new EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                            child: new Icon(Icons.edit, size: 24.0),
                          ),
                          new Text("Edit".toUpperCase()),
                        ],
                      ),
                      onPressed: () { },
                    ),
                    new IconButton(
                      iconSize: 68.0,
                      highlightColor: Colors.transparent,
                      icon: new Column(
                        children: [
                          new Container(
                            padding: new EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                            child: new Icon(Icons.inbox, size: 24.0),
                          ),
                          new Text("Applic".toUpperCase()),
                        ],
                      ),
                      onPressed: () { },
                    ),
                  ]
                ),
              ),
              new Divider(),
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

