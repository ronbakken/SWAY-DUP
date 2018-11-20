import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class InfApiService {
  Future<BusinessOffer> getOfferById(int offerId);
  Observable<BusinessOffer> getOfferByIdCached(int offerId);

  Observable<List<BusinessOfferSummery>> getBusinessOffers(OfferFilter filter);
  Observable<List<BusinessOfferSummery>> getFilteredBusinessOffers();

  Observable<List<BusinessOffer>> getFeaturedBusinessOffers(
      double longitude, double latitude);

  Future<void> setOfferFilter(OfferFilter filter);
  Observable<int> getFilteredBusinessOffersCount();

  void setMapBoundery(
    double topLeftLatitude,
    double topLeftLongitude,
    double bottomRightLatitude,
    double bottomRightLongitude,
    double zoomLevel,
  );
  Observable<List<MapMarker>> getMapMarkers();

  Observable<WaitingChats> waitingChatUpdates();

  Future<void> markChatAsRead(Proposal proposal);
  Future<void> postChatEntry(Proposal proposal, ChatEntry entry);

  // Observable<List<Proposal>> getProposals(ProposalFilter filter);

  // Future<Proposal> getProposalById(int proposalId);

}
