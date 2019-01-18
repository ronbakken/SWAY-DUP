/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/app_composition/app_common.dart';
import 'package:inf/ui/offers/offer_details_page.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_inheritable/api_provider.dart';

import 'package:inf/utility/page_transition.dart';
import 'package:inf/widgets/progress_dialog.dart';

import 'package:inf/screens/search_page_common.dart';
import 'package:logging/logging.dart';

// Influencer user
class AppInfluencer extends StatefulWidget {
  const AppInfluencer({
    Key key,
  }) : super(key: key);

  @override
  _AppInfluencerState createState() => _AppInfluencerState();
}

class _AppInfluencerState extends AppCommonState<AppInfluencer> {
  static final Logger _log = Logger('Inf.AppInfluencer');

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
  @override
  void navigateToOffer(Int64 offerId) {
    final Api network = ApiProvider.of(context);
    if (offerViewOpen != null) {
      _log.fine('Pop previous offer route');
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
      context,
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/offer/' + offerId.toString()),
        builder: (BuildContext context) {
          // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
          final ConfigData config = ConfigProvider.of(context);
          final Api network = ApiProvider.of(context);
          // NavigatorState navigator = Navigator.of(context);
          final DataOffer businessOffer = network.tryGetOffer(offerId);
          final DataAccount businessAccount =
              network.tryGetProfileSummary(businessOffer.senderAccountId);
          return OfferDetailsPage(
            config: config,
            account: network.account,
            offer: businessOffer,
            senderAccount: businessAccount,
            onSenderAccountPressed: () {
              navigateToPublicProfile(businessOffer.senderAccountId);
            },
            onProposalPressed: () {
              navigateToProposal(businessOffer.proposalId);
            },
            onApply: (String remarks) async {
              // TODO: Add terms (negotiate variant)
              final DataProposal proposal = await wrapProgressAndError<DataProposal>(
                context: context,
                progressBuilder:
                    genericProgressBuilder(message: 'Applying for offer...'),
                errorBuilder:
                    genericMessageBuilder(title: 'Failed to apply for offer'),
                task: () async {
                return await network.applyProposal(offerId, remarks);
                },
              );
              navigateToProposal(proposal.proposalId);
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

  void navigateToSearchOffers(TextEditingController searchQueryController) {
    final TextEditingController searchQueryControllerFallback =
        searchQueryController ?? TextEditingController();
    fadeToPage(context, (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      // ConfigData config = ConfigProvider.of(context);
      final Api network = ApiProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return SearchPageCommon(
        searchHint: 'Find nearby offers...',
        searchTooltip: 'Search for nearby offers',
        searchQueryController: searchQueryControllerFallback,
        onSearchRequest: (String searchQuery) async {
          try {
            await network.refreshDemoAllOffers();
          } catch (error, stackTrace) {
            await showDialog<void>(
              context: this.context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Search Failed'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('An error has occured.'),
                        Text('Please try again later.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('Ok'.toUpperCase())],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            _log.severe('Failed to search for offers.', error, stackTrace);
          }
        },
        searchResults: const <Widget>[],
        /*network.demoAllOffers
              .map(
                (Int64 offerId) => OfferCard(
                      businessOffer: offer,
                      onPressed: () {
                        navigateToOffer(offer.offerId);
                      },
                    ),
              )
              .toList()
                ..sort((a, b) => b.businessOffer.offerId
                    .compareTo(a.businessOffer.offerId)) */
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildDashboard(context);
  }
}

/* end of file */
