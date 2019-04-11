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
    final listService = backend<InfListService>();
    listService.listMyOffers().listen((items) {
      assert(!items.any((item) => item.type != InfItemType.offer));
      _myOffersSubject.add(
        items.map<BusinessOffer>((item) => item.offer).toList(),
      );
    });
  }

  @override
  RxCommand<OfferBuilder, double> updateOfferCommand;

  @override
  Stream<List<BusinessOffer>> get myOffers => _myOffersSubject;
  final BehaviorSubject<List<BusinessOffer>> _myOffersSubject = BehaviorSubject<List<BusinessOffer>>();

  @override
  Stream<List<BusinessOffer>> get featuredOffers => _featuredBusinessOffers;
  final BehaviorSubject<List<BusinessOffer>> _featuredBusinessOffers = BehaviorSubject<List<BusinessOffer>>();

  @override
  Future<BusinessOffer> getFullOffer(String id) => backend<InfOfferService>().getOffer(id);

  @override
  OfferBuilder createOfferBuilder() {
    var currentUser = backend<UserManager>().currentUser;
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

      // we have an image file attached we upload it
      if (offerBuilder.images[i].imageFile != null) {
        offerBuilder.images[i] = await backend<ImageService>().uploadImageReference(
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
    if (offerBuilder.images[0].imageFile != null) {
      // first image changed
      offerBuilder.offerThumbnail = await backend<ImageService>().uploadImageReference(
        fileNameTrunc: 'offer_thumbnail',
        imageReference: offerBuilder.images[0],
        imageWidth: 100,
        lowResWidth: 20,
      );
    }

    await backend<InfOfferService>().updateOffer(offerBuilder);

    // signal all done
    yield 1.0;
  }
}
