import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/white_border_circle_avatar.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';

class ProposalDetailsPage extends StatefulWidget {
  final Proposal proposal;

  const ProposalDetailsPage({Key key, this.proposal}) : super(key: key);

  static Route<dynamic> route({Proposal proposal}) {
    return FadePageRoute(
      builder: (BuildContext context) => ProposalDetailsPage(
            proposal: proposal,
          ),
    );
  }

  @override
  _ProposalDetailsPageState createState() => _ProposalDetailsPageState();
}

class _ProposalDetailsPageState extends State<ProposalDetailsPage> {
  Proposal proposal;

  @override
  void initState() {
    proposal = widget.proposal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = backend<UserManager>().currentUser;
    String opositeAvatarUrl;
    String opositeName;
    if (currentUser.userType == UserType.business) {
      opositeAvatarUrl = proposal.influencerAvatarUrl;
      opositeName = proposal.influencerName;
    } else {
      opositeAvatarUrl = proposal.businessAvatarUrl;
      opositeName = proposal.businessName;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.blackTwo,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WhiteBorderCircleAvatar(
              radius: null,
              whiteThickness: 2,
              child: Image.network(opositeAvatarUrl),
            ),
            horizontalMargin8,
            Text(opositeName)
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // OfferShortSummaryTile(),
          const Spacer()
        ],
      ),
    );
  }
}
