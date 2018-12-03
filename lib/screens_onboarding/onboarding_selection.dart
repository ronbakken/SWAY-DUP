/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:inf_app/widgets/network_status.dart';

class OnboardingSelection extends StatelessWidget {
  const OnboardingSelection({
    Key key,
    @required this.onInfluencer,
    @required this.onBusiness,
  }) : super(key: key);

  final Function() onInfluencer;
  final Function() onBusiness;

  @override
  Widget build(BuildContext context) {
    List<Widget> text = [
      Container(
        margin: EdgeInsets.all(8.0),
        child: Text(
          "Hi!",
          style: Theme.of(context).textTheme.display4,
        ),
      ),
      Container(
        margin: EdgeInsets.all(8.0),
        child: Text(
          "How do you see yourself?",
          style: Theme.of(context).textTheme.display1,
          textAlign: TextAlign.center,
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Image(image: AssetImage('assets/logo_appbar.png')),
        centerTitle: true,
      ),
      bottomSheet: NetworkStatus.buildOptional(context),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ((MediaQuery.of(context).size.height >
                    MediaQuery.of(context).size.width)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: text,
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: text,
                  )),
            Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("I am an influencer".toUpperCase())]),
                      onPressed: onInfluencer,
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("I need an influencer".toUpperCase())
                          ]),
                      onPressed: onBusiness,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* end of file */
