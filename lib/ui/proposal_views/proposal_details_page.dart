import 'package:flutter/material.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/routes.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
