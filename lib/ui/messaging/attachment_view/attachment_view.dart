import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/messaging/attachment_view/negotiating_proposal_attachment_view.dart';

class AttachmentView extends StatelessWidget {
  final MessageAttachment attachment;

  const AttachmentView(this.attachment);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement attachment pattern matcher. Something like:
    //  if (attachment is List<Proposal>) return NegotiatingProposalAttachmentView(previousProposal: attachment[0], newProposal: attachment[1],);

    return Text("Attachment: $attachment");
  }
}