import 'dart:typed_data';

import 'package:inf/domain_objects/category.dart';
import 'package:inf/domain_objects/deliverable.dart';
import 'package:inf/domain_objects/location.dart';
import 'package:inf/domain_objects/reward.dart';

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