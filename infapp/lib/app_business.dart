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

import 'dashboard_business.dart';
import 'nearby_influencers.dart';
import 'offer_create.dart';

// Business user
class AppBusiness extends StatefulWidget {
  const AppBusiness({
    Key key,
  }) : super(key: key);

  @override
  _AppBusinessState createState() => new _AppBusinessState();
}

class _AppBusinessState extends State<AppBusiness> {
  void navigateToMakeAnOffer(BuildContext context) {
    Navigator.push(
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context, new MaterialPageRoute(
        builder: (context) {
          ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          NavigatorState navigator = Navigator.of(context);
          return new OfferCreate(
            onUploadImage: network.uploadImage,
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return new DashboardBusiness(
      account: network.account,
      map: new Builder(builder: (context) {
        return new NearbyInfluencers(
          onSearchPressed: (String query) { Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Not yet implemented."))); }
        );
      }),
      onMakeAnOffer: () {
        navigateToMakeAnOffer(context);
      },
    );
  }
}

/* end of file */