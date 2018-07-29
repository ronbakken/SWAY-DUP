/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;

import 'inf.pb.dart';
import 'remote_app.dart';

class RemoteAppOAuth {
  RemoteApp _r;
  ConfigData get config { return _r.config; }
  sqljocky.ConnectionPool get sql { return _r.sql; }
  TalkSocket get ts { return _r.ts; }

  static final Logger opsLog = new Logger('InfOps.RemoteAppOAuth');
  static final Logger devLog = new Logger('InfDev.RemoteAppOAuth');

  RemoteAppOAuth(this._r) {
    _netOAuthUrlReq = ts.stream(TalkSocket.encode("OA_URLRE")).listen(netOAuthUrlReq);
    _netOAuthConnectReq = ts.stream(TalkSocket.encode("OA_CONNE")).listen(netOAuthConnectReq);
  }

  void dispose() {
    if (_netOAuthUrlReq != null) {
      _netOAuthUrlReq.cancel();
      _netOAuthUrlReq = null;
    }
    if (_netOAuthConnectReq != null) {
      _netOAuthConnectReq.cancel();
      _netOAuthConnectReq = null;
    }
    _r = null;
  }

  StreamSubscription<TalkMessage> _netOAuthUrlReq; // OA_URLRE
  static int _netOAuthUrlRes = TalkSocket.encode("OA_R_URL");
  netOAuthUrlReq(TalkMessage message) async {
    devLog.finest("netOAuthUrlReq");
    NetOAuthUrlReq pb = new NetOAuthUrlReq();
    pb.mergeFromBuffer(message.data);
    if (pb.oauthProvider < config.oauthProviders.all.length) {
      ConfigOAuthProvider cfg = config.oauthProviders.all[pb.oauthProvider];
      switch (cfg.mechanism) {
        case OAuthMechanism.OAM_OAUTH1: {
          // Twitter-like
          devLog.finest(cfg.requestTokenUrl);
          devLog.finest(cfg.authenticateUrl);
          devLog.finest(cfg.accessTokenUrl);
          var platform = new oauth1.Platform(
            cfg.host + cfg.requestTokenUrl, 
            cfg.host + cfg.authenticateUrl, 
            cfg.host + cfg.accessTokenUrl, 
            oauth1.SignatureMethods.HMAC_SHA1);
          var clientCredentials = new oauth1.ClientCredentials(cfg.consumerKey, cfg.consumerSecret);
          var auth = new oauth1.Authorization(clientCredentials, platform);
          oauth1.AuthorizationResponse authRes = await auth.requestTemporaryCredentials(cfg.callbackUrl);
          String authUrl = auth.getResourceOwnerAuthorizationURI(authRes.credentials.token);
          NetOAuthUrlRes pbRes = new NetOAuthUrlRes();
          devLog.finest(authUrl);
          pbRes.authUrl = authUrl;
          pbRes.callbackUrl = cfg.callbackUrl;
          ts.sendMessage(_netOAuthUrlRes, pbRes.writeToBuffer(), reply: message);
          break;
        }
        case OAuthMechanism.OAM_OAUTH2: {
          // Facebook, Spotify-like. Much easier (but less standardized)
          Uri baseUri = Uri.parse(cfg.host + cfg.authUrl);
          Map<String, String> query = Uri.splitQueryString(cfg.authQuery);
          query['client_id'] = cfg.clientId;
          query['redirect_uri'] = cfg.callbackUrl;
          Uri uri = baseUri.replace(queryParameters: query);
          String authUrl = "$uri";
          NetOAuthUrlRes pbRes = new NetOAuthUrlRes();
          devLog.finest(authUrl);
          pbRes.authUrl = authUrl;
          pbRes.callbackUrl = cfg.callbackUrl;
          ts.sendMessage(_netOAuthUrlRes, pbRes.writeToBuffer(), reply: message);
          break;
        }
        default: {
          ts.sendException("Invalid oauthProvider specified: ${pb.oauthProvider}", reply: message);
          throw new Exception("OAuth provider has no supported mechanism specified ${pb.oauthProvider}");
        }
      }
    } else {
      ts.sendException("Invalid oauthProvider specified: ${pb.oauthProvider}", reply: message);
      throw new Exception("Invalid oauthProvider specified ${pb.oauthProvider}");
    }
  }

  StreamSubscription<TalkMessage> _netOAuthConnectReq; // OA_CONNE
  static int _netOAuthConnectRes = TalkSocket.encode("OA_R_CON");
  netOAuthConnectReq(TalkMessage message) async {
    devLog.finest("netOAuthConnectReq");
    NetOAuthConnectReq pb = new NetOAuthConnectReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb.callbackQuery);
    if (pb.oauthProvider < config.oauthProviders.all.length) {
      int oauthProvider = pb.oauthProvider;
      ConfigOAuthProvider cfg = config.oauthProviders.all[oauthProvider];
      NetOAuthConnectRes pbRes = new NetOAuthConnectRes();
      bool transitionAccount = false;
      bool connected = false;
      String oauthToken;
      String oauthTokenSecret;
      String oauthUserId;
      String screenName;
      switch (cfg.mechanism) {
        case OAuthMechanism.OAM_OAUTH1: {
          // Twitter-like
          var platform = new oauth1.Platform(
            cfg.host + cfg.requestTokenUrl, 
            cfg.host + cfg.authenticateUrl, 
            cfg.host + cfg.accessTokenUrl, 
            oauth1.SignatureMethods.HMAC_SHA1);
          var clientCredentials = new oauth1.ClientCredentials(cfg.consumerKey, cfg.consumerSecret);
          var auth = new oauth1.Authorization(clientCredentials, platform);
          // auth.requestTokenCredentials(clientCredentials, verifier);
          Map<String, String> query = Uri.splitQueryString(pb.callbackQuery);
          if (query.containsKey('oauth_token') && query.containsKey('oauth_verifier')) {
            var credentials = new oauth1.Credentials(query['oauth_token'], ''); // oauth_token_secret can be left blank it seems
            oauth1.AuthorizationResponse authRes = await auth.requestTokenCredentials(credentials, query['oauth_verifier']);
            // For Twitter, these "Access Tokens" don't expire
            devLog.finest(authRes.credentials.token);
            devLog.finest(authRes.credentials.tokenSecret);
            devLog.finest(authRes.optionalParameters);
            oauthToken = authRes.credentials.token;
            oauthTokenSecret = authRes.credentials.tokenSecret;
            oauthUserId = authRes.optionalParameters['user_id'];
            screenName = authRes.optionalParameters['screen_name'];
          } else {
            devLog.finer("Query doesn't contain the required parameters: ${pb.callbackQuery}");
          }
          break;
        }
        default: {
          ts.sendException("Invalid oauthProvider specified: ${pb.oauthProvider}", reply: message);
          throw new Exception("OAuth provider has no supported mechanism specified ${pb.oauthProvider}");
        }
      }
      if (oauthUserId != null && oauthUserId.length != 0) {
        // Attempt to process valid OAuth transaction.
        // Sets connected true if successfully added to device.
        // Sets transitionAccount if logged in to an account instead.
      }
                        await refreshSocialMedia(oauthProvider, oauthUserId, oauthToken, oauthTokenSecret); // FOR TESTING PURPOSE -- REMOVE THIS LINE
      // Connected
      if (connected) {
        await refreshSocialMedia(oauthProvider, oauthUserId, oauthToken, oauthTokenSecret);
        _r.socialMedia[oauthProvider].connected = true;
        if (_r.socialMedia[oauthProvider].screenName == null || _r.socialMedia[oauthProvider].screenName.length == 0) {
          _r.socialMedia[oauthProvider].screenName = screenName;
        }
      }
      // Simply send update of this specific social media
      pbRes.socialMedia = _r.socialMedia[oauthProvider];
      ts.sendMessage(_netOAuthConnectRes, pbRes.writeToBuffer(), reply: message);
      devLog.finest("OAuth connected: ${pbRes.socialMedia.connected}");
      if (transitionAccount) {
        // Account was found during connection, transition
        _r.unsubscribeOnboarding();
        await _r.updateDeviceState();
        await _r.transitionToApp();
      }
    } else {
      ts.sendException("Invalid oauthProvider specified: ${pb.oauthProvider}", reply: message);
      throw new Exception("Invalid oauthProvider specified ${pb.oauthProvider}");
    }
  }

  Future refreshSocialMedia(int oauthProvider, String oauthUserId, String oauthToken, String oauthTokenSecret) async {
    // Fetch social media stats from the oauth provider. Then store them in the database. Then set them here.
    // Get display name, screen name, followers, following, avatar, banner image
    switch (oauthProvider) {
      case 1: { // Twitter
        // https://api.twitter.com/1.1/users/show.json?user_id=12345
        devLog.finest("Twitter");
        ConfigOAuthProvider cfg = config.oauthProviders.all[oauthProvider];
        var clientCredentials = new oauth1.ClientCredentials(cfg.consumerKey, cfg.consumerSecret);
        var credentials = new oauth1.Credentials(oauthToken, oauthTokenSecret);
        var client = new oauth1.Client(oauth1.SignatureMethods.HMAC_SHA1, clientCredentials, credentials);
        // devLog.finest('show');
        // http.Response res = await client.get("https://api.twitter.com/1.1/users/show.json?user_id=$oauthUserId");
        // https://developer.twitter.com/en/docs/accounts-and-users/manage-account-settings/api-reference/get-account-verify_credentials
        // https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=true&include_email=true
        // devLog.finest(res.body);
        http.Response res = await client.get("https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=true&include_email=true");
        devLog.finest('verify_credentials');
        devLog.finest(res.body);
        dynamic doc = jsonDecode(res.body);
        if (doc['id_str'] != oauthUserId) {
          throw new Exception("Mismatching OAuth user: ${doc['id_str']} != $oauthUserId");
        }
        String screenName = doc['screen_name'];
        if (screenName == null) {
          throw new Exception("Missing screen_name for OAuth user: $oauthUserId");
        }
        String displayName = doc['name'];
        if (displayName == null) {
          displayName = screenName;
        }
        String location = doc['location'];
        String description = doc['description'];
        String url = doc['url'];
        dynamic entities_ = doc['entities'];
        if (entities_ != null) {
          dynamic url_ = entities_['url'];
          if (url_ != null) {
            dynamic urls_ = url_['urls'];
            if (urls_ is List && urls_.length > 0 && urls_[0]['url'] == url) {
              String expandedUrl = urls_[0]['expanded_url'];
              if (expandedUrl != null) {
                url = expandedUrl;
              }
            }
          }
        }
        int followersCount = doc['followers_count'];
        int followingCount = doc['friends_count'];
        int postsCount = doc['statuses_count'];
        bool verified = doc['verified'];
        String email = doc['email'];
        devLog.finer("Twitter $oauthUserId: $screenName, $displayName, $location, $description, $url, $followersCount, $followingCount, $postsCount, $verified, $email");
        break;
      }
      case 2: { // Facebook
        break;
      }
    }
  }

}

/*

Twitter
{
  "id": 800376685472321500,
  "id_str": "800376685472321538", ------- this
  "name": "Beyond the Curtain", ---- this
  "screen_name": "BeyondTCurtain", ---- this
  "location": "Orange, CA",
  "profile_location": {
    "id": "20ba6fb3b1ee82da",
    "url": "https:\\/\\/api.twitter.com\\/1.1\\/geo\\/id\\/20ba6fb3b1ee82da.json",
    "place_type": "unknown",
    "name": "Orange, CA",
    "full_name": "Orange, CA",
    "country_code": "",
    "country": "",
    "contained_within": [],
    "bounding_box": null,
    "attributes": {}
  },
  "description": "The premier destination for Arts, Fashion and culture.", ----- this
  "url": "https:\\/\\/t.co\\/y5oOTSkjW3",
  "entities": {
    "url": {
      "urls": [
        {
          "url": "https:\\/\\/t.co\\/y5oOTSkjW3",
          "expanded_url": "http:\\/\\/www.beyondthecurtain.com", ----- this?
          "display_url": "beyondthecurtain.com",
          "indices": [
            0,
            23
          ]
        }
      ]
    },
    "description": {
      "urls": []
    }
  },
  "protected": false,
  "followers_count": 89, ---- this
  "friends_count": 540, ----- this following
  "listed_count": 1,
  "created_at": "Sun Nov 20 16:34:06 +0000 2016",
  "favourites_count": 216,
  "utc_offset": null,
  "time_zone": null,
  "geo_enabled": false,
  "verified": false,    ------ this
  "statuses_count": 158, ------- this
  "lang": "en",
  "status": {
    "created_at": "Wed Jul 19 16:55:47 +0000 2017",
    "id": 887717617145794600,
    "id_str": "887717617145794564",
    "text": "A Sculpture Like No Other: Tony Smith\\u2019s \\u201cFermi\\u201d at the Center Club https:\\/\\/t.co\\/tSXS6MqzA6 via @beyondtcurtain",
    "truncated": false,
    "entities": {
      "hashtags": [],
      "symbols": [],
      "user_mentions": [
        {
          "screen_name": "BeyondTCurtain",
          "name": "Beyond the Curtain",
          "id": 800376685472321500,
          "id_str": "800376685472321538",
          "indices": [
            95,
            110
          ]
        }
      ],
      "urls": [
        {
          "url": "https:\\/\\/t.co\\/tSXS6MqzA6",
          "expanded_url": "http:\\/\\/beyondthecurtain.com\\/fermi\\/",
          "display_url": "beyondthecurtain.com\\/fermi\\/",
          "indices": [
            67,
            90
          ]
        }
      ]
    },
    "source": "\\u003ca href=\"http:\\/\\/twitter.com\" rel=\"nofollow\"\\u003eTwitter Web Client\\u003c\\/a\\u003e",
    "in_reply_to_status_id": null,
    "in_reply_to_status_id_str": null,
    "in_reply_to_user_id": null,
    "in_reply_to_user_id_str": null,
    "in_reply_to_screen_name": null,
    "geo": null,
    "coordinates": null,
    "place": null,
    "contributors": null,
    "is_quote_status": false,
    "retweet_count": 1,
    "favorite_count": 0,
    "favorited": false,
    "retweeted": false,
    "possibly_sensitive": false,
    "lang": "en"
  },
  "contributors_enabled": false,
  "is_translator": false,
  "is_translation_enabled": false,
  "profile_background_color": "000000",
  "profile_background_image_url": "http:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png",
  "profile_background_image_url_https": "https:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png",
  "profile_background_tile": false,
  "profile_image_url": "http:\\/\\/pbs.twimg.com\\/profile_images\\/804232922978926592\\/p-GnnDk2_normal.jpg",
  "profile_image_url_https": "https:\\/\\/pbs.twimg.com\\/profile_images\\/804232922978926592\\/p-GnnDk2_normal.jpg", ------ this
  "profile_banner_url": "https:\\/\\/pbs.twimg.com\\/profile_banners\\/800376685472321538\\/1484524628",              ------ this
  "profile_link_color": "E81C4F",
  "profile_sidebar_border_color": "000000",
  "profile_sidebar_fill_color": "000000",
  "profile_text_color": "000000",
  "profile_use_background_image": false,
  "has_extended_profile": false,
  "default_profile": false,
  "default_profile_image": false,
  "following": false,
  "follow_request_sent": false,
  "notifications": false,
  "translator_type": "none",
  "suspended": false,
  "needs_phone_verification": false
}

*/

/*
{
  "id": 800376685472321500,
  "id_str": "800376685472321538", ----------- this
  "name": "Beyond the Curtain",   ----------- this
  "screen_name": "BeyondTCurtain",----------- this
  "location": "Orange, CA",       ----------- this
  "description": "The premier destination for Arts, Fashion and culture.", ----------- this
  "url": "https:\\/\\/t.co\\/y5oOTSkjW3",
  "entities": {
    "url": {
      "urls": [
        {
          "url": "https:\\/\\/t.co\\/y5oOTSkjW3",
          "expanded_url": "http:\\/\\/www.beyondthecurtain.com",----------- this (the one that matches y5oOTSkjW3 == y5oOTSkjW3)
          "display_url": "beyondthecurtain.com",
          "indices": [
            0,
            23
          ]
        }
      ]
    },
    "description": {
      "urls": []
    }
  },
  "protected": false,
  "followers_count": 88, ---------- followers
  "friends_count": 540,  ---------- following
  "listed_count": 1,
  "created_at": "Sun Nov 20 16:34:06 +0000 2016",
  "favourites_count": 216,
  "utc_offset": null,
  "time_zone": null,
  "geo_enabled": false,
  "verified": false,     ---------- verified
  "statuses_count": 158, ---------- posts
  "lang": "en",
  "contributors_enabled": false,
  "is_translator": false,
  "is_translation_enabled": false,
  "profile_background_color": "000000",
  "profile_background_image_url": "http:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png",
  "profile_background_image_url_https": "https:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png",
  "profile_background_tile": false,
  "profile_image_url": "http:\\/\\/pbs.twimg.com\\/profile_images\\/804232922978926592\\/p-GnnDk2_normal.jpg",
  "profile_image_url_https": "https:\\/\\/pbs.twimg.com\\/profile_images\\/804232922978926592\\/p-GnnDk2_normal.jpg",
  "profile_banner_url": "https:\\/\\/pbs.twimg.com\\/profile_banners\\/800376685472321538\\/1484524628",
  "profile_link_color": "E81C4F",
  "profile_sidebar_border_color": "000000",
  "profile_sidebar_fill_color": "000000",
  "profile_text_color": "000000",
  "profile_use_background_image": false,
  "has_extended_profile": false,
  "default_profile": false,
  "default_profile_image": false,
  "following": false,
  "follow_request_sent": false,
  "notifications": false,
  "translator_type": "none",
  "suspended": false,
  "needs_phone_verification": false,
  "email": "beyondtcurtain@gmail.com" ---------- email
}
*/

/* end of file */
