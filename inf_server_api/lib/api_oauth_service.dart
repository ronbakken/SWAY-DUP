/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';

import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:grpc/grpc.dart' as grpc;

import 'package:inf_common/inf_backend.dart';

class ApiOAuthService extends ApiOAuthServiceBase {
  final ConfigData config;
  // final Elasticsearch elasticsearch;
  final List<oauth1.Authorization> oauth1Auth;

  static final Logger opsLog = Logger('InfOps.ApiOAuthService');
  static final Logger devLog = Logger('InfDev.ApiOAuthService');

  ApiOAuthService(this.config, this.oauth1Auth);

  @override
  Future<NetOAuthUrl> getUrl(
      grpc.ServiceCall call, NetOAuthGetUrl request) async {
    final DataAuth auth = authFromJwtPayload(call);

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
            final Uri authUri = Uri.parse(authUrl);
            final Map<String, String> query = authUri.queryParameters;
            final Map<String, String> queryExt =
                Uri.splitQueryString(provider.authenticateQuery);
            for (MapEntry<String, String> param in query.entries) {
              queryExt[param.key] = param.value;
            }
            final String authUrlExt =
                authUri.replace(queryParameters: queryExt).toString();
            final NetOAuthUrl response = NetOAuthUrl();
            devLog.finest('$authUrl -> $authUrlExt');
            response.authUrl = authUrlExt;
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
    final DataAuth auth = authFromJwtPayload(call);

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
