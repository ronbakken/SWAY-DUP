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

  final String title;
  final String description;
  final DateTime created;
  final DateTime startDate;
  final DateTime endDate;

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

  BusinessOffer({
    this.id,
    this.businessAccountId,
    this.businessName,
    this.businessDescription,
    this.businessAvatarThumbnailUrl,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
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
    this.influencerProposalId,
  });

  BusinessOffer copyWith({
    int id,
    int businessAccountId,
    String businessName,
    String businessDescription,
    String businessAvatarThumbnailUrl,
    bool isDirectOffer,
    String title,
    String description,
    DateTime created,
    DateTime startDate,
    DateTime endDate,
    int numberOffered,
    int numberRemaining,
    String thumbnailUrl,
    Uint8List thumbnailLowRes,
    List<Deliverable> deliverables,
    Reward reward,
    Location location,
    List<String> coverUrls,
    List<Uint8List> coverLowRes,
    List<Category> categories,
    BusinessOfferState state,
    BusinessOfferStateReason stateReason,
    int newChatMessages,
    int influencerProposalId,
  }) {
    return BusinessOffer(
      id: id ?? this.id,
      businessAccountId: businessAccountId ?? this.businessAccountId,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      businessAvatarThumbnailUrl: businessAvatarThumbnailUrl ?? this.businessAvatarThumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      created: created ?? this.created,
      isDirectOffer: isDirectOffer ?? this.isDirectOffer,
      newChatMessages: newChatMessages ?? this.newChatMessages,
      numberOffered: numberOffered ?? this.numberOffered,
      numberRemaining: numberRemaining ?? this.numberRemaining,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      thumbnailLowRes: thumbnailLowRes ?? this.thumbnailLowRes,
      deliverables: deliverables ?? this.deliverables,
      reward: reward ?? this.reward,
      location: location ?? this.location,
      coverUrls: coverUrls ?? this.coverUrls,
      coverLowRes: coverLowRes ?? this.coverLowRes,
      categories: categories ?? this.categories,
      state: state ?? this.state,
      stateReason: stateReason ?? this.stateReason,
      influencerProposalId: influencerProposalId ?? this.influencerProposalId,
    );
  }
}
