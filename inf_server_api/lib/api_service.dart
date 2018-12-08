/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:inf_common/inf_common.dart';
import 'package:inf_server_api/api_channel.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:logging/logging.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:switchboard/switchboard.dart';
import 'package:dospace/dospace.dart' as dospace;
import 'broadcast_center.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http/http.dart' as http;

class ApiService {
  static final Logger opsLog = new Logger('InfOps.ApiService');
  static final Logger devLog = new Logger('InfDev.ApiService');

  final ConfigData config;
  final sqljocky.ConnectionPool accountDb;
  final sqljocky.ConnectionPool proposalDb;
  final dospace.Bucket bucket;
  final Elasticsearch elasticsearch;
  final Switchboard switchboard;
  final BroadcastCenter bc;
  final http.Client httpClient = new http.Client();
  List<oauth1.Authorization> oauth1Auth;

  ApiService(this.config, this.accountDb, this.proposalDb, this.bucket,
      this.elasticsearch, this.switchboard, this.bc) {
    oauth1Auth = new List<oauth1.Authorization>(config.oauthProviders.length);
    for (int providerId = 0; providerId < oauth1Auth.length; ++providerId) {
      ConfigOAuthProvider provider = config.oauthProviders[providerId];
      if (provider.mechanism == OAuthMechanism.oauth1) {
        var platform = new oauth1.Platform(
            provider.host + provider.requestTokenUrl,
            provider.host + provider.authenticateUrl,
            provider.host + provider.accessTokenUrl,
            oauth1.SignatureMethods.HMAC_SHA1);
        var clientCredentials = new oauth1.ClientCredentials(
            provider.consumerKey, provider.consumerSecret);
        oauth1Auth[providerId] =
            new oauth1.Authorization(clientCredentials, platform, httpClient);
      }
    }
    selfTest();
  }

  Future<void> listen() async {
    await for (ChannelInfo open in switchboard) {
      // TODO: Rename ChannelInfo to ChannelOpen
      if (open.service == "api") {
        TalkChannel talkChannel = new TalkChannel(open.channel);
        new ApiChannel(this, talkChannel, open.payload,
            ipAddress: '8.8.8.8'); // TODO: Proper IP address here
      } else {
        TalkChannel talkChannel = new TalkChannel(open.channel);
        talkChannel.sendAbort("Service not supported.");
        talkChannel.close();
      }
    }
  }

  Future<void> close() async {
    httpClient.close();
  }

  Future<void> selfTest() async {
    try {
      for (int providerId = 0; providerId < oauth1Auth.length; ++providerId) {
        ConfigOAuthProvider provider = config.oauthProviders[providerId];
        if (provider.mechanism == OAuthMechanism.oauth1) {
          oauth1.Authorization auth = oauth1Auth[providerId];
          devLog.fine("OAuth1 ($providerId): " +
              (await auth.requestTemporaryCredentials(provider.callbackUrl))
                  .credentials
                  .toJSON()
                  .toString());
          devLog.fine("OAuth1 ($providerId): " +
              (await auth.requestTemporaryCredentials(provider.callbackUrl))
                  .credentials
                  .toJSON()
                  .toString());
        }
      }
    } catch (error, stackTrace) {
      opsLog.severe("Self test error: $error\n$stackTrace");
    }
  }
}

/* end of file */
