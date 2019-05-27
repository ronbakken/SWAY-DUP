import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/messaging/attachments/proposal_attachment.dart';

class AttachmentWidget extends StatelessWidget {
  const AttachmentWidget(this.attachment);

  final MessageAttachment attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.type == stringType<Proposal>()) {
      final proposal = Proposal.fromJson(attachment.object);
      return ProposalAttachment(newProposal: proposal, previousProposal: proposal);
    }
    return Text('Attachment: $attachment');
  }
}
