
import 'package:inf/domain/domain.dart';
import 'package:rxdart/rxdart.dart';

abstract class OfferManager
{
   Observable<List<BusinessOffer>> getBusinessOffers();

   Observable<List<BusinessOffer>> getFeaturedBusinessOffers();


}