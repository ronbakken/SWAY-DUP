import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class OfferManager {
  Observable<int> get newAppliedOfferMessages;
  Observable<int> get newDealsOfferMessages;
  Observable<int> get newDoneOfferMessages;

  Observable<int> get newOfferMessages;

  Observable<List<BusinessOffer>> getBusinessOffers();

  Observable<List<BusinessOffer>> getFeaturedBusinessOffers();
}
