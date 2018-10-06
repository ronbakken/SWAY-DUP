// import 'dart:async';
// import 'dart:io';

// import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'protobuf/inf_protobuf.dart';
import 'widgets/network_status.dart';

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
    this.proposalsReceived,
    this.proposalsApplying,
    this.proposalsRejected,
    this.agreementsActive,
    this.agreementsHistory,
    this.mapTab,
    this.offersTab,
    this.proposalsTab,
    this.agreementsTab,
  }) : super(key: key);

  final int mapTab;
  final int offersTab;
  // final int applicantsTab;
  final int proposalsTab;
  final int agreementsTab;

  final DataAccount account;
  final Function() onNavigateProfile;
  final Function() onNavigateDebugAccount;
  final Function() onMakeAnOffer;

  final Widget map;
  final Widget offersCurrent;
  final Widget offersHistory;
  final Widget proposalsReceived;
  final Widget proposalsApplying;
  final Widget proposalsRejected;
  final Widget agreementsActive;
  final Widget agreementsHistory;

  @override
  _DashboardCommonState createState() => new _DashboardCommonState();
}

class _DashboardCommonState extends State<DashboardCommon>
    with TickerProviderStateMixin {
  int _currentTab;
  int _tabCount;

  TabController _tabControllerOffers;
  TabController _tabControllerProposals;
  TabController _tabControllerAgreements;

  TabController _tabControllerTabs;

  void _initTabController() {
    _tabCount = 0;
    if (widget.mapTab != null && widget.mapTab >= _tabCount)
      _tabCount = widget.mapTab + 1;
    if (widget.offersTab != null && widget.offersTab >= _tabCount)
      _tabCount = widget.offersTab + 1;
    if (widget.proposalsTab != null && widget.proposalsTab >= _tabCount)
      _tabCount = widget.proposalsTab + 1;
    if (widget.agreementsTab != null && widget.agreementsTab >= _tabCount)
      _tabCount = widget.agreementsTab + 1;
    _currentTab = 0;
    _tabControllerTabs = new TabController(
      length: _tabCount,
      vsync: this,
    );
  }

  void _initTabControllers() {
    _tabControllerOffers = new TabController(
      length: 2,
      vsync: this,
    );
    _tabControllerProposals = new TabController(
      length: 3,
      vsync: this,
    );
    _tabControllerAgreements = new TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void initState() {
    super.initState();
    _initTabControllers();
    _initTabController();
  }

  @override
  void reassemble() {
    super.reassemble();
    _initTabControllers();
    _initTabController();
  }

  @override
  Widget build(BuildContext context) {
    String mapLabel =
        widget.account.state.accountType == AccountType.AT_INFLUENCER
            ? "Offers"
            : "Map";
    String offersLabel = "Offers";
    /*
    String applicantsLabel =
        widget.account.state.accountType == AccountType.AT_INFLUENCER
            ? "Applied"
            : "Applicants";
            */
    String proposalsLabel = "Proposals";
    String agreementsLabel = "Agreements"; // or Accepted
    List<BottomNavigationBarItem> tabBarItems =
        new List<BottomNavigationBarItem>(_tabCount);
    if (widget.mapTab != null) {
      tabBarItems[widget.mapTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.map),
        title: new Text(mapLabel),
      );
    }
    if (widget.offersTab != null) {
      tabBarItems[widget.offersTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.list),
        title: new Text(offersLabel),
      );
    }
    if (widget.proposalsTab != null) {
      tabBarItems[widget.proposalsTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.inbox),
        title: new Text(proposalsLabel),
      );
    }
    if (widget.agreementsTab != null) {
      tabBarItems[widget.agreementsTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.event_note),
        title: new Text(agreementsLabel),
      );
    }
    Widget body;
    if (_currentTab == widget.mapTab) {
      body = widget.map;
    } else if (_currentTab == widget.offersTab) {
      body = new TabBarView(
        key: new Key('TabViewOffers'),
        controller: _tabControllerOffers,
        children: [
          widget.offersCurrent == null
              ? new Text("/* Current */")
              : widget.offersCurrent,
          widget.offersHistory == null
              ? new Text("/* History */")
              : widget.offersHistory
        ],
      );
    } else if (_currentTab == widget.proposalsTab) {
      body = new TabBarView(
        key: new Key('TabViewProposals'),
        controller: _tabControllerProposals,
        children: [
          widget.proposalsReceived == null
              ? new Text("/* Received */")
              : widget.proposalsReceived,
          widget.proposalsApplying == null
              ? new Text("/* Applying */")
              : widget.proposalsApplying,
          widget.proposalsRejected == null
              ? new Text("/* Rejected */")
              : widget.proposalsRejected,
        ],
      );
    } else if (_currentTab == widget.agreementsTab) {
      body = new TabBarView(
        key: new Key('TabViewAgreements'),
        controller: _tabControllerAgreements,
        children: [
          widget.agreementsActive == null
              ? new Text("/* Active */")
              : widget.agreementsActive,
          widget.agreementsHistory == null
              ? new Text("/* History */")
              : widget.agreementsHistory,
        ],
      );
    }
    Widget appBar;
    if (_currentTab != widget.mapTab) {
      String title;
      TabBar tabBar;
      if (_currentTab == widget.offersTab) {
        title = offersLabel;
        tabBar = new TabBar(
            key: new Key('TabBarOffers'),
            controller: _tabControllerOffers,
            tabs: [
              new Tab(text: "Current".toUpperCase()),
              new Tab(text: "History".toUpperCase())
            ]);
      } else if (_currentTab == widget.proposalsTab) {
        title = proposalsLabel;
        tabBar = new TabBar(
            key: new Key('TabBarProposals'),
            controller: _tabControllerProposals,
            tabs: [
              new Tab(text: "Received".toUpperCase()),
              new Tab(text: "Applying".toUpperCase()),
              new Tab(text: "Rejected".toUpperCase())
            ]);
      } else if (_currentTab == widget.agreementsTab) {
        title = agreementsLabel;
        tabBar = new TabBar(
            key: new Key('TabBarAgreements'),
            controller: _tabControllerAgreements,
            tabs: [
              new Tab(text: "Active".toUpperCase()),
              new Tab(text: "History".toUpperCase())
            ]);
      }
      appBar = new AppBar(
        title: new Text(title),
        bottom: tabBar,
      );
    }
    return new Scaffold(
      body: body,
      floatingActionButton: (widget.onMakeAnOffer != null &&
              (_currentTab == widget.mapTab || _currentTab == widget.offersTab))
          ? new FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              tooltip: 'Make an offer',
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Icon(Icons.add),
                  ]),
              onPressed: widget.onMakeAnOffer,
            )
          : null,
      drawer: new Drawer(
        child: new Column(
            children: [
          new AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: new Material(
                  elevation: 4.0, // Match AppBar
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
      appBar: appBar,
      bottomSheet: NetworkStatus.buildOptional(context),
      bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTab,
          onTap: (int index) {
            if (_currentTab == index) {
              if (index == widget.offersTab) {
                _tabControllerOffers.animateTo(0);
              } else if (index == widget.proposalsTab) {
                _tabControllerProposals.animateTo(0);
              } else if (index == widget.agreementsTab) {
                _tabControllerAgreements.animateTo(0);
              }
            } else {
              setState(() {
                _currentTab = index;
              });
              _tabControllerTabs.animateTo(index);
              _tabControllerOffers.offset = 0.0;
              _tabControllerProposals.offset = 0.0;
              _tabControllerAgreements.offset = 0.0;
            }
          },
          items: tabBarItems),
    );
  }
}

/* end of file */
