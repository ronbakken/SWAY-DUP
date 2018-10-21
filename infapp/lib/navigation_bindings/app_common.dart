/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_mobile/network_manager.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/screens/haggle_view.dart';
import 'package:inf/screens/profile_view.dart';

abstract class AppCommonState<T extends StatefulWidget> extends State<T> {
  NetworkInterface _network;
  ConfigData _config;
  CrossAccountNavigator _navigator;
  StreamSubscription<NavigationRequest> _navigationSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _config = ConfigManager.of(context);
    NetworkInterface network = NetworkManager.of(context);
    if (network != _network) {
      _network = network;
    }
    CrossAccountNavigator navigator = CrossAccountNavigation.of(context);
    if (navigator != _navigator) {
      if (_navigationSubscription != null) {
        _navigationSubscription.cancel();
      }
      _navigator = navigator;
      _navigationSubscription = _navigator.listen(_config.services.domain,
          new Int64(_network.account.state.accountId), onNavigationRequest);
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
      // ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      // NavigatorState navigator = Navigator.of(context);
      return new ProfileView(account: network.tryGetProfileDetail(accountId));
    }));
  }

  int proposalViewCount = 0;
  Int64 proposalViewOpen;
  void navigateToProposal(Int64 proposalId) {
    NetworkInterface network = NetworkManager.of(context);
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
          // ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          // NavigatorState navigator = Navigator.of(context);
          if (!suppressed) {
            network.pushSuppressChatNotifications(proposalId);
            suppressed = true;
          }
          DataApplicant proposal = network.tryGetApplicant(proposalId);
          Iterable<DataApplicantChat> chats =
              network.tryGetApplicantChats(proposalId);
          DataBusinessOffer offer =
              network.tryGetOffer(new Int64(proposal.offerId));
          DataAccount businessAccount = (proposal.businessAccountId == 0 &&
                  network.account.state.accountType == AccountType.AT_BUSINESS)
              ? network.account
              : network
                  .tryGetProfileSummary(new Int64(proposal.businessAccountId));
          DataAccount influencerAccount = (proposal.influencerAccountId == 0 &&
                  network.account.state.accountType ==
                      AccountType.AT_INFLUENCER)
              ? network.account
              : network.tryGetProfileSummary(
                  new Int64(proposal.influencerAccountId));
          // DataApplicant proposal = network.tryGetApplicant(applicantId);
          return new HaggleView(
            account: network.account,
            businessAccount: businessAccount,
            influencerAccount: influencerAccount,
            applicant: proposal,
            offer: offer,
            chats: chats,
            onUploadImage: network.uploadImage,
            onPressedProfile: (DataAccount account) {
              navigateToPublicProfile(new Int64(account.state.accountId));
            },
            onPressedOffer: (DataBusinessOffer offer) {
              navigateToOffer(new Int64(offer.offerId));
            },
            onReport: (String message) async {
              await network.reportApplicant(proposal.applicantId, message);
            },
            onSendPlain: (String text) {
              network.chatPlain(proposal.applicantId, text);
            },
            onSendHaggle: (String deliverables, String reward, String remarks) {
              network.chatHaggle(
                  proposal.applicantId, deliverables, reward, remarks);
            },
            onSendImageKey: (String imageKey) {
              network.chatImageKey(proposal.applicantId, imageKey);
            },
            onWantDeal: (DataApplicantChat chat) async {
              await network.wantDeal(chat.applicantId, chat.chatId.toInt());
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
}

/* end of file */
