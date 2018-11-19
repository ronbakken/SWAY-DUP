import 'dart:typed_data';

import 'package:inf/domain/domain.dart';

enum BusinessOfferState {
  draft,
  open, // Open and awaiting new applicants
  closed, // Active but no longer accepting applicants
  archived
}

enum BusinessOfferStateReason {
  newOffer,
  userClosed, // You have closed this offer.
  tosViolation, // This offer violates the Terms of Service
  violation // This offer has been completed by all applicants
}

class BusinessOfferSummery {
  final int id;
  final int offerId;
  final String title;
  final String description;
  final String businessName;
  final String businessAvatarThumbnailUrl;
  final String thumbnailUrl;
  final Uint8List thumbnailLowRes;
  final bool isDirectOffer;
  final DeliverableType deliverableType;
  final List<DeliverableChannels> channels;
  final RewardType rewardType;

  BusinessOfferSummery( 
      {this.id,
      this.offerId,
      this.title,
      this.description,
      this.businessName,
      this.businessAvatarThumbnailUrl,
      this.thumbnailLowRes,
      this.thumbnailUrl,
      this.isDirectOffer,
      this.deliverableType,
      this.channels,
      this.rewardType});
}

class BusinessOffer {
  final int id;
  final int businessAccountId;
  final String businessName;
  final String businessDescription;
  final String businessAvatarThumbnailUrl;



  final bool isDirectOffer;

   String title;
  final String description;
  final DateTime created;
  final DateTime expiryDate;

  final int numberOffered;
  final int numberRemaining;

  final String thumbnailUrl;
  final Uint8List thumbnailLowRes;

  final List<Deliverable> deliverables;
  final Reward reward;

  final Location location;

  // Detail info
  final List<String> coverUrls;
  final List<Uint8List> coverLowRes;

  final List<Category> categories;

  // State
  final BusinessOfferState state;
  final BusinessOfferStateReason stateReason;

  // proposal
  // number of new messages in the chat since
  // the last time the chat was marked as read.
  final int newChatMessages;

  // For later: Info for business
  // final int proposalsCountNew;
  // final int proposalsCountAccepted;
  // final int proposalsCountCompleted;
  // final int proposalsCountRefused;

  // only returned when an influencer queries this offer
  // So the Offer View knows this offer has already been applied to
  final int influencerProposalId;

  BusinessOffer(
      {this.id,
      this.businessAccountId,
      this.businessName,
      this.businessDescription,
      this.businessAvatarThumbnailUrl,
      this.title,
      this.description,
      this.expiryDate,
      this.created,
      this.isDirectOffer,
      this.newChatMessages,
      this.numberOffered = 1,
      this.numberRemaining,
      this.thumbnailUrl,
      this.thumbnailLowRes,
      this.deliverables,
      this.reward,
      this.location,
      this.coverUrls,
      this.coverLowRes,
      this.categories,
      this.state,
      this.stateReason,
      this.influencerProposalId});
}
