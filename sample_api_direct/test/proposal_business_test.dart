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
import 'package:faker/faker.dart';

/*
Test suite for proposals made by an influencer to offers posted by a business.
*/

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
  DataOffer offer;

  final NetSessionCreate sessionCreateRequest = NetSessionCreate();
  sessionCreateRequest.domain = config.services.domain;
  sessionCreateRequest.clientVersion = config.clientVersion;
  sessionCreateRequest.deviceToken = Uint8List(32);
  sessionCreateRequest.deviceName = 'oauth_test';
  sessionCreateRequest.deviceInfo = '{}';
  sessionCreateRequest.freeze();

  int nextSessionGhostId =
      (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) & 0xFFFFFFF;

  const bool devOverride = true;
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

    final Map<String, String> pexelsHeaders = <String, String>{
      'authorization': serverConfig.services.pexelsKey,
    };
    String imageUrl;
    Uint8List imageData;
    final String url = serverConfig.services.pexelsApi +
        '/v1/curated?per_page=1&page=' +
        (random.nextInt(999) + 1).toString();
    final http.Response pexelsResponse =
        await httpClient.get(url, headers: pexelsHeaders);
    expect(pexelsResponse.statusCode, equals(200));
    // log.finest(pexelsResponse.body);
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

    final ApiStorageClient storageClient = ApiStorageClient(
      channel,
      options: grpc.CallOptions(metadata: <String, String>{
        'authorization': 'Bearer $businessAccessToken'
      }),
    );

    // Image info
    final Digest imageSha256 = sha256.convert(imageData);
    final String imageContentType =
        MimeTypeResolver().lookup(imageUrl, headerBytes: imageData);
    log.fine(imageContentType);
    expect(imageContentType, startsWith('image/'));

    // Upload image
    // Create a request to upload the file
    final NetUploadImage uploadRequest = NetUploadImage();
    uploadRequest.fileName = Uri.parse(imageUrl).path;
    uploadRequest.contentLength = imageData.length;
    uploadRequest.contentType = imageContentType;
    uploadRequest.contentSha256 = imageSha256.bytes;
    uploadRequest.freeze();

    // log.finest(request);
    final uploadSigned = await storageClient.signImageUpload(uploadRequest);
    expect(uploadSigned, isNotNull);
    // log.fine(uploadSigned);

    if (uploadSigned.fileExists) {
      // log.warning('Upload test skipped, upload already exists');
    } else {
      // Upload the file
      final http.StreamedRequest httpRequest = http.StreamedRequest(
          uploadSigned.requestMethod, Uri.parse(uploadSigned.requestUrl));
      httpRequest.headers['Content-Type'] = uploadRequest.contentType;
      httpRequest.headers['Content-Length'] =
          uploadRequest.contentLength.toString();
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

    // Create offer
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
        'Post on ${faker.internet.userName()}gram';
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

    final NetOffer offerResponse = await offersClient.create(createOffer);
    expect(offerResponse.hasOffer(), isTrue);

    offer = offerResponse.offer;
    expect(offer.offerId, isNot(equals(Int64.ZERO)));
    expect(offer.title, equals(createOffer.offer.title));
    expect(offer.description, equals(createOffer.offer.description));
    expect(offer.hasTerms(), isTrue);
  });

  tearDownAll(() async {
    await channel.terminate();
  });

  group('Apply and deal without negotiation', () {
    DataOffer offerAsInfluencer;

    test('Influencer fetches the offer', () async {
      offerAsInfluencer = null;
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
      expect(response.offer.hasProposalId(),
          isFalse); // TODO: Verify this goes true after proposing
      offerAsInfluencer = offer;
    });

    // TODO: Validate push messages are sent and received (including on secondary sessions)

    test('Business cannot apply to a business offer', () async {
      final NetApplyProposal request = NetApplyProposal();
      request.offerId = offerAsInfluencer.offerId;
      request.remarks = 'I am the most excellent ${faker.job.title()}';
      request.sessionGhostId = ++nextSessionGhostId;
      request.freeze();
      final ApiProposalsClient proposalsClient = ApiProposalsClient(
        channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer $businessAccessToken'
        }),
      );
      expect(proposalsClient.apply(request),
          throwsA(const TypeMatcher<grpc.GrpcError>()));
    });

    Int64 proposalId;
    DataProposalChat termsChat;
    DataProposalChat lastChat;
    // DataProposalChat markerChat;

    test('Apply for the offer without negotiation', () async {
      proposalId = null;
      termsChat = null;
      lastChat = null;
      // markerChat = null;
      final NetApplyProposal request = NetApplyProposal();
      request.offerId = offerAsInfluencer.offerId;
      request.remarks = 'I am the most excellent ${faker.job.title()}';
      request.sessionGhostId = ++nextSessionGhostId;
      request.freeze();
      final ApiProposalsClient proposalsClient = ApiProposalsClient(
        channel,
        options: grpc.CallOptions(metadata: <String, String>{
          'authorization': 'Bearer $influencerAccessToken'
        }),
      );
      final NetProposal proposalResponse = await proposalsClient.apply(request);
      proposalId = proposalResponse.proposal.proposalId;
      expect(proposalResponse.hasProposal(), isTrue);
      expect(proposalResponse.proposal.proposalId, isNot(equals(Int64.ZERO)));
      expect(
          proposalResponse.proposal.businessName, equals(businessAccount.name));
      expect(proposalResponse.proposal.influencerName,
          equals(influencerAccount.name));
      expect(proposalResponse.proposal.offerTitle,
          equals(offerAsInfluencer.title));
      expect(proposalResponse.proposal.state, equals(ProposalState.proposing));
      expect(proposalResponse.proposal.termsChatId, isNot(equals(Int64.ZERO)));
      expect(proposalResponse.proposal.lastChatId, isNot(equals(Int64.ZERO)));
      for (DataProposalChat chat in proposalResponse.chats) {
        if (chat.chatId == proposalResponse.proposal.termsChatId) {
          // The terms chat exists
          termsChat = chat;
        }
        if (chat.chatId == proposalResponse.proposal.lastChatId) {
          // Last chat is valid
          lastChat = chat;
        }
        /*
        // Disabled. For now the terms chat counts as marker.
        if (chat.type == ProposalChatType.marker &&
            chat.marker == ProposalChatMarker.applied) {
          // There must be a marker chat to signal the new proposal
          markerChat = chat;
        }
        */
      }
      expect(termsChat, isNotNull);
      expect(lastChat, isNotNull);
      // expect(markerChat, isNotNull);
      // Terms without negotiation must match the offer terms
      expect(termsChat.terms, equals(offerAsInfluencer.terms));
      // Last chat must be the highest chat id
      for (DataProposalChat chat in proposalResponse.chats) {
        expect(chat.chatId, lessThanOrEqualTo(lastChat.chatId));
      }
      // Terms is the last chat id
      expect(termsChat.chatId, equals(lastChat.chatId));
    });
  });
}

/* end of file */
