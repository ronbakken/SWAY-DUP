import 'package:decimal/decimal.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/domain/deliverable.dart';
import 'package:inf/domain/reward.dart';

enum OfferFilterAspect {
  offeringBusinessId,
  userApplyingId,
  state,
  channels,
  deliverable,
  reward,
  location
}

enum OfferFilterApect {offerrinBusinessId, userAppliyingId, state, channels, deliverable, reward, loction, date}

class OfferFilter
{
  // Defines which fields  of the filter should be applied/cleared
  List<OfferFilter> aspects;
  int userApplyingId;
  int offeringBusinessId;
  BusinessOfferState state;
  String freeText;
  List<DeliverableChannels> channel;
  List<DeliverableType> deliverableType;

  // if aspect 'reward' is included the next three can ne set
  List<RewardType> rewardType;
  Decimal rewardValueLowerLimit;
  Decimal rewardValueUpperLimit;

  // if aspect 'location' is included the next three will be set
  double latitude;
  double longitude;
  double radiusInMeters;

  DateTime created;
}

// class ProposalFilter
// {
//   ProposalState state;
//   int offerId;
//   int influencerId; // Account which applied
//   int businessId;
//   UserType sentFrom; // Either influencer or business sent this

//   DeliverableChannels channel;
//   DeliverableType deliverableType;

//   int haggleChatId;
//   bool influencerWantsDeal;
//   bool businessWantsDeal;

//   bool influencerMarkedDelivered;
//   bool influencerMarkedRewarded;
//   bool businessMarkedDelivered;
//   bool businessMarkedRewarded;

//   int influencerGaveRating;
//   int businessGaveRating; // 1 to 5, 0 is no rating given (rating given implies complete)

//   bool influencerDisputed;
//   bool businessDisputed;

//   String freeText;
// }
