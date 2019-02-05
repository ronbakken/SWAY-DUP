import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/backend/managers/offer_manager_.dart';
import 'package:inf/domain/domain.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

class OfferManagerImplementation implements OfferManager {
  OfferManagerImplementation() {
    _newAppliedOfferMessages.add(2);
//    _newDealsOfferMessages.add(1);
    _newDoneOfferMessages.add(3);

    updateOfferCommand = RxCommand.createFromStream(updateOffer);
  }

  OfferBuilder activeBuilder;

  @override
  RxCommand<OfferBuilder, double> updateOfferCommand;

  @override
  Observable<int> get newAppliedOfferMessages => _newAppliedOfferMessages;
  final BehaviorSubject<int> _newAppliedOfferMessages = new BehaviorSubject<int>();

  @override
  Observable<int> get newDealsOfferMessages => _newDealsOfferMessages;
  final BehaviorSubject<int> _newDealsOfferMessages = new BehaviorSubject<int>();

  @override
  Observable<int> get newDoneOfferMessages => _newDoneOfferMessages;
  final BehaviorSubject<int> _newDoneOfferMessages = new BehaviorSubject<int>();

  @override
  Observable<int> get newOfferMessages => Observable.combineLatest3<int, int, int, int>(
      newAppliedOfferMessages.startWith(0),
      _newDealsOfferMessages.startWith(0),
      newDoneOfferMessages.startWith(0),
      (a, b, c) => a + b + c);
  @override
  Observable<List<BusinessOffer>> getBusinessOffers() {
    return backend.get<InfApiService>().getBusinessOffers(null);
  }

  @override
  Observable<List<BusinessOffer>> getFeaturedBusinessOffer() {
    return backend.get<InfApiService>().getFeaturedBusinessOffers(0, 0);
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

  @override
  OfferBuilder getOfferBuilder() {
    activeBuilder = new OfferBuilder();
    return activeBuilder;
  }

  Stream<double> updateOffer(OfferBuilder offerBuilder) async* {
    var totalSteps = offerBuilder.images.length + 1;
    int completedSteps = 1;

    List<Uint8List> loresImages = [];

    Image thumbNailImage;
    Image thumbNailLoresImage;

    var imagesToUpLoad = offerBuilder.images.where((image) => image.isFile).toList();

    // upload all offer images
    for (int i = 0; i < imagesToUpLoad.length; i++) {
      yield completedSteps / totalSteps;
      completedSteps++;

      var imageBytes = await imagesToUpLoad[i].imageFile.readAsBytes();

      var image = decodeImage(imageBytes);
      var imageReducedSize = copyResize(image, 800);

      // store a thumbnail of the first image
      if (i == 0) {
        thumbNailImage = copyResize(imageReducedSize, 100);
        thumbNailLoresImage = copyResize(thumbNailImage, 20);
      }

      var imageUrl = await backend.get<ImageService>().uploadImageFromBytes(
            'offer${DateTime.now().microsecondsSinceEpoch.toString()}.jpg',
            encodeJpg(imageReducedSize, quality: 90),
          );
      offerBuilder.images.add(ImageReference(imageUrl: imageUrl));
    }

    yield completedSteps / totalSteps;
    completedSteps++;

    // uploadThumbnail
    var thumbnailUrl = await backend.get<ImageService>().uploadImageFromBytes(
          'offer${DateTime.now().microsecondsSinceEpoch.toString()}.jpg',
          encodeJpg(thumbNailImage),
        );
  }
}
