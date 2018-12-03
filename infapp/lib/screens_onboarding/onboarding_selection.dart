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
      new Container(
        margin: new EdgeInsets.all(8.0),
        child: new Text(
          "Hi!",
          style: Theme.of(context).textTheme.display4,
        ),
      ),
      new Container(
        margin: new EdgeInsets.all(8.0),
        child: new Text(
          "How do you see yourself?",
          style: Theme.of(context).textTheme.display1,
          textAlign: TextAlign.center,
        ),
      )
    ];
    return new Scaffold(
      appBar: new AppBar(
        title: new Image(image: new AssetImage('assets/logo_appbar.png')),
        centerTitle: true,
      ),
      bottomSheet: NetworkStatus.buildOptional(context),
      body: new Container(
        margin: new EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ((MediaQuery.of(context).size.height >
                    MediaQuery.of(context).size.width)
                ? new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: text,
                  )
                : new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: text,
                  )),
            new Column(
              children: [
                new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 8.0),
                    child: new RaisedButton(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("I am an influencer".toUpperCase())
                          ]),
                      onPressed: onInfluencer,
                    )),
                new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 8.0),
                    child: new RaisedButton(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Text("I need an influencer".toUpperCase())
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
