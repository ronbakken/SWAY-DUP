/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/material.dart';
import 'package:sway_common/inf_common.dart';

class SearchItemCard extends StatelessWidget {
  final DataAccount item;

  SearchItemCard({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => print("tapped"),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(item.avatarUrl),
              radius: 30.0,
            ),
            Container(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(item.accountType.toString(),
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(item.location),
                  Container(
                    height: 10.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* end of file */
