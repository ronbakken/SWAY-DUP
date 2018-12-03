/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf_app/navigation_bindings/app_common.dart';
import 'package:inf_app/network_inheritable/multi_account_selection.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf_app/network_inheritable/config_provider.dart';
import 'package:inf_app/network_inheritable/network_provider.dart';
import 'package:inf_app/screens/account_switch.dart';
import 'package:inf_app/widgets/network_status.dart';

import 'package:inf_app/widgets/progress_dialog.dart';

import 'package:inf_app/screens/profile_view.dart';
import 'package:inf_app/screens/profile_edit.dart';
import 'package:inf_app/screens/dashboard_simplified.dart';
import 'package:inf_app/screens/offer_create.dart';
import 'package:inf_app/screens/offer_view.dart';
import 'package:inf_app/screens/business_offer_list.dart';
import 'package:inf_app/screens/debug_account.dart';

// Business user
class AppBusiness extends StatefulWidget {
  const AppBusiness({
    Key key,
  }) : super(key: key);

  @override
  _AppBusinessState createState() => _AppBusinessState();
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
        context, MaterialPageRoute(builder: (context) {
      // ConfigData config = ConfigProvider.of(context);
      ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return OfferCreate(
        onUploadImage: network.uploadImage,
        onCreateOffer: (NetCreateOffer createOffer) async {
          var progressDialog = showProgressDialog(
              context: this.context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator()),
                      Text("Creating offer..."),
                    ],
                  ),
                );
              });
          DataOffer offer;
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
                return AlertDialog(
                  title: Text('Create Offer Failed'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('An error has occured.'),
                        Text('Please try again later.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Ok'.toUpperCase())],
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
            navigateToOffer(offer.offerId);
          }
        },
      );
    }));
  }

  int offerViewCount = 0;
  Int64 offerViewOpen;
  void navigateToOffer(Int64 offerId) {
    ApiClient network = NetworkProvider.of(context);
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
      MaterialPageRoute(
        settings: RouteSettings(name: '/offer/' + offerId.toString()),
        builder: (context) {
          // ConfigData config = ConfigProvider.of(context);
          ApiClient network = NetworkProvider.of(context);
          // NavigatorState navigator = Navigator.of(context);
          DataOffer businessOffer = network.tryGetOffer(offerId);
          DataAccount businessAccount =
              network.tryGetProfileSummary(businessOffer.senderId);
          return OfferView(
            account: network.account,
            businessAccount: businessAccount,
            businessOffer: businessOffer,
            onBusinessAccountPressed: () {
              navigateToPublicProfile(businessOffer.senderId);
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
        context, MaterialPageRoute(builder: (context) {
      // ConfigData config = ConfigProvider.of(context);
      ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return ProfileView(
        account: network.account,
        oauthProviders: ConfigProvider.of(context).oauthProviders,
        onEditPressed: navigateToProfileEdit,
      );
    }));
  }

  void navigateToHistory() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      return Scaffold(
          appBar: AppBar(
            title: Text("History"),
          ),
          bottomSheet: NetworkStatus.buildOptional(context),
          body: proposalsHistory);
    }));
  }

  void navigateToProfileEdit() {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, MaterialPageRoute(builder: (context) {
      // ConfigData config = ConfigProvider.of(context);
      ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return ProfileEdit(
        account: network.account,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    ApiClient network = NetworkProvider.of(context);
    assert(network != null);
    return DashboardSimplified(
      account: network.account,
      offersBusinessTab: 0,
      proposalsDirectTab: 1,
      proposalsAppliedTab: 2,
      proposalsDealTab: 3,
      offersBusiness: Builder(builder: (context) {
        ApiClient network = NetworkProvider.of(context);
        return OfferList(
            businessOffers: network.offers.values
                .where((offer) => (offer.state != OfferState.closed))
                .toList()
                  ..sort((a, b) => b.offerId.compareTo(a.offerId)),
            onRefreshOffers: (network.connected == NetworkConnectionState.ready)
                ? network.refreshOffers
                : null,
            onOfferPressed: (DataOffer offer) {
              navigateToOffer(offer.offerId);
            });
      }),
      /*
          offersHistory: new Builder(builder: (context) {
            ApiClient network = NetworkProvider.of(context);
            return new OfferList(
                businessOffers: network.offers.values
                    .where(
                        (offer) => (offer.state == OfferState.Bclosed))
                    .toList()
                      ..sort((a, b) => b.offerId.compareTo(a.offerId)),
                onRefreshOffers: (network.connected == NetworkConnectionState.ready)
                    ? network.refreshOffers
                    : null,
                onOfferPressed: (DataOffer offer) {
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
