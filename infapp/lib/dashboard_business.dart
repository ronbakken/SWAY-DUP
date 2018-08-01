// import 'dart:async';
// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/cupertino.dart'; 

import 'network/inf.pb.dart';

// import 'network/inf.pb.dart';

// pk.eyJ1IjoibmJzcG91IiwiYSI6ImNqaDBidjJkNjNsZmMyd21sbXlqN3k4ejQifQ.N0z3Tq8fg6LPPxOGVWI8VA

// TODO: Animate transitions between the three windows
//       AppBar should slide in appropriately, but sliding of app bar should not impact the underlying widgets layout

class DashboardBusiness extends StatefulWidget {
  const DashboardBusiness({
    Key key,
    @required this.account,
    @required this.onNavigateProfile,
    @required this.onMakeAnOffer,
    @required this.map,
    @required this.offers,
    @required this.applicants,
  }) : super(key: key);

  final DataAccount account;
  final VoidCallback onNavigateProfile;
  final VoidCallback onMakeAnOffer;

  final Widget map;
  final Widget offers;
  final Widget applicants;

  @override
  _DashboardBusinessState createState() => new _DashboardBusinessState();
}

class _DashboardBusinessState extends State<DashboardBusiness> {
  int _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _currentTab == 1 ? widget.offers : (_currentTab == 2 ? widget.applicants : widget.map),
      floatingActionButton: _currentTab == 2 ? null : new FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Make an offer',
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Icon(Icons.add),
          ]
        ),
        onPressed: widget.onMakeAnOffer,
      ),
      drawer: new Drawer(
        child: new Column(
          children: [
            new Material(
              elevation: 4.0, // TODO: Verify this matches AppBar
              color: Theme.of(context).primaryColor,
              child: new AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: new Stack(
                  children: [
                    widget.account.detail.coverUrls.length > 0 ? new FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder_photo.png',
                      image: widget.account.detail.coverUrls[0],
                      fit: BoxFit.cover
                    ) : new Image(image: new AssetImage('assets/placeholder_photo.png')),
                    new SafeArea(
                      // child: new Text("Hello world"),
                      child: new Align(
                        alignment: Alignment.bottomLeft,
                        child: new Container(
                          margin: new EdgeInsets.fromLTRB(56.0, 16.0, 16.0, 16.0),
                          child: new Text(
                            widget.account.summary.name,
                            style: Theme.of(context).primaryTextTheme.title,
                          )
                        )
                      )
                    )
                  ]
                )
              )
            ),
            new FlatButton(
              padding: new EdgeInsets.all(0.0), // ew EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: new Row(children: [ 
                new Container(
                  margin: new EdgeInsets.all(16.0),
                  child: new Icon(Icons.account_circle), 
                ),
                new Text('Profile')
              ]),
              onPressed: widget.onNavigateProfile
            )
          ]
        ),
      ),
      appBar: _currentTab != 0 ? new AppBar(
        title: new Text(_currentTab == 1 ? "Offers" : "Applicants"),
      ) : null,
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text("Map"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text("Offers"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.inbox),
            title: new Text("Applicants"),
          ),
          /*new BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: new Text("Profile"),
          ),*/
        ]
      ),
    );
  }
}

/* end of file */
