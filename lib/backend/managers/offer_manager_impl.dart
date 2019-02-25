import 'dart:async';

import 'package:image/image.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class OfferManagerImplementation implements OfferManager {
  OfferManagerImplementation() {
    updateOfferCommand = RxCommand.createFromStream(updateOffer);

    initConnection();
  }

  OfferBuilder activeBuilder;

  @override
  RxCommand<OfferBuilder, double> updateOfferCommand;

  @override
  Observable<List<BusinessOffer>> get myOffers => _myOffersSubject;
  final BehaviorSubject<List<BusinessOffer>> _myOffersSubject = new BehaviorSubject<List<BusinessOffer>>();

  @override
  Observable<List<BusinessOffer>> get filteredOffers => _filteredOffersSubject;
  final BehaviorSubject<List<BusinessOffer>> _filteredOffersSubject = new BehaviorSubject<List<BusinessOffer>>();

  @override
  Observable<List<BusinessOffer>> get featuredBusinessOffers => _featuredBusinessOffers;
  final BehaviorSubject<List<BusinessOffer>> _featuredBusinessOffers = new BehaviorSubject<List<BusinessOffer>>();

  @override
  // Observable<int> get newOfferMessages => Observable.combineLatest3<int, int, int, int>(
  //     newAppliedOfferMessages.startWith(0),
  //     _newDealsOfferMessages.startWith(0),
  //     newDoneOfferMessages.startWith(0),
  //     (a, b, c) => a + b + c);

  @override
  Future<void> addOfferFilter(Filter filter) {
    // TODO: implement addOfferFilter
    throw Exception('Not implemented yet');
  }

  @override
  Future<void> clearOfferFilter(Filter filter) {
    // TODO: implement clearOfferFilter
    throw Exception('Not implemented yet');
  }

  @override
  Future<Filter> getOfferFilter(Filter filter) {
    // TODO: implement getOfferFilter
    throw Exception('Not implemented yet');
  }

  @override
  OfferBuilder getOfferBuilder() {
    activeBuilder = new OfferBuilder();
    return activeBuilder;
  }

  Stream<double> updateOffer(OfferBuilder offerBuilder) async* {
    var totalSteps = offerBuilder.images.length + 1;
    int completedSteps = 1;

    var imagesToUpLoad = offerBuilder.images.where((image) => image.isFile).toList();

    // upload all offer images
    for (int i = 0; i < imagesToUpLoad.length; i++) {
      yield completedSteps / totalSteps;
      completedSteps++;

      imagesToUpLoad[i] = await backend.get<ImageService>().uploadImageReference(
            fileNameTrunc: 'offer',
            imageReference: imagesToUpLoad[i],
            imageWidth: 800,
            lowResWidth: 64,
          );
    }

    yield completedSteps / totalSteps;
    completedSteps++;
    
    // Upload Thumbnail
    if (offerBuilder.images[0].imageFile != null) // first image changed
    {
      offerBuilder.offerThumbnail = await backend.get<ImageService>().uploadImageReference(
            fileNameTrunc: 'offer_thumbnail',
            imageReference: imagesToUpLoad[0],
            imageWidth: 100,
            lowResWidth: 20,
          );
    }
  }

  @override
  Future<BusinessOffer> getFullOffer(String offerId) {
    return backend.get<InfOfferService>().getOffer(offerId);
  }

  void initConnection() {
    myOffers.listen((x) => print(x.length));
    backend.get<SystemService>().connectionStateChanges.listen((state) async {
      await _myOffersSubject.addStream(backend.get<InfApiService>().getBusinessOffers(null));
      await _featuredBusinessOffers.addStream(backend.get<InfApiService>().getBusinessOffers(null));
      await _filteredOffersSubject.addStream(backend.get<InfApiService>().getBusinessOffers(null));
    });
  }
}
