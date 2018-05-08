import 'package:flutter/material.dart';

class OnboardingSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Image(
          image: new AssetImage('assets/logo_appbar.png')
        ),
        centerTitle: true,
      ),
      body: new Container(
        margin: new EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new Text(
              "Hi!",
              style: Theme.of(context).textTheme.display4,
            ),
            new Text(
              "How do you see yourself?",
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.center,
            ),
            new Column(
              children: [
                new Container(
                  margin: new EdgeInsets.all(8.0),
                  child: new RaisedButton(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text("I am an influencer".toUpperCase())
                      ]
                    ),
                    onPressed: () => {},
                  )
                ),
                new Container(
                  margin: new EdgeInsets.all(8.0),
                  child: new RaisedButton(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text("I am a business".toUpperCase())
                      ]
                    ),
                    onPressed: () => {},
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
