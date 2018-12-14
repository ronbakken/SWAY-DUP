/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelOAuth {
  ApiChannel _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get accountDb {
    return _r.accountDb;
  }

  sqljocky.ConnectionPool get proposalDb {
    return _r.proposalDb;
  }

  Elasticsearch get elasticsearch {
    return _r.elasticsearch;
  }

  TalkChannel get channel {
    return _r.channel;
  }

  static final Logger opsLog = new Logger('InfOps.ApiChannelOAuth');
  static final Logger devLog = new Logger('InfDev.ApiChannelOAuth');

  http.Client get httpClient {
    return _r.service.httpClient;
  }

  DataAccount get account {
    return _r.account;
  }

  Map<int, DataSocialMedia> get socialMedia {
    return _r.account.socialMedia;
  }

  /*
  DataSocialMedia getSocialMedia(int oauthProvider) {
    return _r.account.socialMedia
        .firstWhere((entry) => entry.key == oauthProvider, orElse: () {
      DataAccount_SocialMediaEntry entry = new DataAccount_SocialMediaEntry();
      entry.key = oauthProvider;
      entry.value = new DataSocialMedia();
      return entry;
    }).value;
  }

  void setSocialMedia(int oauthProvider, DataSocialMedia socialMedia) {
    _r.account.socialMedia.firstWhere((entry) => entry.key == oauthProvider, orElse: () {
      DataAccount_SocialMediaEntry entry = new DataAccount_SocialMediaEntry();
      entry.key = oauthProvider;
      entry.value = new DataSocialMedia();
      _r.account.socialMedia.add(value)
      return entry;
    }).value = socialMedia;
  }
  */

  ApiChannelOAuth(this._r) {
    _r.registerProcedure(
        "OA_URLRE", GlobalAccountState.initialize, _oauthGetUrl);
    _r.registerProcedure(
        "OA_SECRE", GlobalAccountState.initialize, _oauthGetSecrets);
    _r.registerProcedure(
        "OA_CONNE", GlobalAccountState.initialize, _oauthConnect);
  }

  void dispose() {
    _r.unregisterProcedure("OA_URLRE");
    _r.unregisterProcedure("OA_SECRE");
    _r.unregisterProcedure("OA_CONNE");
    _r = null;
  }

  Future<void> _oauthGetUrl(TalkMessage message) async {
    NetOAuthGetUrl pb = new NetOAuthGetUrl();
    pb.mergeFromBuffer(message.data);
    if (pb.oauthProvider < config.oauthProviders.length) {
      ConfigOAuthProvider cfg = config.oauthProviders[pb.oauthProvider];
      switch (cfg.mechanism) {
        case OAuthMechanism.oauth1:
          {
            // Twitter-like
            oauth1.Authorization auth = _r.service.oauth1Auth[pb.oauthProvider];
            channel.replyExtend(message);
            oauth1.AuthorizationResponse authRes =
                await auth.requestTemporaryCredentials(cfg.callbackUrl);
            String authUrl = auth
                .getResourceOwnerAuthorizationURI(authRes.credentials.token);
            NetOAuthUrl pbRes = new NetOAuthUrl();
            devLog.finest(authUrl);
            pbRes.authUrl = authUrl;
            pbRes.callbackUrl = cfg.callbackUrl;
            channel.replyMessage(message, "OA_R_URL", pbRes.writeToBuffer());
            break;
          }
        case OAuthMechanism.oauth2:
          {
            // Facebook, Spotify-like. Much easier (but less standardized)
            Uri baseUri = Uri.parse(cfg.authUrl);
            Map<String, String> query = Uri.splitQueryString(cfg.authQuery);
            query['client_id'] = cfg.clientId;
            query['redirect_uri'] = cfg.callbackUrl;
            Uri uri = baseUri.replace(queryParameters: query);
            String authUrl = "$uri";
            NetOAuthUrl pbRes = new NetOAuthUrl();
            devLog.finest(authUrl);
            pbRes.authUrl = authUrl;
            pbRes.callbackUrl = cfg.callbackUrl;
            channel.replyMessage(message, "OA_R_URL", pbRes.writeToBuffer());
            break;
          }
        default:
          {
            channel.replyAbort(message,
                "Invalid oauthProvider specified '${pb.oauthProvider}'.");
            return;
          }
      }
    } else {
      channel.replyAbort(
          message, "Invalid oauthProvider specified '${pb.oauthProvider}'.");
    }
  }

  Future<void> _oauthGetSecrets(TalkMessage message) async {
    NetOAuthGetSecrets getSecrets = new NetOAuthGetSecrets()
      ..mergeFromBuffer(message.data)
      ..freeze();
    int providerId = getSecrets.oauthProvider;
    if (providerId >= config.oauthProviders.length) {
      channel.replyAbort(
          message, "Invalid oauthProvider specified '$providerId'.");
      return;
    }
    NetOAuthSecrets secrets = new NetOAuthSecrets();
    ConfigOAuthProvider provider = config.oauthProviders[providerId];
    if (provider.consumerKeyExposed) {
      secrets.consumerKey = provider.consumerKey;
    }
    if (provider.consumerSecretExposed) {
      secrets.consumerSecret = provider.consumerSecret;
    }
    if (provider.clientIdExposed) {
      secrets.clientId = provider.clientId;
    }
    channel.replyMessage(message, 'OA_R_SEC', secrets.writeToBuffer());
  }

  /// Fetches access token credentials for a user from an OAuth provider by auth callback query
  Future<DataOAuthCredentials> fetchOAuthCredentials(
      int oauthProvider, String callbackQuery) async {
    devLog.finest(
        "Fetch OAuth Credentials: OAuth Provider: $oauthProvider, Callback Query: $callbackQuery");
    ConfigOAuthProvider cfg = config.oauthProviders[oauthProvider];
    Map<String, String> query = Uri.splitQueryString(callbackQuery);
    DataOAuthCredentials oauthCredentials = new DataOAuthCredentials();
    switch (cfg.mechanism) {
      case OAuthMechanism.oauth1:
        {
          // Twitter-like
          oauth1.Authorization auth = _r.service.oauth1Auth[oauthProvider];
          // auth.requestTokenCredentials(clientCredentials, verifier);
          if (query.containsKey('oauth_token') &&
              query.containsKey('oauth_verifier')) {
            var credentials = new oauth1.Credentials(query['oauth_token'],
                ''); // oauth_token_secret can be left blank it seems
            oauth1.AuthorizationResponse authRes = await auth
                .requestTokenCredentials(credentials, query['oauth_verifier']);
            // For Twitter, these "Access Tokens" don't expire
            devLog.finest(authRes.credentials.token);
            devLog.finest(authRes.credentials.tokenSecret);
            devLog.finest(authRes.optionalParameters);
            oauthCredentials.token = authRes.credentials.token;
            oauthCredentials.tokenSecret = authRes.credentials.tokenSecret;
            oauthCredentials.tokenExpires = 0;
            oauthCredentials.userId = authRes.optionalParameters['user_id'];
            // screenName = authRes.optionalParameters['screen_name']; // DISCARDED
          } else {
            devLog.warning(
                "Query doesn't contain the required parameters: ${callbackQuery}");
          }
          break;
        }
      case OAuthMechanism.oauth2:
        {
          // Facebook, Spotify-like. Much easier (but less standardized)
          if (query.containsKey('code')) {
            // Facebook-like
            Uri baseUri = Uri.parse(cfg.host + cfg.accessTokenUrl);
            var requestQuery = new Map<String, String>();
            requestQuery['client_id'] = cfg.clientId;
            requestQuery['client_secret'] = cfg.clientSecret;
            requestQuery['redirect_uri'] = cfg.callbackUrl;
            requestQuery['code'] = query['code'];
            /* this returns { "access_token": {access-token}, "token_type": {type}, "expires_in":  {seconds-til-expiration} } */
            http.Response accessTokenRes = await httpClient
                .get(baseUri.replace(queryParameters: requestQuery));
            dynamic accessTokenDoc = json.decode(accessTokenRes.body);
            assert(accessTokenDoc['token_type'] == 'bearer');
            assert(accessTokenDoc['expires_in'] > 5000000);
            assert(accessTokenDoc['access_token'] != null);
            print(accessTokenDoc);
            oauthCredentials.token = accessTokenDoc['access_token'];
            oauthCredentials.tokenSecret = '';
            oauthCredentials.tokenExpires =
                (new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) +
                    accessTokenDoc['expires_in'];
            if (oauthCredentials.token != null &&
                oauthProvider == OAuthProviderIds.facebook.value) {
              // Facebook
              baseUri = Uri.parse(cfg.host + "/v3.1/debug_token");
              requestQuery = new Map<String, String>();
              requestQuery['input_token'] = "${oauthCredentials.token}";
              requestQuery['access_token'] =
                  "${cfg.clientId}|${cfg.clientSecret}";
              http.Response debugTokenRes = await httpClient
                  .get(baseUri.replace(queryParameters: requestQuery));
              dynamic debugTokenDoc = json.decode(debugTokenRes.body);
              print(debugTokenDoc);
              dynamic debugData = debugTokenDoc['data'];
              if (debugData['app_id'] != cfg.clientId) {
                opsLog.warning(
                    "User specified invalid app (expect ${cfg.clientId}) $debugTokenDoc");
                break;
              }
              if (debugData['is_valid'] != true) {
                opsLog.warning("User token not valid $debugTokenDoc");
                break;
              }
              oauthCredentials.userId = debugData['user_id'];
              oauthCredentials.tokenExpires = debugData['expires_at'];
            }
          } else {
            devLog.warning(
                "Query doesn't contain the required parameters: ${callbackQuery}");
          }
          break;
        }
      default:
        {
          // channel.sendException("Invalid oauthProvider specified: ${pb.oauthProvider}", replying: message);
          throw new Exception(
              "OAuth provider has no supported mechanism specified ${oauthProvider}");
        }
    }
    print("OAuth Credentials: $oauthCredentials");
    return (oauthCredentials.userId != null &&
            oauthCredentials.userId.length > 0)
        ? oauthCredentials
        : null;
  }

  Future<void> _oauthConnect(TalkMessage message) async {
    devLog.finest("NetOAuthConnect");
    NetOAuthConnect pb = new NetOAuthConnect();
    pb.mergeFromBuffer(message.data);
    // devLog.finest(pb.callbackQuery);
    if (pb.oauthProvider < config.oauthProviders.length) {
      int oauthProvider = pb.oauthProvider;
      DataOAuthCredentials oauthCredentials;

      channel.replyExtend(message);
      dynamic exception;
      try {
        oauthCredentials =
            await fetchOAuthCredentials(oauthProvider, pb.callbackQuery);
      } catch (error, stackTrace) {
        devLog.fine("$error\n$stackTrace");
      }

      // bool transitionAccount = false;
      // bool connected = false;

      ConfigOAuthProvider cfg = config.oauthProviders[oauthProvider];
      NetOAuthConnection pbRes = new NetOAuthConnection();

      bool inserted = false;
      bool takeover = false;
      bool refreshed = false;
      if (oauthCredentials != null) {
        // Attempt to process valid OAuth transaction.
        // Sets connected true if successfully added to session.
        // Sets transitionAccount if logged in to an account instead.
        // There's another situation where media is already connected and we're just updating tokens
        // await fetchSocialMedia(oauthProvider, oauthCredentials); // FOR TESTING PURPOSE -- REMOVE THIS LINE

        // Insert the data we have
        try {
          channel.replyExtend(message);
          sqljocky.Results insertRes = await accountDb.prepareExecute(
              "INSERT INTO `oauth_connections`("
              "`oauth_user_id`, `oauth_provider`, `account_type`, `account_id`, `session_id`, `oauth_token`, `oauth_token_secret`, `oauth_token_expires`"
              ") VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
              <dynamic>[
                oauthCredentials.userId.toString(),
                oauthProvider.toInt(),
                account.accountType.value.toInt(),
                account.accountId,
                account.sessionId,
                oauthCredentials.token.toString(),
                oauthCredentials.tokenSecret.toString(),
                oauthCredentials.tokenExpires.toString()
              ]);
          inserted = insertRes.affectedRows > 0;
          devLog.finest("Inserted new OAuth connection: $inserted");
        } on TalkException {
          rethrow;
        } catch (ex) {
          // This is permitted to fail
          devLog.finest(
              "Atomical (INSERT INTO `oauth_connections`) Exception: $ex");
        }

        // Alternative is to update a previously pending connection that has account_id = 0
        if (!inserted) {
          try {
            if (account.accountId == 0) {
              // Attempt to login to an existing account, or regain a lost connection
              devLog.finest("Try takeover");
              channel.replyExtend(message);
              String query = "UPDATE `oauth_connections` "
                  "SET `updated` = CURRENT_TIMESTAMP(), `session_id` = ?, "
                  "`oauth_token` = ?, `oauth_token_secret` = ?, `oauth_token_expires` = ? "
                  "WHERE `oauth_user_id` = ? AND `oauth_provider` = ? AND `account_type` = ?";
              sqljocky.Results updateRes =
                  await accountDb.prepareExecute(query, <dynamic>[
                account.sessionId,
                oauthCredentials.token.toString(),
                oauthCredentials.tokenSecret.toString(),
                oauthCredentials.tokenExpires.toString(),
                oauthCredentials.userId.toString(),
                oauthProvider.toInt(),
                account.accountType.value.toInt()
              ]);
              takeover = (updateRes.affectedRows > 0) &&
                  (account.accountId == 0); // Also check for account state
              devLog.finest(updateRes.affectedRows);
              devLog.finest("Attempt to takeover OAuth connection: $takeover");
            }
            if (takeover) {
              // Find out if we are logged into an account now
              devLog.finest("Verify takeover");
              channel.replyExtend(message);
              sqljocky.Results connectionRes = await accountDb.prepareExecute(
                  "SELECT `account_id` FROM `oauth_connections` "
                  "WHERE `oauth_user_id` = ? AND `oauth_provider` = ? AND `account_type` = ?",
                  <dynamic>[
                    oauthCredentials.userId.toString(),
                    oauthProvider.toInt(),
                    account.accountType.value.toInt()
                  ]);
              Int64 takeoverAccountId = Int64.ZERO;
              await for (sqljocky.Row row in connectionRes) {
                takeoverAccountId = new Int64(row[0]);
              }
              takeover = (account.accountId == Int64.ZERO) &&
                  (takeoverAccountId != Int64.ZERO);
              if (takeover) {
                // updateDeviceState loads the new state from the database into account.accountId
                devLog.finest(
                    "Takeover, existing account $takeoverAccountId on session ${account.sessionId}");
                String query = "UPDATE `sessions` "
                    "SET `account_id` = ? "
                    "WHERE `session_id` = ? AND `account_id` = 0";
                channel.replyExtend(message);
                await accountDb.prepareExecute(
                    query, <dynamic>[takeoverAccountId, account.sessionId]);
                // NOTE: Technically, here we may escalate any OAuth connections of this session to the account,
                // as long as the account has no connections yet for the connected providers (long-term)
              }
              refreshed =
                  !takeover; // If not anymore a takeover, then simply refreshed by sessionId
              devLog.finest("refreshed: $refreshed, takeover: $takeover");
            }
            if (!takeover && !refreshed) {
              // In case account state changed, or in case the user is simply refreshing tokens
              devLog.finest("Try refresh");
              channel.replyExtend(message);
              String query = "UPDATE `oauth_connections` "
                  "SET `updated` = CURRENT_TIMESTAMP(), `account_id` = ?, `session_id` = ?, `oauth_token` = ?, `oauth_token_secret` = ?, `oauth_token_expires` = ? "
                  "WHERE `oauth_user_id` = ? AND `oauth_provider` = ? AND `account_type` = ? AND (`account_id` = 0 OR `account_id` = ?)"; // Also allow account_id 0 in case of issue
              sqljocky.Results updateRes =
                  await accountDb.prepareExecute(query, <dynamic>[
                account.accountId,
                account.sessionId,
                oauthCredentials.token.toString(),
                oauthCredentials.tokenSecret.toString(),
                oauthCredentials.tokenExpires.toInt(),
                oauthCredentials.userId.toString(),
                oauthProvider.toInt(),
                account.accountType.value.toInt(),
                account.accountId
              ]);
              refreshed = updateRes.affectedRows > 0;
              devLog.finest("Attempt to refresh OAuth tokens: $refreshed");
            }
          } on TalkException {
            rethrow;
          } catch (ex) {
            devLog
                .finest("Atomical (UPDATE `oauth_connections`) Exception: $ex");
          }
        }
      }

      devLog.finest("itf: $inserted, $takeover, $refreshed");
      if (inserted || takeover || refreshed) {
        // Wipe any other previously connected accounts to avoid inconsistent data
        // Happens after addition to ensure race condition will prioritize deletion
        channel.replyExtend(message);
        if (account.accountId != 0) {
          String query =
              "DELETE FROM `oauth_connections` WHERE `account_id` = ? AND `oauth_user_id` != ? AND `oauth_provider` = ?";
          await accountDb.prepareExecute(query, <dynamic>[
            account.accountId,
            oauthCredentials.userId.toString(),
            oauthProvider.toInt()
          ]);
        }
        // TODO: Why is this here twice?
        channel.replyExtend(message);
        if (account.sessionId != 0) {
          String query =
              "DELETE FROM `oauth_connections` WHERE `session_id` = ? AND `oauth_user_id` != ? AND `oauth_provider` = ?";
          await accountDb.prepareExecute(query, <dynamic>[
            account.sessionId,
            oauthCredentials.userId.toString(),
            oauthProvider.toInt()
          ]);
        }

        // Fetch useful data from social media
        channel.replyExtend(message);
        DataSocialMedia dataSocialMedia =
            await fetchSocialMedia(oauthProvider, oauthCredentials);

        // Write fetched social media data to SQL database
        channel.replyExtend(message);
        await cacheSocialMedia(
            oauthCredentials.userId, oauthProvider, dataSocialMedia);

        socialMedia[oauthProvider] = DataSocialMedia();
        socialMedia[oauthProvider].mergeFromMessage(dataSocialMedia);
        socialMedia[oauthProvider].connected = true;
        socialMedia[oauthProvider].canSignUp =
            config.oauthProviders[oauthProvider].canAlwaysAuthenticate &&
                !takeover;
      }

      // Simply send update of this specific social media
      pbRes.socialMedia = socialMedia[oauthProvider];
      channel.replyMessage(message, "OA_R_CON", pbRes.writeToBuffer());
      devLog.finest("OAuth connected: ${pbRes.socialMedia.connected}");

      if (takeover) {
        // Account was found during connection, transition
        _r.unsubscribeOnboarding();
        await _r.lock.synchronized(() async {
          // Load all session state
          await _r.refreshAccount();
          // Send all state to user
          await _r.sendAccountUpdate();
        });
        if (account.accountId != 0) {
          // Transition to app
          await _r.transitionToApp();
        } else {
          devLog.severe(
              "Takeover but account id is 0, this is a fatal bug, disconnecting user now");
          channel.close();
        }
      }
    } else {
      channel.replyAbort(
          message, "Invalid oauthProvider specified '${pb.oauthProvider}'.");
    }
  }

  Future<void> saveSocialMedia(int oauthProvider, String body) async {
    /*
    Map<String, String> headers = <String, String>{
      "Authorization":
          "Basic " + base64.encode(utf8.encode(config.services.elasticsearchBasicAuth)),
      "Content-Type": "application/json"
    };
    String url = config.services.elasticsearchApi +
        "/social_account_" +
        config.oauthProviders[oauthProvider].key +
        "/_doc";
    devLog.finest(url);
    http.Response response = await http.post(url, headers: headers, body: body);
    devLog.finest(response.body);*/
    try {
      await elasticsearch.postDocument(
          "social_account_" + config.oauthProviders[oauthProvider].key, body);
    } catch (error, stackTrace) {
      opsLog.severe(
          "Error posting social media account to Elasticsearch: $error\n$stackTrace");
    }
  }

  Future<DataSocialMedia> fetchSocialMedia(
      int oauthProvider, DataOAuthCredentials oauthCredentials) async {
    devLog.finest(
        "fetchSocialMedia: $oauthProvider, ${oauthCredentials.userId}, ${oauthCredentials.token}, ${oauthCredentials.tokenSecret}");
    DataSocialMedia dataSocialMedia = new DataSocialMedia();
    // Fetch social media stats from the oauth provider. Then store them in the database. Then set them here.
    // Get display name, screen name, followers, following, avatar, banner image
    ConfigOAuthProvider cfg = config.oauthProviders[oauthProvider];
    switch (OAuthProviderIds.valueOf(oauthProvider)) {
      case OAuthProviderIds.twitter:
        {
          // Twitter
          // https://api.twitter.com/1.1/users/show.json?user_id=12345
          devLog.finest("Twitter");
          var clientCredentials =
              new oauth1.ClientCredentials(cfg.consumerKey, cfg.consumerSecret);
          var credentials = new oauth1.Credentials(
              oauthCredentials.token, oauthCredentials.tokenSecret);
          var client = new oauth1.Client(oauth1.SignatureMethods.hmacSha1,
              clientCredentials, credentials, httpClient);
          // devLog.finest('show');
          // http.Response res = await client.get("https://api.twitter.com/1.1/users/show.json?user_id=$oauthUserId");
          // https://developer.twitter.com/en/docs/accounts-and-users/manage-account-settings/api-reference/get-account-verify_credentials
          // https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=true&include_email=true
          // devLog.finest(res.body);
          http.Response res = await client.get(
              "https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=true&include_email=true");
          devLog.finest('verify_credentials');
          devLog.finest(res.body);
          saveSocialMedia(oauthProvider, res.body);
          dynamic doc = json.decode(res.body);
          if (doc['id_str'] != oauthCredentials.userId) {
            throw new Exception(
                "Mismatching OAuth user: ${doc['id_str']} != ${oauthCredentials.userId}");
          }
          if (doc['screen_name'] != null)
            dataSocialMedia.screenName = doc['screen_name'];
          if (doc['name'] != null) dataSocialMedia.displayName = doc['name'];
          if (doc['profile_image_url'] != null &&
              doc['default_profile_image'] != true)
            dataSocialMedia.avatarUrl =
                doc['profile_image_url'].toString().replaceAll('_normal', '');
          if (doc['screen_name'] != null)
            dataSocialMedia.profileUrl =
                "https://twitter.com/${doc['screen_name']}";
          if (doc['location'] != null)
            dataSocialMedia.location = doc['location'];
          if (doc['description'] != null)
            dataSocialMedia.description = doc['description'];
          if (doc['url'] != null) dataSocialMedia.url = doc['url'];
          dynamic entities_ = doc['entities'];
          if (entities_ != null) {
            dynamic url_ = entities_['url'];
            if (url_ != null) {
              dynamic urls_ = url_['urls'];
              if (urls_ is List &&
                  urls_.length > 0 &&
                  urls_[0]['url'] == dataSocialMedia.url) {
                String expandedUrl = urls_[0]['expanded_url'];
                if (expandedUrl != null) {
                  dataSocialMedia.url = expandedUrl;
                }
              }
            }
          }
          dataSocialMedia.followersCount = doc['followers_count'];
          dataSocialMedia.followingCount = doc['friends_count'];
          dataSocialMedia.postsCount = doc['statuses_count'];
          dataSocialMedia.verified = doc['verified'];
          dataSocialMedia.email = doc['email'];
          dataSocialMedia.connected = true;
          break;
        }
      case OAuthProviderIds.facebook:
        {
          // Facebook
          Uri baseUri;
          Map<String, String> requestQuery = new Map<String, String>();
          requestQuery['access_token'] = oauthCredentials.token;

          // Need "Page Public Content Access"

          // User info
          baseUri = Uri.parse(cfg.host +
              "/v3.1/" +
              oauthCredentials
                  .userId); // Try fields=picture.height(961) to get highest resolution avatar
          requestQuery['fields'] =
              "name,email,link,picture.height(1440)"; // ,location,address,hometown // cover,subscribers,subscribedto is deprecated
          http.Response userRes = await httpClient
              .get(baseUri.replace(queryParameters: requestQuery));
          saveSocialMedia(oauthProvider, userRes.body);
          dynamic userDoc = json.decode(userRes.body);
          devLog.finest(userDoc);

          if (userDoc['id'] != oauthCredentials.userId) {
            throw new Exception(
                "Mismatching OAuth user: ${userDoc['id']} != ${oauthCredentials.userId}");
          }

          if (userDoc['name'] != null)
            dataSocialMedia.displayName = userDoc['name'];
          if (userDoc['link'] != null)
            dataSocialMedia.profileUrl = userDoc['link'];
          if (userDoc['email'] != null)
            dataSocialMedia.email = userDoc['email'];

          dynamic picture = userDoc['picture'];
          if (picture != null) {
            dynamic data = picture['data'];
            if (data != null) {
              dynamic url = data['url'];
              if (url != null) dataSocialMedia.avatarUrl = url;
              // devLog.fine("Facebook avatar: $url");
            }
          }

          /*
        devLog.finest(userDoc['link']);
        if (userDoc['link'] != null) {
          // Trick to find the screen name
          http.Response linkRes = await httpClient.get(Uri.parse(userDoc['link']));
          linkRes.isRedirect
        }
        */

          // Friend count
          baseUri = Uri.parse(
              cfg.host + "/v3.1/" + oauthCredentials.userId + "/friends");
          requestQuery['fields'] = "summary";
          requestQuery['summary'] = "total_count";
          http.Response friendsRes = await httpClient
              .get(baseUri.replace(queryParameters: requestQuery));
          dynamic friendsDoc = json.decode(friendsRes.body);
          devLog.finest(friendsDoc);

          dynamic friendsSummary = friendsDoc['summary'];
          if (friendsSummary != null) {
            dynamic totalCount = friendsSummary['total_count'];
            if (totalCount != null) dataSocialMedia.friendsCount = totalCount;
          }

          dataSocialMedia.connected = true;

          // int followingCount = friendsDoc["summary"]["total_count"];

          // List the pages that the user controls
          /*
        baseUri = Uri.parse(cfg.host + "/v3.1/me/accounts");
        requestQuery['fields'] = "data,summary";
        requestQuery['summary'] = "total_count";
        http.Response accountsRes = await httpClient.get(baseUri.replace(queryParameters: requestQuery));
        dynamic accountsDoc = json.decode(accountsRes.body);
        devLog.finest(accountsDoc);
        */

/*
        // List the pages that the user controls
        baseUri = Uri.parse(cfg.host + "/v3.1/" + oauthUserId + "/businesses");
        requestQuery['fields'] = "data,summary";
        requestQuery['summary'] = "total_count";
        http.Response accountsRes = await httpClient.get(baseUri.replace(queryParameters: requestQuery));
        dynamic accountsDoc = json.decode(accountsRes.body);
        devLog.finest(accountsDoc);*/

/*

        // Other
        baseUri = Uri.parse(cfg.host + "/v2.7/smhackapp");
        requestQuery['fields'] = "id,name,fan_count,picture,is_verified";
        http.Response hackRes = await httpClient.get(baseUri.replace(queryParameters: requestQuery));
        dynamic hackDoc = json.decode(hackRes.body);
        devLog.finest(hackDoc);
        // https://graph.facebook.com/v2.7/smhackapp?fields=id,name,fan_count,picture,is_verified&access_token=

        // Test page
        baseUri = Uri.parse(cfg.host + "/v3.1/SheraJanWedding");
        http.Response testRes = await httpClient.get(baseUri.replace(queryParameters: requestQuery));
        dynamic testDoc = json.decode(testRes.body);
        devLog.finest(testDoc);
*/

          break;
        }
    }
    devLog.finer(
        "${OAuthProviderIds.valueOf(oauthProvider)}: ${oauthCredentials.userId}: $dataSocialMedia");
    return dataSocialMedia;
  }

  Future<void> cacheSocialMedia(String oauthUserId, int oauthProvider,
      DataSocialMedia dataSocialMedia) async {
    Map<String, String> stringValues = new Map<String, String>();
    Map<String, int> intValues = new Map<String, int>();
    if (dataSocialMedia.screenName.length > 0)
      stringValues['screen_name'] = dataSocialMedia.screenName;
    if (dataSocialMedia.displayName.length > 0)
      stringValues['display_name'] = dataSocialMedia.displayName;
    if (dataSocialMedia.avatarUrl.length > 0)
      stringValues['avatar_url'] = dataSocialMedia.avatarUrl;
    if (dataSocialMedia.profileUrl.length > 0)
      stringValues['profile_url'] = dataSocialMedia.profileUrl;
    if (dataSocialMedia.description.length > 0)
      stringValues['description'] = dataSocialMedia.description;
    if (dataSocialMedia.location.length > 0)
      stringValues['location'] = dataSocialMedia.location;
    if (dataSocialMedia.url.length > 0)
      stringValues['website'] = dataSocialMedia.url;
    if (dataSocialMedia.email.length > 0)
      stringValues['email'] = dataSocialMedia.email;
    if (dataSocialMedia.friendsCount > 0)
      intValues['friends_count'] = dataSocialMedia.friendsCount;
    if (dataSocialMedia.followersCount > 0)
      intValues['followers_count'] = dataSocialMedia.followersCount;
    if (dataSocialMedia.followingCount > 0)
      intValues['following_count'] = dataSocialMedia.followingCount;
    if (dataSocialMedia.postsCount > 0)
      intValues['posts_count'] = dataSocialMedia.postsCount;
    if (dataSocialMedia.hasVerified())
      intValues['verified'] = dataSocialMedia.verified ? 1 : 0;
    bool comma = true;
    String queryNames = '`updated`';
    String queryValues = 'CURRENT_TIMESTAMP()';
    String queryUpdates = '`updated` = CURRENT_TIMESTAMP()';
    List<dynamic> queryParams = new List<dynamic>();
    for (MapEntry<String, String> v in stringValues.entries) {
      if (comma) {
        queryNames += ', ';
        queryValues += ', ';
        queryUpdates += ', ';
      } else {
        comma = true;
      }
      queryNames += '`${v.key}`';
      queryValues += '?';
      queryUpdates += '`${v.key}` = ?';
      queryParams.add(v.value);
    }
    for (MapEntry<String, int> v in intValues.entries) {
      if (comma) {
        queryNames += ', ';
        queryValues += ', ';
        queryUpdates += ', ';
      } else {
        comma = true;
      }
      queryNames += '`${v.key}`';
      queryValues += '?';
      queryUpdates += '`${v.key}` = ?';
      queryParams.add(v.value);
    }
    if (comma) {
      String query =
          "INSERT INTO `social_media`(`oauth_user_id`, `oauth_provider`, $queryNames) VALUES (?, ?, $queryValues) ON DUPLICATE KEY UPDATE $queryUpdates";
      await accountDb.prepareExecute(
          query,
          <dynamic>[oauthUserId.toString(), oauthProvider.toInt()]
            ..addAll(queryParams)
            ..addAll(queryParams));
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

/*

Facebook OAuth returns giant a code like

code=AQAw5lF_gdhmUaJNtLM0HFPwOjEg3DtHXsZYc3xWI4f5PUohbMapxb7wp7Ma2sQD3s
TybdSuz7lw8Db_4-zvkmCcUdaJjWkQ8GF1g-20UyCylzpBpUR06KUygOhoChSJWx9cKdoTz
2mKdNLLay9FKkX7g8J_j5kVuEmVrvBjxAp8_S_hnNdWSawNgWtqqwDkI8Gaqk7moiWr2qyy
YofGjZRarGeaR3Cznt3Ns8zK2NXLTBdSj_MOMuSM1R7HGesHoay7xRadgBQLUsSKAaiKP32
bruhXggmeyTTWBFXEOgmguqg6aoF284BTWPseOuxQS84

*/

/*

Then output for social media info from Facebook is like

InfDev.ApiChannelOAuth: FINEST: 2018-07-30 15:18:57.172739: {name: Jan Boon, email: kaetemi@gmail.com, link: https://www.facebook.com/app_scoped_user_id/YXNpZADpBWEhuQ3d6OVZAnMHpoLU40cy1yUEhlX3I0Q095YXZAZAYTg5QXNxU094UDlwRzItdzc1a2FMbWtJODFLQWgwazVDbWo3a0FPQzRzSXZAUeTBlZAUpOVHBlTHV6ZATVGU0psOE0yblM2N24xdQZDZD/, picture: {data: {height: 50, is_silhouette: false, url: https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10155696703021547&height=50&width=50&ext=1535527137&hash=AeT1N0Rc2Zx1tHBz, width: 50}}, id: 10155696703021547}
InfDev.ApiChannelOAuth: FINEST: 2018-07-30 15:18:57.474171: {data: [], summary: {total_count: 220}}
InfDev.ApiChannelOAuth: FINEST: 2018-07-30 15:18:57.758358: {data: [{id: 1137023473103283}, {id: 1296007253750622}], paging: {cursors: {before: MTEzNzAyMzQ3MzEwMzI4MwZDZD, after: MTI5NjAwNzI1Mzc1MDYyMgZDZD}}, summary: {total_count: 2}}

*/

/* end of file */
