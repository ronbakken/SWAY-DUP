/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:inf/widgets/blurred_network_image.dart';

import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/widgets/network_status.dart';

// TODO: Animate transitions between the three windows

class DashboardSimplified extends StatefulWidget {
  const DashboardSimplified({
    Key key,
    @required this.account,
    @required this.onNavigateProfile,
    @required this.onNavigateHistory,
    @required this.onNavigateSwitchAccount,
    @required this.onNavigateDebugAccount,
    this.onMakeAnOffer,
    this.mapOffers,
    this.offersBusiness,
    this.proposalsDirect,
    this.proposalsApplied,
    this.proposalsDeal,
    this.mapOffersTab,
    this.offersBusinessTab,
    this.proposalsDirectTab,
    this.proposalsAppliedTab,
    this.proposalsDealTab,
  }) : super(key: key);

  final DataAccount account;

  final Function() onNavigateProfile;
  final Function() onNavigateHistory;
  final Function() onNavigateSwitchAccount;
  final Function() onNavigateDebugAccount;

  final Function() onMakeAnOffer; // FAB

  final int mapOffersTab;
  final int offersBusinessTab;
  final int proposalsDirectTab;
  final int proposalsAppliedTab;
  final int proposalsDealTab;

  final Widget mapOffers;
  final Widget offersBusiness;
  final Widget proposalsDirect;
  final Widget proposalsApplied;
  final Widget proposalsDeal;

  @override
  _DashboardSimplifiedState createState() => new _DashboardSimplifiedState();
}

class _DashboardSimplifiedState extends State<DashboardSimplified>
    with TickerProviderStateMixin {
  int _currentTab;
  int _tabCount;

  TabController _tabControllerTabs;

  void _initTabController() {
    _tabCount = 0;
    if (widget.mapOffersTab != null && widget.mapOffersTab >= _tabCount)
      _tabCount = widget.mapOffersTab + 1;
    if (widget.offersBusinessTab != null &&
        widget.offersBusinessTab >= _tabCount)
      _tabCount = widget.offersBusinessTab + 1;
    if (widget.proposalsDirectTab != null &&
        widget.proposalsDirectTab >= _tabCount)
      _tabCount = widget.proposalsDirectTab + 1;
    if (widget.proposalsAppliedTab != null &&
        widget.proposalsAppliedTab >= _tabCount)
      _tabCount = widget.proposalsAppliedTab + 1;
    if (widget.proposalsDealTab != null && widget.proposalsDealTab >= _tabCount)
      _tabCount = widget.proposalsDealTab + 1;
    if (_currentTab == null || _currentTab >= _tabCount) {
      _currentTab = 0;
    }
    if (_tabControllerTabs?.length != _tabCount) {
      _tabControllerTabs = new TabController(
        length: _tabCount,
        vsync: this,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  @override
  void reassemble() {
    super.reassemble();
    _initTabController();
  }

  @override
  Widget build(BuildContext context) {
    String applicantsLabel =
        widget.account.state.accountType == AccountType.influencer
            ? "Applied"
            : "Applicants";

    /*String mapLabel =
        widget.account.state.accountType == AccountType.influencer
            ? "Offers"
            : "Map";
    String offersLabel = "Offers";
    / *
            */

/*
  final Widget mapOffers;
  final Widget offersBusiness;
  final Widget proposalsDirect;
  final Widget proposalsApplied;
  final Widget proposalsDeal;
*/

    List<BottomNavigationBarItem> tabBarItems =
        new List<BottomNavigationBarItem>(_tabCount);

    if (widget.mapOffersTab != null) {
      tabBarItems[widget.mapOffersTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.map),
        title: new Text("Offers"),
      );
    }
    if (widget.offersBusinessTab != null) {
      tabBarItems[widget.offersBusinessTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.list),
        title: new Text("Offers"),
      );
    }
    if (widget.proposalsDirectTab != null) {
      tabBarItems[widget.proposalsDirectTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.alternate_email),
        title: new Text("Direct"),
      );
    }
    if (widget.proposalsAppliedTab != null) {
      tabBarItems[widget.proposalsAppliedTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.inbox),
        title: new Text(applicantsLabel),
      );
    }
    if (widget.proposalsDealTab != null) {
      tabBarItems[widget.proposalsDealTab] = new BottomNavigationBarItem(
        icon: new Icon(Icons.event_note),
        title: new Text("Deals"),
      );
    }
    Widget body;
    if (_currentTab == widget.mapOffersTab) {
      body = widget.mapOffers;
    } else if (_currentTab == widget.offersBusinessTab) {
      body = widget.offersBusiness;
    } else if (_currentTab == widget.proposalsDirectTab) {
      body = widget.proposalsDirect;
    } else if (_currentTab == widget.proposalsAppliedTab) {
      body = widget.proposalsApplied;
    } else if (_currentTab == widget.proposalsDealTab) {
      body = widget.proposalsDeal;
    }
    Widget appBar;
    if (_currentTab != widget.mapOffersTab) {
      String title;
      if (_currentTab == widget.offersBusinessTab) {
        title = "Offers";
      } else if (_currentTab == widget.proposalsDirectTab) {
        title = "Direct";
      } else if (_currentTab == widget.proposalsAppliedTab) {
        title = applicantsLabel;
      } else if (_currentTab == widget.proposalsDealTab) {
        title = "Deals";
      }
      appBar = new AppBar(
        title: new Text(title),
      );
    }
    return new Scaffold(
      body: body,
      floatingActionButton: (widget.onMakeAnOffer != null &&
              (_currentTab == widget.mapOffersTab ||
                  _currentTab == widget.offersBusinessTab))
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
                      child: new BlurredNetworkImage(
                        url: widget.account.detail.avatarCoverUrl,
                        blurredUrl: widget.account.detail.blurredAvatarCoverUrl,
                        placeholderAsset: 'assets/placeholder_photo.png',
                      ),
                    ),
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
          new FlatButton(
            child: new Row(children: [
              new Container(
                margin: new EdgeInsets.all(16.0),
                child: new Icon(Icons.history),
              ),
              new Text('History')
            ]),
            onPressed: (widget.onNavigateHistory != null)
                ? () {
                    Navigator.pop(context);
                    widget.onNavigateHistory();
                  }
                : null,
          ),
          new FlatButton(
            child: new Row(children: [
              new Container(
                margin: new EdgeInsets.all(16.0),
                child: new Icon(Icons.supervisor_account),
              ),
              new Text('Switch User')
            ]),
            onPressed: (widget.onNavigateSwitchAccount != null)
                ? () {
                    Navigator.pop(context);
                    widget.onNavigateSwitchAccount();
                  }
                : null,
          ),
          (widget.account.state.globalAccountState.value >=
                  GlobalAccountState.debug.value)
              ? new FlatButton(
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
            setState(() {
              _currentTab = index;
            });
          },
          items: tabBarItems),
    );
  }
}

/* end of file */
