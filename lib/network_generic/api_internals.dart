/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:grpc/grpc.dart' as grpc;

class ApiSessionToken {
  final grpc.ClientChannel channel;
  final String token;

  const ApiSessionToken(this.channel, this.token);
}

abstract class ApiInternals {
  // Common
  Logger get log;
  ConfigData get config;
  MultiAccountStore get multiAccountStore;
  Stream<ApiSessionToken> get sessionChanged;

  void accountInitBase();
  void accountInitReady();
  void onCommonChanged();
  void reassembleCommon();
  void disposeCommon();
  void dependencyChangedCommon();
  void processSwitchAccount(LocalAccountData localAccount);

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

  // Demo
  void resetDemoAllOffersState();
  void markDemoAllOffersDirty();
  void onDemoAllOffersChanged();

  // Proposals
  int nextSessionGhostId;
  void resetProposalsState();
  void markProposalsDirty();
  void onProposalChanged(Int64 id);
  void onProposalsChanged();
  void onProposalChatsChanged(Int64 id);
  void onProposalChatNotification(DataProposalChat chat);
  /*
  Future<void> liveNewProposal(TalkMessage message);
  Future<void> liveNewProposalChat(TalkMessage message);
  Future<void> liveUpdateProposal(TalkMessage message);
  Future<void> liveUpdateProposalChat(TalkMessage message);
  */
  void resubmitGhostChats();
  void hintProposalOffer(DataOffer offer);

  // Notifications
  void disposeNotifications();
  Future<void> initFirebaseNotifications();
}

/* end of file */
