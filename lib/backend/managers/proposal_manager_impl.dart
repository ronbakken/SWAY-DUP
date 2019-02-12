import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/proposal_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class ProposalManagerImplementation implements ProposalManager {
  StreamSubscription proposalSubscription;

  ProposalManagerImplementation() {
    backend.get<InfApiClientsService>().connectionChanged.listen((connected) {
      if (connected) {
        proposalSubscription =
            backend.get<InfApiService>().getProposals(backend.get<UserManager>().currentUser.id).listen((proposals) {
              _appliedProposalSubject.add(proposals.where((p) => p.state == ProposalState.proposal).toList());
              _activeDealsSubject.add(proposals.where((p) => p.state == ProposalState.deal).toList());
              _doneProposalSubject.add(proposals.where((p) => p.state == ProposalState.done).toList());
            });
      }
      else
      {
        proposalSubscription?.cancel();
      }
    });
  }

  @override
  Stream<Chat> openChat(String proposalId) {}

  @override
  Observable<List<Proposal>> get appliedProposals => _appliedProposalSubject;
  final BehaviorSubject<List<Proposal>> _appliedProposalSubject = BehaviorSubject<List<Proposal>>();

  @override
  Observable<List<Proposal>> get activeDeals => _activeDealsSubject;
  final BehaviorSubject<List<Proposal>> _activeDealsSubject = BehaviorSubject<List<Proposal>>();
  @override
  Observable<List<Proposal>> get doneProposals => _doneProposalSubject;
  final BehaviorSubject<List<Proposal>> _doneProposalSubject = BehaviorSubject<List<Proposal>>();

  @override
  RxCommand<ChatPostData, void> postChatMessageCommand;

  @override
  RxCommand<String, void> markProposalAsSeenCommand;
  @override
  RxCommand<String, void> accepProposalCommand;
  @override
  RxCommand<String, void> rejectProposalCommand;
}
