/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';

typedef Future<NetOAuthUrl> OAuthGetParams();
typedef Future<bool> OAuthCallbackResult(String callbackQuery);

class OAuthScaffold extends StatefulWidget {
  // stateful widget is basically a widget with private data
  const OAuthScaffold({
    Key key,
    this.appBar,
    this.onOAuthGetParams,
    this.onOAuthCallbackResult,
    this.whitelistHosts,
  }) : super(key: key);

  final AppBar appBar;

  final Future<NetOAuthUrl> Function() onOAuthGetParams;
  final Future<NetOAuthConnection> Function(String callbackQuery)
      onOAuthCallbackResult;
  final List<String> whitelistHosts;

  @override
  _OAuthScaffoldState createState() => _OAuthScaffoldState();
}

class _OAuthScaffoldState extends State<OAuthScaffold> {
  FocusScopeNode _focusScope;

  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;

  bool _ready = false;
  String _authUrl;
  String _callbackUrl = "https://invalid.invalid";
  final Map<String, bool> _hostWhitelist = <String, bool>{};

  Future<Null> _authError() async {
    _focusScope.requestFocus(FocusNode());
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authorization Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('An error has occured.'),
                Text('Please try again later.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Ok'.toUpperCase())],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _startRequest() async {
    try {
      NetOAuthUrl params = await widget.onOAuthGetParams();
      if (!mounted) {
        return;
      }
      setState(() {
        _ready = true;
        _authUrl = params.authUrl;
        _callbackUrl = params.callbackUrl;
        _hostWhitelist[Uri.parse(_authUrl).host] = true;
        _hostWhitelist[Uri.parse(_callbackUrl).host] = true;
      });
      return;
    } catch (e) {
      print(e);
    }
    await _authError();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    for (String host in widget.whitelistHosts) {
      _hostWhitelist[host] = true;
    }
    _onUrlChanged = _flutterWebviewPlugin.onUrlChanged.listen(_urlChanged);
    _startRequest().catchError((Object error, StackTrace stackTrace) {
      Logger('Inf.OAuthScaffold').severe('OAuth Exception.', error, stackTrace);
    });
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    // WORKAROUND (kaetemi): When webview has keyboard focus, it is not released when closing the WebviewScaffold.
    _focusScope.requestFocus(FocusNode());
    _flutterWebviewPlugin.close();
    super.dispose();
  }

  Future<void> _urlChanged(String url) async {
    try {
      if (mounted) {
        Uri uri = Uri.parse(url);
        if (url.startsWith(_callbackUrl)) {
          NetOAuthConnection connection = widget.onOAuthCallbackResult != null
              ? await widget.onOAuthCallbackResult(uri.query)
              : null;
          if (connection != null && connection.socialMedia.connected) {
            print("Authorization success");
            Navigator.of(context).pop();
          } else {
            // Authorization canceled
            print("Authorization canceled: " + url);
            setState(() {
              _ready = false;
            });
            await _authError();
            Navigator.of(context).pop();
          }
        } else if (!_hostWhitelist.containsKey(uri.host)) {
          // Only allow API url.
          // Also allow T&C and Privacy Policy urls.
          print("Url not allowed: " + url);
          setState(() {
            _ready = false;
          });
          await _authError();
          Navigator.of(context).pop();
        }
      }
      return;
    } catch (e) {
      print(e);
    }
    setState(() {
      _ready = false;
    });
    await _authError();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _focusScope = FocusScope.of(context);
    if (!_ready) {
      return Scaffold(
        appBar: widget.appBar,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(),
          ]),
        ]),
      );
    }
    return WebviewScaffold(
      url: _authUrl,
      clearCookies: true, // We must clear cookies to allow multiple accounts
      appBar: widget.appBar != null
          ? widget.appBar
          : AppBar(
              title: Image(image: AssetImage('assets/logo_appbar.png')),
              centerTitle: true,
            ),
    );
  }
}

/* end of file */
