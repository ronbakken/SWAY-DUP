/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

/*

Utility to verify whether a widget is getting rebuilt or not.

*/

import 'package:flutter/widgets.dart';

class RebuildTracker extends StatelessWidget {
  final Widget child;
  final String message;

  const RebuildTracker({Key key, this.child, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("[RebuildTracker] $message");
    return child;
  }
}

/* end of file */
