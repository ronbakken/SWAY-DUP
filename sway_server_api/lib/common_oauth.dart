/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:convert';

import 'package:sway_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;
import 'package:grpc/grpc.dart' as grpc;
import 'package:pedantic/pedantic.dart';

// TODO: OAuth should be moved to a separate service.

/// Fetches access token credentials for a user from an OAuth provider by auth callback query
/// Throws an exception in case the passed query is not permitted
Future<DataOAuthCredentials> fetchOAuthCredentials(
    Logger opsLog,
    Logger devLog,
    ConfigData config,
    List<oauth1.Authorization> oauth1Auth,
    http.Client httpClient,
    int oauthProvider,
    String callbackQuery) async {
  // devLog.finest("Fetch OAuth Credentials: OAuth Provider: $oauthProvider, Callback Query: $callbackQuery");
  final ConfigOAuthProvider provider = config.oauthProviders[oauthProvider];
  final Map<String, String> query = Uri.splitQueryString(callbackQuery);
  final DataOAuthCredentials oauthCredentials = DataOAuthCredentials();
  switch (provider.mechanism) {
    case OAuthMechanism.oauth1:
      {
        // Twitter-like
        final oauth1.Authorization auth = oauth1Auth[oauthProvider];
        // auth.requestTokenCredentials(clientCredentials, verifier);
        if (query.containsKey('oauth_token') &&
            query.containsKey('oauth_verifier')) {
          final oauth1.Credentials credentials = oauth1.Credentials(
              query['oauth_token'],
              ''); // oauth_token_secret can be left blank it seems
          final oauth1.AuthorizationResponse authRes = await auth
              .requestTokenCredentials(credentials, query['oauth_verifier']);
          // For Twitter, these "Access Tokens" don't expire
          // devLog.finest(authRes.credentials.token);
          // devLog.finest(authRes.credentials.tokenSecret);
          // devLog.finest(authRes.optionalParameters);
          oauthCredentials.token = authRes.credentials.token;
          oauthCredentials.tokenSecret = authRes.credentials.tokenSecret;
          oauthCredentials.tokenExpires = 0;
          oauthCredentials.userId = authRes.optionalParameters['user_id'];
          // screenName = authRes.optionalParameters['screen_name']; // DISCARDED
        } else if (query.containsKey('oauth_token') &&
            query.containsKey('oauth_token_secret')) {
          // Direct login for Test Users
          switch (OAuthProviderIds.valueOf(oauthProvider)) {
            case OAuthProviderIds.twitter:
              {
                // This is normally not the used path,
                // but required for testing and plugin support
                // TODO: Ensure that obtained tokens aren't valid for other app consumer keys
                oauthCredentials.token = query['oauth_token'];
                oauthCredentials.tokenSecret = query['oauth_token_secret'];
                oauthCredentials.tokenExpires = 0;
                final oauth1.ClientCredentials clientCredentials =
                    oauth1.ClientCredentials(
                        provider.consumerKey, provider.consumerSecret);
                final oauth1.Credentials credentials = oauth1.Credentials(
                    oauthCredentials.token, oauthCredentials.tokenSecret);
                final oauth1.Client client = oauth1.Client(
                    oauth1.SignatureMethods.hmacSha1,
                    clientCredentials,
                    credentials,
                    httpClient);
                final http.Response response = await client.get(
                    'https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=true');
                final dynamic doc = json.decode(response.body);
                oauthCredentials.userId = doc['id_str'];
              }
          }
        } else {
          // devLog.warning("Query doesn't contain the required parameters: ${callbackQuery}");
        }
        break;
      }
    case OAuthMechanism.oauth2:
      {
        // Facebook, Spotify-like. Much easier (but less standardized)
        if (query.containsKey('code')) {
          // Facebook-like
          final Uri baseUri =
              Uri.parse(provider.host + provider.accessTokenUrl);
          final Map<String, String> requestQuery = <String, String>{};
          requestQuery['client_id'] = provider.clientId;
          requestQuery['client_secret'] = provider.clientSecret;
          requestQuery['redirect_uri'] = provider.callbackUrl;
          requestQuery['code'] = query['code'];
          /* this returns { "access_token": {access-token}, "token_type": {type}, "expires_in":  {seconds-til-expiration} } */
          final http.Response accessTokenRes = await httpClient
              .get(baseUri.replace(queryParameters: requestQuery));
          final dynamic accessTokenDoc = json.decode(accessTokenRes.body);
          assert(accessTokenDoc['token_type'] == 'bearer');
          assert(accessTokenDoc['expires_in'] > 5000000);
          assert(accessTokenDoc['access_token'] != null);
          print(accessTokenDoc);
          oauthCredentials.token = accessTokenDoc['access_token'];
          oauthCredentials.tokenSecret = '';
          oauthCredentials.tokenExpires =
              (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) +
                  accessTokenDoc['expires_in'];
        } else if (query.containsKey('access_token')) {
          // Direct login for Test Users
          oauthCredentials.token = query['access_token'];
        }
        if (oauthCredentials.token.isNotEmpty) {
          if (oauthProvider == OAuthProviderIds.facebook.value) {
            // Facebook
            final Uri baseUri = Uri.parse(provider.host + '/v3.1/debug_token');
            final Map<String, String> requestQuery = <String, String>{};
            requestQuery['input_token'] = '${oauthCredentials.token}';
            requestQuery['access_token'] =
                '${provider.clientId}|${provider.clientSecret}';
            final http.Response debugTokenRes = await httpClient
                .get(baseUri.replace(queryParameters: requestQuery));
            final dynamic debugTokenDoc = json.decode(debugTokenRes.body);
            print(debugTokenDoc);
            final dynamic debugData = debugTokenDoc['data'];
            if (debugData['app_id'] != provider.clientId) {
              opsLog.warning(
                  'User specified invalid app (expect ${provider.clientId}) $debugTokenDoc');
              throw grpc.GrpcError.failedPrecondition(
                  "Invalid app '${debugData['app_id']}' specified");
            }
            if (debugData['is_valid'] != true) {
              opsLog.warning('User token not valid $debugTokenDoc');
              throw grpc.GrpcError.failedPrecondition('User token not valid');
            }
            oauthCredentials.userId = debugData['user_id'];
            oauthCredentials.tokenExpires = debugData['expires_at'];
          }
        } else {
          devLog.warning(
              "Query doesn't contain the required parameters: $callbackQuery");
        }
      }
      break;
    default:
      throw grpc.GrpcError.invalidArgument(
          "OAuth provider '$oauthProvider' has no supported mechanism specified");
  }
  // devLog.finest("OAuth Credentials: $oauthCredentials");
  return (oauthCredentials.userId.isNotEmpty) ? oauthCredentials : null;
}

Future<void> saveSocialMedia(int oauthProvider, String body) async {
  // TODO: Dump raw profile data to storage for development reference purpose
  /*
  try {
    await elasticsearch.postDocument(
        "social_account_" + config.oauthProviders[oauthProvider].key, body);
  } catch (error, stackTrace) {
    opsLog.severe("Error posting social media account to Elasticsearch",
        error, stackTrace);
  }
  */
}

Future<DataSocialMedia> fetchSocialMedia(
    ConfigData config,
    http.Client httpClient,
    int oauthProvider,
    DataOAuthCredentials oauthCredentials) async {
  // devLog.finest("fetchSocialMedia: $oauthProvider, ${oauthCredentials.userId}, ${oauthCredentials.token}, ${oauthCredentials.tokenSecret}");
  final DataSocialMedia dataSocialMedia = DataSocialMedia();
  dataSocialMedia.providerId = oauthProvider;
  // Fetch social media stats from the oauth provider. Then store them in the database. Then set them here.
  // Get display name, screen name, followers, following, avatar, banner image
  final ConfigOAuthProvider provider = config.oauthProviders[oauthProvider];
  switch (OAuthProviderIds.valueOf(oauthProvider)) {
    case OAuthProviderIds.twitter:
      {
        // Twitter
        // https://api.twitter.com/1.1/users/show.json?user_id=12345
        // devLog.finest("Twitter");
        final oauth1.ClientCredentials clientCredentials =
            oauth1.ClientCredentials(
                provider.consumerKey, provider.consumerSecret);
        final oauth1.Credentials credentials = oauth1.Credentials(
            oauthCredentials.token, oauthCredentials.tokenSecret);
        final oauth1.Client client = oauth1.Client(
            oauth1.SignatureMethods.hmacSha1,
            clientCredentials,
            credentials,
            httpClient);
        // devLog.finest('show');
        // http.Response res = await client.get("https://api.twitter.com/1.1/users/show.json?user_id=$oauthUserId");
        // https://developer.twitter.com/en/docs/accounts-and-users/manage-account-settings/api-reference/get-account-verify_credentials
        // https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=true&include_email=true
        // devLog.finest(res.body);
        final http.Response res = await client.get(
            'https://api.twitter.com/1.1/account/verify_credentials.json?skip_status=true&include_email=true');
        // devLog.finest('verify_credentials');
        // devLog.finest(res.body);
        unawaited(saveSocialMedia(oauthProvider, res.body));
        final dynamic doc = json.decode(res.body);
        if (doc['id_str'] != oauthCredentials.userId) {
          throw grpc.GrpcError.failedPrecondition(
              "Mismatching OAuth user: ${doc['id_str']} != ${oauthCredentials.userId}");
        }
        if (doc['screen_name'] != null)
          dataSocialMedia.screenName = doc['screen_name'];
        if (doc['name'] != null) {
          dataSocialMedia.displayName = doc['name'];
        }
        if (doc['profile_image_url'] != null &&
            doc['default_profile_image'] != true)
          dataSocialMedia.avatarUrl =
              doc['profile_image_url'].toString().replaceAll('_normal', '');
        if (doc['screen_name'] != null)
          dataSocialMedia.profileUrl =
              "https://twitter.com/${doc['screen_name']}";
        if (doc['location'] != null) {
          dataSocialMedia.location = doc['location'];
        }
        if (doc['description'] != null)
          dataSocialMedia.description = doc['description'];
        if (doc['url'] != null) {
          dataSocialMedia.url = doc['url'];
        }
        final dynamic entitiesObject = doc['entities'];
        if (entitiesObject != null) {
          final dynamic urlObject = entitiesObject['url'];
          if (urlObject != null) {
            final dynamic urlsObject = urlObject['urls'];
            if (urlsObject is List &&
                urlsObject.isNotEmpty &&
                urlsObject[0]['url'] == dataSocialMedia.url) {
              final String expandedUrl = urlsObject[0]['expanded_url'];
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
        final Map<String, String> requestQuery = <String, String>{};
        requestQuery['access_token'] = oauthCredentials.token;

        // Need "Page Public Content Access"

        // User info
        baseUri = Uri.parse(provider.host +
            '/v3.1/' +
            oauthCredentials
                .userId); // Try fields=picture.height(961) to get highest resolution avatar
        requestQuery['fields'] =
            'name,email,link,picture.height(1440)'; // ,location,address,hometown // cover,subscribers,subscribedto is deprecated
        final http.Response userRes = await httpClient
            .get(baseUri.replace(queryParameters: requestQuery));
        unawaited(saveSocialMedia(oauthProvider, userRes.body));
        final dynamic userDoc = json.decode(userRes.body);
        // devLog.finest(userDoc);

        if (userDoc['id'] != oauthCredentials.userId) {
          throw grpc.GrpcError.failedPrecondition(
              "Mismatching OAuth user: ${userDoc['id']} != ${oauthCredentials.userId}");
        }

        if (userDoc['name'] != null)
          dataSocialMedia.displayName = userDoc['name'];
        if (userDoc['link'] != null)
          dataSocialMedia.profileUrl = userDoc['link'];
        if (userDoc['email'] != null) {
          dataSocialMedia.email = userDoc['email'];
        }

        final dynamic picture = userDoc['picture'];
        if (picture != null) {
          final dynamic data = picture['data'];
          if (data != null) {
            final dynamic url = data['url'];
            if (url != null) {
              dataSocialMedia.avatarUrl = url;
            }
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
            provider.host + '/v3.1/' + oauthCredentials.userId + '/friends');
        requestQuery['fields'] = 'summary';
        requestQuery['summary'] = 'total_count';
        final http.Response friendsRes = await httpClient
            .get(baseUri.replace(queryParameters: requestQuery));
        final dynamic friendsDoc = json.decode(friendsRes.body);
        // devLog.finest(friendsDoc);

        final dynamic friendsSummary = friendsDoc['summary'];
        if (friendsSummary != null) {
          final dynamic totalCount = friendsSummary['total_count'];
          if (totalCount != null) {
            dataSocialMedia.friendsCount = totalCount;
          }
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
  // devLog.finer("${OAuthProviderIds.valueOf(oauthProvider)}: ${oauthCredentials.userId}: $dataSocialMedia");
  return dataSocialMedia;
}

/* end of file */
