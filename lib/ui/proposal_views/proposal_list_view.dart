import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/proposal_views/proposal_details_page.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:pedantic/pedantic.dart';

class ProposalListView extends StatefulWidget {
  final Stream<List<Proposal>> dataSource;

  const ProposalListView({
    @required this.dataSource,
    Key key,
  }) : super(key: key);

  @override
  _ProposalListViewState createState() => _ProposalListViewState();
}

class _ProposalListViewState extends State<ProposalListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Proposal>>(
        stream: widget.dataSource,
        builder: (BuildContext context, AsyncSnapshot<List<Proposal>> snapShot) {
          if (!snapShot.hasData) {
            // TODO
            return Center(child: Text('Here has to be an Error message'));
          }
          final proposals = snapShot.data;
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16.0, 8, 16.0, 0.0),
            itemCount: proposals.length,
            itemBuilder: (BuildContext context, int index) {
              final proposal = proposals[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ProposalListTile(
                  backGroundColor: AppTheme.listViewItemBackground,
                  proposal: proposal,
                  onPressed: () => _onShowDetails(context, proposal),
                ),
              );
            },
          );
        });
  }

  void _onShowDetails(BuildContext context, Proposal proposal) async {
    unawaited(
      Navigator.of(context).push(ProposalDetailsPage.route(proposal: proposal)),
    );
  }
}

class ProposalListTile extends StatelessWidget {
  const ProposalListTile({
    Key key,
    @required this.proposal,
    @required this.onPressed,
    this.tag,
    this.backGroundColor = AppTheme.grey,
  }) : super(key: key);

  final Proposal proposal;
  final VoidCallback onPressed;
  final String tag;
  final Color backGroundColor;

  @override
  Widget build(BuildContext context) {
    String avatarUrl;
    var currentUser = backend.get<UserManager>().currentUser;

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

    String proposalStateText;
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

    TextSpan middleText = TextSpan(style: const TextStyle(fontSize: 16, color: AppTheme.white50), children: [
      fromTo,
      TextSpan(text: ' on '),
      TextSpan(text: proposal.offerTitle, style: const TextStyle(color: Colors.white))
    ]);

    return Material(
      color: backGroundColor,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 168,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: InkResponse(
          onTap: onPressed,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WhiteBorderCircleAvatar(
                      radius: null,
                      child: Image.network(avatarUrl),
                      whiteThickness: 2,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text.rich(middleText),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 90,
                              decoration: ShapeDecoration(
                                color: AppTheme.menuUserNameBackground,
                                shape: StadiumBorder(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  proposalStateText,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                    SizedBox(width: 8),
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            proposal.offerThumbnailUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: Text(
                  proposal.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
