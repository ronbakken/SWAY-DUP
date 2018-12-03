/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:inf_common/inf_common.dart';

// TODO: This will have the infinite scroll mechanism (long term...)

class OfferList extends StatelessWidget {
  final List<DataOffer> businessOffers;

  final Future<void> Function() onRefreshOffers;
  final Function(DataOffer offer) onOfferPressed;

  const OfferList(
      {Key key, this.businessOffers, this.onRefreshOffers, this.onOfferPressed})
      : super(key: key);

  Widget buildTags(BuildContext context, DataOffer data) {
    List<Widget> tags = new List<Widget>();
    // Instead of showing 0 new proposals, show an informative message instead while still accepting new proposals!
    /*
    if (data.proposalsNew == 0 / * && data.proposalsAccepted == 0 * / &&
        data.state == OfferState.Bopen) {
      tags.add(new Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: new Text("awaiting proposals")));
    }
    if (data.proposalsNew != 0) {
      tags.add(new Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: new Text("new proposal${data.proposalsNew > 0 ? 's' : ''}"),
        backgroundColor: Colors.blueAccent.shade700,
        avatar: new CircleAvatar(
          child: new Text("${data.proposalsNew}"),
        ),
      ));
    }
    if (data.proposalsAccepted != 0) {
      tags.add(new Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: new Text("accepted"),
        backgroundColor: Theme.of(context).primaryColor,
        avatar: new CircleAvatar(
          child: new Text("${data.proposalsAccepted}"),
        ),
      ));
    }
    if (data.proposalsCompleted != 0) {
      tags.add(new Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: new Text("completed"),
        backgroundColor: Colors.greenAccent.shade700,
        avatar: new CircleAvatar(
          child: new Text("${data.proposalsCompleted}"),
        ),
      ));
    }
    if (data.proposalsRefused != 0) {
      tags.add(new Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: new Text("rejected"),
        backgroundColor: Colors.redAccent,
        avatar: new CircleAvatar(
          child: new Text("${data.proposalsRefused}"),
        ),
      ));
    }
    */
    return new Container(
      //margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: new Wrap(
        spacing: 0.0,
        children: tags.map((widget) {
          return new Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0), child: widget);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ChipTheme(
      data: Theme.of(context).chipTheme.copyWith(

          // padding: EdgeInsets.all(0.0),
          // shape: new StadiumBorder(
          //),/*new Shapeborder(
          // side: const BorderSide(width: 0.66, style: BorderStyle.solid, color: Colors.grey),
          ///),*/
          ),
      child: new RefreshIndicator(
        // key: _refreshIndicatorKey,
        onRefresh: () async {
          if (onRefreshOffers == null) {
            await new Future.delayed(new Duration(seconds: 2));
          } else {
            await onRefreshOffers();
          }
        },
        child: businessOffers == null
            ? new Text("Please wait...")
            : businessOffers.length == 0
                ? new Text("No offers")
                : ListView.builder(
                    padding: kMaterialListPadding,
                    itemCount: businessOffers.length,
                    itemBuilder: (BuildContext context, int index) {
                      DataOffer data = businessOffers[index];
                      return new Column(children: [
                        new ListTile(
                          isThreeLine: true,
                          leading: new CircleAvatar(
                            backgroundImage: data.thumbnailUrl.length > 0
                                ? new NetworkImage(data.thumbnailUrl)
                                : null,
                            /* child: new Text('$index'), */
                            backgroundColor: Colors
                                .primaries[data.title.hashCode %
                                    Colors.primaries.length]
                                .shade300,
                          ),
                          title: new Container(
                            //margin: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                            child: new Text(data.title),
                          ),
                          subtitle: buildTags(context, data),
                          onTap: onOfferPressed != null
                              ? () {
                                  onOfferPressed(data);
                                }
                              : null,
                        ),
                        new Divider(),
                      ]);
                    },
                  ),
      ),
    );
  }
}

/* end of file */
