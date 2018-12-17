/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inf/navigation_bindings/app_base.dart';
import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_inheritable/multi_account_selection.dart';
import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_inheritable/network_provider.dart';
import 'package:inf/screens/business_offer_list.dart';
import 'package:inf/screens/dashboard_drawer.dart';
import 'package:inf/screens/dashboard_v3.dart';
import 'package:inf/screens/offer_create.dart';
import 'package:inf/screens/offers_map.dart';
import 'package:inf/screens/offers_map_only.dart';
import 'package:inf/screens/profile_edit.dart';
import 'package:inf/ui/main/activities_section.dart';
import 'package:inf/ui/main/browse_list_view.dart';
import 'package:inf/ui/main/browse_section.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/main/menu_drawer.dart';
import 'package:inf/widgets/network_status.dart';
import 'package:inf/widgets/offers_showcase.dart';
import 'package:inf/widgets/progress_dialog.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/screens/debug_account.dart';
import 'package:inf/screens/haggle_view.dart';
import 'package:inf/screens/profile_view.dart';
import 'package:inf/screens/proposal_list.dart';
import 'package:file/file.dart' as file;
import 'package:file/local.dart' as file;
import 'package:latlong/latlong.dart';

abstract class AppCommonState<T extends StatefulWidget>
    extends AppBaseState<T> {
  static const bool prototypeDashboard = false;
  static const bool prototypeDrawer = false;

  ApiClient _network;
  ConfigData _config;
  CrossAccountNavigator _navigator;
  StreamSubscription<NavigationRequest> _navigationSubscription;

  Builder proposalsDirect;
  Builder proposalsApplied;
  Builder proposalsDeal;
  Builder proposalsHistory;

  @override
  void initState() {
    super.initState();
    _initBuilders();
  }

  @override
  void reassemble() {
    super.reassemble();
    _initBuilders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _config = ConfigProvider.of(context);
    final ApiClient network = NetworkProvider.of(context);
    if (network != _network) {
      _network = network;
    }
    final CrossAccountNavigator navigator = CrossAccountNavigation.of(context);
    if (navigator != _navigator) {
      if (_navigationSubscription != null) {
        _navigationSubscription.cancel();
      }
      _navigator = navigator;
      _navigationSubscription = _navigator.listen(_config.services.domain,
          _network.account.accountId, onNavigationRequest);
    }
  }

  @override
  void dispose() {
    if (_navigationSubscription != null) {
      _navigationSubscription.cancel();
      _navigationSubscription = null;
    }
    super.dispose();
  }

  void _initBuilders() {
    // TODO: Just provide the build function directly to the dashboard
    // Then make sure the dashboard wraps them inside a Builder to make sure they're not in the tree when inactive

    proposalsDirect = Builder(
      builder: (BuildContext context) {
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                (proposal.senderAccountId != proposal.influencerAccountId) &&
                (proposal.state == ProposalState.negotiating ||
                    proposal.state == ProposalState.proposing));
      },
    );

    proposalsApplied = Builder(
      builder: (BuildContext context) {
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                (proposal.senderAccountId == proposal.influencerAccountId) &&
                (proposal.state == ProposalState.negotiating ||
                    proposal.state == ProposalState.proposing));
      },
    );

    proposalsDeal = Builder(
      builder: (BuildContext context) {
        final ApiClient network = NetworkProvider.of(context);
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                !(proposal.state == ProposalState.negotiating ||
                    proposal.state == ProposalState.proposing) &&
                !(network.account.accountType == AccountType.influencer
                    ? proposal.influencerArchived
                    : proposal.businessArchived));
      },
    );

    proposalsHistory = Builder(
      builder: (BuildContext context) {
        final ApiClient network = NetworkProvider.of(context);
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                network.account.accountType == AccountType.influencer
                    ? proposal.influencerArchived
                    : proposal.businessArchived);
      },
    );
  }

  Widget _buildProposalList(
      BuildContext context, bool Function(DataProposal proposal) test) {
    final ApiClient network = NetworkProvider.of(context);
    return ProposalList(
      account: network.account,
      proposals: network.proposals.where(test),
      getProfileSummary: (BuildContext context, Int64 accountId) {
        final ApiClient network = NetworkProvider.of(context);
        return network.tryGetProfileSummary(accountId);
      },
      getOffer: (BuildContext context, Int64 offerId) {
        final ApiClient network = NetworkProvider.of(context);
        return network.tryGetOffer(offerId);
      },
      onProposalPressed: (Int64 proposalId) {
        navigateToProposal(proposalId);
      },
    );
  }

  void onNavigationRequest(NavigationTarget target, Int64 id) {
    switch (target) {
      case NavigationTarget.Offer:
        navigateToOffer(id);
        break;
      case NavigationTarget.Profile:
        navigateToPublicProfile(id);
        break;
      case NavigationTarget.Proposal:
        navigateToProposal(id);
        break;
    }
  }

  void navigateToOffer(Int64 offerId);

  void navigateToProfileView() {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      // ConfigData config = ConfigProvider.of(context);
      final ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return ProfileView(
        account: network.account,
        oauthProviders: ConfigProvider.of(context).oauthProviders,
        onEditPressed: navigateToProfileEdit,
      );
    }));
  }

  void navigateToProfileEdit() {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      // ConfigData config = ConfigProvider.of(context);
      final ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return ProfileEdit(
        account: network.account,
      );
    }));
  }

  void navigateToPublicProfile(Int64 accountId) {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      // Important: Cannot depend on any context outside Navigator.push and thus cannot use variables from State widget!
      // ConfigData config = ConfigProvider.of(context);
      final ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return ProfileView(
        account: network.tryGetProfileDetail(accountId),
        oauthProviders: ConfigProvider.of(context).oauthProviders,
      );
    }));
  }

  int proposalViewCount = 0;
  Int64 proposalViewOpen;
  void navigateToProposal(Int64 proposalId) {
    final ApiClient network = NetworkProvider.of(context);
    if (proposalViewOpen != null) {
      print('[INF] Pop previous proposal route');
      Navigator.popUntil(context, (Route<dynamic> route) {
        return route.settings.name
            .startsWith('/proposal/' + proposalViewOpen.toString());
      });
      if (proposalViewOpen == proposalId) {
        return;
      }
      Navigator.pop(context);
    }
    final int count = ++proposalViewCount;
    proposalViewOpen = proposalId;
    bool suppressed = false;
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/proposal/' + proposalId.toString()),
        builder: (BuildContext context) {
          // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
          // ConfigData config = ConfigProvider.of(context);
          final ApiClient network = NetworkProvider.of(context);
          // NavigatorState navigator = Navigator.of(context);
          if (!suppressed) {
            network.pushSuppressChatNotifications(proposalId);
            suppressed = true;
          }
          final DataProposal proposal = network.tryGetProposal(proposalId);
          final Iterable<DataProposalChat> chats =
              network.tryGetProposalChats(proposalId);
          final DataOffer offer = network.tryGetOffer(proposal.offerId);
          final DataAccount businessAccount =
              (proposal.businessAccountId == 0 &&
                      network.account.accountType == AccountType.business)
                  ? network.account
                  : network.tryGetProfileSummary(proposal.businessAccountId);
          final DataAccount influencerAccount =
              (proposal.influencerAccountId == 0 &&
                      network.account.accountType == AccountType.influencer)
                  ? network.account
                  : network.tryGetProfileSummary(proposal.influencerAccountId);
          // DataProposal proposal = network.tryGetProposal(proposalId);
          return HaggleView(
            account: network.account,
            businessAccount: businessAccount,
            influencerAccount: influencerAccount,
            proposal: proposal,
            offer: offer,
            chats: chats,
            onUploadImage: (File f) async {
              return await network
                  .uploadImage(const file.LocalFileSystem().file(f.path));
            },
            onPressedProfile: (DataAccount account) {
              navigateToPublicProfile(account.accountId);
            },
            onPressedOffer: (DataOffer offer) {
              navigateToOffer(offer.offerId);
            },
            onReport: (String message) async {
              await network.reportProposal(proposal.proposalId, message);
            },
            onSendPlain: (String text) {
              network.chatPlain(proposal.proposalId, text);
            },
            onSendHaggle: (String deliverables, String reward, String remarks) {
              network.chatHaggle(
                  proposal.proposalId, deliverables, reward, remarks);
            },
            onSendImageKey: (String imageKey) {
              network.chatImageKey(proposal.proposalId, imageKey);
            },
            onWantDeal: (DataProposalChat chat) async {
              await network.wantDeal(chat.proposalId, chat.chatId);
            },
          );
        },
      ),
    ).whenComplete(() {
      if (count == proposalViewCount) {
        proposalViewOpen = null;
      }
      if (suppressed) {
        network.popSuppressChatNotifications();
      }
    });
  }

  void navigateToDebugAccount() {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      // ConfigData config = ConfigProvider.of(context);
      final ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return DebugAccount(
        account: network.account,
      );
    }));
  }

  void navigateToHistory() {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      // TODO(kaetemi): History should show a tab for proposals, one for offers
      return Scaffold(
          appBar: AppBar(
            title: const Text('History'),
          ),
          bottomSheet: NetworkStatus.buildOptional(context),
          body: proposalsHistory);
    }));
  }

  void navigateToCreateOffer() {
    Navigator.push<void>(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      final ConfigData config = ConfigProvider.of(context);
      final ApiClient network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return OfferCreate(
        config: config,
        onUploadImage: (File f) async {
          return await network
              .uploadImage(const file.LocalFileSystem().file(f.path));
        },
        onCreateOffer: (NetCreateOffer createOffer) async {
          final dynamic progressDialog = showProgressDialog(
              context: this.context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator()),
                      Text('Creating offer...'),
                    ],
                  ),
                );
              });
          DataOffer offer;
          try {
            // Create the offer
            offer = await network.createOffer(createOffer);
          } catch (error, stackTrace) {
            print("[INF] Exception creating offer': $error\n$stackTrace");
          }
          closeProgressDialog(progressDialog);
          if (offer == null) {
            await showDialog<Null>(
              context: this.context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Create Offer Failed'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        const Text('An error has occured.'),
                        const Text('Please try again later.'),
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

  final MapController _mapController = MapController();
  bool _mapFilter = false;
  Int64 _mapHighlightOffer;

  Widget _exploreBuilder(BuildContext context) {
    final bool enoughSpaceForBottom =
        MediaQuery.of(context).size.height > 480.0;
    final ApiClient network = NetworkProvider.of(context);
    final ConfigData config = ConfigProvider.of(context);
    final List<Int64> showcaseOfferIds = enoughSpaceForBottom
        ? network.demoAllOffers
        : <Int64>[]; // TODO(kaetemi): Explore
    final Widget showcase = showcaseOfferIds.isNotEmpty
        ? OffersShowcase(
            getOffer: _getOfferSummary,
            offerIds: showcaseOfferIds,
            onOfferPressed: (DataOffer offer) {
              navigateToOffer(offer.offerId);
            },
            onOfferCenter: (DataOffer offer) {
              _mapController.move(
                  LatLng(offer.latitude, offer.longitude), _mapController.zoom);
              setState(() {
                _mapHighlightOffer = offer.offerId;
              });
            },
          )
        : null;
    final Widget map = OffersMap(
      filterState: _mapFilter,
      account: network.account,
      mapboxUrlTemplate: Theme.of(context).brightness == Brightness.dark
          ? config.services.mapboxUrlTemplateDark
          : config.services.mapboxUrlTemplateLight,
      mapboxToken: config.services.mapboxToken,
      onSearchPressed: () {
        // navigateToSearchOffers(null);
        network.refreshDemoAllOffers();
      },
      onFilterPressed: enoughSpaceForBottom
          ? () {
              setState(() {
                _mapFilter = !_mapFilter;
              });
            }
          : null,
      filterTooltip: 'Filter map offers by category',
      searchTooltip: 'Search for nearby offers',
      mapController: _mapController,
      bottomSpace: (showcase != null) ? 156.0 : 0.0, // + kBottomNavHeight
      offers: network.demoAllOffers,
      highlightOffer: _mapHighlightOffer,
      onOfferPressed: navigateToOffer,
      getOffer: _getOfferSummary,
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
  }

  Widget _exploreBuilderV4(BuildContext context) {
    final bool enoughSpaceForBottom =
        MediaQuery.of(context).size.height > 480.0;
    final ApiClient network = NetworkProvider.of(context);
    final ConfigData config = ConfigProvider.of(context);
    final List<Int64> showcaseOfferIds = enoughSpaceForBottom
        ? network.demoAllOffers
        : <Int64>[]; // TODO(kaetemi): Explore
    /*final Widget showcase = showcaseOfferIds.isNotEmpty
        ? OffersShowcase(
            getOffer: _getOfferSummary,
            offerIds: showcaseOfferIds,
            onOfferPressed: (DataOffer offer) {
              navigateToOffer(offer.offerId);
            },
            onOfferCenter: (DataOffer offer) {
              _mapController.move(
                  LatLng(offer.latitude, offer.longitude), _mapController.zoom);
              setState(() {
                _mapHighlightOffer = offer.offerId;
              });
            },
          )
        : null;*/
    final Widget map = OffersMapOnly(
      account: network.account,
      mapboxUrlTemplate: Theme.of(context).brightness == Brightness.dark
          ? config.services.mapboxUrlTemplateDark
          : config.services.mapboxUrlTemplateLight,
      mapboxToken: config.services.mapboxToken,
      mapController: _mapController,
      bottomSpace:
          kBottomNavHeight, // (showcase != null) ? 156.0 : 0.0, // + kBottomNavHeight
      offers: network.demoAllOffers,
      highlightOffer: _mapHighlightOffer,
      onOfferPressed: navigateToOffer,
      getOffer: _getOfferSummary,
    );
    return MainBrowseSection(
      map: map,
      featured: const SizedBox(),
      list: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavHeight),
        child: BrowseListView(
          config: config,
          getOffer: _getOfferSummary,
          offers: network.demoAllOffers,
          onOfferPressed: navigateToOffer,
        ),
      ),
    );
  }

  Widget _activitiesBuilderV4(BuildContext context) {
    final ApiClient network = NetworkProvider.of(context);
    // final ConfigData config = ConfigProvider.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: kBottomNavHeight),
      child: MainActivitiesSection(
        accountType: network.account.accountType,
        offersBuilder: _offersBuilder,
        directBuilder: _directBuilder,
        appliedBuilder: _appliedBuilder,
        dealsBuilder: _dealsBuilder,
      ),
    );
  }

  DataOffer _getOfferSummary(BuildContext context, Int64 offerId) {
    final ApiClient network = NetworkProvider.of(context);
    return network.tryGetOffer(offerId, detail: false);
  }

  Widget _offersBuilder(BuildContext context) {
    final ApiClient network = NetworkProvider.of(context);
    final ConfigData config = ConfigProvider.of(context);
    if (network.offers.isEmpty) {
      if (network.offersLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Nothing here',
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      );
    }
    return OfferList(
      config: config,
      offers: network.offers,
      onRefreshOffers: (network.connected == NetworkConnectionState.ready)
          ? network.refreshOffers
          : null,
      onOfferPressed: navigateToOffer,
      getOffer: _getOfferSummary,
    );
  }

  Widget _directBuilder(BuildContext context) {
    return proposalsDirect;
  }

  Widget _appliedBuilder(BuildContext context) {
    return proposalsApplied;
  }

  Widget _dealsBuilder(BuildContext context) {
    return proposalsDeal;
  }

  Widget _buildDrawer(BuildContext context) {
    final ApiClient network = NetworkProvider.of(context);
    final ConfigData config = ConfigProvider.of(context);
    if (prototypeDrawer) {
      return DashboardDrawer(
        account: network.account,
        onNavigateProfile: navigateToProfileView,
        onNavigateSwitchAccount: navigateToSwitchAccount,
        onNavigateHistory: navigateToHistory,
        onNavigateDebugAccount: navigateToDebugAccount,
      );
    }
    return Drawer(
      child: MainNavigationDrawer(
        config: config,
        account: network.account,
        onEditAccount: null,
        onEditSocialMedia: null,
        onLogOut: null,
        onNavigateProfile: navigateToProfileView,
        onNavigateSwitchAccount: navigateToSwitchAccount,
        onNavigateHistory: navigateToHistory,
        onNavigateDebugAccount: navigateToDebugAccount,
      ),
    );
  }

  Widget buildDashboard(BuildContext context) {
    final ApiClient network = NetworkProvider.of(context);
    assert(network != null);
    if (prototypeDashboard) {
      return DashboardV3(
        account: network.account,
        networkStatusBuilder: NetworkStatus.buildOptional,
        exploreBuilder: _exploreBuilder,
        offersBuilder: _offersBuilder,
        directBuilder: _directBuilder,
        appliedBuilder: _appliedBuilder,
        dealsBuilder: _dealsBuilder,
        drawer: _buildDrawer(context),
        onMakeAnOffer: navigateToCreateOffer,
      );
    }
    return MainPage(
      account: network.account,
      networkStatusBuilder: NetworkStatus.buildOptional,
      exploreBuilder: _exploreBuilderV4,
      activitiesBuilder: _activitiesBuilderV4,
      drawer: _buildDrawer(context),
      onMakeAnOffer: navigateToCreateOffer,
      // TODO(kaetemi): Set new search filter (network.setSearchFilter(...))
      // Explore state will be automatically updated in the background!
      onSearchPressed: network.refreshDemoAllOffers,
    );
  }
}

/* end of file */
