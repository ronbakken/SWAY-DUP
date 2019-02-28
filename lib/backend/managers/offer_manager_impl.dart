import 'dart:async';

import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class OfferManagerImplementation implements OfferManager {
  OfferManagerImplementation() {
    updateOfferCommand = RxCommand.createFromStream(updateOffer, emitLastResult: true);

    initConnection();
  }

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
  OfferBuilder createOfferBuilder() {
    var currentUser = backend.get<UserManager>().currentUser;
    return OfferBuilder(
      businessAccountId: currentUser.id,
      businessAvatarThumbnailUrl: currentUser.avatarThumbnail.imageUrl,
      businessDescription: currentUser.description,
      businessName: currentUser.name,
      status: OfferDto_Status.active,
      statusReason: OfferDto_StatusReason.open,
    );
  }

  Stream<double> updateOffer(OfferBuilder offerBuilder) async* {
    var totalSteps = offerBuilder.images.length + 2;
    int completedSteps = 1;
    yield 0.2;

    // upload all offer images
    for (int i = 0; i < offerBuilder.images.length; i++) {
      yield completedSteps / totalSteps;
      completedSteps++;

      // we have an imagefile attached we upload it
      if (offerBuilder.images[i].imageFile != null) {
        offerBuilder.images[i] = await backend.get<ImageService>().uploadImageReference(
              fileNameTrunc: 'offer',
              imageReference: offerBuilder.images[i],
              imageWidth: 800,
              lowResWidth: 64,
            );
      }
    }

    yield completedSteps / totalSteps;
    completedSteps++;

    // Upload Thumbnail
    if (offerBuilder.images[0].imageFile != null) // first image changed
    {
      offerBuilder.offerThumbnail = await backend.get<ImageService>().uploadImageReference(
            fileNameTrunc: 'offer_thumbnail',
            imageReference: offerBuilder.images[0],
            imageWidth: 100,
            lowResWidth: 20,
          );
    }

    var updatedOffer = await backend.get<InfOfferService>().updateOffer(offerBuilder);
    // signal all done
    yield 1.0;
  }

  @override
  Future<BusinessOffer> getFullOffer(BusinessOffer partialOffer) {
    return backend.get<InfOfferService>().getOffer(partialOffer.id);
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
