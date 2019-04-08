import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/proposal_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class ProposalManagerImplementation implements ProposalManager {
  StreamSubscription proposalSubscription;

  ProposalManagerImplementation() {
    /*
    backend<InfApiClientsService>().connectionChanged.listen((connected) {
      if (connected) {
        // FIXME: InfApiService
        proposalSubscription =
            backend<InfApiService>().getProposals(backend<UserManager>().currentUser.id).listen((proposals) {
          _appliedProposalSubject.add(
              proposals.where((p) => p.state == ProposalState.proposal || p.state == ProposalState.haggling).toList());
          _activeDealsSubject
              .add(proposals.where((p) => p.state == ProposalState.deal || p.state == ProposalState.dispute).toList());
          _doneProposalSubject.add(proposals.where((p) => p.state == ProposalState.done).toList());
        });
      } else {
        proposalSubscription?.cancel();
      }
    });
    */
  }

  @override
  Observable<List<Proposal>> get appliedProposals => _appliedProposalSubject;
  final BehaviorSubject<List<Proposal>> _appliedProposalSubject = BehaviorSubject<List<Proposal>>();

  @override
  Observable<List<Proposal>> get activeDeals => _activeDealsSubject;
  final BehaviorSubject<List<Proposal>> _activeDealsSubject = BehaviorSubject<List<Proposal>>();

  @override
  Observable<List<Proposal>> get doneProposals => _doneProposalSubject;
  final BehaviorSubject<List<Proposal>> _doneProposalSubject = BehaviorSubject<List<Proposal>>();
}
