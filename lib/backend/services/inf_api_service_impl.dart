
import 'package:inf/backend/services/inf_api_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class InfApiServiceImplementation implements InfApiService
{
  @override
  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter)
  {
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
  Future<Chat> getChat(int offerId) {
    // TODO: implement getChat
      throw Exception('Not implemented yet');
  }

  @override
  Future<void> markChatAsRead(Chat chat) {
    // TODO: implement markChatAsRead
      throw Exception('Not implemented yet');
  }

  @override
  Future<void> postChatEntry(Chat chat, ChatEntry entry) {
    // TODO: implement postChatEntry
      throw Exception('Not implemented yet');
  }

  @override
  Observable<WaitingChats> waitingChatUpdates() {
    // TODO: implement waitingChatUpdates
      throw Exception('Not implemented yet');
  }

  @override
  Future<void> addOfferFilter(OfferFilter filter) {
    // TODO: implement addOfferFilter
      throw Exception('Not implemented yet');
  }

  @override
  Future<void> clearAllOfferFilters(OfferFilter filter) {
    // TODO: implement clearAllOfferFilters
      throw Exception('Not implemented yet');
  }

  @override
  Future<void> clearOfferFilter(OfferFilter filter) {
    // TODO: implement clearOfferFilter
      throw Exception('Not implemented yet');
  }

  @override
  Observable<List<BusinessOffer>> getFilteredBusinessOffers() {
    // TODO: implement getFilteredBusinessOffers
      throw Exception('Not implemented yet');
  }

  @override
  Observable<int> getFilteredBusinessOffersCount() {
    // TODO: implement getFilteredBusinessOffersCount
      throw Exception('Not implemented yet');
  }

  @override
  Future<OfferFilter> getOfferFilter(OfferFilter filter) {
    // TODO: implement getOfferFilter
    throw Exception('Not implemented yet');
  }

  @override
  Future<void> markOfferAsRead(BusinessOffer offer) {
    // TODO: implement markOfferAsRead
      throw Exception('Not implemented yet');
  }
}