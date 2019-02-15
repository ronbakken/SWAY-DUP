
import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/utils/selection_set.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_command/rx_command.dart';
import 'package:inf/utils/date_time_helpers.dart';

abstract class OfferManager {
  RxCommand<OfferBuilder, double> updateOfferCommand;

  // All this streams return partial BusinessOffers
  Observable<List<BusinessOffer>> get myOffers;
  Observable<List<BusinessOffer>> get filteredOffers;
  Observable<List<BusinessOffer>> get featuredBusinessOffers;

  Future<BusinessOffer> getFullOffer(int offerId);

  Future<void> addOfferFilter(OfferFilter filter);
  Future<void> clearOfferFilter(OfferFilter filter);
  Future<OfferFilter> getOfferFilter(OfferFilter filter);

  OfferBuilder getOfferBuilder();
}

class OfferBuilder {
  List<ImageReference> images = [];
  String title;
  String description;
  bool isDirectOffer;
  SelectionSet<DeliverableType> deliverableTypes = SelectionSet<DeliverableType>();
  SelectionSet<SocialNetworkProvider> channels = SelectionSet<SocialNetworkProvider>();
  SelectionSet<Category> categories = SelectionSet<Category>();
  String deliverableDescription;
  Decimal cashValue;
  Decimal barterValue;
  String rewardDescription;
  int minFollowers;
  Location location;
  int numberOffered;
  bool unlimitedAvailable = false;
  AcceptancePolicy acceptancePolicy;

  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;

  OfferBuilder();
  OfferBuilder.fromOffer(BusinessOffer offer) {
    assert(offer.title != null);
    assert(offer.description != null);
    assert(offer.startDate != null);
    assert(offer.endDate != null);

    images = offer.imageUrls.map<ImageReference>((url) => ImageReference(imageUrl: url)).toList();
    title = offer.title;
    description = offer.description;

    isDirectOffer = offer.isDirectOffer;
    deliverableTypes = SelectionSet.fromIterable(offer.terms.deliverable.types);
    channels = SelectionSet.fromIterable(offer.channels);
    categories = SelectionSet.fromIterable(offer.categories);
    deliverableDescription = offer.terms.deliverable.description;
    cashValue = offer.terms.reward.cashValue ?? Decimal.fromInt(0);
    barterValue = offer.terms.reward.barterValue ?? Decimal.fromInt(0);
    rewardDescription = offer.terms.reward.description ?? '';
    minFollowers = offer.minFolllowers ?? 0;
    location = offer.location.copyWidth();
    numberOffered = offer.numberOffered;
    unlimitedAvailable = offer.unlimitedAvailable;
    acceptancePolicy = offer.acceptancePolicy;
    startDate = getPureDate(offer.startDate);
    endDate = getPureDate(offer.endDate);
    startTime = TimeOfDay.fromDateTime(offer.startDate);
    endTime = TimeOfDay.fromDateTime(offer.endDate);
  }
}
