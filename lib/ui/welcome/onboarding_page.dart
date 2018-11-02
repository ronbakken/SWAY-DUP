import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {

  final List<Widget> pages;
  final String title;

  const OnboardingPage({Key key, this.pages, this.title}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Center(child: Text(widget.title),),
          Expanded(
            child: PageView(
              children: widget.pages
            ),
          ),
        ],
      ),
    );
  }
}