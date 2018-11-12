
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class NetWorkService
{
  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter);

  Future<BusinessOffer> getOfferById(int offerId);

  Observable<List<Proposal>> getProposals(ProposalFilter filter);

  Future<Proposal> getProposalById(int proposalId);

}