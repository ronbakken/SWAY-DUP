/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:switchboard/switchboard.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'package:inf_common/inf_common.dart';
import 'api_channel.dart';

class ApiChannelUpload {
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  ApiChannel _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkChannel get channel {
    return _r.channel;
  }

  dospace.Bucket get bucket {
    return _r.bucket;
  }

  DataAccount get account {
    return _r.account;
  }

  Int64 get accountId {
    return _r.account.accountId;
  }

  GlobalAccountState get globalAccountState {
    return _r.account.globalAccountState;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.ApiChannelOAuth');
  static final Logger devLog = new Logger('InfDev.ApiChannelOAuth');

  ApiChannelUpload(this._r) {
    _r.registerProcedure(
        "UP_IMAGE", GlobalAccountState.readWrite, netUploadImageReq);
  }

  void dispose() {
    _r.unregisterProcedure("UP_IMAGE");
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  Future<void> netUploadImageReq(TalkMessage message) async {
    NetUploadImageReq pb = new NetUploadImageReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);

    if (pb.contentLength > (5 * 1024 * 1204)) {
      opsLog.warning(
          "User $accountId attempts to upload file of size ${pb.contentLength}, that's too large.");
      channel.replyAbort(message, "Upload size limit exceeded");
      return;
    }

    if (!pb.contentType.startsWith('image/')) {
      opsLog.warning(
          "User $accountId attempts to upload file of type ${pb.contentType}, that's not supported.");
      channel.replyAbort(message, "Unsupported file type");
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
          uriExt = lastIndex > 0
              ? pb.fileName.substring(lastIndex + 1).toLowerCase()
              : 'bin';
        }
    }

    Digest contentSha256 = new Digest(pb.contentSha256);
    String key = "${config.services.domain}/user/$accountId/$contentSha256.$uriExt";

    NetUploadImageRes netUploadImageRes = new NetUploadImageRes();

    channel.replyExtend(message);
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
      devLog.finest(netUploadImageRes.requestUrl);
    }

    // Result options
    netUploadImageRes.fileExists = fileExists;
    netUploadImageRes.uploadKey = key;
    netUploadImageRes.coverUrl = _r.makeCloudinaryCoverUrl(key);
    netUploadImageRes.thumbnailUrl = _r.makeCloudinaryThumbnailUrl(key);

    channel.replyMessage(
        message, "UP_R_IMG", netUploadImageRes.writeToBuffer());
  }
}
