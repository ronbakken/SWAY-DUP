
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class NetWorkService
{
  /// TBD: What is the best was to define a Filter
  Observable<List<BusinessOffer>> getBusinessOffers(int userId,);

  Observable<List<Proposal>> getProposals(int userId, int offerId);
}