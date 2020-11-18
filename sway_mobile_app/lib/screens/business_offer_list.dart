/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/styling_constants.dart';

import 'package:inf_common/inf_common.dart';

class OfferList extends StatelessWidget {
  final List<Int64> offers;

  final Future<void> Function() onRefreshOffers;

  final Widget Function(BuildContext context, Int64 offerId) offerBuilder;

  const OfferList({
    Key key,
    this.offers,
    this.onRefreshOffers,
    @required this.offerBuilder,
  }) : super(key: key);

  Widget _tileBuilder(BuildContext context, int index) {
    final Int64 offerId = offers[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kInfPaddingHalf),
      child: offerBuilder(context, offerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // key: _refreshIndicatorKey,
      onRefresh: () async {
        if (onRefreshOffers == null) {
          await Future<void>.delayed(Duration(seconds: 2));
        } else {
          await onRefreshOffers();
        }
      },
      child: offers == null
          ? const Text('Please wait...')
          : offers.isEmpty
              ? const Text('No offers')
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: kInfPaddingHalf),
                  itemCount: offers.length,
                  itemBuilder: _tileBuilder,
                ),
    );
  }
}

/* end of file */
