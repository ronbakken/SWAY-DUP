/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/navigation_bindings/app_common.dart';
import 'package:inf/network_inheritable/multi_account_selection.dart';

import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_inheritable/network_provider.dart';
import 'package:inf/screens/account_switch.dart';
import 'package:inf/widgets/network_status.dart';

import 'package:inf/widgets/progress_dialog.dart';

import 'package:inf/screens/profile_view.dart';
import 'package:inf/screens/profile_edit.dart';
import 'package:inf/screens/dashboard_simplified.dart';
import 'package:inf/screens/offer_create.dart';
import 'package:inf/screens/offer_view.dart';
import 'package:inf/screens/business_offer_list.dart';
import 'package:inf/screens/debug_account.dart';

// Business user
class AppBusiness extends StatefulWidget {
  const AppBusiness({
    Key key,
  }) : super(key: key);

  @override
  _AppBusinessState createState() => new _AppBusinessState();
}

class _AppBusinessState extends AppCommonState<AppBusiness> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateToMakeAnOffer() {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      // ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
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
            navigateToOffer(new Int64(offer.offerId));
          }
        },
      );
    }));
  }

  int offerViewCount = 0;
  Int64 offerViewOpen;
  void navigateToOffer(Int64 offerId) {
    NetworkInterface network = NetworkProvider.of(context);
    if (offerViewOpen != null) {
      print("[INF] Pop previous offer route");
      Navigator.popUntil(context, (Route<dynamic> route) {
        return route.settings.name
            .startsWith('/offer/' + offerViewOpen.toString());
      });
      if (offerViewOpen == offerId) {
        network.getOffer(offerId); // Background refresh
        return;
      }
      Navigator.pop(context);
    }
    network.getOffer(offerId); // Background refresh
    int count = ++offerViewCount;
    offerViewOpen = offerId;
    Navigator.push(
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      new MaterialPageRoute(
        settings: new RouteSettings(name: '/offer/' + offerId.toString()),
        builder: (context) {
          // ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkProvider.of(context);
          // NavigatorState navigator = Navigator.of(context);
          DataBusinessOffer businessOffer = network.tryGetOffer(offerId);
          DataAccount businessAccount =
              network.tryGetProfileSummary(new Int64(businessOffer.accountId));
          return new OfferView(
            account: network.account,
            businessAccount: businessAccount,
            businessOffer: businessOffer,
            onBusinessAccountPressed: () {
              navigateToPublicProfile(new Int64(businessOffer.accountId));
            },
          );
        },
      ),
    ).whenComplete(() {
      if (count == offerViewCount) {
        offerViewOpen = null;
      }
    });
  }

  void navigateToProfileView() {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      // ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return new ProfileView(
        account: network.account,
        onEditPressed: navigateToProfileEdit,
      );
    }));
  }

  void navigateToHistory() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      return new Scaffold(
          appBar: new AppBar(
            title: new Text("History"),
          ),
          bottomSheet: NetworkStatus.buildOptional(context),
          body: proposalsHistory);
    }));
  }

  void navigateToProfileEdit() {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      // ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return new ProfileEdit(
        account: network.account,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkProvider.of(context);
    assert(network != null);
    return new DashboardSimplified(
      account: network.account,
      offersBusinessTab: 0,
      proposalsDirectTab: 1,
      proposalsAppliedTab: 2,
      proposalsDealTab: 3,
      offersBusiness: new Builder(builder: (context) {
        NetworkInterface network = NetworkProvider.of(context);
        return new BusinessOfferList(
            businessOffers: network.offers.values
                .where(
                    (offer) => (offer.state != BusinessOfferState.Bclosed))
                .toList()
                  ..sort((a, b) => b.offerId.compareTo(a.offerId)),
            onRefreshOffers: (network.connected == NetworkConnectionState.ready)
                ? network.refreshOffers
                : null,
            onOfferPressed: (DataBusinessOffer offer) {
              navigateToOffer(new Int64(offer.offerId));
            });
      }),
      /*
          offersHistory: new Builder(builder: (context) {
            NetworkInterface network = NetworkProvider.of(context);
            return new BusinessOfferList(
                businessOffers: network.offers.values
                    .where(
                        (offer) => (offer.state == BusinessOfferState.Bclosed))
                    .toList()
                      ..sort((a, b) => b.offerId.compareTo(a.offerId)),
                onRefreshOffers: (network.connected == NetworkConnectionState.ready)
                    ? network.refreshOffers
                    : null,
                onOfferPressed: (DataBusinessOffer offer) {
                  navigateToOffer(new Int64(offer
                      .offerId)); // account will be able to use a future value provider thingy for not-mine offers
                });
          }),*/
      onMakeAnOffer: (network.connected == NetworkConnectionState.ready)
          ? navigateToMakeAnOffer
          : null,
      onNavigateProfile: navigateToProfileView,
      onNavigateSwitchAccount: navigateToSwitchAccount,
      onNavigateHistory: navigateToHistory,
      onNavigateDebugAccount: navigateToDebugAccount,
      proposalsDirect: proposalsDirect,
      proposalsApplied: proposalsApplied,
      proposalsDeal: proposalsDeal,
    );
  }
}

class DasboardSimplified {}

/* end of file */
