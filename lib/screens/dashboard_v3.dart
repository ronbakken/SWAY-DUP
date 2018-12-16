/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:inf_common/inf_common.dart';

// TODO: Animate transitions between the three windows

class DashboardV3 extends StatefulWidget {
  const DashboardV3({
    Key key,
    @required this.account,
    this.drawer,
    this.onMakeAnOffer,
    @required this.exploreBuilder,
    @required this.offersBuilder,
    @required this.directBuilder,
    @required this.appliedBuilder,
    @required this.dealsBuilder,
    @required this.networkStatusBuilder,
  }) : super(key: key);

  final DataAccount account;

  final Widget drawer;
  final Function() onMakeAnOffer;

  final Widget Function(BuildContext context) exploreBuilder;
  final Widget Function(BuildContext context) offersBuilder;
  final Widget Function(BuildContext context) directBuilder;
  final Widget Function(BuildContext context) appliedBuilder;
  final Widget Function(BuildContext context) dealsBuilder;

  final Function(BuildContext context) networkStatusBuilder;

  @override
  _DashboardV3State createState() => _DashboardV3State();
}

class _DashboardV3State extends State<DashboardV3> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    //_initTabController();
  }

  @override
  void reassemble() {
    super.reassemble();
    //_initTabController();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar;
    if (_currentTab != 0) {
      String title;
      if (_currentTab == 1) {
        title = widget.account.accountType == AccountType.influencer
            ? 'Solicitations'
            : 'Offer';
      } else if (_currentTab == 2) {
        title = 'Direct';
      } else if (_currentTab == 3) {
        title = widget.account.accountType == AccountType.influencer
            ? 'Applied'
            : 'Applicants';
      } else if (_currentTab == 4) {
        title = 'Deals';
      }
      appBar = AppBar(
        title: Text(title),
      );
    }
    Widget body;
    if (_currentTab == 0) {
      body = widget.exploreBuilder(context);
    } else if (_currentTab == 1) {
      body = widget.offersBuilder(context);
    } else if (_currentTab == 2) {
      body = widget.directBuilder(context);
    } else if (_currentTab == 3) {
      body = widget.appliedBuilder(context);
    } else if (_currentTab == 4) {
      body = widget.dealsBuilder(context);
    }
    return Scaffold(
        body: body,
        floatingActionButton: (widget.onMakeAnOffer != null && _currentTab == 1)
            ? FloatingActionButton(
                heroTag: 'make-an-offer-' +
                    Random()
                        .nextInt(1 << 32)
                        .toString(), // TODO: ..... Issue after offer made!
                backgroundColor: Theme.of(context).primaryColor,
                tooltip: 'Make an offer',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.add),
                  ],
                ),
                onPressed: widget.onMakeAnOffer,
              )
            : null,
        drawer: widget.drawer,
        appBar: appBar,
        bottomSheet: widget.networkStatusBuilder != null
            ? widget.networkStatusBuilder(context)
            : null, // NetworkStatus.buildOptional(context),
        bottomNavigationBar: _DashboardBottomNavigation(
          accountType: widget.account.accountType,
          onTap: _onBottomTap,
        ));
  }

  void _onBottomTap(int index) {
    setState(() {
      _currentTab = index;
    });
  }
}

class _DashboardBottomNavigation extends StatelessWidget {
  final AccountType accountType;
  final Function(int index) onTap;
  final int currentTab;

  const _DashboardBottomNavigation(
      {Key key, this.accountType, this.onTap, this.currentTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> tabBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text('Explore'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.list),
        title: Text(
            accountType == AccountType.influencer ? 'Solicitations' : 'Offer'),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.alternate_email),
        title: Text('Direct'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.inbox),
        title: Text(
            accountType == AccountType.influencer ? 'Applied' : 'Applicants'),
      ),
      const BottomNavigationBarItem(
          icon: Icon(Icons.event_note), title: Text('Deals')),
    ];
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentTab ?? 0,
      onTap: onTap,
      items: tabBarItems,
    );
  }
}

/* end of file */
