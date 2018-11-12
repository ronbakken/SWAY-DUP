import 'package:inf/domain/domain.dart';

enum ProposalState {
  proposed,
  haggling,
  deal,
  rejected,
  complete,
  dispute,
  resolved,
}

class Proposal {
  final int id;
  final int offerId;
  final int influencerId; // Account which applied
  final int businessId;
  final UserType sentFrom; // Either influencer or business sent this

  /// Embedded data
  final String influencerName;
  final String businessName;
  final String offerText;

  final DeliverableChannels channel;
  final DeliverableType deliverableType;

  // datetime schedule etc

  /// Current chat ID with haggle buttons (deliverables / reward / remarks)
  final int haggleChatId;
  final bool influencerWantsDeal;
  final bool businessWantsDeal;

  final bool influencerMarkedDelivered;
  final bool influencerMarkedRewarded;
  final bool businessMarkedDelivered;
  final bool businessMarkedRewarded;

  final int influencerGaveRating;
  final int businessGaveRating; // 1 to 5, 0 is no rating given (rating given implies complete)

  final bool influencerDisputed;
  final bool businessDisputed;

  final ProposalState state;

  Proposal({
    this.id,
    this.offerId,
    this.influencerId,
    this.businessId,
    this.sentFrom,
    this.influencerName,
    this.businessName,
    this.offerText,
    this.channel,
    this.deliverableType,
    this.haggleChatId,
    this.influencerWantsDeal,
    this.businessWantsDeal,
    this.influencerMarkedDelivered,
    this.influencerMarkedRewarded,
    this.businessMarkedDelivered,
    this.businessMarkedRewarded,
    this.influencerGaveRating,
    this.businessGaveRating,
    this.influencerDisputed,
    this.businessDisputed,
    this.state,
  });
}
