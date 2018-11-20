import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class OfferManagerImplementation implements OfferManager {
  @override
  Observable<int> get newAppliedOfferMessages => _newAppliedOfferMessages;
  final BehaviorSubject<int> _newAppliedOfferMessages =
      new BehaviorSubject<int>();

  @override
  Observable<int> get newDealsOfferMessages => _newDealsOfferMessages;
  final BehaviorSubject<int> _newDealsOfferMessages =
      new BehaviorSubject<int>();

  @override
  Observable<int> get newDoneOfferMessages => _newDoneOfferMessages;
  final BehaviorSubject<int> _newDoneOfferMessages = new BehaviorSubject<int>();

  @override
  Observable<int> get newOfferMessages =>
      Observable.combineLatest3<int, int, int, int>(
          newAppliedOfferMessages.startWith(0),
          _newDealsOfferMessages.startWith(0),
          newDoneOfferMessages.startWith(0),
          (a, b, c) => a + b + c);
  @override
  Observable<List<BusinessOfferSummery>> getBusinessOffers() {
    return backend.get<InfApiService>().getBusinessOffers(null);
  }

  @override
  Observable<List<BusinessOffer>> getFeaturedBusinessOffer() {
    return backend.get<InfApiService>().getFeaturedBusinessOffers(0, 0);
  }

  OfferManagerImplementation() {
    _newAppliedOfferMessages.add(2);
//    _newDealsOfferMessages.add(1);
    _newDoneOfferMessages.add(3);
  }

  @override
  Future<void> addOfferFilter(OfferFilter filter) {
    // TODO: implement addOfferFilter
    throw Exception('Not implemented yet');
  }

  @override
  Future<void> clearOfferFilter(OfferFilter filter) {
    // TODO: implement clearOfferFilter
    throw Exception('Not implemented yet');
  }

  @override
  Future<OfferFilter> getOfferFilter(OfferFilter filter) {
    // TODO: implement getOfferFilter
    throw Exception('Not implemented yet');
  }
}
