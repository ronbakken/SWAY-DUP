import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/utils/selection_set.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rx_command/rx_command.dart';

abstract class OfferManager {

  RxCommand<OfferBuilder, double> updateOfferCommand;

  Observable<List<BusinessOfferSummary>> get myOffers;
  Observable<List<BusinessOfferSummary>> get receivedDirectOffers;

  Observable<List<BusinessOfferSummary>> get filteredOffers;
  Observable<List<BusinessOfferSummary>> get featuredBusinessOffers;

  Future<BusinessOffer> getOfferFromSummary(BusinessOfferSummary summary);


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
  int cashValue;
  int barterValue;
  String rewardDescription;
  int miniFollowers;
  Location location;
  int amountAvailable;
  bool unlimitedAvailable = false;
  AcceptancePolicy acceptancePolicy;

  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
}
