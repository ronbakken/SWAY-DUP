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
    this.onSharePressed,
    this.onEndPressed,
    this.onEditPressed,
    this.onApplicantsPressed,
  }) : super(key: key);

  final DataBusinessOffer businessOffer;
  final DataAccount businessAccount;
  final DataAccount account;

  final VoidCallback onSharePressed;

  final VoidCallback onEndPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onApplicantsPressed;

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
              onSharePressed == null
                  ? null
                  : new IconButton(
                      icon: new Icon(Icons.share),
                      onPressed: () {},
                    )
            ]..removeWhere((Widget w) => w == null),
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
              new DarkContainer(
                child: new ListTile(
                  //isThreeLine: true, //-------------------
                  //enabled: true,
                  leading: new CircleAvatar(
                      backgroundImage:
                          businessAccount.summary.avatarThumbnailUrl.isNotEmpty
                              ? new NetworkImage(
                                  businessAccount.summary.avatarThumbnailUrl)
                              : null,
                      backgroundColor: Colors
                          .primaries[businessAccount.summary.name.hashCode %
                              Colors.primaries.length]
                          .shade300),
                  title: new Text(
                      businessOffer.locationName.isNotEmpty
                          ? businessOffer.locationName
                          : businessAccount.summary.name,
                      maxLines: 1,
                      overflow: TextOverflow.fade),
                  subtitle: new Text(
                      businessAccount.summary.description.isNotEmpty
                          ? businessAccount.summary.description
                          : businessAccount.summary.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              onEndPressed == null &&
                      onEditPressed == null &&
                      onApplicantsPressed == null
                  ? null
                  : new Container(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            onEndPressed == null
                                ? null
                                : new IconButton(
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: new Column(
                                      children: [
                                        new Container(
                                          padding: new EdgeInsets.all(8.0),
                                          child: new Icon(Icons.remove_circle,
                                              size: 24.0),
                                        ),
                                        new Text("End".toUpperCase(),
                                            maxLines: 1),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return new AlertDialog(
                                            title: new Text('End Your Offer'),
                                            content: new SingleChildScrollView(
                                              child: new ListBody(
                                                children: [
                                                  new Text(
                                                      "Are you sure you would like to end this offer?\n\n"
                                                      "This will remove the offer from influencer search results."
                                                      "The offer will remain standing for current applicants."),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              new FlatButton(
                                                child: new Text("End This Offer"
                                                    .toUpperCase()),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  onEndPressed();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                            onEditPressed == null
                                ? null
                                : new IconButton(
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: new Column(
                                      children: [
                                        new Container(
                                          padding: new EdgeInsets.all(8.0),
                                          child:
                                              new Icon(Icons.edit, size: 24.0),
                                        ),
                                        new Text("Edit".toUpperCase(),
                                            maxLines: 1),
                                      ],
                                    ),
                                    onPressed: onEditPressed,
                                  ),
                            onApplicantsPressed == null
                                ? null
                                : new IconButton(
                                    // TODO: Refactor to not use IconButton
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: new Column(
                                      children: [
                                        new Container(
                                          padding: new EdgeInsets.all(8.0),
                                          child:
                                              new Icon(Icons.inbox, size: 24.0),
                                        ),
                                        new Text("Applicants".toUpperCase(),
                                            maxLines: 1,
                                            overflow: TextOverflow
                                                .ellipsis), // FIXME: IconButton width is insufficient
                                      ],
                                    ),
                                    onPressed: onApplicantsPressed,
                                  ),
                          ]..removeWhere((Widget w) => w == null)),
                    ),
              onEndPressed == null &&
                      onEditPressed == null &&
                      onApplicantsPressed == null
                  ? null
                  : new Divider(),
              new ListTile(
                title: new Text(businessOffer.description,
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.work),
                title: new Text(businessOffer.deliverables,
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text(businessOffer.reward,
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.pin_drop),
                title: new Text(businessOffer.location,
                    style: Theme.of(context).textTheme.body1),
              ),
              new Divider(),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text("Free dinner",
                    style: Theme.of(context).textTheme.body1),
              ),
            ]..removeWhere((Widget w) => w == null)),
          ),
        ],
      ),
    );
  }
}
