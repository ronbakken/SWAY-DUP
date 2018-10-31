import 'package:inf/domain_objects/enums.dart';

class BusinessOffer {
  int offerId;
  int accountId;
  int locationId;
  
  String title;
  String description;
  String thumbnailUrl;
  String blurredThumbnailUrl;
  
  /// Question: is a String enough here?
  String deliverables;
  String reward;
  
  // Embedded business location info
  String locationName; // Business or location name depending
  String location;
  double latitude;
  double longitude;
  // Question: What about unlimited offers?
  int locationOfferCount; // Number of offers at the same location
  
  // Detail info
  List<String> coverUrls;
  List<String> blurredCoverUrls;
  // JAN: ??
  //bytes categories;
  
  // State
  BusinessOfferState state;
  BusinessOfferStateReason stateReason;
  
  // Info for business
  int applicantsNew;
  int applicantsAccepted;
  int applicantsCompleted;
  int applicantsRefused;
  
  // Info for influencer
  // Jan: Shouldn't this be a List?
  int influencerApplicantId; // So the Offer View knows this offer has already been applied to
  
}