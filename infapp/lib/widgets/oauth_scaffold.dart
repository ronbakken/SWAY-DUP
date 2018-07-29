import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../network/inf.pb.dart';

typedef Future<NetOAuthUrlRes> OAuthGetParams();
typedef Future<bool> OAuthCallbackResult(String callbackQuery);

class OAuthScaffold extends StatefulWidget { // stateful widget is basically a widget with private data
  const OAuthScaffold({
    Key key,
    this.appBar,
    this.onOAuthGetParams,
    this.onOAuthCallbackResult,
  }) : super(key: key);

  final AppBar appBar;

  final OAuthGetParams onOAuthGetParams;
  final OAuthCallbackResult onOAuthCallbackResult;

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
  Map<String, bool> _hostWhitelist = new Map<String, bool>();

  Future<Null> _authError() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                children: [
                  new Text('Ok')
                ],
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
      NetOAuthUrlRes params = await widget.onOAuthGetParams();
      if (!mounted) {
        return;
      }
      setState(() {
        _ready = true;
        _authUrl = params.authUrl; //widget.host + widget.authenticateUrl + "?oauth_token=" + Uri.encodeComponent(_temporaryToken);
        _callbackUrl = params.callbackUrl;
        _hostWhitelist[Uri.parse(_authUrl).host] = true;
        _hostWhitelist[Uri.parse(_callbackUrl).host] = true;
      });
      /*
      var platform = new oauth1.Platform(
        widget.host + widget.requestTokenUrl,
        widget.host + "/", // widget.authorizeUrl,
        widget.host + "/", // widget.accessTokenUrl,
        oauth1.SignatureMethods.HMAC_SHA1
      );
      var clientCredentials = new oauth1.ClientCredentials(
        widget.consumerKey, 
        widget.consumerSecret
      );
      var authorization = new oauth1.Authorization(
        clientCredentials,
        platform
      );
      print("Await temp cred to ${widget.callbackUrl}");
      // TODO: Can we do this server-side?
      var tokenRes = await authorization.requestTemporaryCredentials(widget.callbackUrl);
      // authorization.getResourceOwnerAuthorizationURI(temporaryCredentialsIdentifier)
      print("Got temp cred");
      if (!mounted) {
        return;
      }
      setState(() {
        _ready = true;
        _temporaryToken = tokenRes.credentials.token;
        _url =  widget.host + widget.authenticateUrl + "?oauth_token=" + Uri.encodeComponent(_temporaryToken);
      });
      */
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
    // WORKAROUND (kaetemi): When webview has keyboard focus, it is not released when closing the WebviewScaffold
    _focusScope.requestFocus(new FocusNode());
    _flutterWebviewPlugin.close();
    super.dispose();
  }

  _urlChanged(String url) async {
    if (mounted) {
      Uri uri = Uri.parse(url);
      if (url.startsWith(_callbackUrl)) {
        if (widget.onOAuthCallbackResult != null && await widget.onOAuthCallbackResult(uri.query)) { // uri.queryParameters.containsKey('oauth_token') && uri.queryParameters.containsKey('oauth_verifier')) {
          print("Authorization success");
          Navigator.of(context).pop();
          /*
          // Got a valid token
          if (_temporaryToken == uri.queryParameters['oauth_token']) {
            print("Authorization success");
            widget.onSuccess(uri.queryParameters['oauth_token'], uri.queryParameters['oauth_verifier']);
            Navigator.of(context).pop();
          } else {
            print("Authorization failed with mismatching tokens: "
              "$_temporaryToken != ${uri.queryParameters['oauth_token']}, "
              "${uri.queryParameters['oauth_verifier']}");
            setState(() { _ready = false; });
            await _authError();
            Navigator.of(context).pop();
          }
          */
        } else {
          // Authorization canceled
          print("Authorization canceled: " + url);
          setState(() { _ready = false; });
          await _authError();
          Navigator.of(context).pop();
        }
      } else if (!_hostWhitelist.containsKey(uri.host)) { // url.startsWith(widget.host)) {
        // Only allow API url
        // TODO: Also allow T&C and Privacy Policy urls!
        print("Url not allowed: " + url);
        setState(() { _ready = false; });
        await _authError();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _focusScope = FocusScope.of(context);
    if (!_ready) {
      return new Scaffold(
        appBar: widget.appBar,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new CircularProgressIndicator(),
              ]
            ),
          ]
        ),
      );
    }
    return new WebviewScaffold(
      url: _authUrl,
      appBar: widget.appBar != null ? widget.appBar : new AppBar(
        title: new Image(
          image: new AssetImage('assets/logo_appbar.png')
        ),
        centerTitle: true,
      ),
    );
  }
}

/* end of file */
