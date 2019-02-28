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

  final CategorySet categorySet;

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
    this.categorySet,
  });

  Filter copyWith({
    String offeringBusinessId,
    OfferDto_Status state,
    String freeText,
    List<SocialNetworkProvider> channels,
    List<DeliverableType> deliverableType,
    List<RewardDto_Type> rewardType,
    Money rewardValueLowerLimit,
    Money rewardValueUpperLimit,
    double latitude,
    double longitude,
    double radiusInMeters,
    DateTime created,
    UserType userType,
    CategorySet categorySet,
  }) {
    return Filter(
      offeringBusinessId: offeringBusinessId ?? this.offeringBusinessId,
      state: state ?? this.state,
      freeText: freeText ?? this.freeText,
      channels: channels ?? this.channels,
      deliverableType: deliverableType ?? this.deliverableType,
      rewardType: rewardType ?? this.rewardType,
      rewardValueLowerLimit: rewardValueLowerLimit ?? this.rewardValueLowerLimit,
      rewardValueUpperLimit: rewardValueUpperLimit ?? this.rewardValueUpperLimit,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusInMeters: radiusInMeters ?? this.radiusInMeters,
      created: created ?? this.created,
      userType: userType ?? this.userType,
      categorySet: categorySet ?? this.categorySet,
    );
  }

  @override
  String toString() {
    return 'Filter{\n'
        '  offeringBusinessId: $offeringBusinessId, \n'
        '  state: $state, \n'
        '  freeText: $freeText, \n'
        '  channels: $channels, \n'
        '  deliverableType: $deliverableType, \n'
        '  rewardType: $rewardType, \n'
        '  rewardValueLowerLimit: $rewardValueLowerLimit, \n'
        '  rewardValueUpperLimit: $rewardValueUpperLimit, \n'
        '  latitude: $latitude, \n'
        '  longitude: $longitude, \n'
        '  radiusInMeters: $radiusInMeters, \n'
        '  created: $created, \n'
        '  userType: $userType \n'
        '  categorySet: $categorySet \n'
        '}\n';
  }
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
