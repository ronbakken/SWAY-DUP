import 'dart:async';

import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class InfApiService {
  Future<BusinessOffer> getOfferById(String offerId);



  Observable<List<BusinessOffer>> getBusinessOffers(Filter filter);
  Observable<List<BusinessOffer>> getFilteredBusinessOffers();

  Observable<List<BusinessOffer>> getFeaturedBusinessOffers(
      double longitude, double latitude);

  Future<void> setOfferFilter(Filter filter);
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


  Observable<List<Proposal>> getProposals(String userId);

  // Future<Proposal> getProposalById(int proposalId);

}
