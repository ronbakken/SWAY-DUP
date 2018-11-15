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

class BusinessOffer {
  final int offerId;
  final int businessAccountId;
  final String businessName;
  final String businessDescription;
  final String businessAvatarThumbnailUrl;

  /// if a user is not logged in the server will only return a limiuted nunber of offers
  /// if offers should not fully displayed this field is set to true
  bool displayLimited;

  final String title;
  final String description;
  final DateTime expiryDate;
  final int numberAvailable;

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

  // true if offer was marked seen
  final bool wasRead;

  // number of new messages in the chat since
  // the last time the chat was marked as read.
  final int newChatMessages;

  // Info for business
  final int proposalsCountNew;
  final int proposalsCountAccepted;
  final int proposalsCountCompleted;
  final int proposalsCountRefused;

  // only returned when an influencer queries this offer
  // So the Offer View knows this offer has already been applied to
  final int influencerProposalId;

  BusinessOffer(
      {this.offerId,
      this.businessAccountId,
      this.businessName,
      this.businessDescription,
      this.businessAvatarThumbnailUrl,
      this.displayLimited,
      this.title,
      this.description,
      this.expiryDate,
      this.wasRead,
      this.newChatMessages,
      this.numberAvailable = 1,
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
      this.proposalsCountNew,
      this.proposalsCountAccepted,
      this.proposalsCountCompleted,
      this.proposalsCountRefused,
      this.influencerProposalId});
}
