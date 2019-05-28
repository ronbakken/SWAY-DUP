import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/messaging/attachments/image_attachment.dart';
import 'package:inf/ui/messaging/attachments/proposal_attachment.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class AttachmentWidget extends StatelessWidget {
  const AttachmentWidget({
    Key key,
    @required this.attachment,
  }) : super(key: key);

  final MessageAttachment attachment;

  @override
  Widget build(BuildContext context) {
    if (attachment.type == stringType<Proposal>()) {
      final proposal = Proposal.fromJson(attachment.object);
      return ProposalAttachment(
        newProposal: proposal,
        previousProposal: proposal,
      );
    } else if (attachment.type == stringType<ImageReference>()) {
      final imageRef = ImageReference.fromJson(attachment.object);
      return ImageAttachment(
        imageReference: imageRef,
      );
    }
    return emptyWidget;
  }
}
