import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/proposal_views/proposal_details_page.dart';
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
    return Material(
      color: backGroundColor,
      elevation: 2.0,
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 104,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: InkResponse(
          onTap: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
      ),
    );
  }
}
