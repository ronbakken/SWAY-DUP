/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:geohash/geohash.dart';
import 'package:inf_server_api/api_channel_offer.dart';
import 'package:inf_server_api/api_channel_proposal.dart';
import 'package:inf_server_api/api_channel_proposal_transactions.dart';
import 'package:inf_server_api/api_service.dart';
import 'package:inf_server_api/elasticsearch.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:sqljocky5/sqljocky.dart' as sqljocky;
// import 'package:crypto/crypto.dart';
import 'package:http_client/console.dart' as http;
import 'package:synchronized/synchronized.dart';
import 'package:mime/mime.dart';
import 'package:dospace/dospace.dart' as dospace;
import 'package:s2geometry/s2geometry.dart';

import 'package:inf_common/inf_common.dart';
import 'broadcast_center.dart';
import 'api_channel_profile.dart';
import 'api_channel_haggle_actions.dart';

// TODO: Move sql queries into a separate shared class, to allow prepared statements, and simplify code here

class ApiChannel {
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Onboarding messages
  /////////////////////////////////////////////////////////////////////



  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // Utility
  /////////////////////////////////////////////////////////////////////



  Future<Uint8List> downloadData(String url) async {
    final Uri uri = Uri.parse(url);
    devLog.fine(uri);
    devLog.fine(uri.host);
    final http.Request request = http.Request('GET', uri);
    final http.Response response = await httpClient.send(request);
    final BytesBuilder builder = BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    Uint8List body = builder.toBytes();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.reasonPhrase);
    }
    return body;
  }

  /// Downloads user image, returns key
  Future<String> downloadUserImage(Int64 accountId, String url) async {
    // Fetch image to memory
    Uri uri = Uri.parse(url);
    /*
    http.Request request = http.Request('GET', uri);
    http.Response response = await httpClient.send(request);
    BytesBuilder builder = BytesBuilder(copy: false);
    await response.body.forEach(builder.add);
    Uint8List body = builder.toBytes();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(response.reasonPhrase);
    }*/
    Uint8List body = await downloadData(url);

    // Get mime type
    String contentType = MimeTypeResolver().lookup(url, headerBytes: body);
    if (contentType == null) {
      contentType = 'application/octet-stream';
      devLog.severe("Image '$url' does not have a detectable MIME type");
    }

    // Get hash and generate filename
    String uriExt;
    switch (contentType) {
      case 'image/jpeg':
        uriExt = 'jpg';
        break;
      case 'image/png':
        uriExt = 'png';
        break;
      case 'image/gif':
        uriExt = 'gif';
        break;
      case 'image/webp':
        uriExt = 'webp';
        break;
      case 'image/heif':
        uriExt = 'heif';
        break;
      default:
        {
          int lastIndex = uri.path.lastIndexOf('.');
          uriExt = lastIndex > 0
              ? uri.path.substring(lastIndex + 1).toLowerCase()
              : 'jpg';
        }
    }

    Digest contentSha256 = sha256.convert(body);
    String key =
        "${config.services.domain}/user/$accountId/$contentSha256.$uriExt";
    bucket.uploadData(key, body, contentType, dospace.Permissions.public,
        contentSha256: contentSha256);
    return key;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  // App
  /////////////////////////////////////////////////////////////////////

}

/* end of file */
