import 'package:flutter/material.dart';

import 'follower_count.dart';
import '../network/inf.pb.dart';


class FollowerTray extends StatelessWidget
{ 
  FollowerTray({
    Key key, 
    this.followerWidgets,
    }) :super (key: key);

  final List<FollowerWidget> followerWidgets;

  @override
  Widget build(BuildContext context){
    return new Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: followerWidgets,
		);
  }
}
