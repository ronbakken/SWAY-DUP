import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_api_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/money.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

class InfApiServiceMock implements InfApiService {
  List<BusinessOffer> allOffers;

  double zoomLevel = 11.5;

  BehaviorSubject<List<MapMarker>> makerSubject = BehaviorSubject<List<MapMarker>>();

  @override
  Observable<List<BusinessOffer>> getBusinessOffers(Filter filter) {
    return Observable.fromFuture(loadPartialBusinessOfferMockData());
  }

  @override
  Observable<List<BusinessOffer>> getFeaturedBusinessOffers(double longitude, double latitude) {
    return Observable.fromFuture(loadPartialBusinessOfferMockData());
  }

  // @override
  // Observable<List<Proposal>> getProposals(ProposalFilter filter) {
  //   return null; // TODO
  // }
  // @override
  // Future<Proposal> getProposalById(int proposalId) {
  //   throw Exception('Not implemented yet');
  // }

  @override
  Future<BusinessOffer> getOfferById(String offerId) {
    return Future.value(allOffers.firstWhere((x) => x.id == offerId, orElse: null));
  }

  @override
  Future<void> markChatAsRead(Proposal chat) {
    // TODO: implement markChatAsRead
    return null;
  }

  @override
  Future<void> postChatEntry(Proposal chat, ChatEntry entry) {
    // TODOement postChatEntry
    return null;
  }

  @override
  Observable<WaitingChats> waitingChatUpdates() {
    // TODO: implement waitingChatUpdates
    return null;
  }

  @override
  Observable<List<BusinessOffer>> getFilteredBusinessOffers() {
    // TODO: implement getFilteredBusinessOffers
    return null;
  }

  @override
  Observable<int> getFilteredBusinessOffersCount() {
    // TODO: implement getFilteredBusinessOffersCount
    return null;
  }

  @override
  Observable<List<MapMarker>> getMapMarkers() {
    if (zoomLevel >= 12) {
      makerSubject.add(allMarkers[0]);
    } else {
      makerSubject.add(allMarkers[1]);
    }
    return makerSubject;
  }

  @override
  void setMapBoundary(double topLeftLatitude, double topLeftLongitude, double bottomRightLatitude,
      double bottomRightLongitude, double zoomLevel) {
    if (zoomLevel != this.zoomLevel) {
      if (zoomLevel >= 12) {
        makerSubject.add(allMarkers[0]);
      } else {
        makerSubject.add(allMarkers[1]);
      }
    }
    this.zoomLevel = zoomLevel;
    print('Zoomlevel: $zoomLevel');
  }

  @override
  Future<void> setOfferFilter(Filter filter) {
    // TODO: implement setOfferFilter
    return null;
  }

  Future<List<BusinessOffer>> loadPartialBusinessOfferMockData() async {
    allOffers = await loadBusinessOfferMockData();
    return [
      BusinessOffer(
          id: '1',
          isPartial: true,
          numberOffered: 5,
          proposalStatus: OfferDto_ProposalStatus.none,
          businessName: 'CarWash Tom',
          businessAvatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          title: 'Car Wash',
          description:
              'Our car wash is the best car wash in the universe of car washes. We want more people to get to know our'
              'amazing service. '
              'Our car wash is the best car wash in the universe of car washes.',
          location: Location(latitude: 34.032395, longitude: -118.301019),
          terms: DealTerms(
            deliverable: Deliverable(
              description: 'Tell people how good our service is',
              types: [DeliverableType.post, DeliverableType.video],
              channels: [
                backend.get<ConfigService>().socialNetworkProviders[0],
                backend.get<ConfigService>().socialNetworkProviders[1]
              ],
            ),
            reward: Reward(
              description: 'One free premium car wash',
              type: RewardDto_Type.barter,
              barterValue: Money.fromInt(20),
              cashValue: Money.fromInt(1000),
            ),
          ),
          status: OfferDto_Status.active,
          statusReason: OfferDto_StatusReason.open,
          images: [
            ImageReference(
                lowresUrl:
                    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1_lowres.jpg?alt=media&token=cb093556-5af8-4dda-9979-2bc9ef6f42f2',
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1.jpg?alt=media&token=af2e4919-a67d-4e48-b7c0-286c2e444f2e')
          ],
          thumbnailImage: ImageReference(
              lowresUrl:
                  'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb_lowres.jpg?alt=media&token=6e219c88-d480-4ce5-8d75-b765b35df1f9',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb.jpg?alt=media&token=a3c145ef-790c-433d-ae11-7ea5c48eeb45')),
      BusinessOffer(
        id: '2',
        isPartial: true,
        proposalStatus: OfferDto_ProposalStatus.atLeastOne,
        businessName: 'Scent of Asia',
        businessAvatarThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        title: 'Spoon Ice Tea',
        description: 'Free ice tea if you stop by',
        numberOffered: 10,
        location: Location(latitude: 34.040031, longitude: -118.257318),
        terms: DealTerms(
          deliverable: Deliverable(
            description: 'Tell people how good our tea is',
            types: [DeliverableType.post],
            channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          ),
          reward: Reward(
            description: 'One ice tea for you and a friend',
            type: RewardDto_Type.barter,
            barterValue: Money.fromInt(5),
          ),
        ),
        status: OfferDto_Status.active,
        statusReason: OfferDto_StatusReason.open,
        images: [
          ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          ),
        ],
        thumbnailImage: ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb_lowres.jpg?alt=media&token=702a2349-6ef0-45a6-89c7-904dd8950e0a',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a'),
      ),
      BusinessOffer(
        id: '3',
        proposalStatus: OfferDto_ProposalStatus.none,
        businessName: 'Scent of Asia',
        businessAvatarThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        title: 'Spoon Ice Tea',
        description: 'Free ice tea if you stop by',
        numberOffered: 10,
        location: Location(latitude: 34.040031, longitude: -118.257318),
        terms: DealTerms(
          deliverable: Deliverable(
            description: 'Tell people how good our tea is',
            types: [DeliverableType.post, DeliverableType.mention],
            channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          ),
          reward: Reward(
            description: 'One ice tea for you and a friend',
            type: RewardDto_Type.barter,
            barterValue: Money.fromInt(5),
          ),
        ),
        status: OfferDto_Status.active,
        statusReason: OfferDto_StatusReason.open,
        images: [
          ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          ),
        ],
        thumbnailImage: ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb_lowres.jpg?alt=media&token=702a2349-6ef0-45a6-89c7-904dd8950e0a',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a'),
      ),
    ];
  }

  Future<List<BusinessOffer>> loadBusinessOfferMockData() async {
    return [
      BusinessOffer(
        id: '1',
        startDate: DateTime(2019, 1, 1),
        endDate: DateTime(2019, 3, 1),
        acceptancePolicy: OfferDto_AcceptancePolicy.allowNegotiation,
        proposalStatus: OfferDto_ProposalStatus.atLeastOne,
        businessAccountId: '1',
        businessName: 'CarWash Tom',
        businessDescription: 'We wash anything',
        businessAvatarThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        title: 'Car Wash',
        description:
            'Our car wash is the best car wash in the universe of car washes. We want more people to get to know our'
            'amazing service. '
            'Our car wash is the best car wash in the universe of car washes.',
        categories: [
          Category(CategoryDto()
            ..name = 'cars'
            ..description = 'All about cars')
        ],
        numberOffered: 0,
        location: Location(latitude: 34.032395, longitude: -118.301019),
        terms: DealTerms(
          deliverable: Deliverable(
            description: 'Tell people how good our service is',
            types: [DeliverableType.post, DeliverableType.video],
            channels: [
              backend.get<ConfigService>().socialNetworkProviders[0],
              backend.get<ConfigService>().socialNetworkProviders[1]
            ],
          ),
          reward: Reward(
            description: 'One free premium car wash',
            type: RewardDto_Type.barter,
            barterValue: Money.fromInt(20),
            cashValue: Money.fromInt(1000),
          ),
        ),
        status: OfferDto_Status.active,
        statusReason: OfferDto_StatusReason.open,
        images: [
          ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1_lowres.jpg?alt=media&token=cb093556-5af8-4dda-9979-2bc9ef6f42f2',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1.jpg?alt=media&token=af2e4919-a67d-4e48-b7c0-286c2e444f2e',
          ),
          ImageReference(
              lowresUrl:
                  'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_lowres.jpg?alt=media&token=f25fca74-8f5a-4356-b748-ca772f334431',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2.jpg?alt=media&token=0913cd09-1efc-47d6-a760-cbfe47476b5d')
        ],
        thumbnailImage: ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb_lowres.jpg?alt=media&token=6e219c88-d480-4ce5-8d75-b765b35df1f9',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb.jpg?alt=media&token=a3c145ef-790c-433d-ae11-7ea5c48eeb45'),
      ),
      BusinessOffer(
        id: '2',
        startDate: DateTime(2019, 1, 1),
        endDate: DateTime(2019, 3, 1),
        proposalStatus: OfferDto_ProposalStatus.none,
        businessAccountId: "1",
        businessName: 'Scent of Asia',
        businessDescription: 'Best flavoured teas in town',
        businessAvatarThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        title: 'Spoon Ice Tea',
        description: 'Free ice tea if you stop by',
        numberOffered: 10,
        categories: [
          Category(CategoryDto()
            ..name = 'food'
            ..description = 'All about food'),
          Category(CategoryDto()
            ..name = 'tea'
            ..description = 'Tea')
        ],
        location: Location(latitude: 34.040031, longitude: -118.257318),
        terms: DealTerms(
          deliverable: Deliverable(
            description: 'Tell people how good our tea is',
            types: [DeliverableType.post],
            channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          ),
          reward: Reward(
            description: 'One ice tea for you and a friend',
            type: RewardDto_Type.barter,
            barterValue: Money.fromInt(5),
          ),
        ),
        status: OfferDto_Status.active,
        statusReason: OfferDto_StatusReason.open,
        images: [
          ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          ),
          ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          )
        ],
        thumbnailImage: ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb_lowres.jpg?alt=media&token=702a2349-6ef0-45a6-89c7-904dd8950e0a',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a'),
      ),
      BusinessOffer(
        id: '3',
        proposalStatus: OfferDto_ProposalStatus.none,
        businessAccountId: "1",
        businessName: 'Scent of Asia',
        businessDescription: 'Best flavoured teas in town',
        businessAvatarThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        title: 'Spoon Ice Tea',
        description: 'Free ice tea if you stop by',
        numberOffered: 10,
        categories: [
          Category(CategoryDto()
            ..name = 'food'
            ..description = 'All about food'),
          Category(CategoryDto()
            ..name = 'tea'
            ..description = 'Tea')
        ],
        startDate: DateTime(2019, 1, 1),
        endDate: DateTime(2019, 3, 1),
        location: Location(latitude: 34.040031, longitude: -118.257318),
        terms: DealTerms(
          deliverable: Deliverable(
            description: 'Tell people how good our tea is',
            types: [DeliverableType.post],
            channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          ),
          reward: Reward(
            description: 'One ice tea for you and a friend',
            type: RewardDto_Type.barter,
            barterValue: Money.fromInt(5),
          ),
        ),
        status: OfferDto_Status.active,
        statusReason: OfferDto_StatusReason.open,
        images: [
          ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          ),
          ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2_lowres.jpg?alt=media&token=084f7e12-b9f0-4181-ba29-2d98bd56fdc3',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          )
        ],
        thumbnailImage: ImageReference(
            lowresUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb_lowres.jpg?alt=media&token=702a2349-6ef0-45a6-89c7-904dd8950e0a',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a'),
      ),
    ];
  }

  @override
  Observable<List<Proposal>> getProposals(String userId) {
    return Observable.fromFuture(loadProposalMockData());
  }

  Future<List<Proposal>> loadProposalMockData() async {
    return [
      Proposal(
        id: '1',
        offerId: 1,
        offerTitle: 'Spoon Ice Tea',
        lastTimeUpdated: DateTime.now().subtract(Duration(minutes: 10)),
        state: ProposalState.proposal,
        sentFrom: UserType.influencer,
        influencerId: "2",
        influencerName: 'Jane Doe',
        businessName: 'Scent of Asia',
        businessAvatarUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        influencerAvatarUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78',
        businessId: "1",
        text: 'I love all sorts of Tea and my followers love all sort of great food.'
            'So I think a selfy with me and your tea would fit great.',
        influencerWantsDeal: true,
        businessGaveRating: 0,
        influencerGaveRating: 0,
        influencerMarkedDelivered: false,
        businessMarkedDelivered: false,
        businessWantsDeal: false,
        businessDisputed: false,
        businessMarkedRewarded: false,
        influencerDisputed: false,
        influencerMarkedRewarded: false,
        offerThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a',
      ),
      Proposal(
        id: '2',
        offerId: 2,
        offerTitle: 'Car Wash',
        lastTimeUpdated: DateTime.now().subtract(Duration(hours: 5)),
        state: ProposalState.haggling,
        sentFrom: UserType.influencer,
        influencerId: '2',
        influencerName: 'Thomas',
        businessName: 'CarWash Tom',
        businessAvatarUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        influencerAvatarUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        businessId: '1',
        text: 'I could post a picture of my race car in front of your car wash',
        influencerWantsDeal: true,
        businessGaveRating: 0,
        influencerGaveRating: 0,
        influencerMarkedDelivered: false,
        businessMarkedDelivered: false,
        businessWantsDeal: false,
        businessDisputed: false,
        businessMarkedRewarded: false,
        influencerDisputed: false,
        influencerMarkedRewarded: false,
        offerThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb.jpg?alt=media&token=a3c145ef-790c-433d-ae11-7ea5c48eeb45',
      ),
      Proposal(
        id: '3',
        offerId: 1,
        offerTitle: 'Spoon Ice Tea',
        lastTimeUpdated: DateTime.now().subtract(Duration(days: 2)),
        state: ProposalState.done,
        sentFrom: UserType.business,
        influencerId: '43',
        influencerName: 'Jane Doe',
        businessName: 'CarWash Tom',
        businessAvatarUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
        influencerAvatarUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78',
        businessId: '42',
        text: 'I love all sorts of Tea and my followers love all sort of great food.'
            'So I think a selfy with me and your tea would fit great.',
        offerThumbnailUrl:
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a',
        influencerWantsDeal: true,
        businessGaveRating: 0,
        influencerGaveRating: 0,
        influencerMarkedDelivered: false,
        businessMarkedDelivered: false,
        businessWantsDeal: false,
        businessDisputed: false,
        businessMarkedRewarded: false,
        influencerDisputed: false,
        influencerMarkedRewarded: false,
      ),
    ];
  }

  List<List<MapMarker>> allMarkers = [
    [
      MapMarker(
          latitude: 34.043454, longitude: -118.314071, isDirectOffer: false, type: MapMarkerType.offer, offerId: 1),
      MapMarker(
          latitude: 34.044201, longitude: -118.318041, isDirectOffer: true, type: MapMarkerType.offer, offerId: 2),
      MapMarker(
          latitude: 34.053055, longitude: -118.318084, isDirectOffer: false, type: MapMarkerType.offer, offerId: 2),
      MapMarker(
          latitude: 34.047259, longitude: -118.324178, isDirectOffer: false, type: MapMarkerType.offer, offerId: 2),
      MapMarker(
          latitude: 34.058309, longitude: -118.303922, isDirectOffer: false, type: MapMarkerType.offer, offerId: 2),
      MapMarker(
          latitude: 34.061908, longitude: -118.299544, isDirectOffer: false, type: MapMarkerType.offer, offerId: 2),
      MapMarker(
          latitude: 34.066095, longitude: -118.305627, isDirectOffer: false, type: MapMarkerType.offer, offerId: 2),
      MapMarker(
          latitude: 34.068316, longitude: -118.309597, isDirectOffer: false, type: MapMarkerType.offer, offerId: 2),
      MapMarker(
          latitude: 34.065668,
          longitude: -118.314779,
          isDirectOffer: null,
          type: MapMarkerType.user,
          userType: UserType.business,
          userId: 42)
    ],
    [
      MapMarker(latitude: 34.044201, longitude: -118.318041, type: MapMarkerType.cluster, clusterCount: 15),
      MapMarker(latitude: 34.061908, longitude: -118.299544, type: MapMarkerType.cluster, clusterCount: 5),
      MapMarker(
          latitude: 34.065668,
          longitude: -118.314779,
          isDirectOffer: null,
          type: MapMarkerType.user,
          userType: UserType.business,
          userId: 42)
    ],
  ];
}
