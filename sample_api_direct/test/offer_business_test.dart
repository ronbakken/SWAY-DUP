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
import 'package:sway_common/inf_common.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:faker/faker.dart';

/*
Test suite for offers posted by a business.
*/

List<int> getLeafCategories(ConfigData config, List<int> categories) {
  final Set<int> res = Set<int>();
  res.addAll(categories);
  for (int category in categories) {
    int parent = config.categories[category].parentId;
    while (parent != 0) {
      res.remove(parent);
      parent = config.categories[parent].parentId;
    }
  }
  return res.toList();
}

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
  final Random random = Random();
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

  const bool devOverride = false;
  const String devIp = '192.168.43.202';

  setUpAll(() async {
    httpClient = http.Client();
    channel = grpc.ClientChannel(
      devOverride ? devIp : '127.0.0.1',
      port: 8080, // Connect to Envoy Proxy
      options: const grpc.ChannelOptions(
        credentials: grpc.ChannelCredentials.insecure(),
      ),
    );
    final ApiSessionClient sessionClient = ApiSessionClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer ${config.services.applicationToken}'
      }),
    );
    final NetSession influencerSession =
        await sessionClient.create(sessionCreateRequest);
    influencerAccessToken = influencerSession.accessToken;
    final NetSession businessSession =
        await sessionClient.create(sessionCreateRequest);
    businessAccessToken = businessSession.accessToken;
    influencerAccountClient = ApiAccountClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $influencerAccessToken'
      }),
    );
    businessAccountClient = ApiAccountClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $businessAccessToken'
      }),
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

  DataOffer offer;

  test('Create an offer', () async {
    final ApiOffersClient offersClient = ApiOffersClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $businessAccessToken'
      }),
    );

    final NetCreateOffer createOffer = NetCreateOffer();
    createOffer.offer = DataOffer();
    createOffer.offer.title = faker.conference.name();
    createOffer.offer.coverKeys.add(uploadSigned.uploadKey);
    createOffer.offer.description =
        'Presented to you by ${faker.person.name()} of ${faker.company.name()}';
    createOffer.offer.terms = DataTerms();
    createOffer.offer.terms.deliverablesDescription =
        'Post on ${faker.internet.domainWord()}';
    createOffer.offer.terms.rewardItemOrServiceDescription =
        '${faker.food.dish()}';
    for (int i = 2; i < (random.nextInt(4) + 4); ++i) {
      final int categoryId = random.nextInt(config.categories.length - 1) + 1;
      if (!createOffer.offer.categories.contains(categoryId)) {
        if (config.categories[categoryId].parentId != 0 ||
            config.categories[categoryId].childIds.isNotEmpty) {
          createOffer.offer.categories.add(categoryId);
        }
      }
    }
    List<int> categories =
        getLeafCategories(config, createOffer.offer.categories);
    expect(categories, isNotEmpty);
    createOffer.offer.categories.clear();
    for (int categoryId in categories) {
      createOffer.offer.categories.add(categoryId);
    }
    createOffer.offer.terms.deliverableSocialPlatforms.add(1);
    for (int i = 1; i < (random.nextInt(1) + 2); ++i) {
      final int platformId =
          random.nextInt(config.oauthProviders.length - 1) + 1;
      if (!createOffer.offer.terms.deliverableSocialPlatforms
          .contains(platformId)) {
        if (config.oauthProviders[platformId].visible) {
          createOffer.offer.terms.deliverableSocialPlatforms.add(platformId);
        }
      }
    }
    for (int i = 1; i < (random.nextInt(1) + 2); ++i) {
      final int formatId = random.nextInt(config.contentFormats.length - 1) + 1;
      if (!createOffer.offer.terms.deliverableContentFormats
          .contains(formatId)) {
        createOffer.offer.terms.deliverableContentFormats.add(formatId);
      }
    }
    createOffer.offer.terms.rewardCashValue = (random.nextInt(200) + 1) * 1000;
    createOffer.offer.terms.rewardItemOrServiceValue =
        (random.nextInt(20) + 1) * 1000;

    final NetOffer response = await offersClient.create(createOffer);
    expect(response.hasOffer(), isTrue);

    offer = response.offer;
    expect(offer.offerId, isNot(equals(Int64.ZERO)));
    expect(offer.title, equals(createOffer.offer.title));
    expect(offer.coverKeys, equals(createOffer.offer.coverKeys));
    expect(offer.description, equals(createOffer.offer.description));
    expect(offer.hasTerms(), isTrue);
    expect(offer.terms.deliverablesDescription,
        equals(createOffer.offer.terms.deliverablesDescription));
    expect(offer.terms.deliverableSocialPlatforms,
        equals(createOffer.offer.terms.deliverableSocialPlatforms));
    expect(offer.terms.deliverableContentFormats,
        equals(createOffer.offer.terms.deliverableContentFormats));
    expect(offer.terms.rewardItemOrServiceDescription,
        equals(createOffer.offer.terms.rewardItemOrServiceDescription));
    expect(offer.terms.rewardCashValue,
        equals(createOffer.offer.terms.rewardCashValue));
    expect(offer.terms.rewardItemOrServiceValue,
        equals(createOffer.offer.terms.rewardItemOrServiceValue));
    expect(offer.categories, equals(createOffer.offer.categories));
    expect(offer.hasLocationId(), isTrue);
    expect(offer.hasLocationAddress(), isTrue);
    expect(offer.senderName, equals(businessAccount.name));
    expect(offer.senderAccountId, equals(businessAccount.accountId));
    expect(offer.senderAccountType, equals(AccountType.business));
    expect(offer.senderAvatarUrl,
        equals(businessAccount.avatarUrl)); // TODO: Blurred data
    // expect(offer.locationAddress, equals(businessAccount.locationAddress)); // TODO: Account.locationAddress is missing
    expect(offer.hasStateReason(), isTrue);
    /*
    expect(offer.hasProposalsProposing(), isTrue);
    expect(offer.hasProposalsNegotiating(), isTrue);
    expect(offer.hasProposalsDeal(), isTrue);
    expect(offer.hasProposalsRejected(), isTrue);
    expect(offer.hasProposalsDispute(), isTrue);
    expect(offer.hasProposalsResolved(), isTrue);
    expect(offer.hasProposalsComplete(), isTrue);
    */
  });

  test('Business fetches own offer', () async {
    final ApiOffersClient offersClient = ApiOffersClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $businessAccessToken'
      }),
    );

    final NetGetOffer request = NetGetOffer();
    request.offerId = offer.offerId;
    final NetOffer response = await offersClient.get(request);
    expect(response.hasOffer(), isTrue);
    expect(response.detail, isTrue);
    expect(response.summary, isTrue);
    expect(response.state, isTrue);
    expect(response.offer.offerId, equals(offer.offerId));
    expect(response.offer, equals(offer));
    expect(response.offer.hasLocationId(), isTrue);
    expect(response.offer.hasLocationAddress(), isTrue);
  });

  test('Influencer fetches the same offer', () async {
    final ApiOffersClient offersClient = ApiOffersClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $influencerAccessToken'
      }),
    );

    final NetGetOffer request = NetGetOffer();
    request.offerId = offer.offerId;
    final NetOffer response = await offersClient.get(request);
    expect(response.hasOffer(), isTrue);
    expect(response.detail, isTrue);
    expect(response.summary, isTrue);
    expect(response.state, isTrue);
    expect(response.offer.offerId, equals(offer.offerId));
    expect(response.offer.offerId, isNot(equals(Int64.ZERO)));
    expect(response.offer.title, equals(offer.title));
    expect(response.offer.coverKeys, isEmpty);
    expect(response.offer.coverUrls, isNotEmpty);
    expect(response.offer.description, equals(offer.description));
    expect(response.offer.hasTerms(), isTrue);
    expect(response.offer.terms.deliverablesDescription,
        equals(offer.terms.deliverablesDescription));
    expect(response.offer.terms.deliverableSocialPlatforms,
        equals(offer.terms.deliverableSocialPlatforms));
    expect(response.offer.terms.deliverableContentFormats,
        equals(offer.terms.deliverableContentFormats));
    expect(response.offer.terms.rewardItemOrServiceDescription,
        equals(offer.terms.rewardItemOrServiceDescription));
    expect(response.offer.terms.rewardCashValue,
        equals(offer.terms.rewardCashValue));
    expect(response.offer.terms.rewardItemOrServiceValue,
        equals(offer.terms.rewardItemOrServiceValue));
    expect(response.offer.categories, equals(offer.categories));
    expect(response.offer, isNot(equals(offer)));
    // The location id is private to the business, influencer only gets a summary
    expect(response.offer.hasLocationId(), isFalse);
    expect(response.offer.hasLocationAddress(), isTrue);
    expect(response.offer.senderName, equals(businessAccount.name));
    expect(response.offer.senderAccountId, equals(businessAccount.accountId));
    expect(response.offer.senderAccountType, equals(AccountType.business));
    expect(response.offer.hasStateReason(), isFalse);
    expect(response.offer.hasArchived(), isFalse);
    expect(response.offer.hasProposalsProposing(), isFalse);
    expect(response.offer.hasProposalsNegotiating(), isFalse);
    expect(response.offer.hasProposalsDeal(), isFalse);
    expect(response.offer.hasProposalsRejected(), isFalse);
    expect(response.offer.hasProposalsDispute(), isFalse);
    expect(response.offer.hasProposalsResolved(), isFalse);
    expect(response.offer.hasProposalsComplete(), isFalse);
    expect(response.offer.hasProposalId(),
        isFalse); // TODO: Verify this goes true after proposing
  });

  test('Force Elasticsearch to refresh (created offer)', () async {
    // Elasticsearch has a 1s delay for refreshing
    final String endPoint = devOverride
        ? 'http://$devIp:9200'
        : serverConfig.services.elasticsearchApi;
    final Map<String, String> headers = serverConfig
            .services.elasticsearchBasicAuth.isNotEmpty
        ? <String, String>{
            'Authorization': 'Basic ' +
                base64.encode(
                    utf8.encode(serverConfig.services.elasticsearchBasicAuth)),
            'Content-Type': 'application/json'
          }
        : <String, String>{'Content-Type': 'application/json'};
    final String url = endPoint + '/_refresh';
    final http.Response response =
        await httpClient.post(url, headers: headers, body: '{}');
    expect(response.statusCode, equals(200));
  });

  test('Business offer list contains the offer', () async {
    final ApiOffersClient offersClient = ApiOffersClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $businessAccessToken'
      }),
    );

    final NetListOffers request = NetListOffers();
    final List<NetOffer> responses = await offersClient.list(request).toList();
    NetOffer offerSummary;
    expect(responses, isNotEmpty);
    log.finest('Look for ${offer.offerId} in list size ${responses.length}');
    for (NetOffer netOffer in responses) {
      expect(netOffer.summary, isTrue);
      expect(netOffer.detail, isFalse);
      expect(netOffer.state, isTrue);
      expect(netOffer.hasOffer(), isTrue);
      log.finest(netOffer.offer.offerId);
      if (netOffer.offer.offerId == offer.offerId) {
        expect(offerSummary, isNull);
        offerSummary = netOffer;
      }
    }

    expect(offerSummary, isNotNull);
    expect(offerSummary.hasOffer(), isTrue);
    expect(offerSummary.offer.title, equals(offer.title));
    expect(offerSummary.offer.hasDescription(), isFalse);
  });

  test('Influencer offer list does not contain the offer', () async {
    final ApiOffersClient offersClient = ApiOffersClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $influencerAccessToken'
      }),
    );

    final NetListOffers request = NetListOffers();
    final List<NetOffer> responses = await offersClient.list(request).toList();
    expect(() {
      responses
          .firstWhere((NetOffer value) => value.offer.offerId == offer.offerId);
    }, throwsA(const TypeMatcher<StateError>()));
  });
}

/* end of file */
