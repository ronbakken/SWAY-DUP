/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/multi_account_store.dart';
import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

abstract class NetworkInternals {
  // Common
  Logger get log;
  TalkSocket get ts;
  ConfigData get config;
  MultiAccountStore get multiAccountStore;
  void commonInitBase();
  void commonInitReady();
  void onCommonChanged();
  void reassembleCommon();
  void disposeCommon();
  void dependencyChangedCommon();
  void processSwitchAccount(LocalAccountData localAccount);

  // Profiles
  void cacheProfile(DataAccount account);
  void resetProfilesState();
  void markProfilesDirty();
  void onProfileChanged(ChangeAction action, Int64 id);
  DataAccount emptyAccount();
  void hintProfileOffer(DataOffer offer);

  // Offers
  void cacheOffer(DataOffer offer);
  void resetOffersState();
  void onOfferChanged(ChangeAction action, Int64 id);
  void markOffersDirty();
  void markOfferDirty(Int64 offerId);
  void hintOfferProposal(DataProposal proposal);

  // Offers Business
  void resetOffersBusinessState();
  void markOffersBusinessDirty();
  void dataOffer(TalkMessage message); // TODO: Remove this!!!
  void onOffersBusinessChanged(ChangeAction action, Int64 id);

  // Offers Demo
  void resetOffersDemoState();
  void markOffersDemoDirty();
  void onOffersDemoChanged(ChangeAction action, Int64 id);

  // Proposals
  int nextDeviceGhostId;
  void resetProposalsState();
  void markProposalsDirty();
  void onProposalChanged(ChangeAction action, Int64 id);
  void onProposalChatChanged(
      ChangeAction action,
      DataProposalChat
          chat); // Individual chat messages don't change (currently)
  void liveNewProposal(TalkMessage message);
  void liveNewProposalChat(TalkMessage message);
  void liveUpdateProposal(TalkMessage message);
  void liveUpdateProposalChat(TalkMessage message);
  void resubmitGhostChats();
  void hintProposalOffer(DataOffer offer);

  // Notifications
  void disposeNotifications();
  Future<void> initFirebaseNotifications();
}

/* end of file */
