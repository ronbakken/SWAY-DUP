/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'inf.pb.dart';
import 'remote_app.dart';

class RemoteAppUpload {
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  RemoteApp _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkSocket get ts {
    return _r.ts;
  }

  dospace.Bucket get bucket {
    return _r.bucket;
  }

  DataAccount get account {
    return _r.account;
  }

  int get accountId {
    return _r.account.state.accountId;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.RemoteAppOAuth');
  static final Logger devLog = new Logger('InfDev.RemoteAppOAuth');

  RemoteAppUpload(this._r) {
    _netUploadImageReq = _r.safeListen("UP_IMAGE", netUploadImageReq);
  }

  void dispose() {
    if (_netUploadImageReq != null) {
      _netUploadImageReq.cancel();
      _netUploadImageReq = null;
    }
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  StreamSubscription<TalkMessage> _netUploadImageReq; // UP_IMAGE
  static int _netUploadImageRes = TalkSocket.encode("OA_R_URL");
  Future<void> netUploadImageReq(TalkMessage message) async {
    NetUploadImageReq pb = new NetUploadImageReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    if (pb.contentLength > (5 * 1024 * 1204)) {
      opsLog.warning(
          "User $accountId attempts to upload file of size ${pb.contentLength}, that's too large");
      ts.sendException("Upload size limit exceeded", message);
      return;
    }

    if (!pb.contentType.startsWith('image/')) {
      opsLog.warning(
          "User $accountId attempts to upload file of type ${pb.contentType}, that's not supported");
      ts.sendException("Unsupported file type", message);
      return;
    }

    String uriExt;
    switch (pb.contentType) {
      case 'image/jpeg':
        uriExt = 'jpg';
        break;
      case 'image/png':
        uriExt = 'png';
        break;
      default:
        {
          int lastIndex = pb.fileName.lastIndexOf('.');
          uriExt = lastIndex > 0 ? pb.fileName.substring(lastIndex + 1) : 'bin';
        }
    }

    Digest contentSha256 = new Digest(pb.contentSha256);
    String key = "user/$accountId/$contentSha256" +
        (uriExt.length > 0 ? ('.' + uriExt) : '.bin');

    NetUploadImageRes netUploadImageRes = new NetUploadImageRes();

    ts.sendExtend(message);
    bool fileExists = false; // TODO: Use HEAD to check for existence
    await for (dospace.BucketContent bucketContent
        in bucket.listContents(prefix: key)) {
      if (bucketContent.key == key) {
        fileExists = true;
      }
    }

    // Request options
    if (!fileExists) {
      netUploadImageRes.requestMethod = 'PUT';
      netUploadImageRes.requestUrl = bucket.preSignUpload(key,
          contentLength: pb.contentLength,
          contentType: pb.contentType,
          contentSha256: contentSha256,
          permissions: dospace.Permissions.public);
    }

    // Result options
    netUploadImageRes.fileExists = fileExists;
    netUploadImageRes.uploadKey = key;
    netUploadImageRes.coverUrl = _r.makeCloudinaryCoverUrl(key);
    netUploadImageRes.thumbnailUrl = _r.makeCloudinaryThumbnailUrl(key);

    ts.sendMessage(_netUploadImageRes, netUploadImageRes.writeToBuffer(),
        replying: message);
  }
}
