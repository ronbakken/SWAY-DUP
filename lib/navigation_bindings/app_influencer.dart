/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf_app/navigation_bindings/app_common.dart';
import 'package:inf_app/network_generic/multi_account_client.dart';
import 'package:inf_app/network_inheritable/multi_account_selection.dart';
import 'package:inf_app/screens/account_switch.dart';
import 'package:inf_app/screens/dashboard_simplified.dart';
import 'package:inf_app/widgets/network_status.dart';

import 'package:latlong/latlong.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf_app/network_inheritable/config_provider.dart';
import 'package:inf_app/network_inheritable/network_provider.dart';

import 'package:inf_app/utility/page_transition.dart';
import 'package:inf_app/widgets/progress_dialog.dart';
import 'package:inf_app/widgets/offers_showcase.dart';
import 'package:inf_app/cards/offer_card.dart';

import 'package:inf_app/screens/profile_view.dart';
import 'package:inf_app/screens/profile_edit.dart';
import 'package:inf_app/screens/offer_view.dart';
import 'package:inf_app/screens/debug_account.dart';
import 'package:inf_app/screens/offers_map.dart';
import 'package:inf_app/screens/search_page_common.dart';

// Influencer user
class AppInfluencer extends StatefulWidget {
  const AppInfluencer({
    Key key,
  }) : super(key: key);

  @override
  _AppInfluencerState createState() => _AppInfluencerState();
}

class _AppInfluencerState extends AppCommonState<AppInfluencer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
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
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: '/offer/' + offerId.toString()),
        builder: (BuildContext context) {
          // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
          // ConfigData config = ConfigProvider.of(context);
          ApiClient network = NetworkProvider.of(context);
          // NavigatorState navigator = Navigator.of(context);
          DataOffer businessOffer = network.tryGetOffer(offerId);
          DataAccount businessAccount =
              network.tryGetProfileSummary(businessOffer.senderId);
          return OfferView(
            account: network.account,
            businessOffer: businessOffer,
            businessAccount: businessAccount,
            onBusinessAccountPressed: () {
              navigateToPublicProfile(businessOffer.senderId);
            },
            onProposalPressed: (Int64 proposalId) {
              navigateToProposal(proposalId);
            },
            onApply: (remarks) async {
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
                          Text("Applying for offer..."),
                        ],
                      ),
                    );
                  });
              DataProposal proposal;
              try {
                // Create the offer
                proposal = await network.sendProposal(offerId, remarks);
              } catch (error, stack) {
                print("[INF] Exception applying for offer': $error\n$stack");
              }
              closeProgressDialog(progressDialog);
              if (proposal == null) {
                // TODO: Request refreshing the offer!!!
                await showDialog<Null>(
                  context: this.context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Failed to apply for offer'),
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
                // Navigator.of(this.context).pop();
                navigateToProposal(proposal.proposalId);
              }
              return proposal;
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
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      // ConfigData config = ConfigProvider.of(context);
      ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return ProfileView(
          account: network.account,
          oauthProviders: ConfigProvider.of(context).oauthProviders,
          onEditPressed: () {
            navigateToProfileEdit();
          });
    }));
  }

  void navigateToProfileEdit() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      // ConfigData config = ConfigProvider.of(context);
      ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return ProfileEdit(
        account: network.account,
      );
    }));
  }

  void navigateToSearchOffers(TextEditingController searchQueryController) {
    TextEditingController searchQueryControllerFallback =
        searchQueryController ?? TextEditingController();
    fadeToPage(context, (context, animation, secondaryAnimation) {
      // ConfigData config = ConfigProvider.of(context);
      ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return SearchPageCommon(
          searchHint: "Find nearby offers...",
          searchTooltip: "Search for nearby offers",
          searchQueryController: searchQueryControllerFallback,
          onSearchRequest: (String searchQuery) async {
            try {
              await network.refreshDemoAllOffers();
            } catch (error, stack) {
              await showDialog<Null>(
                context: this.context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Search Failed'),
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
              print("Failed to search for offers: $error\n$stack");
            }
          },
          searchResults: network.demoAllOffers.values
              .map((offer) => OfferCard(
                  businessOffer: offer,
                  onPressed: () {
                    navigateToOffer(offer.offerId);
                  }))
              .toList()
                ..sort((a, b) => b.businessOffer.offerId
                    .compareTo(a.businessOffer.offerId)) //<Widget>[],
          );
    });
  }

  MapController _mapController = MapController();
  bool _mapFilter = false;
  DataOffer _mapHighlightOffer;

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

  @override
  Widget build(BuildContext context) {
    ApiClient network = NetworkProvider.of(context);
    bool enoughSpaceForBottom = (MediaQuery.of(context).size.height > 480.0);
    assert(network != null);
    return DashboardSimplified(
      account: network.account,
      mapOffersTab: 0,
      proposalsDirectTab: 1,
      proposalsAppliedTab: 2,
      proposalsDealTab: 3,
      mapOffers: Builder(builder: (context) {
        ConfigData config = ConfigProvider.of(context);
        ApiClient network = NetworkProvider.of(context);
        List<int> showcaseOfferIds = enoughSpaceForBottom
            ? network.demoAllOffers.keys.toList()
            : <int>[]; // TODO
        Widget showcase = showcaseOfferIds.isNotEmpty
            ? OffersShowcase(
                getOffer: (BuildContext context, int offerId) {
                  ApiClient network = NetworkProvider.of(context);
                  return network.tryGetOffer(Int64(offerId));
                },
                getAccount: (BuildContext context, int accountId) {
                  ApiClient network = NetworkProvider.of(context);
                  return network.tryGetProfileSummary(Int64(accountId));
                },
                offerIds: network.demoAllOffers.keys.toList(),
                onOfferPressed: (DataOffer offer) {
                  navigateToOffer(offer.offerId);
                },
                onOfferCenter: (DataOffer offer) {
                  _mapController.move(LatLng(offer.latitude, offer.longitude),
                      _mapController.zoom);
                  setState(() {
                    _mapHighlightOffer = offer;
                  });
                },
              )
            : null;
        Widget map = OffersMap(
          filterState: _mapFilter,
          account: network.account,
          mapboxUrlTemplate: Theme.of(context).brightness == Brightness.dark
              ? config.services.mapboxUrlTemplateDark
              : config.services.mapboxUrlTemplateLight,
          mapboxToken: config.services.mapboxToken,
          onSearchPressed: () {
            navigateToSearchOffers(null);
          },
          onFilterPressed: enoughSpaceForBottom
              ? () {
                  setState(() {
                    _mapFilter = !_mapFilter;
                  });
                }
              : null,
          filterTooltip: "Filter map offers by category",
          searchTooltip: "Search for nearby offers",
          mapController: _mapController,
          bottomSpace: (showcase != null) ? 156.0 : 0.0,
          offers: network.demoAllOffers.values.toList(),
          highlightOffer: _mapHighlightOffer,
          onOfferPressed: navigateToOffer,
        );
        return showcase != null
            ? Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  map,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      showcase,
                    ],
                  )
                ],
              )
            : map;
      }),
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

/* end of file */
