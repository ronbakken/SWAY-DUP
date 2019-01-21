import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:inf/domain/domain.dart';
import 'package:http/http.dart' as http;

Future<SocialMediaAccount> connectToSocialMediaAccount(SocialNetworkProvider provider, BuildContext context) async {
  if (provider.type == SocialNetworkProviderType.INSTAGRAM ||
          provider.type == SocialNetworkProviderType.FACEBOOK ||
          provider.type == SocialNetworkProviderType.TWITTER
      // ||provider.type == SocialNetworkProviderType.SNAPCHAT
      ) {
  } else if (provider.type == SocialNetworkProviderType.YOU_TUBE) {
  } else {}
  return null;
}

// if (provider.type == SocialNetworkProviderType.INSTAGRAM) ||
// {

// }
// else if (provider.type == SocialNetworkProviderType.FACEBOOK)
// {

// }
// else if (provider.type == SocialNetworkProviderType.TWITTER)
// {

// }
// else if (provider.type == SocialNetworkProviderType.YOU_TUBE)
// {

// }
// else if (provider.type == SocialNetworkProviderType.SNAPCHAT)
// {

// }
// else{

// }

class SocialMediaConnectorPage extends StatefulWidget {
  final SocialNetworkProvider connectTo;
  final Set<String> whitelistHosts;

  SocialMediaConnectorPage({Key key, this.connectTo, this.whitelistHosts}) : super(key: key);
  @override
  _SocialMediaConnectorPageState createState() => _SocialMediaConnectorPageState();
}

class _SocialMediaConnectorPageState extends State<SocialMediaConnectorPage> {
  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  String _authUrl;
  String _callbackUrl;
  Set<String> _whitelistHosts;

  SocialNetworkProvider provider;

  oauth1.Authorization twitterAuth;
  oauth1.AuthorizationResponse twitterAuthResponse;
  oauth1.Platform platform;
  oauth1.ClientCredentials clientCredentials;

  StreamSubscription _urlChangedSubscription;

  @override
  void initState() {
    provider = widget.connectTo;
    _callbackUrl = 'https://www.infmarketplace.com/wait.html';

    if (provider.type == SocialNetworkProviderType.INSTAGRAM) {
      _authUrl =
          'https://api.instagram.com/oauth/authorize/?client_id=apiKey&redirect_uri=callbackUrl&response_type=token';
      _authUrl = _authUrl.replaceFirst('apiKey', provider.apiKey);
      _authUrl = _authUrl.replaceFirst('callbackUrl', Uri.encodeComponent(_callbackUrl));
    } else if (provider.type == SocialNetworkProviderType.FACEBOOK) {
      _authUrl =
          'https://www.facebook.com/v3.2/dialog/oauth?client_id=apiKey&redirect_uri=callbackUrl&response_type=token&scope=pages_show_list';

      _authUrl = _authUrl.replaceFirst('apiKey', provider.apiKey);
      _authUrl = _authUrl.replaceFirst('callbackUrl', Uri.encodeComponent(_callbackUrl));
    } else if (provider.type == SocialNetworkProviderType.SNAPCHAT) {
      // todo
    } else if (provider.type == SocialNetworkProviderType.TWITTER) {
      _whitelistHosts.add('https://twitter.com/account/begin_password_reset');

      platform = new oauth1.Platform(
          'https://api.twitter.com/oauth/request_token', // temporary credentials request
          'https://api.twitter.com/oauth/authorize', // resource owner authorization
          'https://api.twitter.com/oauth/access_token', // token credentials request
          oauth1.SignatureMethods.HMAC_SHA1 // signature method
          );

      // define client credentials (consumer keys)
      final String apiKey = provider.apiKey;
      final String apiSecret = provider.apiKeySecret;
      clientCredentials = oauth1.ClientCredentials(apiKey, apiSecret);

      // create Authorization object with client credentials and platform definition
      twitterAuth = new oauth1.Authorization(clientCredentials, platform);
      // request temporary credentials (request tokens)

      twitterAuth.requestTemporaryCredentials(_callbackUrl).then((authResponse) {
        twitterAuthResponse = authResponse;
        setState(() {
          // for Twitter we have to set _authUrl dynamically
          _authUrl = twitterAuth.getResourceOwnerAuthorizationURI(authResponse.credentials.token);
          _whitelistHosts.add(_authUrl);
          _whitelistHosts.add(Uri.parse(_authUrl).host);
        });
      });
    } else {
      assert(false, 'ILLEGAL provider type');
    }

    _whitelistHosts.add(_callbackUrl);
    _whitelistHosts.add(_authUrl);
    _whitelistHosts.add(Uri.parse(_authUrl ?? '').host);

    _urlChangedSubscription = _flutterWebviewPlugin.onUrlChanged.listen(_onUrlChanged);

    super.initState();
  }

  @override
  void dispose() {
    _flutterWebviewPlugin.close();
    _flutterWebviewPlugin.dispose();
    _urlChangedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _authUrl != null
        ? WebviewScaffold(
            url: _authUrl,
            clearCookies: true, // We must clear cookies to allow multiple accounts
            appBar: AppBar(
              title: Text('Connect to ${provider.name}'),
              centerTitle: true,
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  void _onUrlChanged(String url) async {
    print('++++++++++++++++++++++++++++++++++Url Changed: $url');
    try {
      if (mounted) {
        if (url.startsWith(_callbackUrl)) {
          await _urlChangedSubscription?.cancel();
          setState(() {
            _authUrl = null;
          });

          var uri = Uri.parse(url);
          SocialMediaAccount newAccount;

          if (provider.type == SocialNetworkProviderType.TWITTER) {
            newAccount = await handleTwitter(uri);
          } else {
            //
            // for all other OAuth2 providers:
            //
            const accessTokenString = 'access_token=';
            String accessToken;
            var fragment = uri.fragment;
            var accessTokenStart = fragment.indexOf(accessTokenString) + accessTokenString.length;
            if (accessTokenStart < 0) {
              Navigator.of(context).pop(null);
              return;
            }
            var accessTokenEnd = fragment.indexOf('&', accessTokenStart);
            // if another parameter after the access_token was found
            if (accessTokenEnd > accessTokenStart) {
              accessToken = fragment.substring(accessTokenStart, accessTokenEnd);
            } else {
              accessToken = fragment.substring(accessTokenStart);
            }
            print('Access token: $accessToken');

            /// Different handling for the different networks
            if (provider.type == SocialNetworkProviderType.INSTAGRAM) {
              newAccount = await handleInstagram(accessToken);
            } else if (provider.type == SocialNetworkProviderType.FACEBOOK) {
              newAccount = await handleFacebook(accessToken, context);
            }

            Navigator.of(context).pop<SocialMediaAccount>(newAccount);
          }
        } else if (!_whitelistHosts.contains(url) && !_whitelistHosts.contains(Uri.parse(url).host)) {
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
    } catch (e) {
      print(e);
    }
    setState(() {
      _authUrl = null;
    });
    Navigator.of(context).pop(null);
  }

  Future<SocialMediaAccount> handleFacebook(String accessToken, BuildContext context) async {
    var url = 'https://graph.facebook.com/v3.1/me?fields=id,name,link&access_token=${accessToken}';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var asMap = json.decode(response.body);
      var userId = asMap['id'];

      if (userId != null) {
        // get all pages of this user
        url = 'https://graph.facebook.com/v3.1/me/accounts?&access_token=${accessToken}';
        response = await http.get(url);

        if (response.statusCode == 200) {
          asMap = json.decode(response.body);
          List<Map> pagesMap = asMap['data'];
          if (pagesMap != null) {
            // if no pages are connected to this account you cannot link it to our App
            if (pagesMap.isEmpty) {
              await showMessageDialog(context, 'Connection problem', 'You need a facebook page to connect to facebook');
            }

            var pages = <FaceBookPageInfo>[];

            for (var page in pagesMap) {
              pages.add(FaceBookPageInfo.fromMap(page));
            }

            /// PageSelectotDialog

            FaceBookPageInfo selectedPage;

            /// Get pages details
            url = 'https://graph.facebook.com/v3.1/${selectedPage.id}?fields=link,fan_count&access_token=${accessToken}';
            response = await http.get(url);

            if (response.statusCode == 200) {
              asMap = json.decode(response.body);
              if (asMap != null) {
                var fanCount = asMap['fan_count'];
                var link = asMap['link'];

                if (fanCount != null && link != null) {
                  var account = SocialMediaAccount(
                      accessToken: accessToken,
                      audienceSize: fanCount,
                      displayName: selectedPage.name,
                      userId: userId,
                      pageId: selectedPage.id,
                      postsCount: -1,
                      profileUrl: link,
                      socialNetWorkProvider: provider);
                  return account;
                }
              }
            }
          }
        }
      }
    }
    return null;
  }

  Future<SocialMediaAccount> handleInstagram(String accessToken) async {
    var url = 'https://api.instagram.com/v1/users/self/?access_token=$accessToken';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var asMap = json.decode(response.body);

      if (asMap != null) {
        var data = asMap['data'];
        if (data != null) {
          var userId = data['id'];
          var userName = data['username'];
          var counts = data['counts'];
          var followers = counts != null ? counts['followed_by'] : -1;
          var media = counts != null ? counts['media'] : -1;
          if (userId != null && userName != null) {
            var account = SocialMediaAccount(
                accessToken: accessToken,
                audienceSize: followers,
                displayName: userName,
                userId: userId,
                postsCount: media ?? -1,
                profileUrl: 'https://www.instagram.com/$userName/',
                socialNetWorkProvider: provider);
            return account;
          }
        }
      }
    }
    return null;
  }

  Future<SocialMediaAccount> handleTwitter(Uri uri) async {
    var verifier = uri.queryParameters['oauth_verifier'];
    var result = await twitterAuth.requestTokenCredentials(twitterAuthResponse.credentials, verifier);
    print(result.credentials.token);
    print(result.credentials.tokenSecret);

    var client = new oauth1.Client(platform.signatureMethod, clientCredentials, result.credentials);

    var response = await client.get('https://api.twitter.com/1.1/account/verify_credentials.json');
    if (response.statusCode == 200) {
      var asMap = json.decode(response.body);
      if (asMap != null) {
        var userId = asMap['id_str'];
        var userName = asMap['screen_name'];
        var followers = asMap['followers_count'];
        var postCount = asMap['statuses_count'];

        if (userId != null && userName != null && followers != null) {
          var account = SocialMediaAccount(
              accessToken: result.credentials.token,
              accessTokenSecret: result.credentials.tokenSecret,
              audienceSize: followers,
              displayName: userName,
              userId: userId,
              postsCount: postCount ?? -1,
              profileUrl: 'https://twitter.com/$userName',
              socialNetWorkProvider: provider);
          return account;
        }
      }
    }
    return null;
  }
}

class FaceBookPageInfo {
  final String id;
  final String name;

  FaceBookPageInfo({this.id, this.name});

  static FaceBookPageInfo fromMap(Map<String, String> map) {
    return FaceBookPageInfo(id: map['id'], name: map['name']);
  }
}
