/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

// import 'dart:async';
// import 'dart:io';

// import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:inf/widgets/blurred_network_image.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf/widgets/network_status.dart';

// TODO: Animate transitions between the three windows
//       AppBar should slide in appropriately, but sliding of app bar should not impact the underlying widgets layout

class DashboardCommon extends StatefulWidget {
  const DashboardCommon({
    Key key,
    @required this.account,
    @required this.onNavigateProfile,
    @required this.onNavigateSwitchAccount,
    @required this.onNavigateDebugAccount,
    this.onMakeAnOffer,
    this.map,
    this.offersCurrent,
    this.offersHistory,
    this.proposalsSent,
    this.proposalsReceived,
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
  // final int proposalsTab;
  final int proposalsTab;
  final int agreementsTab;

  final DataAccount account;
  final Function() onNavigateProfile;
  final Function() onNavigateSwitchAccount;
  final Function() onNavigateDebugAccount;
  final Function() onMakeAnOffer;

  final Widget map;
  final Widget offersCurrent;
  final Widget offersHistory;
  final Widget proposalsSent;
  final Widget proposalsReceived;
  final Widget proposalsRejected;
  final Widget agreementsActive;
  final Widget agreementsHistory;

  @override
  _DashboardCommonState createState() => _DashboardCommonState();
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
    if (_currentTab == null || _currentTab >= _tabCount) {
      _currentTab = 0;
    }
    if (_tabControllerTabs?.length != _tabCount) {
      _tabControllerTabs = TabController(
        length: _tabCount,
        vsync: this,
      );
    }
  }

  void _initTabControllers() {
    _tabControllerOffers = TabController(
      length: 2,
      vsync: this,
    );
    _tabControllerProposals = TabController(
      length: 3,
      vsync: this,
    );
    _tabControllerAgreements = TabController(
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
    _initTabController();
  }

  @override
  Widget build(BuildContext context) {
    String mapLabel =
        widget.account.accountType == AccountType.influencer ? "Offers" : "Map";
    String offersLabel = "Offers";
    /*
    String proposalsLabel =
        widget.account.accountType == AccountType.influencer
            ? "Applied"
            : "Proposals";
            */
    String proposalsLabel = "Haggle";
    String agreementsLabel = "Deals"; // or Accepted
    List<BottomNavigationBarItem> tabBarItems =
        List<BottomNavigationBarItem>(_tabCount);
    if (widget.mapTab != null) {
      tabBarItems[widget.mapTab] = BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text(mapLabel),
      );
    }
    if (widget.offersTab != null) {
      tabBarItems[widget.offersTab] = BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text(offersLabel),
      );
    }
    if (widget.proposalsTab != null) {
      tabBarItems[widget.proposalsTab] = BottomNavigationBarItem(
        icon: Icon(Icons.inbox),
        title: Text(proposalsLabel),
      );
    }
    if (widget.agreementsTab != null) {
      tabBarItems[widget.agreementsTab] = BottomNavigationBarItem(
        icon: Icon(Icons.event_note),
        title: Text(agreementsLabel),
      );
    }
    Widget body;
    if (_currentTab == widget.mapTab) {
      body = widget.map;
    } else if (_currentTab == widget.offersTab) {
      body = TabBarView(
        key: Key('TabViewOffers'),
        controller: _tabControllerOffers,
        children: [
          widget.offersCurrent == null
              ? Text("/* Current */")
              : widget.offersCurrent,
          widget.offersHistory == null
              ? Text("/* History */")
              : widget.offersHistory
        ],
      );
    } else if (_currentTab == widget.proposalsTab) {
      body = TabBarView(
        key: Key('TabViewProposals'),
        controller: _tabControllerProposals,
        children: [
          widget.proposalsSent == null
              ? Text("/* Sent */")
              : widget.proposalsSent,
          widget.proposalsReceived == null
              ? Text("/* Received */")
              : widget.proposalsReceived,
          widget.proposalsRejected == null
              ? Text("/* Rejected */")
              : widget.proposalsRejected,
        ],
      );
    } else if (_currentTab == widget.agreementsTab) {
      body = TabBarView(
        key: Key('TabViewAgreements'),
        controller: _tabControllerAgreements,
        children: [
          widget.agreementsActive == null
              ? Text("/* Active */")
              : widget.agreementsActive,
          widget.agreementsHistory == null
              ? Text("/* History */")
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
        tabBar = TabBar(
            key: Key('TabBarOffers'),
            controller: _tabControllerOffers,
            tabs: [
              Tab(text: "Current".toUpperCase()),
              Tab(text: "History".toUpperCase())
            ]);
      } else if (_currentTab == widget.proposalsTab) {
        title = proposalsLabel;
        tabBar = TabBar(
            key: Key('TabBarProposals'),
            controller: _tabControllerProposals,
            tabs: [
              Tab(
                  text: (widget.account.accountType == AccountType.influencer
                          ? "Applied"
                          : "Direct")
                      .toUpperCase()),
              Tab(
                  text: (widget.account.accountType == AccountType.influencer
                          ? "Direct"
                          : "Proposals")
                      .toUpperCase()),
              Tab(text: "Rejected".toUpperCase())
            ]);
      } else if (_currentTab == widget.agreementsTab) {
        title = agreementsLabel;
        tabBar = TabBar(
            key: Key('TabBarAgreements'),
            controller: _tabControllerAgreements,
            tabs: [
              Tab(text: "Active".toUpperCase()),
              Tab(text: "History".toUpperCase())
            ]);
      }
      appBar = AppBar(
        title: Text(title),
        bottom: tabBar,
      );
    }
    return Scaffold(
      body: body,
      floatingActionButton: (widget.onMakeAnOffer != null &&
              (_currentTab == widget.mapTab || _currentTab == widget.offersTab))
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              tooltip: 'Make an offer',
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add),
              ]),
              onPressed: widget.onMakeAnOffer,
            )
          : null,
      drawer: Drawer(
        child: Column(
            children: [
          AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Material(
                  elevation: 4.0, // Match AppBar
                  color: Theme.of(context).primaryColor,
                  child: Stack(children: [
                    Positioned.fill(
                      child: BlurredNetworkImage(
                        url: widget.account.avatarUrl,
                        blurredUrl: widget.account.blurredAvatarUrl,
                        placeholderAsset: 'assets/placeholder_photo.png',
                      ),
                    ),
                    SafeArea(
                        // child: new Text("Hello world"),
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                                margin:
                                    EdgeInsets.fromLTRB(56.0, 16.0, 16.0, 16.0),
                                child: Text(
                                  widget.account.name,
                                  style:
                                      Theme.of(context).primaryTextTheme.title,
                                ))))
                  ]))),
          FlatButton(
            child: Row(children: [
              Container(
                margin: EdgeInsets.all(16.0),
                child: Icon(Icons.account_circle),
              ),
              Text('Profile')
            ]),
            onPressed: (widget.onNavigateProfile != null)
                ? () {
                    Navigator.pop(context);
                    widget.onNavigateProfile();
                  }
                : null,
          ),
          FlatButton(
            child: Row(children: [
              Container(
                margin: EdgeInsets.all(16.0),
                child: Icon(Icons.supervisor_account),
              ),
              Text('Switch User')
            ]),
            onPressed: (widget.onNavigateSwitchAccount != null)
                ? () {
                    Navigator.pop(context);
                    widget.onNavigateSwitchAccount();
                  }
                : null,
          ),
          (widget.account.globalAccountState.value >=
                  GlobalAccountState.debug.value)
              ? FlatButton(
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: Icon(Icons.account_box),
                    ),
                    Text('Debug Account')
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
      bottomNavigationBar: BottomNavigationBar(
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
