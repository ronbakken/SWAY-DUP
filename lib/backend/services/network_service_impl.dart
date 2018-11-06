
import 'package:inf/backend/services/network_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class NetworkServiceImplementation implements NetWorkService
{
  /// TBD: What is the best was to define a Filter
  @override
  Observable<List<BusinessOffer>> getBusinessOffers({int userId,})
  {
      throw new Exception('Not implemented yet');
  }

  @override
  Observable<List<Proposal>> getProposals(int userId, int offerId)
  {
      throw new Exception('Not implemented yet');
  }
}