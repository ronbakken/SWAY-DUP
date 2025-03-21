/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

// import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sway_mobile_app/app_composition/app_common.dart';
// import 'package:sway_mobile_app/network_inheritable/multi_account_selection.dart';
import 'package:sway_mobile_app/ui/offer_views/offer_details_page.dart';

import 'package:sway_common/inf_common.dart';
import 'package:sway_mobile_app/network_inheritable/config_provider.dart';
import 'package:sway_mobile_app/network_inheritable/api_provider.dart';
// import 'package:sway_mobile_app/screens/account_switch.dart';
// import 'package:sway_mobile_app/widgets/network_status.dart';

// import 'package:sway_mobile_app/widgets/progress_dialog.dart';

// import 'package:sway_mobile_app/screens/profile_view.dart';
// import 'package:sway_mobile_app/screens/profile_edit.dart';
// import 'package:sway_mobile_app/screens/dashboard_simplified.dart';
// import 'package:sway_mobile_app/screens/offer_create.dart';
// import 'package:sway_mobile_app/screens/offer_view.dart';
// import 'package:sway_mobile_app/screens/business_offer_list.dart';
// import 'package:sway_mobile_app/screens/debug_account.dart';
// import 'package:file/file.dart' as file;
// import 'package:file/local.dart' as file;

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

  int offerViewCount = 0;
  Int64 offerViewOpen;
  @override
  void navigateToOffer(Int64 offerId) {
    final Api network = ApiProvider.of(context);
    if (offerViewOpen != null) {
      print('[INF] Pop previous offer route');
      Navigator.popUntil(context, (Route<dynamic> route) {
        return route.settings.name != null &&
            route.settings.name
                .startsWith('/offer/' + offerViewOpen.toString());
      });
      if (offerViewOpen == offerId) {
        network.getOffer(offerId); // Background refresh
        return;
      }
      Navigator.pop(context);
    }
    network.getOffer(offerId); // Background refresh
    final int count = ++offerViewCount;
    offerViewOpen = offerId;
    Navigator.push<void>(
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/offer/' + offerId.toString()),
        builder: (BuildContext context) {
          final ConfigData config = ConfigProvider.of(context);
          final Api network = ApiProvider.of(context);
          // NavigatorState navigator = Navigator.of(context);
          final DataOffer businessOffer = network.tryGetOffer(offerId);
          final DataAccount businessAccount =
              network.tryGetProfileSummary(businessOffer.senderAccountId);
          return OfferDetailsPage(
            config: config,
            account: network.account,
            senderAccount: businessAccount,
            offer: businessOffer,
            onSenderAccountPressed: () {
              navigateToPublicProfile(businessOffer.senderAccountId);
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

  @override
  Widget build(BuildContext context) {
    return buildDashboard(context);
    /*
    final ApiClient network = NetworkProvider.of(context);
    assert(network != null);
    return DashboardSimplified(
      account: network.account,
      offersBusinessTab: 0,
      proposalsDirectTab: 1,
      proposalsAppliedTab: 2,
      proposalsDealTab: 3,
      offersBusiness: Builder(builder: (context) {
        final ApiClient network = NetworkProvider.of(context);
        return OfferList(
            businessOffers: network.offers
                .map<DataOffer>(
                    (offerId) => network.tryGetOffer(offerId, detail: false))
                .where((offer) => offer.state != OfferState.closed)
                .toList()
                  ..sort((a, b) => b.offerId.compareTo(a.offerId)),
            onRefreshOffers: (network.connected == NetworkConnectionState.ready)
                ? network.refreshOffers
                : null,
            onOfferPressed: (DataOffer offer) {
              navigateToOffer(offer.offerId);
            });
      }),
      / *
          offersHistory: new Builder(builder: (context) {
            final ApiClient network = NetworkProvider.of(context);
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
          }),* /
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
    );*/
  }
}

class DasboardSimplified {}

/* end of file */
