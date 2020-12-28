/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:sway_common/inf_common.dart';
import 'package:mime/mime.dart';
import 'package:http_client/console.dart' as http_client;
import 'package:dospace/dospace.dart' as dospace;

Future<Uint8List> downloadData(
    http_client.Client httpClient, String url) async {
  final Uri uri = Uri.parse(url);
  // devLog.fine(uri);
  // devLog.fine(uri.host);
  final http_client.Request request = http_client.Request('GET', uri);
  final http_client.Response response = await httpClient.send(request);
  final BytesBuilder builder = BytesBuilder(copy: false);
  await response.body.forEach(builder.add);
  final Uint8List body = builder.toBytes();
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(response.reasonPhrase);
  }
  return body;
}

/// Downloads user image, returns key
Future<String> downloadUserImage(
    ConfigData config,
    http_client.Client httpClient,
    dospace.Bucket bucket,
    Int64 accountId,
    String url) async {
  // Fetch image to memory
  final Uri uri = Uri.parse(url);
  final Uint8List body = await downloadData(httpClient, url);

  // Get mime type
  String contentType = MimeTypeResolver().lookup(url, headerBytes: body);
  if (contentType == null) {
    contentType = 'application/octet-stream';
    // devLog.severe("Image '$url' does not have a detectable MIME type");
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
        final int lastIndex = uri.path.lastIndexOf('.');
        uriExt = lastIndex > 0
            ? uri.path.substring(lastIndex + 1).toLowerCase()
            : 'jpg';
      }
  }

  final Digest contentSha256 = sha256.convert(body);
  final String key =
      '${config.services.domain}/user/$accountId/$contentSha256.$uriExt';
  await bucket.uploadData(key, body, contentType, dospace.Permissions.public,
      contentSha256: contentSha256);
  return key;
}

/* end of file */
