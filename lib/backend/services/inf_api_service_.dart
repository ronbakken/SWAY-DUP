
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class InfApiService
{
  //Obervables must me backed by a BehaviourSubject

  Future<BusinessOffer> getOfferById(int offerId);
  
  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter);
  Observable<List<BusinessOffer>> getFilteredBusinessOffers();

  Future<void> addOfferFilter(OfferFilter filter);
  Future<void> clearOfferFilter(OfferFilter filter);
  Future<OfferFilter> getOfferFilter(OfferFilter filter);

  Future<void> clearAllOfferFilters(OfferFilter filter);
  

  Observable<int> getFilteredBusinessOffersCount();
  


  Observable<WaitingChats> waitingChatUpdates();
  Future<Chat> getChat(int offerId);
  Future<void> markChatAsRead(Chat chat);
  Future<void> postChatEntry(Chat chat, ChatEntry entry);




  // Observable<List<Proposal>> getProposals(ProposalFilter filter);

  // Future<Proposal> getProposalById(int proposalId);

}