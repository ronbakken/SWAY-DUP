/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:sway_mobile_app/network_generic/multi_account_store.dart';
import 'package:sway_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;

class ApiSessionToken {
  final String endPoint;
  final grpc.ClientChannel channel;
  final String token;

  const ApiSessionToken(this.endPoint, this.channel, this.token);
}

abstract class ApiInternals {
  // Common
  Logger get log;
  ConfigData get config;
  MultiAccountStore get multiAccountStore;
  Stream<ApiSessionToken> get sessionChanged;

  void initAccount();
  void accountStartSession();
  void onCommonChanged();
  void accountReassemble();
  void disposeAccount();
  void accountDependencyChanged();
  void processSwitchAccount(LocalAccountData localAccount);
  void receivedAccountUpdate(DataAccount account, {DataAccount removeGhost});
  void markEverythingDirty();
  Future<void> refreshAccessToken();

  // Profiles
  void initProfiles();
  void disposeProfiles();
  void cacheProfile(DataAccount account);
  void resetProfilesState();
  void markProfilesDirty();
  void onProfileChanged(Int64 id);
  DataAccount emptyAccount();
  void hintProfileOffer(DataOffer offer);

  // Offer
  void initOffers();
  void disposeOffers();
  void cacheOffer(DataOffer offer, bool detail);
  void resetOffersState();
  void onOfferChanged(Int64 id);
  void markOffersDirty();
  void markOfferDirty(Int64 offerId);
  void hintOfferProposal(DataProposal proposal);
  void onOffersChanged();

  // Proposals
  void initProposals();
  void disposeProposals();
  int nextSessionGhostId;
  void resetProposalsState();
  void markProposalsDirty();
  void onProposalChanged(Int64 id);
  void onProposalsChanged();
  void onProposalChatsChanged(Int64 id);
  void onProposalChatNotification(DataProposalChat chat);
  void liveNewProposal(NetProposal push);
  void liveNewProposalChat(NetProposalChat push);
  void liveUpdateProposal(NetProposal push, {bool delta = false});
  void liveUpdateProposalChat(NetProposalChat push);
  Future<void> resubmitGhostChats();
  void hintProposalOffer(DataOffer offer);

  // Explore
  void initExplore();
  void disposeExplore();
  void resetExploreState();
  void markExploreDirty();
  void onDemoAllOffersChanged();

  // Push
  void initPush();
  Future<void> disposePush();

  // Notifications
  void disposeNotifications();
  Future<void> refreshFirebaseNotifications();
}

/* end of file */
