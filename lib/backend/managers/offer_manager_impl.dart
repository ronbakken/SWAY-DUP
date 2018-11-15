import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

class OfferManagerImplementation implements OfferManager 
{
   @override
   Observable<List<BusinessOffer>> getBusinessOffers()
   {
     return backend.get<InfApiService>().getBusinessOffers(null);
   }

  @override
  Observable<List<BusinessOffer>> getFeaturedBusinessOffers() {
     return backend.get<InfApiService>().getBusinessOffers(null);
  }

}