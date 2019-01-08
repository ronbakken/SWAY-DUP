/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:inf_common/inf_common.dart';
import 'package:inf_server_api/api_channel.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:logging/logging.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;
import 'broadcast_center.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;

class ApiService {
  static final Logger opsLog = Logger('InfOps.ApiService');
  static final Logger devLog = Logger('InfDev.ApiService');

  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  final dospace.Bucket bucket;
  final Elasticsearch elasticsearch;
  final BroadcastCenter bc;
  final http.Client httpClient = http.Client();
  List<oauth1.Authorization> oauth1Auth;

  ApiService(this.config, this.accountDb, this.proposalDb, this.bucket,
      this.elasticsearch, this.bc) {
    oauth1Auth = List<oauth1.Authorization>(config.oauthProviders.length);
    for (int providerId = 0; providerId < oauth1Auth.length; ++providerId) {
      final ConfigOAuthProvider provider = config.oauthProviders[providerId];
      if (provider.mechanism == OAuthMechanism.oauth1) {
        final oauth1.Platform platform = oauth1.Platform(
            provider.host + provider.requestTokenUrl,
            provider.host + provider.authenticateUrl,
            provider.host + provider.accessTokenUrl,
            oauth1.SignatureMethods.hmacSha1);
        final oauth1.ClientCredentials clientCredentials =
            oauth1.ClientCredentials(
                provider.consumerKey, provider.consumerSecret);
        oauth1Auth[providerId] =
            oauth1.Authorization(clientCredentials, platform, httpClient);
      }
    }
    selfTest();
  }

  Future<void> close() async {
    httpClient.close();
  }

  Future<void> selfTest() async {
    try {
      for (int providerId = 0; providerId < oauth1Auth.length; ++providerId) {
        final ConfigOAuthProvider provider = config.oauthProviders[providerId];
        if (provider.mechanism == OAuthMechanism.oauth1) {
          final oauth1.Authorization auth = oauth1Auth[providerId];
          devLog.fine('OAuth1 ($providerId): ' +
              (await auth.requestTemporaryCredentials(provider.callbackUrl))
                  .credentials
                  .toJSON()
                  .toString());
          devLog.fine('OAuth1 ($providerId): ' +
              (await auth.requestTemporaryCredentials(provider.callbackUrl))
                  .credentials
                  .toJSON()
                  .toString());
        }
      }
    } catch (error, stackTrace) {
      opsLog.severe('Self test error', error, stackTrace);
    }
  }
}

/* end of file */
