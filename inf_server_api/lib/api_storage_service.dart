/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';

import 'package:dospace/dospace.dart' as dospace;
import 'package:grpc/grpc.dart' as grpc;

import 'package:inf_common/inf_common.dart';

class ApiStorageService extends ApiStorageServiceBase {
  final ConfigData config;
  final dospace.Bucket bucket;
  static final Logger opsLog = Logger('InfOps.ApiStorageService');
  static final Logger devLog = Logger('InfDev.ApiStorageService');

  ApiStorageService(this.config, this.bucket);

  String _makeImageUrl(String template, String key) {
    final int lastIndex = key.lastIndexOf('.');
    final String keyNoExt = lastIndex > 0 ? key.substring(0, lastIndex) : key;
    return template.replaceAll('{key}', key).replaceAll('{keyNoExt}', keyNoExt);
  }

  @override
  Future<NetUploadSigned> signImageUpload(
      grpc.ServiceCall call, NetUploadImage request) async {
    final DataAuth auth =
        DataAuth.fromJson(call.clientMetadata['x-jwt-payload'] ?? '{}');
    final Int64 accountId = auth.accountId;

    devLog.finest(call.clientMetadata);
    devLog.finest(auth);
    devLog.finest(request);

    if (auth.accountId == Int64.ZERO ||
        auth.globalAccountState.value < GlobalAccountState.readWrite.value) {
      throw grpc.GrpcError.permissionDenied();
    }

    if (request.contentLength > (5 * 1024 * 1204)) {
      opsLog.warning(
          "User $accountId attempts to upload file of size ${request.contentLength}, that's too large.");
      throw grpc.GrpcError.invalidArgument('Upload size limit exceeded');
    }

    if (!request.contentType.startsWith('image/')) {
      opsLog.warning(
          "User $accountId attempts to upload file of type ${request.contentType}, that's not supported.");
      throw grpc.GrpcError.invalidArgument('Unsupported file type');
    }

    String uriExt;
    switch (request.contentType) {
      case 'image/jpeg':
        uriExt = 'jpg';
        break;
      case 'image/png':
        uriExt = 'png';
        break;
      default:
        {
          final int lastIndex = request.fileName.lastIndexOf('.');
          uriExt = lastIndex > 0
              ? request.fileName.substring(lastIndex + 1).toLowerCase()
              : 'bin';
        }
    }

    final Digest contentSha256 = Digest(request.contentSha256);
    final String key =
        '${config.services.domain}/user/$accountId/$contentSha256.$uriExt';

    final NetUploadSigned response = NetUploadSigned();

    bool fileExists = false; // TODO(kaetemi): Use HEAD to check for existence
    await for (dospace.BucketContent bucketContent
        in bucket.listContents(prefix: key)) {
      if (bucketContent.key == key) {
        fileExists = true;
      }
    }

    // Request options
    if (!fileExists) {
      response.requestMethod = 'PUT';
      response.requestUrl = bucket.preSignUpload(key,
          contentLength: request.contentLength,
          contentType: request.contentType,
          contentSha256: contentSha256,
          permissions: dospace.Permissions.public);
      devLog.finest(response.requestUrl);
    }

    // Result options
    response.fileExists = fileExists;
    response.uploadKey = key;
    response.coverUrl = _makeImageUrl(config.services.galleryCoverUrl, key);
    response.thumbnailUrl =
        _makeImageUrl(config.services.galleryThumbnailUrl, key);

    return response;
  }
}

/* end of file */
