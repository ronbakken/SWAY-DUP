import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/attachments/attachment_widget.dart';
import 'package:inf/ui/messaging/chat_avatar.dart';
import 'package:inf/ui/widgets/inf_form_label.dart';
import 'package:inf/ui/widgets/inf_since_when.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key key,
    @required this.message,
    this.isLastMessage,
  }) : super(key: key);

  final MessageTextProvider message;

  final bool isLastMessage;

  static const boxCornerRadii = const Radius.circular(12.0);

  @override
  Widget build(BuildContext context) {
    final currentUser = backend<UserManager>().currentUser;
    final isCurrentUser = (currentUser.id == message.user.id);
    final dimMessage = false; //!isLastMessage && message.hasProposal; // FIXME: dimming old negotiations
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
                  child: Opacity(
                    opacity: dimMessage ? 0.25 : 1.0,
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
                      child: _buildMessageContent(context, message),
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

  Widget _buildMessageContent(BuildContext context, MessageTextProvider message) {
    if (message.attachments.isEmpty) {
      return Text(message.text);
    }
    print('Showing message: ${message.id}');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (message.text.isNotEmpty)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (message.hasProposal) const InfFormLabel('Message'),
              verticalMargin8,
              Text(message.text),
              verticalMargin8,
            ],
          ),
        for (final attachment in message.attachments) AttachmentWidget(attachment: attachment),
      ],
    );
  }
}
