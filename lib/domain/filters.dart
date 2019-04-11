import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:latlong/latlong.dart';

@immutable
abstract class Filter {
  const Filter();

  ItemFilterDto toDto();
}

@immutable
abstract class LocationFilter extends Filter {
  final int zoomLevel;
  final LatLng northWest;
  final LatLng southEast;

  const LocationFilter({
    this.zoomLevel,
    this.northWest,
    this.southEast,
  });

  LocationFilter withNewLocation({
    int zoomLevel,
    LatLng northWest,
    LatLng southEast,
  });
}

@immutable
class OfferFilter extends LocationFilter {
  final CategorySet categorySet;
  final String queryText;
  final String offeringBusinessId;
  final OfferDto_Status status;
  final List<DeliverableType> deliverableTypes;
  final List<RewardDto_Type> rewardTypes;
  final Money minimumRewardValue;

  const OfferFilter({
    int zoomLevel,
    LatLng northWest,
    LatLng southEast,
    this.categorySet,
    this.queryText,
    this.offeringBusinessId,
    this.status,
    this.deliverableTypes,
    this.rewardTypes,
    this.minimumRewardValue,
  }) : super(
          zoomLevel: zoomLevel,
          northWest: northWest,
          southEast: southEast,
        );

  OfferFilter copyWith({
    int zoomLevel,
    LatLng northWest,
    LatLng southEast,
    CategorySet categorySet,
    String queryText,
    String offeringBusinessId,
    OfferDto_Status status,
    List<DeliverableType> deliverableTypes,
    List<RewardDto_Type> rewardTypes,
    Money minimumRewardValue,
  }) {
    return OfferFilter(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      northWest: northWest ?? this.northWest,
      southEast: southEast ?? this.southEast,
      categorySet: categorySet ?? this.categorySet,
      queryText: queryText ?? this.queryText,
      offeringBusinessId: offeringBusinessId ?? this.offeringBusinessId,
      status: status ?? this.status,
      deliverableTypes: deliverableTypes ?? this.deliverableTypes,
      rewardTypes: rewardTypes ?? this.rewardTypes,
      minimumRewardValue: minimumRewardValue ?? this.minimumRewardValue,
    );
  }

  @override
  LocationFilter withNewLocation({
    int zoomLevel,
    LatLng northWest,
    LatLng southEast,
  }) {
    return copyWith(
      zoomLevel: zoomLevel,
      northWest: northWest,
      southEast: southEast,
    );
  }

  @override
  ItemFilterDto toDto() {
    final dto = ItemFilterDto();
    final filter = dto.offerFilter = ItemFilterDto_OfferFilterDto();

    // Offering Business Id
    if (offeringBusinessId?.isNotEmpty ?? false) {
      filter.businessAccountId = offeringBusinessId;
    }

    // Free Text
    if (queryText?.isNotEmpty ?? false) {
      filter.phrase = queryText;
    }

    // Category
    if (categorySet?.isNotEmpty ?? false) {
      filter.categoryIds.addAll(categorySet.map((cat) => cat.id));
    }

    // Offer Status
    if (status != null) {
      filter.offerStatuses.add(status);
    }

    // Deliverable Types
    if (deliverableTypes?.isNotEmpty ?? false) {
      filter.deliverableTypes.addAll(deliverableTypes);
    }

    // Reward Types
    if (rewardTypes?.isNotEmpty ?? false) {
      filter.rewardTypes.addAll(rewardTypes);
    }

    // Minimum Reward Value
    if (minimumRewardValue != null) {
      filter.minimumReward = minimumRewardValue.toDto();
    }

    // Location / Map
    /*
    if (northWest != null && southEast != null) {
      filter.mapLevel = zoomLevel;
      filter.northWest = GeoPointDto()
        ..latitude = northWest.latitude
        ..longitude = northWest.longitude;
      filter.southEast = GeoPointDto()
        ..latitude = southEast.latitude
        ..longitude = southEast.longitude;
    }
     */

    return dto;
  }

  @override
  String toString() {
    return 'OfferFilter{zoomLevel: $zoomLevel, northWest: $northWest, southEast: $southEast, '
      'categorySet: $categorySet, queryText: $queryText, '
      'offeringBusinessId: $offeringBusinessId, status: $status, '
      'deliverableTypes: $deliverableTypes, rewardTypes: $rewardTypes, '
      'minimumRewardValue: $minimumRewardValue}';
  }
}

@immutable
class UserFilter extends LocationFilter {
  final CategorySet categorySet;
  final String queryText;
  final UserType userType;
  final List<SocialNetworkProvider> channels;

  const UserFilter({
    int zoomLevel,
    LatLng northWest,
    LatLng southEast,
    this.categorySet,
    this.queryText,
    this.userType,
    this.channels,
  }) : super(
          zoomLevel: zoomLevel,
          northWest: northWest,
          southEast: southEast,
        );

  UserFilter copyWith({
    int zoomLevel,
    LatLng northWest,
    LatLng southEast,
    CategorySet categorySet,
    String freeText,
    UserType userType,
    List<SocialNetworkProvider> channels,
  }) {
    return UserFilter(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      northWest: northWest ?? this.northWest,
      southEast: southEast ?? this.southEast,
      categorySet: categorySet ?? this.categorySet,
      queryText: freeText ?? this.queryText,
      userType: userType ?? this.userType,
      channels: channels ?? this.channels,
    );
  }

  @override
  LocationFilter withNewLocation({
    int zoomLevel,
    LatLng northWest,
    LatLng southEast,
  }) {
    return copyWith(
      zoomLevel: zoomLevel,
      northWest: northWest,
      southEast: southEast,
    );
  }

  @override
  ItemFilterDto toDto() {
    final dto = ItemFilterDto();
    final filter = dto.userFilter = ItemFilterDto_UserFilterDto();

    // User Type
    if (userType != null) {
      filter.userTypes.add(userType);
    }

    // Free Text
    if (queryText?.isNotEmpty ?? false) {
      filter.phrase = queryText;
    }

    // Category
    if (categorySet?.isNotEmpty ?? false) {
      filter.categoryIds.addAll(categorySet.map((cat) => cat.id));
    }

    // Social Media Networks
    if (channels?.isNotEmpty ?? false) {
      filter.socialMediaNetworkIds.addAll(channels.map((social) => social.id));
    }

    // Location / Map
    if (northWest != null && southEast != null) {
      filter.mapLevel = zoomLevel;
      filter.northWest = GeoPointDto()
        ..latitude = northWest.latitude
        ..longitude = northWest.longitude;
      filter.southEast = GeoPointDto()
        ..latitude = southEast.latitude
        ..longitude = southEast.longitude;
    }

    return dto;
  }

  @override
  String toString() {
    return 'UserFilter{zoomLevel: $zoomLevel, northWest: $northWest, southEast: $southEast, '
        'categorySet: $categorySet, queryText: $queryText, userType: $userType, channels: $channels}';
  }
}

@immutable
class ConversationFilter extends Filter {
  final User participant;
  final String topicId;
  final ConversationDto_Status status;

  const ConversationFilter({
    this.participant,
    this.topicId,
    this.status,
  });

  ConversationFilter copyWith({
    User participant,
    String topicId,
    ConversationDto_Status status,
  }) {
    return ConversationFilter(
      participant: participant ?? this.participant,
      topicId: topicId ?? this.topicId,
      status: status ?? this.status,
    );
  }

  @override
  ItemFilterDto toDto() {
    final dto = ItemFilterDto();
    final filter = dto.conversationFilter = ItemFilterDto_ConversationFilterDto();

    // Participating User
    if (participant != null) {
      filter.participatingUserId = participant.id;
    }

    // Topic
    if (topicId != null) {
      filter.topicId = topicId;
    }

    // Status
    if (status != null) {
      filter.conversationStatuses.add(status);
    }

    return dto;
  }

  @override
  String toString() {
    return 'ConversationFilter{participant: $participant, topicId: $topicId, status: $status}';
  }
}

@immutable
class MessageFilter extends Filter {
  final String conversationId;

  const MessageFilter({
    this.conversationId,
  });

  MessageFilter copyWith({
    String conversationId,
  }) {
    return MessageFilter(
      conversationId: conversationId ?? this.conversationId,
    );
  }

  @override
  ItemFilterDto toDto() {
    final dto = ItemFilterDto();
    final filter = dto.messageFilter = ItemFilterDto_MessageFilterDto();

    // Conversation
    if (conversationId != null) {
      filter.conversationId = conversationId;
    }

    return dto;
  }

  @override
  String toString() {
    return 'MessageFilter{conversationId: $conversationId}';
  }
}
