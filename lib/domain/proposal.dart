

import 'package:inf/domain/domain.dart';

enum ProposalState {
  haggling,
  
  deal,
  rejected,
  
  complete,
  dispute,
  resolved
}

class Proposal {
  int id;
  int offerId;
  int influencerId; // Account which applied
  int businessId;
  UserType sentFrom; // Either influencer or business sent this
  
  /// Embedded data
  String influencerName;
  String businessName;
  String offerTitle;
  
  // datetime schedule etc
  
  /// Current chat ID with haggle buttons (deliverables / reward / remarks)
  int haggleChatId;
  bool influencerWantsDeal;
  bool businessWantsDeal;
  
  bool influencerMarkedDelivered;
  bool influencerMarkedRewarded;
  bool businessMarkedDelivered;
  bool businessMarkedRewarded;
  
  int influencerGaveRating;
  int businessGaveRating; // 1 to 5, 0 is no rating given (rating given implies complete)
  
  bool influencerDisputed;
  bool businessDisputed;
  
  ProposalState state;
  
}