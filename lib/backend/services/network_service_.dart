
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class NetWorkService
{
  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter);

  Observable<List<Proposal>> getProposals(ProposalFilter filter);
}