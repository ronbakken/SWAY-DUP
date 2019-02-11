import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';


enum ProposalState  {receivedFirstMessage, haggling, rejected, deal }

class Proposal {
  final String id;
  final int offerId;
  final String influencerId; // Account which applied
  final String businessId;
  final UserType sentFrom; // Either influencer or business sent this

  final DateTime lastTimeSeen;
  // Changes to the chat has to update this field too
  final DateTime lastTimeUpdated;

  /// Embedded data
  final String influencerName;
  final String businessName;
  final String influencerAvatarUrl;
  final String businessAvatarUrl;
  final String offerText;
  final Location loaction;

  final DealTerms latestTerms;

  final String chatId;

  final bool influencerWantsDeal;
  final bool businessWantsDeal;

  final bool influencerRejected;
  final bool businessRejected;

  final bool influencerMarkedDelivered;
  final bool influencerMarkedRewarded;
  final bool businessMarkedDelivered;
  final bool businessMarkedRewarded;

  final int influencerGaveRating;
  final int businessGaveRating; // 1 to 5, 0 is no rating given (rating given implies complete)

  final bool influencerDisputed;
  final bool businessDisputed;

  Proposal( {
    this.id,
    this.lastTimeSeen, 
    this.lastTimeUpdated,    
    this.offerId,
    this.influencerId,
    this.businessId,
    this.sentFrom,
    this.influencerName,
    this.businessName,
    this.influencerAvatarUrl,
    this.businessAvatarUrl,
    this.loaction,
    this.latestTerms,
    this.chatId,
    this.offerText,
    this.influencerWantsDeal,
    this.businessWantsDeal,
    this.influencerRejected, 
    this.businessRejected,     
    this.influencerMarkedDelivered,
    this.influencerMarkedRewarded,
    this.businessMarkedDelivered,
    this.businessMarkedRewarded,
    this.influencerGaveRating,
    this.businessGaveRating,
    this.influencerDisputed,
    this.businessDisputed,
  });

  Proposal copyWith({
    String id,
    int offerId,
    DateTime lastTimeSeen,
    DateTime lastTimeUpdated,
    String influencerId,
    String businessId,
    UserType sentFrom,
    String influencerName,
    String businessName,
    String influencerAvatarUrl,
    String businessAvatarUrl,
    String offerText,
    Location loaction,
    DealTerms latestTerms,
    bool influencerWantsDeal,
    bool businessWantsDeal,
    bool influencerMarkedDelivered,
    bool influencerMarkedRewarded,
    bool businessMarkedDelivered,
    bool businessMarkedRewarded,
    int influencerGaveRating,
    int businessGaveRating,
    bool influencerDisputed,
    bool businessDisputed,
  }) {
    return Proposal(
      id: id ?? this.id,
      lastTimeSeen: lastTimeSeen ?? this.lastTimeSeen, 
      lastTimeUpdated: lastTimeUpdated ?? this.lastTimeUpdated,    
      offerId: offerId ?? this.offerId,
      influencerId: influencerId ?? this.influencerId,
      businessId: businessId ?? this.businessId,
      sentFrom: sentFrom ?? this.sentFrom,
      influencerName: influencerName ?? this.influencerName,
      businessName: businessName ?? this.businessName,
      influencerAvatarUrl: influencerAvatarUrl ?? this.influencerAvatarUrl,
      businessAvatarUrl: businessAvatarUrl ?? this.businessAvatarUrl,
      loaction: loaction ?? this.loaction,
      latestTerms: latestTerms ?? this.latestTerms,
      offerText: offerText ?? this.offerText,
      influencerWantsDeal: influencerWantsDeal ?? this.influencerWantsDeal,
      // chatID cannot be changed
      chatId: this.chatId,
      businessWantsDeal: businessWantsDeal ?? this.businessWantsDeal,
      influencerMarkedDelivered: influencerMarkedDelivered ?? this.influencerMarkedDelivered,
      influencerMarkedRewarded: influencerMarkedRewarded ?? this.influencerMarkedRewarded,
      businessMarkedDelivered: businessMarkedDelivered ?? this.businessMarkedDelivered,
      businessMarkedRewarded: businessMarkedRewarded ?? this.businessMarkedRewarded,
      influencerGaveRating: influencerGaveRating ?? this.influencerGaveRating,
      businessGaveRating: businessGaveRating ?? this.businessGaveRating,
      influencerDisputed: influencerDisputed ?? this.influencerDisputed,
      businessDisputed: businessDisputed ?? this.businessDisputed,
    );
  }
}
