import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/inf_api_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';

class InfApiServiceMock implements InfApiService {
  List<BusinessOffer> allOffers;

  double zoomLevel = 11.5;

  BehaviorSubject<List<MapMarker>> makerSubject = BehaviorSubject<List<MapMarker>>();

  @override
  Observable<List<BusinessOffer>> getBusinessOffers(OfferFilter filter) {
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
  Future<BusinessOffer> getOfferById(int offerId) {
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
  Future<void> setOfferFilter(OfferFilter filter) {
    // TODO: implement setOfferFilter
    return null;
  }

  Future<List<BusinessOffer>> loadPartialBusinessOfferMockData() async {
    allOffers = await loadBusinessOfferMockData();
    return [
      BusinessOffer(
          id: 1,
          isPartial: true,
          isDirectOffer: false,
          numberOffered: 5,
          userIdsThatHaveProposed: [],
          businessName: 'CarWash Tom',
          businessAvatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          title: 'Car Wash',
          description:
              'Our car wash is the best car wash in the universe of car washes. We want more people to get to know our'
              'amazing service. '
              'Our car wash is the best car wash in the universe of car washes.',
          channels: [
            backend.get<ConfigService>().socialNetworkProviders[0],
            backend.get<ConfigService>().socialNetworkProviders[1]
          ],
          location: Location(latitude: 34.032395, longitude: -118.301019),
          terms: DealTerms(
            deliverable: Deliverable(
                description: 'Tell people how good our service is',
                types: [DeliverableType.POST, DeliverableType.VIDEO]),
            reward: Reward(
              description: 'One free premium car wash',
              type: RewardType.barter,
              barterValue: Decimal.fromInt(20),
              cashValue: Decimal.fromInt(1000),
            ),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          imagesLowRes: [(await rootBundle.load('assets/mockdata/car_wash1_lowres.jpg')).buffer.asUint8List()],
          imageUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1.jpg?alt=media&token=af2e4919-a67d-4e48-b7c0-286c2e444f2e'
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/car_wash2_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb.jpg?alt=media&token=a3c145ef-790c-433d-ae11-7ea5c48eeb45'),
      BusinessOffer(
          id: 2,
          isPartial: true,
          userIdsThatHaveProposed: ['abc'],
          businessName: 'Scent of Asia',
          businessAvatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          title: 'Spoon Ice Tea',
          description: 'Free ice tea if you stop by',
          numberOffered: 10,
          channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          location: Location(latitude: 34.040031, longitude: -118.257318),
          terms: DealTerms(
            deliverable: Deliverable(description: 'Tell people how good our tea is', types: [DeliverableType.POST]),
            reward: Reward(
              description: 'One ice tea for you and a friend',
              type: RewardType.barter,
              barterValue: Decimal.fromInt(5),
            ),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          imagesLowRes: [(await rootBundle.load('assets/mockdata/ice_tea_lowres.jpg')).buffer.asUint8List()],
          imageUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/ice_tea_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a'),
      BusinessOffer(
          id: 3,
          userIdsThatHaveProposed: [],
          businessName: 'Scent of Asia',
          businessAvatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          title: 'Spoon Ice Tea',
          description: 'Free ice tea if you stop by',
          numberOffered: 10,
          channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          location: Location(latitude: 34.040031, longitude: -118.257318),
          terms: DealTerms(
            deliverable: Deliverable(
                description: 'Tell people how good our tea is', types: [DeliverableType.POST, DeliverableType.MENTION]),
            reward: Reward(
              description: 'One ice tea for you and a friend',
              type: RewardType.barter,
              barterValue: Decimal.fromInt(5),
            ),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          imagesLowRes: [(await rootBundle.load('assets/mockdata/ice_tea_lowres.jpg')).buffer.asUint8List()],
          imageUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/ice_tea_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a'),
    ];
  }

  Future<List<BusinessOffer>> loadBusinessOfferMockData() async {
    return [
      BusinessOffer(
          id: 1,
          startDate: DateTime(2019, 1, 1),
          endDate: DateTime(2019, 3, 1),
          acceptancePolicy: AcceptancePolicy.allowNegotiation,
          userIdsThatHaveProposed: [],
          businessAccountId: 42,
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
          channels: [
            backend.get<ConfigService>().socialNetworkProviders[0],
            backend.get<ConfigService>().socialNetworkProviders[1]
          ],
          unlimitedAvailable: true,
          location: Location(latitude: 34.032395, longitude: -118.301019),
          terms: DealTerms(
            deliverable: Deliverable(
                description: 'Tell people how good our service is',
                types: [DeliverableType.POST, DeliverableType.VIDEO]),
            reward: Reward(
              description: 'One free premium car wash',
              type: RewardType.barter,
              barterValue: Decimal.fromInt(20),
              cashValue: Decimal.fromInt(1000),
            ),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          imagesLowRes: [
            (await rootBundle.load('assets/mockdata/car_wash1_lowres.jpg')).buffer.asUint8List(),
            (await rootBundle.load('assets/mockdata/car_wash2_lowres.jpg')).buffer.asUint8List(),
          ],
          imageUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1.jpg?alt=media&token=af2e4919-a67d-4e48-b7c0-286c2e444f2e',
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2.jpg?alt=media&token=0913cd09-1efc-47d6-a760-cbfe47476b5d'
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/car_wash2_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb.jpg?alt=media&token=a3c145ef-790c-433d-ae11-7ea5c48eeb45'),
      BusinessOffer(
          id: 2,
          startDate: DateTime(2019, 1, 1),
          endDate: DateTime(2019, 3, 1),
          userIdsThatHaveProposed: [],
          businessAccountId: 43,
          businessName: 'Scent of Asia',
          businessDescription: 'Best flavoured teas in town',
          businessAvatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          title: 'Spoon Ice Tea',
          description: 'Free ice tea if you stop by',
          numberOffered: 10,
          unlimitedAvailable: false,
          categories: [
            Category(CategoryDto()
              ..name = 'food'
              ..description = 'All about food'),
            Category(CategoryDto()
              ..name = 'tea'
              ..description = 'Tea')
          ],
          channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          location: Location(latitude: 34.040031, longitude: -118.257318),
          terms: DealTerms(
            deliverable: Deliverable(description: 'Tell people how good our tea is', types: [DeliverableType.POST]),
            reward: Reward(
              description: 'One ice tea for you and a friend',
              type: RewardType.barter,
              barterValue: Decimal.fromInt(5),
            ),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          imagesLowRes: [
            (await rootBundle.load('assets/mockdata/ice_tea_lowres.jpg')).buffer.asUint8List(),
            (await rootBundle.load('assets/mockdata/ice_tea2_lowres.jpg')).buffer.asUint8List(),
          ],
          imageUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2.jpg?alt=media&token=e4b231d1-a4d3-419b-9c50-8b05fd4ab8d7'
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/ice_tea_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a'),
      BusinessOffer(
          id: 3,
          userIdsThatHaveProposed: [],
          businessAccountId: 43,
          businessName: 'Scent of Asia',
          businessDescription: 'Best flavoured teas in town',
          businessAvatarThumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          title: 'Spoon Ice Tea',
          description: 'Free ice tea if you stop by',
          numberOffered: 10,
          unlimitedAvailable: false,
          categories: [
            Category(CategoryDto()
              ..name = 'food'
              ..description = 'All about food'),
            Category(CategoryDto()
              ..name = 'tea'
              ..description = 'Tea')
          ],
          channels: [backend.get<ConfigService>().socialNetworkProviders[0]],
          startDate: DateTime(2019, 1, 1),
          endDate: DateTime(2019, 3, 1),
          location: Location(latitude: 34.040031, longitude: -118.257318),
          terms: DealTerms(
            deliverable: Deliverable(description: 'Tell people how good our tea is', types: [DeliverableType.POST]),
            reward: Reward(
              description: 'One ice tea for you and a friend',
              type: RewardType.barter,
              barterValue: Decimal.fromInt(5),
            ),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          imagesLowRes: [
            (await rootBundle.load('assets/mockdata/ice_tea_lowres.jpg')).buffer.asUint8List(),
            (await rootBundle.load('assets/mockdata/ice_tea2_lowres.jpg')).buffer.asUint8List(),
          ],
          imageUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2.jpg?alt=media&token=e4b231d1-a4d3-419b-9c50-8b05fd4ab8d7'
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/ice_tea_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a')
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
        influencerAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78',
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
        influencerAvatarUrl: 'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Finf_profile_small.png?alt=media&token=885455ad-0892-476b-9b78-725da0fb7c78',
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
