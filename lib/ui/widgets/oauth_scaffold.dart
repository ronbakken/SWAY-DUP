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

Future<NetOAuthConnection> oauthConnect(
  BuildContext context, {
  ConfigOAuthProvider oauthProvider,
  Future<NetOAuthUrl> Function() onOAuthGetParams,
  Future<NetOAuthSecrets> Function() onOAuthGetSecrets,
  Future<NetOAuthConnection> Function(String callbackQuery)
      onOAuthCallbackResult,
}) async {
  bool connectionAttempted = false;
  NetOAuthConnection connection;
  if (!connectionAttempted &&
      oauthProvider.whitelistHosts.contains('facebook.com')) {
    // Attempt to use Facebook plugin
    // TODO
  }
  if (!connectionAttempted &&
      oauthProvider.whitelistHosts.contains('twitter.com')) {
    // Attempt to use Twitter plugin
    // TODO
  }
  if (!connectionAttempted) {
    // Attempt to use generic OAuth
    await Navigator.push(
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      new MaterialPageRoute(
        builder: (context) {
          return new OAuthScaffold(
            onOAuthGetParams: onOAuthGetParams,
            onOAuthCallbackResult: onOAuthCallbackResult,
            whitelistHosts: oauthProvider.whitelistHosts,
          );
        },
      ),
    );
  }
  return connection;
}

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
  _OAuthScaffoldState createState() => new _OAuthScaffoldState();
}

class _OAuthScaffoldState extends State<OAuthScaffold> {
  FocusScopeNode _focusScope;

  final _flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;

  bool _ready = false;
  String _authUrl;
  String _callbackUrl = "https://invalid.invalid";
  final Map<String, bool> _hostWhitelist = <String, bool>{};

  Future<Null> _authError() async {
    _focusScope.requestFocus(new FocusNode());
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Authorization Failed'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('An error has occured.'),
                new Text('Please try again later.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [new Text('Ok'.toUpperCase())],
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
    _startRequest().catchError((e) {
      print("OAuth Exception: $e");
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
    _focusScope.requestFocus(new FocusNode());
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
      return new Scaffold(
        appBar: widget.appBar,
        body:
            new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            new CircularProgressIndicator(),
          ]),
        ]),
      );
    }
    return new WebviewScaffold(
      url: _authUrl,
      clearCookies: true, // We must clear cookies to allow multiple accounts
      appBar: widget.appBar != null
          ? widget.appBar
          : new AppBar(
              title: new Image(image: new AssetImage('assets/logo_appbar.png')),
              centerTitle: true,
            ),
    );
  }
}

/* end of file */
