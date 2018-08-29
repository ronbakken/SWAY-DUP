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
import 'nearby_influencers.dart';
import 'offer_create.dart';
import 'offer_view.dart';
import 'business_offer_list.dart';
import 'debug_account.dart';

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
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new OfferCreate(
        onUploadImage: network.uploadImage,
        onCreateOffer: (NetCreateOfferReq createOffer) async {
          var progressDialog = showProgressDialog(
              context: this.context,
              builder: (BuildContext context) {
                return new Dialog(
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new Container(
                          padding: new EdgeInsets.all(24.0),
                          child: new CircularProgressIndicator()),
                      new Text("Creating offer..."),
                    ],
                  ),
                );
              });
          DataBusinessOffer offer;
          try {
            // Create the offer
            offer = await network.createOffer(createOffer);
          } catch (error, stack) {
            print("[INF] Exception creating offer': $error\n$stack");
          }
          closeProgressDialog(progressDialog);
          if (offer == null) {
            await showDialog<Null>(
              context: this.context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('Create Offer Failed'),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('An error has occured.'),
                        new Text('Please try again later.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [new Text('Ok'.toUpperCase())],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.of(this.context).pop();
            navigateToOfferView(this.context, network.account, offer);
          }
        },
      );
    }));
  }

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

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return new DashboardCommon(
      account: network.account,
      mapTab: 0,
      offersTab: 1,
      applicantsTab: 2,
      map: new Builder(builder: (context) {
        return new NearbyInfluencers(onSearchPressed: (String query) {
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Not yet implemented.")));
        });
      }),
      offersCurrent: new Builder(builder: (context) {
        NetworkInterface network = NetworkManager.of(context);
        return new BusinessOfferList(
            businessOffers: network.offers.values
                .where(
                    (offer) => (offer.state != BusinessOfferState.BOS_CLOSED))
                .toList()
                  ..sort((a, b) => b.offerId.compareTo(a.offerId)),
            onRefreshOffers: (network.connected == NetworkConnectionState.Ready)
                ? network.refreshOffers
                : null,
            onOfferPressed: (DataBusinessOffer offer) {
              navigateToOfferView(context, network.account, offer);
            });
      }),
      offersHistory: new Builder(builder: (context) {
        NetworkInterface network = NetworkManager.of(context);
        return new BusinessOfferList(
            businessOffers: network.offers.values
                .where(
                    (offer) => (offer.state == BusinessOfferState.BOS_CLOSED))
                .toList()
                  ..sort((a, b) => b.offerId.compareTo(a.offerId)),
            onRefreshOffers: (network.connected == NetworkConnectionState.Ready)
                ? network.refreshOffers
                : null,
            onOfferPressed: (DataBusinessOffer offer) {
              navigateToOfferView(context, network.account,
                  offer); // account will be able to use a future value provider thingy for not-mine offers
            });
      }),
      onMakeAnOffer: (network.connected == NetworkConnectionState.Ready)
          ? () {
              navigateToMakeAnOffer(context);
            }
          : null,
      onNavigateProfile: () {
        navigateToProfileView(context);
      },
      onNavigateDebugAccount: navigateToDebugAccount,
    );
  }
}

/* end of file */
