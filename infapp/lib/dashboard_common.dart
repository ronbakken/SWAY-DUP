// import 'dart:async';
// import 'dart:io';

// import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'network/inf.pb.dart';

// TODO: Animate transitions between the three windows
//       AppBar should slide in appropriately, but sliding of app bar should not impact the underlying widgets layout

class DashboardCommon extends StatefulWidget {
  const DashboardCommon({
    Key key,
    @required this.account,
    @required this.onNavigateProfile,
    @required this.onNavigateDebugAccount,
    this.onMakeAnOffer,
    this.map,
    this.offersCurrent,
    this.offersHistory,
    this.applicantsApplying,
    this.applicantsAccepted,
    this.applicantsHistory,
    this.mapTab,
    this.offersTab,
    this.applicantsTab,
  }) : super(key: key);

  final mapTab;
  final offersTab;
  final applicantsTab;

  final DataAccount account;
  final Function() onNavigateProfile;
  final Function() onNavigateDebugAccount;
  final Function() onMakeAnOffer;

  final Widget map;
  final Widget offersCurrent;
  final Widget offersHistory;
  final Widget applicantsApplying;
  final Widget applicantsAccepted;
  final Widget applicantsHistory;

  @override
  _DashboardCommonState createState() => new _DashboardCommonState();
}

class _DashboardCommonState extends State<DashboardCommon>
    with TickerProviderStateMixin {
  int _currentTab;
  int _tabCount;
  TabController _tabControllerOffers;
  TabController _tabControllerApplicants;
  TabController _tabControllerTabs;

  @override
  void initState() {
    super.initState();
    _tabCount = 0;
    if (widget.mapTab != null && widget.mapTab >= _tabCount)
      _tabCount = widget.mapTab + 1;
    if (widget.offersTab != null && widget.offersTab >= _tabCount)
      _tabCount = widget.offersTab + 1;
    if (widget.applicantsTab != null && widget.applicantsTab >= _tabCount)
      _tabCount = widget.applicantsTab + 1;
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
      length: _tabCount,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> tabBarItems =
        new List<BottomNavigationBarItem>(_tabCount);
    if (widget.mapTab != null) {
      tabBarItems[widget.mapTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.map),
        title: new Text("Map"),
      );
    }
    if (widget.offersTab != null) {
      tabBarItems[widget.offersTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.list),
        title: new Text("Offers"),
      );
    }
    if (widget.applicantsTab != null) {
      tabBarItems[widget.applicantsTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.inbox),
        title: new Text(
            widget.account.state.accountType == AccountType.AT_INFLUENCER
                ? "Applied"
                : "Applicants"),
      );
    }
    return new Scaffold(
      body: _currentTab == widget.offersTab
          ? new TabBarView(
              key: new Key('TabViewOffers'),
              controller: _tabControllerOffers,
              children: [widget.offersCurrent, widget.offersHistory],
            )
          : (_currentTab == widget.applicantsTab
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
      floatingActionButton:
          (widget.onMakeAnOffer == null || _currentTab == widget.applicantsTab)
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
        child: new Column(
            children: [
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
            //padding: new EdgeInsets.all(
            //    0.0), // ew EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
          (widget.account.state.globalAccountState.value >=
                  GlobalAccountState.GAS_DEBUG.value)
              ? new FlatButton(
                  //padding: new EdgeInsets.all(
                  //    0.0), // ew EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: new Row(children: [
                    new Container(
                      margin: new EdgeInsets.all(16.0),
                      child: new Icon(Icons.account_box),
                    ),
                    new Text('Debug Account')
                  ]),
                  onPressed: (widget.onNavigateDebugAccount != null)
                      ? () {
                          Navigator.pop(context);
                          widget.onNavigateDebugAccount();
                        }
                      : null,
                )
              : null,
        ].where((w) => w != null).toList()),
      ),
      appBar: _currentTab != widget.mapTab
          ? new AppBar(
              title: new Text(
                  _currentTab == widget.offersTab ? "Offers" : "Applicants"),
              bottom: _currentTab == widget.offersTab
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
              if (index == widget.offersTab) {
                _tabControllerOffers.animateTo(0);
              } else if (index == widget.applicantsTab) {
                _tabControllerApplicants.animateTo(0);
              }
            } else {
              setState(() {
                _currentTab = index;
              });
              _tabControllerTabs.animateTo(index);
              _tabControllerOffers.offset = 0.0;
              // _tabControllerOffers.index = 0;
              _tabControllerApplicants.offset = 0.0;
              // _tabControllerApplicants.index = 0;
            }
          },
          items: tabBarItems),
    );
  }
}

/* end of file */
