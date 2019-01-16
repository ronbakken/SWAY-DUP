import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth1/oauth1.dart' as oauth1;






class OAuthSettings {
  final String authURL;
  final String callbackUrl;
  
  OAuthSettings({this.authURL, this.callbackUrl});
}

Map<SocialNetWorks, OAuthSettings> oAuthSettings = <SocialNetWorks, OAuthSettings>{
  SocialNetWorks.twitter: OAuthSettings(callbackUrl: 'https://login.internal', )
};

enum SocialNetWorks { twitter, instagramm, facebook, youtube }

class SocialMediaConnectorPage extends StatefulWidget {
  final SocialNetWorks connectTo;
  final Set<String> whitelistHosts;



  SocialMediaConnectorPage({Key key, this.connectTo, this.whitelistHosts}) : super(key: key);
  @override
  _SocialMediaConnectorPageState createState() => _SocialMediaConnectorPageState();
}

class _SocialMediaConnectorPageState extends State<SocialMediaConnectorPage> {
  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  String _authUrl;
  String _callbackUrl;
  Set<String> whitelistHosts;

  oauth1.Authorization twitterAuth;
  oauth1.AuthorizationResponse twitterAuthResponse;

  StreamSubscription urlChangedSubscription; 

  @override
  void initState() {
    whitelistHosts = widget.whitelistHosts ?? Set<String>();

    _callbackUrl = oAuthSettings[SocialNetWorks.twitter].callbackUrl;
    whitelistHosts.add(_callbackUrl);
    _authUrl = oAuthSettings[SocialNetWorks.twitter].authURL;
    whitelistHosts.add(_authUrl);
    whitelistHosts.add(Uri.parse(_authUrl ?? '').host);

    if (widget.connectTo == SocialNetWorks.twitter) {

      whitelistHosts.add('https://twitter.com/account/begin_password_reset');

      var platform = new oauth1.Platform(
          'https://api.twitter.com/oauth/request_token', // temporary credentials request
          'https://api.twitter.com/oauth/authorize', // resource owner authorization
          'https://api.twitter.com/oauth/access_token', // token credentials request
          oauth1.SignatureMethods.HMAC_SHA1 // signature method
          );

      // define client credentials (consumer keys)
      const String apiKey = 'yebVfiIgUGwg0Ij5FwooEW5xE';
      const String apiSecret = 'iaAfdlnXarC240VhgReeEXZxXyH1RqkidBVGNNS9gGouIiL2Cy';
      var clientCredentials = oauth1.ClientCredentials(apiKey, apiSecret);

      // create Authorization object with client credentials and platform definition
      twitterAuth = new oauth1.Authorization(clientCredentials, platform);
      // request temporary credentials (request tokens)

      twitterAuth.requestTemporaryCredentials(_callbackUrl).then((authResponse) {
        twitterAuthResponse = authResponse;
        setState(() {
          // for Twitter we have to set _authUrl dynamically
          _authUrl = twitterAuth.getResourceOwnerAuthorizationURI(authResponse.credentials.token);
          whitelistHosts.add(_authUrl);
          whitelistHosts.add(Uri.parse(_authUrl).host);
        });
      });
    }

    urlChangedSubscription = _flutterWebviewPlugin.onUrlChanged.listen(_onUrlChanged);

    super.initState();
  }

  @override
    void dispose() {
      urlChangedSubscription?.cancel();
      _flutterWebviewPlugin.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return _authUrl != null
        ? WebviewScaffold(
            url: _authUrl,
            clearCookies: true, // We must clear cookies to allow multiple accounts
            appBar: AppBar(
              title: Text('Connect to:'),
              centerTitle: true,
            ),
          )
        : CircularProgressIndicator();
  }

  Future<Null> _showErrorDialog() async {
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

  void _onUrlChanged(String url) async {
    print('++++++++++++++++++++++++++++++++++Url Changed: $url');
    try {
      if (mounted) {
        if (url.startsWith(_callbackUrl)) {
          urlChangedSubscription?.cancel();
          setState(() {
            _authUrl = null;
          });
          Navigator.of(context).pop();

          await processCallbackUrl(url);
        }
        else if (!whitelistHosts.contains(url) && !whitelistHosts.contains(Uri.parse(url).host)) {
          
          // Only allow API url.
          // Also allow T&C and Privacy Policy urls.
           print("Url not allowed: " + url);
        //   setState(() {
        //     _authUrl = null;
        //   });
        //   await _showErrorDialog();
        //   Navigator.of(context).pop();
         }
      }
      return;
    } catch (e) {
      print(e);
    }
    setState(() {
      _authUrl = null;
    });
    await _showErrorDialog();
    Navigator.of(context).pop();
  }

  Future<void> processCallbackUrl(String url) async {
    if (widget.connectTo == SocialNetWorks.twitter)
    {
       var uri = Uri.parse(url);
       var verifier = uri.queryParameters['oauth_verifier'];
       var result = await twitterAuth.requestTokenCredentials(twitterAuthResponse.credentials, verifier);
       print(result.credentials.token);
       print(result.credentials.tokenSecret);
       

    }
  }
}
