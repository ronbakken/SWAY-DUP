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
    @required this.offersCurrent,
    @required this.offersHistory,
    @required this.applicantsApplying,
    @required this.applicantsAccepted,
    @required this.applicantsHistory,
  }) : super(key: key);

  final DataAccount account;
  final VoidCallback onNavigateProfile;
  final VoidCallback onMakeAnOffer;

  final Widget map;
  final Widget offersCurrent;
  final Widget offersHistory;
  final Widget applicantsApplying;
  final Widget applicantsAccepted;
  final Widget applicantsHistory;

  @override
  _DashboardBusinessState createState() => new _DashboardBusinessState();
}

class _DashboardBusinessState extends State<DashboardBusiness>
    with TickerProviderStateMixin {
  int _currentTab;
  TabController _tabControllerOffers;
  TabController _tabControllerApplicants;
  TabController _tabControllerTabs;

  @override
  void initState() {
    super.initState();
    _currentTab = 0;
    _tabControllerOffers = new TabController(
      length: 2,
      vsync: this,
    );
    _tabControllerApplicants = new TabController(
      length: 3,
      vsync: this,
    );
    _tabControllerTabs = new TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _currentTab == 1
          ? new TabBarView(
              key: new Key('TabViewOffers'),
              controller: _tabControllerOffers,
              children: [widget.offersCurrent, widget.offersHistory],
            )
          : (_currentTab == 2
              ? new TabBarView(
                  key: new Key('TabViewApplicants'),
                  controller: _tabControllerApplicants,
                  children: [
                    widget.applicantsApplying,
                    widget.applicantsAccepted,
                    widget.applicantsHistory
                  ],
                )
              : widget.map),
      floatingActionButton: _currentTab == 2
          ? null
          : new FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              tooltip: 'Make an offer',
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Icon(Icons.add),
                  ]),
              onPressed: widget.onMakeAnOffer,
            ),
      drawer: new Drawer(
        child: new Column(children: [
          new AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: new Material(
                  elevation: 4.0, // TODO: Verify this matches AppBar
                  color: Theme.of(context).primaryColor,
                  child: new Stack(children: [
                    new Positioned.fill(
                        child: widget.account.detail.avatarCoverUrl.length > 0
                            ? new FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder_photo.png',
                                image: widget.account.detail.avatarCoverUrl,
                                fit: BoxFit.cover)
                            : new Image(
                                image: new AssetImage(
                                    'assets/placeholder_photo.png'),
                                fit: BoxFit.cover)),
                    new SafeArea(
                        // child: new Text("Hello world"),
                        child: new Align(
                            alignment: Alignment.bottomLeft,
                            child: new Container(
                                margin: new EdgeInsets.fromLTRB(
                                    56.0, 16.0, 16.0, 16.0),
                                child: new Text(
                                  widget.account.summary.name,
                                  style:
                                      Theme.of(context).primaryTextTheme.title,
                                ))))
                  ]))),
          new FlatButton(
            padding: new EdgeInsets.all(
                0.0), // ew EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: new Row(children: [
              new Container(
                margin: new EdgeInsets.all(16.0),
                child: new Icon(Icons.account_circle),
              ),
              new Text('Profile')
            ]),
            onPressed: (widget.onNavigateProfile != null)
                ? () {
                    Navigator.pop(context);
                    widget.onNavigateProfile();
                  }
                : null,
          ),
        ]),
      ),
      appBar: _currentTab != 0
          ? new AppBar(
              title: new Text(_currentTab == 1 ? "Offers" : "Applicants"),
              bottom: _currentTab == 1
                  ? new TabBar(
                      key: new Key('TabBarOffers'),
                      controller: _tabControllerOffers,
                      tabs: [
                          new Tab(text: "Current".toUpperCase()),
                          new Tab(text: "History".toUpperCase())
                        ])
                  : new TabBar(
                      key: new Key('TabBarApplicants'),
                      controller: _tabControllerApplicants,
                      tabs: [
                          new Tab(text: "Applying".toUpperCase()),
                          new Tab(text: "Accepted".toUpperCase()),
                          new Tab(text: "History".toUpperCase())
                        ]),
            )
          : null,
      bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTab,
          onTap: (int index) {
            if (_currentTab == index) {
              if (index == 1) {
                _tabControllerOffers.animateTo(0);
              } else if (index == 2) {
                _tabControllerApplicants.animateTo(0);
              }
            } else {
              setState(() {
                _currentTab = index;
              });
              _tabControllerTabs.index = index;
              _tabControllerOffers.offset = 0.0;
              // _tabControllerOffers.index = 0;
              _tabControllerApplicants.offset = 0.0;
              // _tabControllerApplicants.index = 0;
            }
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
          ]),
    );
  }
}

/* end of file */
