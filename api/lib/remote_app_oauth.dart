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
    if (pb.oauthProvider < _r.config.oauthProviders.all.length) {
      ConfigOAuthProvider cfg = _r.config.oauthProviders.all[pb.oauthProvider];
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
          throw new Exception("OAuth provider has no supported mechanism specified ${pb.oauthProvider}");
        }
      }
    } else {
      throw new Exception("Invalid oauthProvider specified ${pb.oauthProvider}");
    }
  }

  StreamSubscription<TalkMessage> _netOAuthConnectReq; // OA_CONNE
  static int _netOAuthConnectRes = TalkSocket.encode("OA_R_CON");
  netOAuthConnectReq(TalkMessage message) async {
    devLog.finest("netOAuthConnectReq");
  }

}

/* end of file */
