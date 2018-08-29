/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import 'network/inf.pb.dart';
import 'network/config_manager.dart';
import 'network/network_manager.dart';

import 'utility/progress_dialog.dart';

import 'profile/profile_view.dart';
import 'profile/profile_edit.dart';

import 'dashboard_common.dart';
import 'nearby_offers.dart';
import 'offer_view.dart';
import 'business_offer_list.dart';
import 'debug_account.dart';

// Influencer user
class AppInfluencer extends StatefulWidget {
  const AppInfluencer({
    Key key,
  }) : super(key: key);

  @override
  _AppInfluencerState createState() => new _AppInfluencerState();
}

class _AppInfluencerState extends State<AppInfluencer> {
  void navigateToOfferView(
      BuildContext context, DataAccount account, DataBusinessOffer offer) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new OfferView(
        account: network.account,
        businessAccount: network.latestAccount(account),
        businessOffer: network.latestBusinessOffer(offer),
      );
    }));
  }

  void navigateToProfileView(BuildContext context) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new ProfileView(
          account: network.account,
          onEditPressed: () {
            navigateToProfileEdit(context);
          });
    }));
  }

  void navigateToProfileEdit(BuildContext context) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new ProfileEdit(
        account: network.account,
      );
    }));
  }

  void navigateToDebugAccount() {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new DebugAccount(
        account: network.account,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return new DashboardCommon(
      account: network.account,
      mapTab: 0,
      applicantsTab: 1,
      map: new Builder(builder: (context) {
        NetworkInterface network = NetworkManager.of(context);
        return new NearbyOffers(onSearchPressed: (String query) {
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Not yet implemented.")));
        });
      }),
      onNavigateProfile: () {
        navigateToProfileView(context);
      },
      onNavigateDebugAccount: navigateToDebugAccount,
    );
  }
}

/* end of file */
