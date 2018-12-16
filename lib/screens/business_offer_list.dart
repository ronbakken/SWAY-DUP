/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/styling_constants.dart';
import 'package:inf/ui/main/offer_list_tile.dart';

import 'package:inf_common/inf_common.dart';

class OfferList extends StatelessWidget {
  final ConfigData config;
  final List<Int64> offers;

  final Future<void> Function() onRefreshOffers;
  final Function(Int64 offerId) onOfferPressed;

  final DataOffer Function(BuildContext context, Int64 offerId) getOffer;

  const OfferList({
    Key key,
    this.config,
    this.offers,
    this.onRefreshOffers,
    this.onOfferPressed,
    @required this.getOffer,
  }) : super(key: key);

  Widget _tileBuilder(BuildContext context, int index) {
    final Int64 offerId = offers[index];
    final DataOffer offer = getOffer(context, offerId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kInfPaddingHalf),
      child: OfferListTile(
        config: config,
        offer: offer,
        onPressed: onOfferPressed == null
            ? null
            : () {
                onOfferPressed(offerId);
              },
      ),
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
