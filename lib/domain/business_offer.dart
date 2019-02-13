import 'dart:typed_data';

import 'package:inf/domain/category.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';

enum BusinessOfferState {
  draft,
  open, // Open and awaiting new applicants
  closed, // Active but no longer accepting applicants
  archived
}

enum BusinessOfferStateReason {
  newOffer,
  userClosed, // Business has closed this offer.
  tosViolation, // This offer violates the Terms of Service
  completed // This offer has been completed by all applicants
}

enum AcceptancePolicy { manualReview, automaticAcceptMatching, allowNegotiation }

class BusinessOffer {
  final bool isPartial;
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
  final int minFolllowers;

  final int numberOffered;
  int  get numberRemaining => numberOffered - numberOfProposals;
  final bool unlimitedAvailable;

  final String thumbnailUrl;
  final Uint8List thumbnailLowRes;


  final DealTerms terms;
  final List<SocialNetworkProvider> channels;

  final Location location;

  // Detail info
  final List<String> imageUrls;
  final List<Uint8List> imagesLowRes;

  final List<Category> categories;

  // State
  final BusinessOfferState state;
  final BusinessOfferStateReason stateReason;

  // proposal
  int get numberOfProposals => userIdsThatHaveProposed.length;
  final List<String> userIdsThatHaveProposed;

  // For later: Info for business
  // final int proposalsCountNew;
  // final int proposalsCountAccepted;
  // final int proposalsCountCompleted;
  // final int proposalsCountRefused;

  final AcceptancePolicy acceptancePolicy;

  BusinessOffer(
      {this.id,
      this.isPartial = false,
      this.businessAccountId,
      this.businessName,
      this.businessDescription,
      this.businessAvatarThumbnailUrl,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.created,
      this.minFolllowers,
      this.isDirectOffer,
      this.numberOffered = 1,
      this.unlimitedAvailable,
      this.thumbnailUrl,
      this.thumbnailLowRes,
      this.channels,
      this.terms,
      this.location,
      this.imageUrls,
      this.imagesLowRes,
      this.categories,
      this.state,
      this.stateReason,
      this.userIdsThatHaveProposed,
      this.acceptancePolicy});

  // BusinessOffer copyWith({
  //   int id,
  //   bool isPartial,
  //   int businessAccountId,
  //   String businessName,
  //   String businessDescription,
  //   String businessAvatarThumbnailUrl,
  //   bool isDirectOffer,
  //   String title,
  //   String description,
  //   DateTime created,
  //   DateTime startDate,
  //   DateTime endDate,
  //   int minFollowers,
  //   int numberOffered,
  //   bool unlimitedAvailable,
  //   int numberRemaining,
  //   String thumbnailUrl,
  //   Uint8List thumbnailLowRes,
  //   DealTerms terms,
  //   Location location,
  //   List<String> imageUrls,
  //   List<Uint8List> imagesLowRes,
  //   List<Category> categories,
  //   BusinessOfferState state,
  //   BusinessOfferStateReason stateReason,
  //   int newChatMessages,
  //   int influencerProposalId,
  // }) {
  //   return BusinessOffer(
  //     id: id ?? this.id,
  //     isPartial: isPartial ?? this.isPartial,
  //     businessAccountId: businessAccountId ?? this.businessAccountId,
  //     businessName: businessName ?? this.businessName,
  //     businessDescription: businessDescription ?? this.businessDescription,
  //     businessAvatarThumbnailUrl: businessAvatarThumbnailUrl ?? this.businessAvatarThumbnailUrl,
  //     title: title ?? this.title,
  //     description: description ?? this.description,
  //     startDate: startDate ?? this.startDate,
  //     endDate: endDate ?? this.endDate,
  //     minFolllowers: minFollowers ?? this.minFolllowers,
  //     created: created ?? this.created,
  //     isDirectOffer: isDirectOffer ?? this.isDirectOffer,
  //     numberOffered: numberOffered ?? this.numberOffered,
    
  //     unlimitedAvailable: unlimitedAvailable ?? this.unlimitedAvailable,
  //     thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
  //     thumbnailLowRes: thumbnailLowRes ?? this.thumbnailLowRes,
  //     terms: terms ?? this.terms,
  //     location: location ?? this.location,
  //     imageUrls: imageUrls ??  this.imageUrls,
  //     imagesLowRes: imagesLowRes ?? this.imagesLowRes,
  //     categories: categories ?? this.categories,
  //     state: state ?? this.state,
  //     stateReason: stateReason ?? this.stateReason,
  //   );
  // }
}

