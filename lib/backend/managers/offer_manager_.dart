import 'dart:io';

import 'package:inf/domain/domain.dart';
import 'package:inf/utils/selection_set.dart';
import 'package:rxdart/rxdart.dart';

abstract class OfferManager {
  Observable<int> get newAppliedOfferMessages;
  Observable<int> get newDealsOfferMessages;
  Observable<int> get newDoneOfferMessages;

  Observable<int> get newOfferMessages;

  Observable<List<BusinessOffer>> getBusinessOffers();

  Observable<List<BusinessOffer>> getFeaturedBusinessOffer();

  Future<void> addOfferFilter(OfferFilter filter);
  Future<void> clearOfferFilter(OfferFilter filter);
  Future<OfferFilter> getOfferFilter(OfferFilter filter);

  OfferBuilder getOfferBuilder();

}


class OfferBuilder
{
  List<File> imagesToUpLoad = <File>[];
  String title;
  String description;
  bool isDirectOffer;
  SelectionSet<DeliverableType> deliverableTypes = SelectionSet<DeliverableType>();
  SelectionSet<SocialNetworkProvider> channels = SelectionSet<SocialNetworkProvider>();
  SelectionSet<Category> categories = SelectionSet<Category>();
  String deliverableDescription;
  int cashValue;
  int barterValue;
  String rewardDescription;
  int miniFollowers;
  Location location;

}