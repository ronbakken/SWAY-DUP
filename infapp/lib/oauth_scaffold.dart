import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class OAuthScaffold extends StatefulWidget { // stateful widget is basically a widget with private data
  const OAuthScaffold({
    Key key,
    this.appBar,
    this.consumerKey = "dJBat7EvZlqUuC7qsl9Gi0Kk1",
    this.consumerSecret = "gwJSX2xyqOic8VLoPHu8zncfh1xogwWKBWrroVoNfwM4X70n0m",
  }) : super(key: key);

  final AppBar appBar;

  final String consumerKey; // = "dJBat7EvZlqUuC7qsl9Gi0Kk1";
  final String consumerSecret; // = "gwJSX2xyqOic8VLoPHu8zncfh1xogwWKBWrroVoNfwM4X70n0m";

  @override
  _OAuthScaffoldState createState() => new _OAuthScaffoldState();
}

class _OAuthScaffoldState extends State<OAuthScaffold> {

  final _flutterWebviewPlugin = new FlutterWebviewPlugin();

  bool _ready = false;
  String _url = "https://net.no-break.space/";

  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    _onUrlChanged = _flutterWebviewPlugin.onUrlChanged.listen(_urlChanged);
    _ready = true;
    // ...
  }

  @override
  void reassemble() { 
    super.reassemble();
    // ...
  }

  @override
  void dispose() {
    // ...
    _onUrlChanged.cancel();
    super.dispose();
  }

  void _urlChanged(String url) {
    if (mounted) {
      print(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return new Scaffold(
        appBar: widget.appBar,
      );
    }
    return new WebviewScaffold(
      url: _url,
      appBar: widget.appBar,
    );
  }
}

/* end of file */
