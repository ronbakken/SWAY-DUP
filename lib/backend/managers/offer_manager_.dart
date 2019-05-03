import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/money.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/utils/date_time_helpers.dart';
import 'package:inf/utils/selection_set.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:rx_command/rx_command.dart';

abstract class OfferManager {
  RxCommand<OfferBuilder, double> updateOfferCommand;

  // All this streams return partial BusinessOffers
  Stream<List<BusinessOffer>> get myOffers;

  Stream<List<BusinessOffer>> get featuredOffers;

  Future<BusinessOffer> getFullOffer(String id);

  OfferBuilder createOfferBuilder();
}

class OfferBuilder {
  // Defaults for new offers or values that get copied from the original offer
  // but cannot be edited
  final String id;
  final OfferDto_Status status;
  final OfferDto_StatusReason statusReason;
  final String businessAccountId;
  final String businessName;
  final String businessDescription;
  final String businessAvatarThumbnailUrl;

  List<ImageReference> images = [];
  ImageReference offerThumbnail;
  String title;
  String description;
  SelectionSet<DeliverableType> deliverableTypes = SelectionSet<DeliverableType>();
  SelectionSet<SocialNetworkProvider> channels = SelectionSet<SocialNetworkProvider>();
  CategorySet categories = CategorySet();
  String deliverableDescription;
  Money cashValue;
  Money barterValue;
  RewardDto_Type rewardType;
  String rewardDescription;
  int minFollowers;
  Location location;
  int numberOffered;
  bool unlimitedAvailable = false;
  OfferDto_AcceptancePolicy acceptancePolicy;

  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;

  OfferBuilder({
    this.id,
    this.status,
    this.statusReason,
    this.businessAccountId,
    this.businessName,
    this.businessDescription,
    this.businessAvatarThumbnailUrl,
  });

  OfferBuilder.fromOffer(BusinessOffer offer)
      : assert(offer.title != null),
        assert(offer.description != null),
        assert(offer.startDate != null),
        assert(offer.endDate != null),
        id = offer.id,
        status = offer.status,
        statusReason = offer.statusReason,
        businessAccountId = offer.businessAccountId,
        businessName = offer.businessName,
        businessDescription = offer.businessDescription,
        businessAvatarThumbnailUrl = offer.businessAvatarThumbnailUrl {
    images = offer.images;
    offerThumbnail = offer.thumbnailImage;
    title = offer.title;
    description = offer.description;

    deliverableTypes = SelectionSet.fromIterable(offer.terms.deliverable.types);
    channels = SelectionSet.fromIterable(offer.terms.deliverable.channels);
    categories = CategorySet.fromIterable(offer.categories);
    deliverableDescription = offer.terms.deliverable.description;
    cashValue = offer.terms.reward.cashValue;
    barterValue = offer.terms.reward.barterValue;
    rewardDescription = offer.terms.reward.description ?? '';
    rewardType = offer.terms.reward.type;
    minFollowers = offer.minFollowers ?? 0;
    location = offer.location.copyWidth();
    numberOffered = offer.numberOffered;
    unlimitedAvailable = offer.unlimitedAvailable;
    acceptancePolicy = offer.acceptancePolicy;
    startDate = getPureDate(offer.startDate);
    endDate = getPureDate(offer.endDate);
    startTime = TimeOfDay.fromDateTime(offer.startDate);
    endTime = TimeOfDay.fromDateTime(offer.endDate);
  }

  OfferDto toDto() {
    assert(location != null);
    assert(businessAccountId != null);
    assert(businessName != null);
    assert(businessDescription != null);
    assert(businessAvatarThumbnailUrl != null);
    assert(title != null && title.isNotEmpty);
    assert(description != null && title.isNotEmpty);
    assert(offerThumbnail != null);
    return OfferDto()
      ..id = id ?? ''
      ..status = status ?? OfferDto_Status.active
      ..statusReason = statusReason ?? OfferDto_StatusReason.open
      ..location = location.toDto()
      ..full = (OfferDto_FullDataDto()
        ..businessAccountId = businessAccountId
        ..businessName = businessName
        ..businessDescription = businessDescription
        ..businessAvatarThumbnailUrl = businessAvatarThumbnailUrl
        ..title = title
        ..description = description
        ..start = Timestamp.fromDateTime(startDate)
        ..end = Timestamp.fromDateTime(endDate)
        ..minFollowers = minFollowers ?? 0
        ..numberOffered = unlimitedAvailable ? 0 : numberOffered
        ..terms = (DealTermsDto()
          ..deliverable = (DeliverableDto()
            ..deliverableTypes.addAll(deliverableTypes.toList())
            ..socialNetworkProviderIds.addAll(channels.toList().map<String>((c) => c.id))
            ..description = deliverableDescription)
          ..reward = (RewardDto()
            ..barterValue = barterValue?.toDto() ?? Money.zero.toDto()
            ..barterValue = cashValue?.toDto() ?? Money.zero.toDto()
            ..description = description ?? ''
            ..type = rewardType))
        ..acceptancePolicy = acceptancePolicy
        ..images.addAll(images.map<ImageDto>((x) => x.toImageDto()))
        ..categoryIds.addAll(categories.toList().map((x) => x.id))
        ..thumbnail = offerThumbnail.toImageDto());
  }
}
