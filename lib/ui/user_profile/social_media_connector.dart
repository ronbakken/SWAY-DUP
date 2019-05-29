import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/widgets/curved_box.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_bottom_sheet.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_stadium_button.dart';
import 'package:inf/ui/widgets/routes.dart';
import 'package:inf/ui/widgets/widget_utils.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

Future<SocialMediaAccount> connectToSocialMediaAccount(SocialNetworkProvider provider, BuildContext context) async {
  if (provider.type == SocialNetworkProviderType.INSTAGRAM ||
          provider.type == SocialNetworkProviderType.FACEBOOK ||
          provider.type == SocialNetworkProviderType.TWITTER
      // ||provider.type == SocialNetworkProviderType.SNAPCHAT
      ) {
    return await Navigator.of(context).push<SocialMediaAccount>(
      InfBottomSheet.route<SocialMediaAccount>(
        title: 'Connect your ${provider.name}',
        child: _SocialNetWorkConnectionStatusView(connectTo: provider),
      ),
    );
  } else if (provider.type == SocialNetworkProviderType.YOU_TUBE) {}
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
  static Route<SocialMediaAccount> route({SocialNetworkProvider connectTo}) {
    return FadePageRoute(
      builder: (BuildContext context) => SocialMediaConnectorPage(connectTo: connectTo),
    );
  }

  final SocialNetworkProvider connectTo;

  SocialMediaConnectorPage({
    Key key,
    this.connectTo,
  }) : super(key: key);

  @override
  _SocialMediaConnectorPageState createState() => _SocialMediaConnectorPageState();
}

class _SocialMediaConnectorPageState extends State<SocialMediaConnectorPage> {
  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  String _authUrl;
  String _callbackUrl;
  final _whitelistHosts = <String>{};

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

      _whitelistHosts.add('www.instagram.com');
    } else if (provider.type == SocialNetworkProviderType.FACEBOOK) {
      _authUrl =
          'https://www.facebook.com/v3.2/dialog/oauth?client_id=apiKey&redirect_uri=callbackUrl&response_type=token&scope=pages_show_list';

      _authUrl = _authUrl.replaceFirst('apiKey', provider.apiKey);
      _authUrl = _authUrl.replaceFirst('callbackUrl', Uri.encodeComponent(_callbackUrl));

      _whitelistHosts.add('m.facebook.com');
    } else if (provider.type == SocialNetworkProviderType.SNAPCHAT) {
      // todo
    } else if (provider.type == SocialNetworkProviderType.TWITTER) {
      _whitelistHosts.add('https://twitter.com/account/begin_password_reset');

      platform = oauth1.Platform(
        'https://api.twitter.com/oauth/request_token', // temporary credentials request
        'https://api.twitter.com/oauth/authorize', // resource owner authorization
        'https://api.twitter.com/oauth/access_token', // token credentials request
        oauth1.SignatureMethod('HMAC-SHA1', (key, text) {
          Hmac hmac = Hmac(sha1, key.codeUnits);
          List<int> bytes = hmac.convert(text.codeUnits).bytes;
          // The output of the HMAC signing function is a binary
          // string. This needs to be base64 encoded to produce
          // the signature string.
          return base64.encode(bytes);
        }),
      );

      // define client credentials (consumer keys)
      final String apiKey = provider.apiKey;
      final String apiSecret = provider.apiKeySecret;
      clientCredentials = oauth1.ClientCredentials(apiKey, apiSecret);

      // create Authorization object with client credentials and platform definition
      twitterAuth = oauth1.Authorization(clientCredentials, platform);
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
        : loadingWidget;
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
          }
          Navigator.of(context).pop<SocialMediaAccount>(newAccount);
        } else if (!_whitelistHosts.contains(url) && !_whitelistHosts.contains(Uri.parse(url).host)) {
          var host = Uri.parse(url).host;
          print(host);
          // Only allow API url.
          // Also allow T&C and Privacy Policy urls.
          print('Url not allowed: ' + url);
          //   setState(() {
          //     _authUrl = null;
          //   });
          //   await _showErrorDialog();
          //   Navigator.of(context).pop();
        }
      }
    } catch (e) {
      print(e);
      setState(() {
        _authUrl = null;
      });
      Navigator.of(context).pop(null);
    }
  }

  Future<SocialMediaAccount> handleFacebook(String accessToken, BuildContext context) async {
    var url = 'https://graph.facebook.com/v3.1/me?fields=id,name,link&access_token=$accessToken';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var asMap = json.decode(response.body);
      var userId = asMap['id'];

      if (userId != null) {
        // get all pages of this user
        url = 'https://graph.facebook.com/v3.1/me/accounts?&access_token=$accessToken';
        response = await http.get(url);

        if (response.statusCode == 200) {
          asMap = json.decode(response.body);
          List<dynamic> pagesMap = asMap['data'];
          if (pagesMap != null) {
            // if no pages are connected to this account you cannot link it to our App
            if (pagesMap.isEmpty) {
              showMessageDialog(
                context,
                'Connection problem',
                'You need a facebook page to connect to facebook',
              );
              return null;
            }

            var pages = <FaceBookPageInfo>[];

            for (var page in pagesMap) {
              pages.add(FaceBookPageInfo.fromMap(page));
            }

            var selectedPage = await showDialog<FaceBookPageInfo>(
              context: context,
              builder: (context) => _FacebookPageSelectorDialog(
                    pages: pages,
                  ),
            );

            /// Get pages details
            url = 'https://graph.facebook.com/v3.1/${selectedPage.id}?fields=link,fan_count&access_token=$accessToken';
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
                    postCount: -1,
                    profileUrl: link,
                    socialNetWorkProvider: provider,
                  );
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
                postCount: media ?? -1,
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

    var client = oauth1.Client(platform.signatureMethod, clientCredentials, result.credentials);

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
              postCount: postCount ?? -1,
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

  static FaceBookPageInfo fromMap(Map<String, dynamic> map) {
    return FaceBookPageInfo(id: map['id'], name: map['name']);
  }
}

class _FacebookPageSelectorDialog extends StatelessWidget {
  final List<FaceBookPageInfo> pages;

  const _FacebookPageSelectorDialog({Key key, this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 128),
      child: Material(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const CurvedBox(
            bottom: true,
            top: false,
            child: const Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
              child: const Text('Please select you facebook page you want to connect'),
            ),
          ),
          verticalMargin16,
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: AppTheme.listViewItemBackground,
                  height: 48,
                  child: FlatButton(
                    onPressed: () => Navigator.of(context).pop<FaceBookPageInfo>(pages[index]),
                    child: Center(
                      child: Text(
                        pages[index].name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: InfStadiumButton(
              text: 'CANCEL',
              height: 56.0,
              color: AppTheme.blue,
              onPressed: () => Navigator.of(context).pop<FaceBookPageInfo>(null),
            ),
          )
        ]),
      ),
    );
  }
}

class _SocialNetWorkConnectionStatusView extends StatefulWidget {
  final SocialNetworkProvider connectTo;

  const _SocialNetWorkConnectionStatusView({Key key, this.connectTo}) : super(key: key);

  @override
  _SocialNetWorkConnectionStatusViewState createState() => _SocialNetWorkConnectionStatusViewState();
}

enum _connectionState { notConnected, connected, failed }

class _SocialNetWorkConnectionStatusViewState extends State<_SocialNetWorkConnectionStatusView> {
  SocialMediaAccount account;

  _connectionState connectionState = _connectionState.notConnected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalMargin16,
        buildConnectionIconRow(),
        verticalMargin16,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: getText(),
        ),
        verticalMargin32,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: connectionState == _connectionState.notConnected
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.lock, size: 16),
                    horizontalMargin8,
                    Text(
                      'This does not let the app post anything\n under your account',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : emptyWidget,
        ),
        verticalMargin16,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: InfStadiumButton(
            color: Colors.white,
            text: getButtonText(),
            onPressed: onButtonPressed,
          ),
        ),
      ],
    );
  }

  String getButtonText() {
    switch (connectionState) {
      case _connectionState.notConnected:
        return 'CONNECT';
        break;
      default:
        return 'OKAY';
    }
  }

  Widget getText() {
    switch (connectionState) {
      case _connectionState.notConnected:
        return const Text(
          'INF will receive the following info: your public profile and email adress',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        );
        break;
      case _connectionState.connected:
        assert(account != null);
        switch (account.socialNetWorkProvider.type) {
          case SocialNetworkProviderType.FACEBOOK:
            return Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'We have connected your account and verified you have '),
                  TextSpan(
                    text: account.audienceSizeAsString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' likes on your page.'),
                ],
              ),
            );
            break;
          case SocialNetworkProviderType.SNAPCHAT:
            return Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'We have connected your account with the user name '),
                  TextSpan(text: account.displayName ?? 'no name', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
            break;
          default:
            return Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'We have connected your account and verified you have '),
                  TextSpan(text: account.audienceSizeAsString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' followers.')
                ],
              ),
            );
        }
        break;
      case _connectionState.failed:
        return const Text('Sorry there was a problem connecting your account please try again later');
        break;
    }
    return const Text('getText unknown State');
  }

  Widget buildConnectionIconRow() {
    Widget connectionStateIcon;

    switch (connectionState) {
      case _connectionState.notConnected:
        connectionStateIcon = const InfAssetImage(AppIcons.connect, width: 24.0);
        break;
      case _connectionState.connected:
        connectionStateIcon = Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.lightBlue),
          width: 24,
          height: 24,
          child: const InfAssetImage(AppIcons.check),
        );
        break;
      case _connectionState.failed:
        connectionStateIcon = const InfIcon(
          AppIcons.close,
          size: 32,
          color: Colors.red,
        );
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: AppTheme.blue,
          ),
          height: 48,
          width: 48,
          child: const Center(
            child: const InfAssetImage(
              AppLogo.swayLogoIcon,
              height: 24,
              width: 24,
            ),
          ),
        ),
        horizontalMargin8,
        connectionStateIcon,
        horizontalMargin8,
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: widget.connectTo.logoBackgroundColor,
            image: widget.connectTo.hasLogoBackgroundImage
                ? DecorationImage(image: widget.connectTo.logoBackgroundImage, fit: BoxFit.contain)
                : null,
          ),
          height: 48,
          width: 48,
          child: InfAssetImage(
            widget.connectTo.logoRawAssetMonochrome,
          ),
        ),
      ],
    );
  }

  void onButtonPressed() async {
    switch (connectionState) {
      case _connectionState.notConnected:
        var result = await Navigator.of(context).push<SocialMediaAccount>(
          SocialMediaConnectorPage.route(
            connectTo: widget.connectTo,
          ),
        );
        if (result != null) {
          setState(() {
            account = result;
            connectionState = _connectionState.connected;
          });
        } else {
          setState(() {
            account = null;
            connectionState = _connectionState.failed;
          });
        }

        break;
      default:
        Navigator.of(context).pop<SocialMediaAccount>(account);
    }
  }
}
