/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Kenneth Amiel Santos <kennethamiel.santos@gmail.com>
*/

import 'package:flutter/material.dart';
import 'package:inf_common/inf_common.dart';

class SearchItemCard extends StatelessWidget {
  final DataAccount item;

  SearchItemCard({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new InkWell(
        onTap: () => print("tapped"),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              backgroundImage:
                  new NetworkImage(item.avatarUrl),
              radius: 30.0,
            ),
            new Container(
              width: 8.0,
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: 10.0,
                  ),
                  new Container(
                    decoration: new BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: new Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(item.accountType.toString(),
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                    ),
                  ),
                  new Container(
                    height: 4.0,
                  ),
                  new Text(
                    item.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  new Container(
                    height: 4.0,
                  ),
                  new Text(item.location),
                  new Container(
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
