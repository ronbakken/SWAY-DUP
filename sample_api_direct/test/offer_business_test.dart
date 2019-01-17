/*
INF Marketplace
Copyright (C) 2018-2019  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

Future<void> main() async {
  // Logging
  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.error == null) {
      print(
          '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}');
    } else {
      print(
          '${rec.loggerName}: ${rec.level.name}: ${rec.time}: ${rec.message}\n${rec.error.toString()}\n${rec.stackTrace.toString()}');
    }
  });
  final Logger log = Logger('OfferBusinessTest');

  // Config
  const String configFile = '../assets/config_local.bin';
  log.info("Config file: '$configFile'");
  final Uint8List configBytes = await File(configFile).readAsBytes();
  final ConfigData config = ConfigData();
  config.mergeFromBuffer(configBytes);

  // Server Config
  const String serverConfigFile = '../assets/config_local_server.bin';
  log.info("Server Config file: '$serverConfigFile'");
  final Uint8List serverConfigBytes =
      await File(serverConfigFile).readAsBytes();
  final ConfigData serverConfig = ConfigData();
  serverConfig.mergeFromBuffer(serverConfigBytes);

  // Setup
  http.Client httpClient;
  Random random = Random();
  grpc.ClientChannel channel;
  String influencerAccessToken;
  String businessAccessToken;
  ApiAccountClient influencerAccountClient;
  ApiAccountClient businessAccountClient;
  DataAccount influencerAccount;
  DataAccount businessAccount;

  final NetSessionCreate sessionCreateRequest = NetSessionCreate();
  sessionCreateRequest.domain = config.services.domain;
  sessionCreateRequest.clientVersion = config.clientVersion;
  sessionCreateRequest.deviceToken = Uint8List(32);
  sessionCreateRequest.deviceName = 'oauth_test';
  sessionCreateRequest.deviceInfo = '{}';
  sessionCreateRequest.freeze();

  setUpAll(() async {
    httpClient = http.Client();
    channel = grpc.ClientChannel(
      '192.168.43.202', //'127.0.0.1', //
      port: 8080, // Connect to Envoy Proxy
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
    final ApiSessionClient sessionClient = ApiSessionClient(channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer ${config.services.applicationToken}'
        }));
    final NetSession influencerSession =
        await sessionClient.create(sessionCreateRequest);
    influencerAccessToken = influencerSession.accessToken;
    final NetSession businessSession =
        await sessionClient.create(sessionCreateRequest);
    businessAccessToken = businessSession.accessToken;
    influencerAccountClient = ApiAccountClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'authorization': 'Bearer $influencerAccessToken'
        },
      ),
    );
    businessAccountClient = ApiAccountClient(
      channel,
      options: grpc.CallOptions(
        metadata: <String, String>{
          'authorization': 'Bearer $businessAccessToken'
        },
      ),
    );
    final NetSetAccountType setTypeRequest = NetSetAccountType();
    setTypeRequest.accountType = AccountType.influencer;
    await influencerAccountClient.setType(setTypeRequest);
    setTypeRequest.accountType = AccountType.business;
    await businessAccountClient.setType(setTypeRequest);
    final NetOAuthConnect request = NetOAuthConnect();
    request.oauthProvider = OAuthProviderIds.twitter.value;

    // Log into or create influencer account
    request.callbackQuery =
        'oauth_token=1085053886933565440-t6ce1nK4D7yjxtjciRXEBQjjJb6Cue&oauth_token_secret=zQgdWQ40LB6sVsj76Q7LiV20lOTaAlpYHJ2Vt8KCKQgNF';
    NetOAuthConnection response =
        await influencerAccountClient.connectProvider(request);
    expect(response.hasSocialMedia(), isTrue);
    expect(response.socialMedia.connected, isTrue);
    if (!response.hasAccount()) {
      final NetAccountCreate createRequest = NetAccountCreate();
      createRequest.latitude = 34.0718836; // Nearby Wally's
      createRequest.longitude = -118.4032531;
      final NetSession account =
          await influencerAccountClient.create(createRequest);
      if (account.hasAccount()) {
        influencerAccount = account.account;
        influencerAccessToken = account.accessToken;
      }
    } else {
      influencerAccount = response.account;
      influencerAccessToken = response.accessToken;
    }
    expect(influencerAccount, isNotNull);

    // Log into or create business account
    request.callbackQuery =
        'oauth_token=1085549519767400449-enBoFc1UbJcBA3OUGUuYSwkEKFWDyV&oauth_token_secret=KUtP7MtArBfo4mNfFdlmdiTcMzu5XaxsmY4OWxWbcZF2q';
    response = await businessAccountClient.connectProvider(request);
    expect(response.hasSocialMedia(), isTrue);
    expect(response.socialMedia.connected, isTrue);
    if (!response.hasAccount()) {
      final NetAccountCreate createRequest = NetAccountCreate();
      createRequest.latitude = 34.0807925; // Nearby Craig's
      createRequest.longitude = -118.3886626;
      final NetSession account =
          await businessAccountClient.create(createRequest);
      if (account.hasAccount()) {
        businessAccount = account.account;
        businessAccessToken = account.accessToken;
      }
    } else {
      businessAccount = response.account;
      businessAccessToken = response.accessToken;
    }
    expect(businessAccount, isNotNull);

    log.fine(influencerAccount);
    log.fine(businessAccount);
    expect(influencerAccount.accountType, equals(AccountType.influencer));
    expect(businessAccount.accountType, equals(AccountType.business));
    expect(influencerAccount.name, equals('INF Sandbox'));
    expect(businessAccount.name, equals('INF Boxsand'));
  });

  tearDownAll(() async {
    await channel.terminate();
  });

  String imageUrl;
  Uint8List imageData;
  final Map<String, String> pexelsHeaders = <String, String>{
    'authorization': serverConfig.services.pexelsKey,
  };

  test('Download testing image', () async {
    final String url = serverConfig.services.pexelsApi +
        '/v1/curated?per_page=1&page=' +
        (random.nextInt(999) + 1).toString();
    final http.Response pexelsResponse =
        await httpClient.get(url, headers: pexelsHeaders);
    expect(pexelsResponse.statusCode, equals(200));
    log.finest(pexelsResponse.body);
    final dynamic pexelsDoc = json.decode(pexelsResponse.body);
    expect(pexelsDoc['photos'][0]['id'], isNonZero);
    expect(pexelsDoc['photos'][0]['src']['large2x'], isNotEmpty);
    imageUrl = pexelsDoc['photos'][0]['src']['large2x'];
    log.fine(imageUrl);
    final http.Response imageResponse =
        await httpClient.get(imageUrl, headers: pexelsHeaders);
    expect(imageResponse.statusCode, equals(200));
    imageData = imageResponse.bodyBytes;
    expect(imageData, isNotEmpty);
  });

  Digest imageSha256;

  test('Calculate SHA256 of testing image', () async {
    imageSha256 = sha256.convert(imageData);
    log.fine(imageSha256);
  });

  String imageContentType;

  test('Verify content type is image', () async {
    imageContentType =
        MimeTypeResolver().lookup(imageUrl, headerBytes: imageData);
    log.fine(imageContentType);
    expect(imageContentType, startsWith('image/'));
  });

  NetUploadSigned uploadSigned;

  test('Upload image', () async {
    final ApiStorageClient storageClient = ApiStorageClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $businessAccessToken'
      }),
    );

    // Create a request to upload the file
    final NetUploadImage request = NetUploadImage();
    request.fileName = Uri.parse(imageUrl).path;
    request.contentLength = imageData.length;
    request.contentType = imageContentType;
    request.contentSha256 = imageSha256.bytes;
    request.freeze();

    log.finest(request);
    uploadSigned = await storageClient.signImageUpload(request);
    expect(uploadSigned, isNotNull);
    log.fine(uploadSigned);

    if (uploadSigned.fileExists) {
      log.warning('Upload test skipped, upload already exists');
    } else {
      // Upload the file
      final http.StreamedRequest httpRequest = http.StreamedRequest(
          uploadSigned.requestMethod, Uri.parse(uploadSigned.requestUrl));
      httpRequest.headers['Content-Type'] = request.contentType;
      httpRequest.headers['Content-Length'] = request.contentLength.toString();
      // TODO: DigitalOcean Spaces doesn't process this option when in pre-signed URL query
      httpRequest.headers['x-amz-acl'] = 'public-read';
      final Future<http.StreamedResponse> futureResponse = httpRequest.send();
      httpRequest.sink.add(imageData);
      httpRequest.sink.close();
      final http.StreamedResponse httpResponse = await futureResponse;
      expect(httpResponse.statusCode, equals(200));
    }

    expect(uploadSigned.uploadKey, isNotEmpty);
    expect(uploadSigned.coverUrl, isNotEmpty);
    expect(uploadSigned.thumbnailUrl, isNotEmpty);
  });

  test('Attempt to download thumbnail image', () async {
    expect(uploadSigned, isNotNull);
    final http.Response imageResponse =
        await httpClient.get(uploadSigned.thumbnailUrl);
    expect(imageResponse.statusCode, equals(200));
    expect(imageResponse.bodyBytes, isNotEmpty);
  });

  test('Attempt to download cover image', () async {
    expect(uploadSigned, isNotNull);
    final http.Response imageResponse =
        await httpClient.get(uploadSigned.coverUrl);
    expect(imageResponse.statusCode, equals(200));
    expect(imageResponse.bodyBytes, isNotEmpty);
  });

  test('Image reupload attempt must be flagged as already existing', () async {
    final ApiStorageClient storageClient = ApiStorageClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $businessAccessToken'
      }),
    );

    // Create a request to upload the file
    final NetUploadImage request = NetUploadImage();
    request.fileName = Uri.parse(imageUrl).path;
    request.contentLength = imageData.length;
    request.contentType = imageContentType;
    request.contentSha256 = imageSha256.bytes;
    request.freeze();

    final NetUploadSigned response =
        await storageClient.signImageUpload(request);

    // Must already exist
    expect(response.fileExists, isTrue);
    expect(response.uploadKey, isNotEmpty);
  });

  /*
  test('Create an offer', () async {
  });
  */
}

/* end of file */
