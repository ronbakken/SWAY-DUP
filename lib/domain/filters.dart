import 'package:decimal/decimal.dart';
import 'package:inf/domain/business_offer.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/reward.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';


class Filter {
  int offeringBusinessId;
  OfferDto_Status state;
  String freeText;
  List<SocialNetworkProvider> channels;
  List<DeliverableType> deliverableType;

  List<RewardDto_Type> rewardType;
  Decimal rewardValueLowerLimit;
  Decimal rewardValueUpperLimit;

  double latitude;
  double longitude;
  double radiusInMeters;

  DateTime created;

  UserType userType;
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
