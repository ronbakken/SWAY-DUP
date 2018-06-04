import 'package:flutter/material.dart';
import 'follower_count.dart' show FollowerWidget;

class InfluencerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('INF'),
      ),
      body: new Row(
        children: <Widget>[
          new FollowerWidget(),
          new FollowerWidget(),
          new FollowerWidget(),
          new FollowerWidget(),
        ],
      ),
    );
  }
}

