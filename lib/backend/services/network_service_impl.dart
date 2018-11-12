
import 'package:inf/backend/services/network_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class NetworkServiceImplementation implements NetWorkService
{
  /// TBD: What is the best was to define a Filter
  @override
  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter)
  {
      throw Exception('Not implemented yet');
  }

  @override
  Observable<List<Proposal>> getProposals(ProposalFilter filter)
  {
      throw Exception('Not implemented yet');
  }

  @override
  Future<BusinessOffer> getOfferById(int offerId) {
      throw Exception('Not implemented yet');
  }

  @override
  Future<Proposal> getProposalById(int proposalId) {
      throw Exception('Not implemented yet');
  }
}