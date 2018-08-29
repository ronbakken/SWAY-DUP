/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

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
import 'nearby_common.dart';
import 'offer_view.dart';
import 'business_offer_list.dart';
import 'debug_account.dart';
import 'page_transition.dart';

import 'search/search_page_common.dart';
import 'cards/offer_card.dart';

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

  void navigateToSearchOffers(TextEditingController searchQueryController) {
    fadeToPage(context, (context, animation, secondaryAnimation) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new SearchPageCommon(
          searchHint: "Find nearby offers...",
          searchTooltip: "Search for nearby offers",
          searchQueryController: searchQueryController,
          onSearchRequest: (String searchQuery) async {
            await network.refreshDemoAllOffers();
          },
          searchResults: network.demoAllOffers.values
              .map((offer) => new OfferCard(
                  businessOffer: offer,
                  onPressed: () {
                    network.backgroundReloadBusinessOffer(offer);
                    navigateToOfferView(
                        context,
                        network.tryGetPublicProfile(offer.accountId,
                            fallbackOffer: offer),
                        offer);
                  }))
              .toList()
                ..sort((a, b) => b.businessOffer.offerId
                    .compareTo(a.businessOffer.offerId)) //<Widget>[],
          );
    });
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
        ConfigData config = ConfigManager.of(context);
        NetworkInterface network = NetworkManager.of(context);
        return new NearbyCommon(
          account: network.account,
          mapboxUrlTemplate: config.services.mapboxUrlTemplate,
          mapboxToken: config.services.mapboxToken,
          onSearchPressed: (TextEditingController searchQuery) {
            navigateToSearchOffers(searchQuery);
            // query.text = ":)";
            // Scaffold.of(context).showSnackBar(
            //     new SnackBar(content: new Text("Not yet implemented.")));
          },
          searchHint: "Find nearby offers...",
          searchTooltip: "Search for nearby offers",
        );
      }),
      onNavigateProfile: () {
        navigateToProfileView(context);
      },
      onNavigateDebugAccount: navigateToDebugAccount,
    );
  }
}

/* end of file */
