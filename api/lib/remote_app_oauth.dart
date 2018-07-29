/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:oauth1/oauth1.dart' as oauth1;

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
      ConfigOAuthProvider cfg = config.oauthProviders.all[pb.oauthProvider];
      NetOAuthConnectRes pbRes = new NetOAuthConnectRes();
      bool transitionAccount = false;
      String oauthToken;
      String oauthTokenSecret;
      String oauthUserId;
      String screenName;
      switch (cfg.mechanism) {
        case OAuthMechanism.OAM_OAUTH1: {
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
            devLog.finest(authRes.credentials.token);
            devLog.finest(authRes.credentials.tokenSecret);
            devLog.finest(authRes.optionalParameters);
            oauthToken = authRes.credentials.token;
            oauthTokenSecret = authRes.credentials.tokenSecret;
            oauthUserId = authRes.optionalParameters['user_id'];
            screenName = authRes.optionalParameters['user_id'];
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
      // Simply send update of specific social media
      pbRes.socialMedia = _r.socialMedia[pb.oauthProvider];
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

}

/* end of file */
