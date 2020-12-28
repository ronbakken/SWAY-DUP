import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:sway_mobile_app/app/theme.dart';
import 'package:sway_mobile_app/ui/main/offer_list_tile.dart';
import 'package:sway_mobile_app/ui/main/main_page.dart';
import 'package:sway_mobile_app/ui/offer_views/offer_details_page.dart';
import 'package:sway_mobile_app/ui/widgets/notification_marker.dart';
import 'package:inf_common/inf_common.dart';

class ActivitiesOffers extends StatefulWidget {
  final String name;
  final List<Int64> offers;
  final Widget Function(BuildContext cibtext, Int64 offerId) offerBuilder;

  const ActivitiesOffers({
    @required this.name,
    Key key,
    @required this.offers,
    @required this.offerBuilder,
  }) : super(key: key);

  @override
  _ActivitiesOffersState createState() => _ActivitiesOffersState();
}

class _ActivitiesOffersState extends State<ActivitiesOffers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _tileBuilder(BuildContext context, int index) {
    final Int64 offerId = widget.offers[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: widget.offerBuilder(context, offerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.0, 8, 16.0, 0.0),
      itemCount: widget.offers.length,
      itemBuilder: _tileBuilder,
    );
  }
}
