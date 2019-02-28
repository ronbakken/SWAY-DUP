import 'package:decimal/decimal.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';

class Filter {
  final String offeringBusinessId;
  final OfferDto_Status state;
  final String freeText;
  final List<SocialNetworkProvider> channels;
  final List<DeliverableType> deliverableType;

  final List<RewardDto_Type> rewardType;
  final Money rewardValueLowerLimit;
  final Money rewardValueUpperLimit;

  final double latitude;
  final double longitude;
  final double radiusInMeters;

  final DateTime created;

  final UserType userType;

  Filter({
    this.offeringBusinessId,
    this.state,
    this.freeText,
    this.channels,
    this.deliverableType,
    this.rewardType,
    this.rewardValueLowerLimit,
    this.rewardValueUpperLimit,
    this.latitude,
    this.longitude,
    this.radiusInMeters,
    this.created,
    this.userType,
  });
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
