/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:inf/widgets/blurred_network_image.dart';

import 'package:inf_common/inf_common.dart';
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
  _DashboardSimplifiedState createState() => _DashboardSimplifiedState();
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
      _tabControllerTabs = TabController(
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
    String proposalsLabel = widget.account.accountType == AccountType.influencer
        ? "Applied"
        : "Proposals";

    /*String mapLabel =
        widget.account.accountType == AccountType.influencer
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
        List<BottomNavigationBarItem>(_tabCount);

    if (widget.mapOffersTab != null) {
      tabBarItems[widget.mapOffersTab] = BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text("Offers"),
      );
    }
    if (widget.offersBusinessTab != null) {
      tabBarItems[widget.offersBusinessTab] = BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text("Offers"),
      );
    }
    if (widget.proposalsDirectTab != null) {
      tabBarItems[widget.proposalsDirectTab] = BottomNavigationBarItem(
        icon: Icon(Icons.alternate_email),
        title: Text("Direct"),
      );
    }
    if (widget.proposalsAppliedTab != null) {
      tabBarItems[widget.proposalsAppliedTab] = BottomNavigationBarItem(
        icon: Icon(Icons.inbox),
        title: Text(proposalsLabel),
      );
    }
    if (widget.proposalsDealTab != null) {
      tabBarItems[widget.proposalsDealTab] = BottomNavigationBarItem(
        icon: Icon(Icons.event_note),
        title: Text("Deals"),
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
        title = proposalsLabel;
      } else if (_currentTab == widget.proposalsDealTab) {
        title = "Deals";
      }
      appBar = AppBar(
        title: Text(title),
      );
    }
    return Scaffold(
      body: body,
      floatingActionButton: (widget.onMakeAnOffer != null &&
              (_currentTab == widget.mapOffersTab ||
                  _currentTab == widget.offersBusinessTab))
          ? FloatingActionButton(
              heroTag: 'make-an-offer-' + Random().nextInt(1 << 32).toString(), // TODO: ..... Issue after offer made!
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
                child: Icon(Icons.history),
              ),
              Text('History')
            ]),
            onPressed: (widget.onNavigateHistory != null)
                ? () {
                    Navigator.pop(context);
                    widget.onNavigateHistory();
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
            setState(() {
              _currentTab = index;
            });
          },
          items: tabBarItems),
    );
  }
}

/* end of file */
