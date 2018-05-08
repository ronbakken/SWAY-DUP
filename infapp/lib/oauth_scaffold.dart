import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:oauth1/oauth1.dart' as oauth1;

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

typedef void OAuthTokenCallback(String oauthToken, String oauthVerifier);

class OAuthScaffold extends StatefulWidget { // stateful widget is basically a widget with private data
  const OAuthScaffold({
    Key key,
    this.appBar,
    this.consumerKey = "dJBat7EvZlqUuC7qsl9Gi0Kk1",
    this.consumerSecret = "gwJSX2xyqOic8VLoPHu8zncfh1xogwWKBWrroVoNfwM4X70n0m",
    this.host = "https://api.twitter.com",
    this.requestTokenUrl = "/oauth/request_token",
    // this.authorizeUrl = "/oauth/authorize", // Not necessary?
    // this.accessTokenUrl = "/oauth/access_token", // Not necessary?
    this.authenticateUrl = "/oauth/authenticate",
    this.callbackUrl = "https://net.no-break.space",
    @required this.onSuccess,
  }) : super(key: key);

  final AppBar appBar;

  final String consumerKey;
  final String consumerSecret;

  final String host;
  final String requestTokenUrl;
  // final String authorizeUrl;
  // final String accessTokenUrl;
  final String authenticateUrl;

  /// When the OAuth mechanism browses to this URL, we assume success.
  final String callbackUrl;

  final OAuthTokenCallback onSuccess;

  @override
  _OAuthScaffoldState createState() => new _OAuthScaffoldState();
}

class _OAuthScaffoldState extends State<OAuthScaffold> {
  FocusScopeNode _focusScope;

  final _flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;

  bool _ready = false;
  String _url;

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

  _startRequest() async {
    try {
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
      var tokenRes = await authorization.requestTemporaryCredentials(widget.callbackUrl);
      if (!mounted) {
        return;
      }
      setState(() {
        _ready = true;
        _url =  widget.host + widget.authenticateUrl + "?oauth_token=" + Uri.encodeComponent(tokenRes.credentials.token);
      });
    } catch (e) {
      await _authError();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _onUrlChanged = _flutterWebviewPlugin.onUrlChanged.listen(_urlChanged);
    _startRequest();
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
      // print(url);
      // https://net.no-break.space/?oauth_token=6VK2rwAAAAAA5_oKAAABYz85WYA&oauth_verifier=L4XzyddrSLXTwi4F5XknXbmwVVuhb165
      if (url.startsWith(widget.callbackUrl)) {
        Uri uri = Uri.parse(url);
        if (widget.onSuccess != null && uri.queryParameters.containsKey('oauth_token') && uri.queryParameters.containsKey('oauth_verifier')) {
          // Got a valid token
          print("Authorization success");
          widget.onSuccess(uri.queryParameters['oauth_token'], uri.queryParameters['oauth_verifier']);
          Navigator.of(context).pop();
        } else {
          // Authorization canceled
          print("Authorization canceled: " + widget.host);
          setState(() { _ready = false; });
          await _authError();
          Navigator.of(context).pop();
        }
      } else if (!url.startsWith(widget.host)) {
        // Only allow API url
        // TODO: Also allow T&C and Privacy Policy urls!
        print("Url not allowed: " + widget.host);
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
      url: _url,
      appBar: widget.appBar,
    );
  }
}

/* end of file */

  
  //String _nonce;
/*
  String _getSignatureParams() {
    return 'oauth_callback=${Uri.encodeComponent(widget.callbackUrl)}&'
           'oauth_consumer_key=${Uri.encodeComponent(widget.consumerKey)}&'
           'oauth_nonce=${Uri.encodeComponent(_nonce)}&'
           'oauth_signature_method=HMAC-SHA1&'
           'oauth_timestamp=${Uri.encodeComponent((new DateTime.now().millisecondsSinceEpoch / 1000).floor().toString())}&'
           'oauth_version=1.0';
  }

  String _getSignatureBase() {
    return 'POST'
           '&${Uri.encodeComponent(widget.host + widget.requestToken)}'
           '&${Uri.encodeComponent(_getSignatureParams())}';
  }

  String _getAuthorizationHeader() {
    String signatureBase = _getSignatureBase();
    return 'OAuth '
           'oauth_callback="${Uri.encodeComponent(widget.callbackUrl)}", '
           'oauth_consumer_key="${Uri.encodeComponent(widget.consumerKey)}", '
           'oauth_nonce="${Uri.encodeComponent(_nonce)}", '
           'oauth_signature="hello", '
           'oauth_signature_method="HMAC-SHA1", '
           'oauth_timestamp="${Uri.encodeComponent((new DateTime.now().millisecondsSinceEpoch / 1000).floor().toString())}", '
           'oauth_version="1.0"';
  }
*/
    /*Utf8Codec utf8codec = new Utf8Codec();
    Base64Codec base64codec = new Base64Codec.urlSafe();
    _nonce = base64codec.encode(utf8codec.encode(new DateTime.now().millisecondsSinceEpoch.toString()));*/
    
    /*String authorizationHeader = _getAuthorizationHeader();
    print(authorizationHeader);*/
    /*http.Response tokenRes = await http.post(
      widget.host + widget.requestToken,
      headers: {
        "Authorization": authorizationHeader
      }
    );*/