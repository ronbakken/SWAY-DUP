import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/services/network_service_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class NetworkServiceMock implements NetWorkService {
  List<BusinessOffer> allOffers;

  /// TBD: What is the best way to define a Filter
  @override
  Observable<List<BusinessOffer>> getBusinessOffers({int userId}) {
    var showLimited = backend.get<UserManager>().isLoggedIn;
    return Observable.fromFuture(loadBusinessOfferMockData())
        .map((list) => list..forEach((offer) => offer.displayLimited = showLimited));
  }

  @override
  Observable<List<Proposal>> getProposals(int userId, int offerId) {}

  Future<List<BusinessOffer>> loadBusinessOfferMockData() async {
    return [
      BusinessOffer(
          businessAccountId: 42,
          businessName: 'CarWash Tom',
          businessDescription: 'We wash anything',
          businessAvatarThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',
          offerId: 4711,
          title: 'Card Wash',
          description: 'Our car wash is the best car wash in the universe of car washes',
          categories: [Category(name: 'cars', description: 'All about cars')],
          deliverables: [
            Deliverable(
                channel: DeliverableChannels.facebook,
                description: 'Tell people how good our service is',
                type: DeliverableType.post)
          ],
          expiryDate: DateTime.now().add(Duration(days: 10)),
          location: Location(activeOfferCount: 1, latitude: 34.032395, longitude: -118.301019),
          reward: Reward(
            description: 'One free premium car wash',
            type: RewardType.barter,
            value: Decimal.fromInt(20),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          proposalsCountAccepted: 0,
          proposalsCountCompleted: 0,
          proposalsCountNew: 2,
          proposalsCountRefused: 1,
          coverLowRes: [
            (await rootBundle.load('assets/mockdata/car_wash1_lowres.jpg')).buffer.asUint8List(),
            (await rootBundle.load('assets/mockdata/car_wash2_lowres.jpg')).buffer.asUint8List(),
          ],
          coverUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash1.jpg?alt=media&token=af2e4919-a67d-4e48-b7c0-286c2e444f2e',
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2.jpg?alt=media&token=0913cd09-1efc-47d6-a760-cbfe47476b5d'
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/car_wash2_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fcar_wash2_thumb.jpg?alt=media&token=a3c145ef-790c-433d-ae11-7ea5c48eeb45'),
      BusinessOffer(
          businessAccountId: 43,
          businessName: 'Scent of Asia',
          businessDescription: 'Best flavoured teas in town',
          businessAvatarThumbnailUrl: 'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fprofile-small.jpg?alt=media&token=8a59a097-b7a0-4ebc-8679-8255551af741',

          offerId: 1912,
          title: 'Spoon Ice Tea',
          description: 'Free ice tea if you stop by',
          categories: [Category(name: 'food', description: 'All about food')],
          deliverables: [
            Deliverable(
                channel: DeliverableChannels.instagramm,
                description: 'Tell people how good our tea is',
                type: DeliverableType.post)
          ],
          expiryDate: DateTime.now().add(Duration(days: 10)),
          location: Location(activeOfferCount: 1, latitude: 34.040031, longitude: -118.257318),
          reward: Reward(
            description: 'One ice tea for you and a friend',
            type: RewardType.barter,
            value: Decimal.fromInt(5),
          ),
          state: BusinessOfferState.open,
          stateReason: BusinessOfferStateReason.newOffer,
          proposalsCountAccepted: 0,
          proposalsCountCompleted: 1,
          proposalsCountNew: 2,
          proposalsCountRefused: 0,
          coverLowRes: [
            (await rootBundle.load('assets/mockdata/ice_tea_lowres.jpg')).buffer.asUint8List(),
            (await rootBundle.load('assets/mockdata/ice_tea2_lowres.jpg')).buffer.asUint8List(),
          ],
          coverUrls: [
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea.jpg?alt=media&token=284e7496-d2ba-4462-8bec-26799e6e2b3a',
            'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea2.jpg?alt=media&token=e4b231d1-a4d3-419b-9c50-8b05fd4ab8d7'
          ],
          thumbnailLowRes: (await rootBundle.load('assets/mockdata/ice_tea_thumb_lowres.jpg')).buffer.asUint8List(),
          thumbnailUrl:
              'https://firebasestorage.googleapis.com/v0/b/inf-development.appspot.com/o/mock_data%2Fimages%2Fice_tea_thumb.jpg?alt=media&token=340434bf-7a23-423b-991b-bf938404e14a')
    ];
  }
}
