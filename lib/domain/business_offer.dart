import 'dart:typed_data';

import 'package:inf/domain/domain.dart';



enum BusinessOfferState {
  draft,
  open, // Open and awaiting new applicants
  active, // Active but no longer accepting applicants // (Will be renamed to CLOSED)
  closed // (Will be renamed to ARCHIVED)
}

enum BusinessOfferStateReason {
  newOffer,
  userClosed, // You have closed this offer.
  tosViolation, // This offer violates the Terms of Service
  violation // This offer has been completed by all applicants
}


class BusinessOffer {
  int offerId;
  int accountId;
  int locationId;

  /// if a user is not logged in the server will only return a limiuted nunber of offers
  /// if offers should not fully displayed this field is set to true
  bool displayLimited;
  
  String title;
  String description;
  DateTime expiryDate;
  
  String thumbnailUrl;
  Uint8List thumbnailLowRes;
  

  Deliverable deliverables;
  Reward reward;
  
  Location location;
  double latitude;
  double longitude;

  
  // Detail info
  List<String> coverUrls;
  List<Uint8List> coverLowRes;

  List<Category> categories;
  
  // State
  BusinessOfferState state;
  BusinessOfferStateReason stateReason;
  
  // Question: Should this be Lists?
  // Info for business
  int proposalsCountNew;
  int proposalsCountAccepted;
  int proposalsCountCompleted;
  int proposalsCountRefused;
  
  // only returned when an influencer queries this offer
  int influencerProposalId; // So the Offer View knows this offer has already been applied to
  
}