import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class ProposalManager {
  Observable<List<Proposal>> get appliedProposals;

  Observable<List<Proposal>> get activeDeals;

  Observable<List<Proposal>> get doneProposals;
}
