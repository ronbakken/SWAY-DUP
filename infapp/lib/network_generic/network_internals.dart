/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:wstalk/wstalk.dart';

abstract class NetworkInternals {
  // Common
  TalkSocket get ts;

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
}

/* end of file */
