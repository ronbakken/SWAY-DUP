/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf/backend/services/network/network_generic/change.dart';
import 'package:inf/backend/services/network/network_generic/multi_account_store.dart';
import 'package:inf/backend/services/network/protobuf/inf_protobuf.dart';
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
  void hintProfileOffer(DataBusinessOffer offer);

  // Offers
  void cacheOffer(DataBusinessOffer offer);
  void resetOffersState();
  void onOfferChanged(ChangeAction action, Int64 id);
  void markOffersDirty();
  void markOfferDirty(Int64 offerId);
  void hintOfferProposal(DataApplicant proposal);

  // Offers Business
  void resetOffersBusinessState();
  void markOffersBusinessDirty();
  void dataBusinessOffer(TalkMessage message); // TODO: Remove this!!!
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
      DataApplicantChat
          chat); // Individual chat messages don't change (currently)
  void liveNewApplicant(TalkMessage message);
  void liveNewApplicantChat(TalkMessage message);
  void liveUpdateApplicant(TalkMessage message);
  void liveUpdateApplicantChat(TalkMessage message);
  void resubmitGhostChats();
  void hintProposalOffer(DataBusinessOffer offer);

  // Notifications
  void disposeNotifications();
  Future<void> initFirebaseNotifications();
}

/* end of file */
