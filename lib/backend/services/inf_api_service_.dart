import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class InfApiService {
  Future<BusinessOffer> getOfferById(int offerId);
  Observable<BusinessOffer> getOfferByIdCached(int offerId);

  Observable<List<BusinessOfferSummery>> getBusinessOfferSummaries(OfferFilter filter);
  Observable<List<BusinessOfferSummery>> getFilteredBusinessOfferSummaries();

  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter);
  Observable<List<BusinessOffer>> getFilteredBusinessOffers();

  Observable<List<BusinessOffer>> getFeaturedBusinessOffers(
      double longitude, double latitude);

  Future<void> setOfferFilter(OfferFilter filter);
  Observable<int> getFilteredBusinessOffersCount();

  void setMapBoundary(
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
