import 'dart:io';

import 'package:inf/domain/domain.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class ChatPostData {
  final ChatEntryType type;
  final String text; // The written text
  final String attachmentUrl;
  final DealTerms newTerms;

  ChatPostData({
    this.type,
    this.text,
    this.attachmentUrl,
    this.newTerms,
  });
}

abstract class ProposalManager {
  Stream<Chat> openChat(String proposalId);

  Observable<List<Proposal>> appliedProposals;
  Observable<List<Proposal>> activeDeals;
  Observable<List<Proposal>> doneProposals;

  RxCommand<ChatPostData, void> postChatMessageCommand;

  RxCommand<String, void> markProposalAsSeenCommand;
  RxCommand<String, void> accepProposalCommand;
  RxCommand<String, void> rejectProposalCommand;
}
