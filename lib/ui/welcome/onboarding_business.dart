  import 'package:flutter/material.dart';

List<Widget> buildBusinessPages(BuildContext context) {
    Widget page1(BuildContext context) {
      return Center(child: Text('Page1'));
    }

    Widget page2(BuildContext context) {
      return Center(child: Text('Page2'));
    }

    Widget page3(BuildContext context) {
      return Center(child: Text('Page3'));
    }

    return <Widget>[
      page1(context),
      page2(context),
      page3(context),
    ];
  }
