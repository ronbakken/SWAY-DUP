import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/main/offer_list_tile.dart';
import 'package:inf/ui/main/main_page.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/proposal_views/proposal_list_view.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/notification_marker.dart';
import 'package:inf/utils/stream_from_value_and_future.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

class MainActivitiesSection extends StatefulWidget {
  const MainActivitiesSection({
    Key key,
    this.padding = EdgeInsets.zero,
  })  : assert(padding != null),
        super(key: key);

  final EdgeInsets padding;

  @override
  _MainActivitiesSectionState createState() => _MainActivitiesSectionState();
}

class _MainActivitiesSectionState extends State<MainActivitiesSection> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  static const double kTabBarBottomPadding = 16;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.padding.top, bottom: widget.padding.bottom),
      child: Container(
        color: AppTheme.darkGrey,
        child: Column(
          children: [
            SizedBox(
              height: kMenuIconSize + kTabBarBottomPadding,
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: TabBar(
                  indicatorWeight: 4.0,
                  indicatorColor: AppTheme.tabIndicator,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  isScrollable: false,
                  controller: controller,
                  tabs: [
                    _TabBarItem(
                      text: 'OFFERS',
                      bottomPadding: kTabBarBottomPadding,
                    ),
                    _TabBarItem(
                      text: 'PROPOSED',
                      bottomPadding: kTabBarBottomPadding,
                    ),
                    _TabBarItem(
                      text: 'DEALS',
                      bottomPadding: kTabBarBottomPadding,
                    ),
                    _TabBarItem(
                      text: 'DONE',
                      bottomPadding: kTabBarBottomPadding,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: AppTheme.listViewAndMenuBackground,
                child: TabBarView(
                  controller: controller,
                  children: [
                    OfferSummeryListView(
                      name: 'offers-applied',
                    ),
                    ProposalListView(dataSource: backend.get<ProposalManager>().appliedProposals,),                    
                    ProposalListView(dataSource: backend.get<ProposalManager>().activeDeals,),                    
                    ProposalListView(dataSource: backend.get<ProposalManager>().doneProposals,),                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  const _TabBarItem({
    Key key,
    @required this.text,
    @required this.bottomPadding,
    @required this.notifications,
  }) : super(key: key);

  final double bottomPadding;
  final String text;
  final Stream<int> notifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text(text, style: const TextStyle(fontSize: 12),),
          ),
          notifications != null
              ? Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: StreamBuilder<int>(
                    initialData: 0,
                    stream: notifications,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData || snapshot.data == 0) {
                        return SizedBox();
                      }
                      return NotificationMarker();
                    },
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class OfferSummeryListView extends StatefulWidget {
  final String name;

  const OfferSummeryListView({
    @required this.name,
    Key key,
  }) : super(key: key);

  @override
  _OfferSummeryListViewState createState() => _OfferSummeryListViewState();
}

class _OfferSummeryListViewState extends State<OfferSummeryListView> {
  Stream<List<BusinessOffer>> dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = backend.get<OfferManager>().filteredOffers;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BusinessOffer>>(
        stream: dataSource,
        builder: (BuildContext context, AsyncSnapshot<List<BusinessOffer>> snapShot) {
          if (!snapShot.hasData) {
            // TODO
            return Center(child: Text('Here has to be an Error message'));
          }
          final offers = snapShot.data;
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16.0, 8, 16.0, 0.0),
            itemCount: offers.length,
            itemBuilder: (BuildContext context, int index) {
              final offer = offers[index];
              final tag = '${widget.name}-${offer.id}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: OfferListTile(
                  backGroundColor: AppTheme.listViewItemBackground,
                  offer: offer,
                  onPressed: () => _onShowDetails(context, offer, tag),
                  tag: tag,
                ),
              );
            },
          );
        });
  }

  void _onShowDetails(BuildContext context, BusinessOffer partialOffer, String tag) async {
    try {
      unawaited(
        Navigator.of(context).push(
          OfferDetailsPage.route(
            streamFromValueAndFuture<BusinessOffer>(
                partialOffer, backend.get<OfferManager>().getFullOffer(partialOffer.id)),
            tag,
          ),
        ),
      );
    } catch (ex) {
      // TODO should this be done centralized?
      await showMessageDialog(context, 'Connection Problem', 'Sorry we cannot retrievd the Offer you want to view');
    }
  }
}
