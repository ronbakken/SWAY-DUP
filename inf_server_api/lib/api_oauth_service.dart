/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';

import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:grpc/grpc.dart' as grpc;
import 'package:http/http.dart' as http;

import 'package:inf_common/inf_common.dart';

class ApiOAuthService extends ApiOAuthServiceBase {
  final ConfigData config;
  // final Elasticsearch elasticsearch;

  static final Logger opsLog = Logger('InfOps.ApiOAuthService');
  static final Logger devLog = Logger('InfDev.ApiOAuthService');
  final http.Client httpClient = http.Client();

  List<oauth1.Authorization> oauth1Auth;

  ApiOAuthService(this.config) {
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
    _selfTest();
  }

  Future<void> _selfTest() async {
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

  @override
  Future<NetOAuthUrl> getUrl(
      grpc.ServiceCall call, NetOAuthGetUrl request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');

    // Can either be used by an accountless session
    // or by an account that's not banned
    if (auth.sessionId == Int64.ZERO ||
        (auth.accountId != Int64.ZERO &&
            auth.globalAccountState.value <
                GlobalAccountState.readOnly.value)) {
      throw grpc.GrpcError.permissionDenied();
    }

    if (request.oauthProvider < config.oauthProviders.length) {
      final ConfigOAuthProvider provider =
          config.oauthProviders[request.oauthProvider];
      switch (provider.mechanism) {
        case OAuthMechanism.oauth1:
          {
            // Twitter-like
            final oauth1.Authorization auth = oauth1Auth[request.oauthProvider];
            final oauth1.AuthorizationResponse authRes =
                await auth.requestTemporaryCredentials(provider.callbackUrl);
            final String authUrl = auth
                .getResourceOwnerAuthorizationURI(authRes.credentials.token);
            final NetOAuthUrl response = NetOAuthUrl();
            devLog.finest(authUrl);
            response.authUrl = authUrl;
            response.callbackUrl = provider.callbackUrl;
            return response;
          }
        case OAuthMechanism.oauth2:
          {
            // Facebook, Spotify-like. Much easier (but less standardized)
            final Uri baseUri = Uri.parse(provider.authUrl);
            final Map<String, String> query =
                Uri.splitQueryString(provider.authQuery);
            query['client_id'] = provider.clientId;
            query['redirect_uri'] = provider.callbackUrl;
            final Uri uri = baseUri.replace(queryParameters: query);
            final String authUrl = '$uri';
            final NetOAuthUrl response = NetOAuthUrl();
            devLog.finest(authUrl);
            response.authUrl = authUrl;
            response.callbackUrl = provider.callbackUrl;
            return response;
          }
        default:
          {
            throw grpc.GrpcError.invalidArgument(
                "Invalid oauthProvider specified '${request.oauthProvider}'.");
          }
      }
    } else {
      throw grpc.GrpcError.invalidArgument(
          "Invalid oauthProvider specified '${request.oauthProvider}'.");
    }
  }

  @override
  Future<NetOAuthSecrets> getSecrets(
      grpc.ServiceCall call, NetOAuthGetSecrets request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');

    // Can either be used by an accountless session
    // or by an account that's not banned
    if (auth.sessionId == Int64.ZERO ||
        (auth.accountId != Int64.ZERO &&
            auth.globalAccountState.value <
                GlobalAccountState.readOnly.value)) {
      throw grpc.GrpcError.permissionDenied();
    }

    final int providerId = request.oauthProvider;
    if (providerId >= config.oauthProviders.length) {
      throw grpc.GrpcError.invalidArgument(
          "Invalid oauthProvider specified '$providerId'.");
    }

    final NetOAuthSecrets response = NetOAuthSecrets();
    final ConfigOAuthProvider provider = config.oauthProviders[providerId];
    if (provider.consumerKeyExposed) {
      response.consumerKey = provider.consumerKey;
    }
    if (provider.consumerSecretExposed) {
      response.consumerSecret = provider.consumerSecret;
    }
    if (provider.clientIdExposed) {
      response.clientId = provider.clientId;
    }

    return response;
  }
}

/* end of file */
