import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf/utils/date_time_helpers.dart';

class ConversationListTile extends StatelessWidget {
  const ConversationListTile({
    Key key,
    @required this.conversationHolder,
    @required this.onPressed,
    this.tag,
  }) : super(key: key);

  final ConversationHolder conversationHolder;
  final VoidCallback onPressed;
  final String tag;

  @override
  Widget build(BuildContext context) {

    /*
    var currentUser = backend<UserManager>().currentUser;

    String avatarUrl;
    TextSpan fromTo;
    if (proposal.sentFrom == currentUser.userType) {
      if (currentUser.userType == UserType.business) {
        avatarUrl = proposal.influencerAvatarUrl;
        fromTo = TextSpan(text: 'proposal to ', children: [
          TextSpan(text: proposal.influencerName, style: const TextStyle(color: Colors.white)),
        ]);
      } else {
        avatarUrl = proposal.businessAvatarUrl;
        fromTo = TextSpan(text: 'proposal to ', children: [
          TextSpan(text: proposal.businessName, style: const TextStyle(color: Colors.white)),
        ]);
      }
    } else {
      if (currentUser.userType == UserType.business) {
        avatarUrl = proposal.influencerAvatarUrl;
        fromTo = TextSpan(text: 'proposal from ', children: [
          TextSpan(text: proposal.influencerName, style: const TextStyle(color: Colors.white)),
        ]);
      } else {
        avatarUrl = proposal.businessAvatarUrl;
        fromTo = TextSpan(text: 'proposal from ', children: [
          TextSpan(text: proposal.businessName, style: const TextStyle(color: Colors.white)),
        ]);
      }
    }
    */

    String proposalStateText = 'APPLIED';
    /*
    switch (proposal.state) {
      case ProposalState.proposal:
        proposalStateText = 'APPLIED';
        break;
      case ProposalState.haggling:
        proposalStateText = 'NEGOTIATION';
        break;
      case ProposalState.dispute:
        proposalStateText = 'DISPUTED';
        break;
      case ProposalState.deal:
        proposalStateText = 'DEAL';
        break;
      case ProposalState.done:
        proposalStateText = 'DONE';
        break;
      default:
        assert(false, ' Not yet supported proposalState ${proposal.state.toString()}');
    }
    */

    final message = conversationHolder.latestMessage;

    TextSpan middleText = TextSpan(
      style: const TextStyle(
        fontSize: 16.0,
        color: AppTheme.white50,
      ),
      children: [
        TextSpan(
          text: message.user.name,
          style: const TextStyle(color: Colors.white),
        ),
        const TextSpan(text: ' has sent you an offer '),
        TextSpan(
          text: conversationHolder.offer.title,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );

    return Material(
      color: AppTheme.listViewItemBackground,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 72.0,
                    child: Stack(
                      children: <Widget>[
                        WhiteBorderCircle(
                          radius: null,
                          child: InfImage.fromProvider(
                            message.user.avatarThumbnail,
                            fit: BoxFit.cover,
                          ),
                          whiteThickness: 2,
                        ),
                        Positioned(
                          bottom: 3.0,
                          right: 3.0,
                          child: Container(
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                side: BorderSide(color: AppTheme.blackTwo, width: 1.5),
                              ),
                              color: AppTheme.lightBlue,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: const InfIcon(AppIcons.message, size: 11.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalMargin8,
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text.rich(middleText),
                        verticalMargin4,
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              decoration: const ShapeDecoration(
                                color: AppTheme.menuUserNameBackground,
                                shape: StadiumBorder(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 4.0),
                                child: Text(
                                  proposalStateText,
                                  style: const TextStyle(fontSize: 12.0),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            horizontalMargin8,
                            Expanded(
                              child: Text(
                                sinceWhen(message.timestamp),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: AppTheme.white50,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  horizontalMargin8,
                  SizedBox(
                    height: 72.0,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: InfImage.fromProvider(
                            conversationHolder.offer.thumbnailImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Text(
                  '"${message.text}"',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
