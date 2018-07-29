import 'oauth_scaffold.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OAuthScaffoldTwitter extends StatelessWidget {
  const OAuthScaffoldTwitter({
    Key key,
    this.appBar,
    this.consumerKey = "dJBat7EvZlqUuC7qsl9Gi0Kk1",
    this.consumerSecret = "gwJSX2xyqOic8VLoPHu8zncfh1xogwWKBWrroVoNfwM4X70n0m",
    @required this.onSuccess,
  }) : super(key: key);

  final AppBar appBar;

  final String consumerKey;
  final String consumerSecret;

  final OAuthTokenCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    return new OAuthScaffold(
      appBar: appBar,
      host: "https://api.twitter.com",
      requestTokenUrl: "/oauth/request_token",
      authenticateUrl: "/oauth/authenticate",
      accessTokenUrl: "/oauth/access_token",
      callbackUrl: "https://net.no-break.space",
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
      onSuccess: onSuccess,
    );
  }
}

/* end of file */
