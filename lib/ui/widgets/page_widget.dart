import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class PageWidget extends StatefulWidget {
  const PageWidget({Key key}) : super(key: key);

  @override
  PageState createState();
}

abstract class PageState<T extends PageWidget> extends State<T> {
  ThemeData _themeData;

  ThemeData get theme => _themeData ??= Theme.of(context);
}
