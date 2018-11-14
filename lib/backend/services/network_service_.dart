
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class NetWorkService
{
  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter);
  Observable<int> getBusinessOffersCount(OfferFilter filter);
  Future<BusinessOffer> getOfferById(int offerId);


  Observable<WaitingChats> waitingChatUpdates();
  Future<Chat> getChat(int offerId);
  Future<void> markChatAsRead(Chat chat);
  Future<void> postChatEntry(Chat chat, ChatEntry entry);




  Observable<List<Proposal>> getProposals(ProposalFilter filter);

  Future<Proposal> getProposalById(int proposalId);

}