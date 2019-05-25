import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/attachment_view/negotiating_proposal_attachment_view.dart';
import 'package:inf/ui/messaging/chat_avatar.dart';
import 'package:inf/ui/widgets/inf_since_when.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

Proposal p1 = (ProposalBuilder()
      ..deliverableDescription = "This text and moneywill change."
      ..cashRewardValue = Money.fromInt(150)
      ..serviceDescription = "This text and money stays the same."
      ..serviceValue = Money.fromInt(50))
    .build();
Proposal p2 = p1.copyWith(
  deliverableDescription: "This text has changed.",
  cashRewardValue: Money.fromInt(200),
);

class MessageTile extends StatelessWidget {
  final MessageTextProvider message;

  static const boxCornerRadii = const Radius.circular(12.0);

  const MessageTile({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = backend<UserManager>().currentUser;
    final isCurrentUser = (currentUser.id == message.user.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (!isCurrentUser) ChatAvatar(user: message.user),
              Expanded(
                child: Align(
                  alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: isCurrentUser ? 0.0 : 12.0,
                      right: isCurrentUser ? 12.0 : 0.0,
                      bottom: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: boxCornerRadii,
                        topRight: boxCornerRadii,
                        bottomLeft: (isCurrentUser) ? boxCornerRadii : Radius.zero,
                        bottomRight: (!isCurrentUser) ? boxCornerRadii : Radius.zero,
                      ),
                      color: AppTheme.charcoalGrey,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: 
                    // TODO: Edit so that this stuff is only displayed when there are attachments. If not, display regular message.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _HeaderText("Message"),
                        verticalMargin8,
                        Text(message.text),
                        verticalMargin8,
                        _Line(), // TODO: Reuse this. Dunno where to put it.
                        NegotiatingProposalAttachmentView(
                          previousProposal: p1,
                          newProposal: p2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isCurrentUser) ChatAvatar(user: message.user),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 2.0,
              left: isCurrentUser ? 0.0 : 54.0,
              right: isCurrentUser ? 54.0 : 0.0,
            ),
            child: InfSinceWhen(
              message.timestamp,
              textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String data;

  _HeaderText(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(data.toUpperCase(), style: AppTheme.formFieldLabelStyle);
  }
}

class _Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider(color: Colors.white.withAlpha(128)),
    );
  }
}
