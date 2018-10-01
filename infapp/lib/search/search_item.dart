import 'package:flutter/material.dart';
import '../protobuf/inf_protobuf.dart';

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
                  new NetworkImage(item.summary.avatarThumbnailUrl),
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
                      child: new Text(item.state.accountType.toString(),
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                    ),
                  ),
                  new Container(
                    height: 4.0,
                  ),
                  new Text(
                    item.summary.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  new Container(
                    height: 4.0,
                  ),
                  new Text(item.summary.location),
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
