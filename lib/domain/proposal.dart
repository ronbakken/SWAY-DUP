import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';


enum ProposalState  {proposal, haggling, deal, dispute, done }

class Proposal {
  final String id;
  final ProposalState state;
  final int offerId;
  final String influencerId; // Account which applied
  final String businessId; // Account that created the proposal
  final UserType sentFrom; // Either influencer or business sent this

  final DateTime lastTimeSeen;
  // Changes to the chat has to update this field too
  final DateTime lastTimeUpdated;

  /// Embedded data
  final String influencerName;
  final String businessName;
  final String influencerAvatarUrl;
  final String businessAvatarUrl;
  final String offerThumbnailUrl;
  final String offerTitle;
  final Location location;
  final bool issuerAllowsNegotiation;
  
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

  Proposal({
    this.id,
    this.state,
    this.lastTimeSeen, 
    this.lastTimeUpdated,    
    this.offerId,
    this.influencerId,
    this.businessId,
    this.sentFrom,
    this.influencerName,
    this.businessName,
    this.issuerAllowsNegotiation,
    this.influencerAvatarUrl,
    this.businessAvatarUrl,
    this.offerThumbnailUrl,
    this.location,
    this.latestTerms,
    this.chatId,
    this.offerTitle,
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

  // Proposal copyWith({
  //   String id,
  //   int offerId,
  //   DateTime lastTimeSeen,
  //   DateTime lastTimeUpdated,
  //   String influencerId,
  //   String businessId,
  //   UserType sentFrom,
  //   String influencerName,
  //   String businessName,
  //   String influencerAvatarUrl,
  //   String issuerAvatarUrl,
  //   String offerText,
  //   Location loaction,
  //   DealTerms latestTerms,
  //   bool influencerWantsDeal,
  //   bool businessWantsDeal,
  //   bool influencerMarkedDelivered,
  //   bool influencerMarkedRewarded,
  //   bool businessMarkedDelivered,
  //   bool businessMarkedRewarded,
  //   int influencerGaveRating,
  //   int businessGaveRating,
  //   bool influencerDisputed,
  //   bool businessDisputed,
  // }) {
  //   return Proposal(
  //     id: id ?? this.id,
  //     lastTimeSeen: lastTimeSeen ?? this.lastTimeSeen, 
  //     lastTimeUpdated: lastTimeUpdated ?? this.lastTimeUpdated,    
  //     offerId: offerId ?? this.offerId,
  //     clientId: influencerId ?? this.clientId,
  //     issuerId: businessId ?? this.issuerId,
  //     sentFrom: sentFrom ?? this.sentFrom,
  //     clientName: influencerName ?? this.clientName,
  //     issuerName: businessName ?? this.issuerName,
  //     clientAvatarUrl: influencerAvatarUrl ?? this.clientAvatarUrl,
  //     issuerAvatarUrl: issuerAvatarUrl ?? this.issuerAvatarUrl,
  //     location: loaction ?? this.location,
  //     latestTerms: latestTerms ?? this.latestTerms,
  //     offerTitle: offerText ?? this.offerTitle,
  //     influencerWantsDeal: influencerWantsDeal ?? this.influencerWantsDeal,
  //     // chatID cannot be changed
  //     chatId: this.chatId,
  //     businessWantsDeal: businessWantsDeal ?? this.businessWantsDeal,
  //     influencerMarkedDelivered: influencerMarkedDelivered ?? this.influencerMarkedDelivered,
  //     influencerMarkedRewarded: influencerMarkedRewarded ?? this.influencerMarkedRewarded,
  //     businessMarkedDelivered: businessMarkedDelivered ?? this.businessMarkedDelivered,
  //     businessMarkedRewarded: businessMarkedRewarded ?? this.businessMarkedRewarded,
  //     influencerGaveRating: influencerGaveRating ?? this.influencerGaveRating,
  //     businessGaveRating: businessGaveRating ?? this.businessGaveRating,
  //     influencerDisputed: influencerDisputed ?? this.influencerDisputed,
  //     businessDisputed: businessDisputed ?? this.businessDisputed,
  //   );
  // }
}
