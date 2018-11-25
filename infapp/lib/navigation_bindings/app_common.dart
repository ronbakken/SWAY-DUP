/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_inheritable/multi_account_selection.dart';
import 'package:inf/network_inheritable/config_provider.dart';
import 'package:inf/network_inheritable/network_provider.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/screens/account_switch.dart';
import 'package:inf/screens/debug_account.dart';
import 'package:inf/screens/haggle_view.dart';
import 'package:inf/screens/profile_view.dart';
import 'package:inf/screens/proposal_list.dart';

abstract class AppCommonState<T extends StatefulWidget> extends State<T> {
  NetworkInterface _network;
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
    NetworkInterface network = NetworkProvider.of(context);
    if (network != _network) {
      _network = network;
    }
    CrossAccountNavigator navigator = CrossAccountNavigation.of(context);
    if (navigator != _navigator) {
      if (_navigationSubscription != null) {
        _navigationSubscription.cancel();
      }
      _navigator = navigator;
      _navigationSubscription = _navigator.listen(_config.services.environment,
          _network.account.state.accountId, onNavigationRequest);
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
    proposalsDirect = new Builder(
      builder: (BuildContext context) {
        NetworkInterface network = NetworkProvider.of(context);
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                (proposal.senderAccountId != proposal.influencerAccountId) &&
                (proposal.state == ProposalState.negotiating));
      },
    );
    proposalsApplied = new Builder(
      builder: (context) {
        NetworkInterface network = NetworkProvider.of(context);
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                (proposal.senderAccountId == proposal.influencerAccountId) &&
                (proposal.state == ProposalState.negotiating));
      },
    );
    proposalsDeal = new Builder(
      builder: (context) {
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                (proposal.state == ProposalState.deal) ||
                (proposal.state == ProposalState.dispute));
      },
    );
    proposalsHistory = new Builder(
      builder: (context) {
        return _buildProposalList(
            context,
            (DataProposal proposal) =>
                (proposal.state == ProposalState.rejected) ||
                (proposal.state == ProposalState.complete) ||
                (proposal.state == ProposalState.resolved));
      },
    );
  }

  Widget _buildProposalList(
      BuildContext context, bool Function(DataProposal proposal) test) {
    NetworkInterface network = NetworkProvider.of(context);
    return new ProposalList(
      account: network.account,
      proposals: network.proposals.where(test),
      getProfileSummary: (BuildContext context, Int64 accountId) {
        NetworkInterface network = NetworkProvider.of(context);
        return network.tryGetProfileSummary(accountId);
      },
      getOffer: (BuildContext context, Int64 offerId) {
        NetworkInterface network = NetworkProvider.of(context);
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

  void navigateToPublicProfile(Int64 accountId) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on any context outside Navigator.push and thus cannot use variables from State widget!
      // ConfigData config = ConfigProvider.of(context);
      NetworkInterface network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return new ProfileView(account: network.tryGetProfileDetail(accountId));
    }));
  }

  int proposalViewCount = 0;
  Int64 proposalViewOpen;
  void navigateToProposal(Int64 proposalId) {
    NetworkInterface network = NetworkProvider.of(context);
    if (proposalViewOpen != null) {
      print("[INF] Pop previous proposal route");
      Navigator.popUntil(context, (Route<dynamic> route) {
        return route.settings.name
            .startsWith('/proposal/' + proposalViewOpen.toString());
      });
      if (proposalViewOpen == proposalId) {
        return;
      }
      Navigator.pop(context);
    }
    int count = ++proposalViewCount;
    proposalViewOpen = proposalId;
    bool suppressed = false;
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: new RouteSettings(name: '/proposal/' + proposalId.toString()),
        builder: (context) {
          // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
          // ConfigData config = ConfigProvider.of(context);
          NetworkInterface network = NetworkProvider.of(context);
          // NavigatorState navigator = Navigator.of(context);
          if (!suppressed) {
            network.pushSuppressChatNotifications(proposalId);
            suppressed = true;
          }
          DataProposal proposal = network.tryGetProposal(proposalId);
          Iterable<DataProposalChat> chats =
              network.tryGetProposalChats(proposalId);
          DataOffer offer = network.tryGetOffer(proposal.offerId);
          DataAccount businessAccount = (proposal.businessAccountId == 0 &&
                  network.account.state.accountType == AccountType.business)
              ? network.account
              : network.tryGetProfileSummary(proposal.businessAccountId);
          DataAccount influencerAccount = (proposal.influencerAccountId == 0 &&
                  network.account.state.accountType == AccountType.influencer)
              ? network.account
              : network.tryGetProfileSummary(proposal.influencerAccountId);
          // DataProposal proposal = network.tryGetProposal(proposalId);
          return new HaggleView(
            account: network.account,
            businessAccount: businessAccount,
            influencerAccount: influencerAccount,
            proposal: proposal,
            offer: offer,
            chats: chats,
            onUploadImage: network.uploadImage,
            onPressedProfile: (DataAccount account) {
              navigateToPublicProfile(account.state.accountId);
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

  void navigateToSwitchAccount() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      ConfigData config = ConfigProvider.of(context);
      // NetworkInterface network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      MultiAccountClient selection = MultiAccountSelection.of(context);
      return new AccountSwitch(
        environment: config.services.environment,
        accounts: selection.accounts,
        onAddAccount: () {
          selection.addAccount();
        },
        onSwitchAccount: (LocalAccountData localAccount) {
          selection.switchAccount(
              localAccount.environment, localAccount.accountId);
        },
      );
    }));
  }

  void navigateToDebugAccount() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      // ConfigData config = ConfigProvider.of(context);
      NetworkInterface network = NetworkProvider.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return new DebugAccount(
        account: network.account,
      );
    }));
  }
}

/* end of file */
