import 'package:inf/backend/services/inf_api_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class InfApiServiceImplementation implements InfApiService {
  @override
  Observable<List<BusinessOfferSummery>> getBusinessOffers(OfferFilter filter) {
    // TODO: implement getChat
    throw Exception('Not implemented yet');
  }

  @override
  // Observable<List<Proposal>> getProposals(ProposalFilter filter)
  // {
  //     throw Exception('Not implemented yet');
  // }
  // @override
  // Future<Proposal> getProposalById(int proposalId) {
  //     throw Exception('Not implemented yet');
  // }

  @override
  Future<BusinessOffer> getOfferById(int offerId) {
    // TODO: implement getChat
    throw Exception('Not implemented yet');
  }

  @override
  Future<void> markChatAsRead(Proposal proposal) {
    // TODO: implement markChatAsRead
    throw Exception('Not implemented yet');
  }

  @override
  Future<void> postChatEntry(Proposal proposal, ChatEntry entry) {
    // TODO: implement postChatEntry
    throw Exception('Not implemented yet');
  }

  @override
  Observable<WaitingChats> waitingChatUpdates() {
    // TODO: implement waitingChatUpdates
    throw Exception('Not implemented yet');
  }


  @override
  Observable<int> getFilteredBusinessOffersCount() {
    // TODO: implement getFilteredBusinessOffersCount
    throw Exception('Not implemented yet');
  }

 

  @override
  Observable<List<BusinessOffer>> getFeaturedBusinessOffers(double longitude, double latitude) {
    // TODO: implement getFeaturedBusinessOffers
    throw Exception('Not implemented yet');
  }

  @override
  Observable<List<BusinessOfferSummery>> getFilteredBusinessOffers() {
    // TODO: implement getFilteredBusinessOffers
    throw Exception('Not implemented yet');
  }

  @override
  Observable<List<MapMarker>> getMapMarkers() {
    // TODO: implement getMapMarkers
    throw Exception('Not implemented yet');
  }

  @override
  Observable<BusinessOffer> getOfferByIdCached(int offerId) {
    // TODO: implement getOfferByIdCached
    throw Exception('Not implemented yet');
  }

  @override
  void setMapBoundery(double topLeftLatitude, double topLeftLongitude, double bottomRightLatitude, double bottomRightLongitude, double zoomLevel) {
    // TODO: implement setMapBoundery
    throw Exception('Not implemented yet');
  }

  @override
  Future<void> setOfferFilter(OfferFilter filter) {
    // TODO: implement setOfferFilter
    throw Exception('Not implemented yet');
  }


}
