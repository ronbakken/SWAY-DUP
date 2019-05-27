import 'package:flutter/widgets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/utils/geo.dart';
import 'package:inf_api_client/inf_api_client.dart';
import 'package:latlong/latlong.dart';

@immutable
abstract class Filter {
  const Filter();

  ItemFilterDto toDto();

  Filter clone();
}

@immutable
abstract class MapViewportFilter extends Filter {
  final int viewportZoomLevel;
  final LatLng viewportNorthWest;
  final LatLng viewportSouthEast;

  const MapViewportFilter({
    this.viewportZoomLevel,
    this.viewportNorthWest,
    this.viewportSouthEast,
  });

  MapViewportFilter withNewMapViewport({
    int viewportZoomLevel,
    LatLng viewportNorthWest,
    LatLng viewportSouthEast,
  });
}

@immutable
class OfferFilter extends MapViewportFilter {
  final CategorySet categorySet;
  final LatLng northWest;
  final LatLng southEast;
  final String locationName;
  final String queryText;
  final String offeringBusinessId;
  final OfferDto_Status status;
  final List<DeliverableType> deliverableTypes;
  final List<String> deliverableSocialMediaNetworkIds;
  final Money minimumRewardCashValue;
  final Money minimumRewardServiceValue;

  OfferFilter({
    int viewportZoomLevel,
    LatLng viewportNorthWest,
    LatLng viewportSouthEast,
    CategorySet categorySet,
    this.northWest,
    this.southEast,
    this.locationName,
    this.queryText,
    this.offeringBusinessId,
    this.status,
    this.deliverableTypes,
    this.deliverableSocialMediaNetworkIds,
    this.minimumRewardCashValue,
    this.minimumRewardServiceValue,
  })  : this.categorySet = categorySet ?? CategorySet(),
        super(
          viewportZoomLevel: viewportZoomLevel,
          viewportNorthWest: viewportNorthWest,
          viewportSouthEast: viewportSouthEast,
        );

  @override
  Filter clone() => copyWith();

  OfferFilter copyWith({
    int viewportZoomLevel,
    LatLng viewportNorthWest,
    LatLng viewportSouthEast,
    CategorySet categorySet,
    LatLng northWest,
    LatLng southEast,
    String locationName,
    String queryText,
    String offeringBusinessId,
    OfferDto_Status status,
    List<DeliverableType> deliverableTypes,
    List<String> deliverableSocialMediaNetworkIds,
    Money minimumRewardCashValue,
    Money minimumRewardServiceValue,
  }) {
    return OfferFilter(
      viewportZoomLevel: viewportZoomLevel ?? this.viewportZoomLevel,
      viewportNorthWest: viewportNorthWest ?? this.viewportNorthWest,
      viewportSouthEast: viewportSouthEast ?? this.viewportSouthEast,
      categorySet: categorySet ?? this.categorySet,
      northWest: northWest ?? this.northWest,
      southEast: southEast ?? this.southEast,
      locationName: locationName ?? this.locationName,
      queryText: queryText ?? this.queryText,
      offeringBusinessId: offeringBusinessId ?? this.offeringBusinessId,
      status: status ?? this.status,
      deliverableTypes: deliverableTypes ?? this.deliverableTypes,
      deliverableSocialMediaNetworkIds: deliverableSocialMediaNetworkIds ?? this.deliverableSocialMediaNetworkIds,
      minimumRewardCashValue: minimumRewardCashValue ?? this.minimumRewardCashValue,
      minimumRewardServiceValue: minimumRewardServiceValue ?? this.minimumRewardServiceValue,
    );
  }

  OfferFilter copyWithout({
    bool zoomLevel = false,
    bool viewportNorthWest = false,
    bool viewportSouthEast = false,
    bool categorySet = false,
    bool northWest = false,
    bool southEast = false,
    bool locationName = false,
    bool queryText = false,
    bool offeringBusinessId = false,
    bool status = false,
    bool deliverableTypes = false,
    bool deliverableSocialMediaNetworkIds = false,
    bool minimumRewardCashValue = false,
    bool minimumRewardServiceValue = false,
  }) {
    return OfferFilter(
      viewportZoomLevel: zoomLevel ? null : this.viewportZoomLevel,
      viewportNorthWest: viewportNorthWest ? null : this.viewportNorthWest,
      viewportSouthEast: viewportSouthEast ? null : this.viewportSouthEast,
      categorySet: categorySet ? null : this.categorySet,
      northWest: northWest ? null : this.northWest,
      southEast: southEast ? null : this.southEast,
      locationName: locationName ? null : this.locationName,
      queryText: queryText ? null : this.queryText,
      offeringBusinessId: offeringBusinessId ? null : this.offeringBusinessId,
      status: status ? null : this.status,
      deliverableTypes: deliverableTypes ? null : this.deliverableTypes,
      deliverableSocialMediaNetworkIds: deliverableSocialMediaNetworkIds ? null : this.deliverableSocialMediaNetworkIds,
      minimumRewardCashValue: minimumRewardCashValue ? null : this.minimumRewardCashValue,
      minimumRewardServiceValue: minimumRewardServiceValue ? null : this.minimumRewardServiceValue,
    );
  }

  @override
  MapViewportFilter withNewMapViewport({
    int viewportZoomLevel,
    LatLng viewportNorthWest,
    LatLng viewportSouthEast,
  }) =>
      copyWith(
        viewportZoomLevel: viewportZoomLevel,
        viewportNorthWest: viewportNorthWest,
        viewportSouthEast: viewportSouthEast,
      );

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

    // Deliverable Social Media Network IDs
    if (deliverableSocialMediaNetworkIds?.isNotEmpty ?? false) {
      filter.deliverableSocialMediaNetworkIds.addAll(deliverableSocialMediaNetworkIds);
    }

    // Minimum Reward Cash Value
    if (minimumRewardCashValue != null) {
      filter.minimumRewardCash = minimumRewardCashValue.toDto();
    }

    // Minimum Reward Service Value
    if (minimumRewardServiceValue != null) {
      filter.minimumRewardService = minimumRewardServiceValue.toDto();
    }

    // Effective geo bounding box
    var viewportBoundingBox = GeoBoundingBox.empty();
    var boundingBox = GeoBoundingBox.empty();
    GeoBoundingBox effectiveBoundingBox;

    if (viewportNorthWest != null && viewportSouthEast != null) {
      filter.mapLevel = viewportZoomLevel;
      viewportBoundingBox = GeoBoundingBox(
        northWest: GeoPoint(viewportNorthWest.latitude, viewportNorthWest.longitude),
        southEast: GeoPoint(viewportSouthEast.latitude, viewportSouthEast.longitude),
      );
    }

    if (northWest != null && southEast != null) {
      boundingBox = GeoBoundingBox(
        northWest: GeoPoint(northWest.latitude, northWest.longitude),
        southEast: GeoPoint(southEast.latitude, southEast.longitude),
      );
    }

    if (viewportBoundingBox.isNotEmpty && boundingBox.isNotEmpty) {
      effectiveBoundingBox = viewportBoundingBox.intersect(boundingBox);
    } else if (viewportBoundingBox.isNotEmpty) {
      effectiveBoundingBox = viewportBoundingBox;
    } else if (boundingBox.isNotEmpty) {
      effectiveBoundingBox = boundingBox;
    }

    if (effectiveBoundingBox != null) {
      if (effectiveBoundingBox.isEmpty) {
        // bounding box effectively excludes everything. TODO: it might be nice to recognize this formally on the client and avoid sending to server.
        filter.northWest = GeoPointDto()
          ..latitude = 0
          ..longitude = 0;
        filter.southEast = GeoPointDto()
          ..latitude = 0
          ..longitude = 0;
      } else {
        filter.northWest = GeoPointDto()
          ..latitude = effectiveBoundingBox.northWest.latitude
          ..longitude = effectiveBoundingBox.northWest.longitude;
        filter.southEast = GeoPointDto()
          ..latitude = effectiveBoundingBox.southEast.latitude
          ..longitude = effectiveBoundingBox.southEast.longitude;
      }
    }

    debugPrint("Filter DTO: $dto");

    return dto;
  }

  @override
  String toString() {
    return 'OfferFilter{viewportZoomLevel: $viewportZoomLevel, viewportNorthWest: $viewportNorthWest, viewportSouthEast: $viewportSouthEast, '
        'categorySet: $categorySet, northWest: $northWest, southEast: $southEast, queryText: $queryText, '
        'offeringBusinessId: $offeringBusinessId, status: $status, '
        'deliverableTypes: $deliverableTypes, deliverableSocialMediaNetworkIds: $deliverableSocialMediaNetworkIds, '
        'minimumRewardCashValue: $minimumRewardCashValue}'
        'minimumRewardServiceValue: $minimumRewardServiceValue}';
  }
}

@immutable
class UserFilter extends MapViewportFilter {
  final CategorySet categorySet;
  final LatLng northWest;
  final LatLng southEast;
  final String locationName;
  final String queryText;
  final UserType userType;
  final Money maximumFee;
  final List<SocialNetworkProvider> channels;

  UserFilter({
    int viewportZoomLevel,
    LatLng viewportNorthWest,
    LatLng viewportSouthEast,
    CategorySet categorySet,
    this.northWest,
    this.southEast,
    this.locationName,
    this.queryText,
    this.userType,
    this.maximumFee,
    this.channels,
  })  : this.categorySet = categorySet ?? CategorySet(),
        super(
          viewportZoomLevel: viewportZoomLevel,
          viewportNorthWest: viewportNorthWest,
          viewportSouthEast: viewportSouthEast,
        );

  @override
  Filter clone() => copyWith();

  UserFilter copyWith({
    int viewportZoomLevel,
    LatLng viewportNorthWest,
    LatLng viewportSouthEast,
    CategorySet categorySet,
    LatLng northWest,
    LatLng southEast,
    String locationName,
    String queryText,
    UserType userType,
    Money maximumFee,
    List<SocialNetworkProvider> channels,
  }) {
    return UserFilter(
      viewportZoomLevel: viewportZoomLevel ?? this.viewportZoomLevel,
      viewportNorthWest: viewportNorthWest ?? this.viewportNorthWest,
      viewportSouthEast: viewportSouthEast ?? this.viewportSouthEast,
      categorySet: categorySet ?? this.categorySet,
      northWest: northWest ?? this.northWest,
      southEast: southEast ?? this.southEast,
      locationName: locationName ?? this.locationName,
      queryText: queryText ?? this.queryText,
      userType: userType ?? this.userType,
      maximumFee: maximumFee ?? this.maximumFee,
      channels: channels ?? this.channels,
    );
  }

  UserFilter copyWithout({
    bool viewportZoomLevel = false,
    bool viewportNorthWest = false,
    bool viewportSouthEast = false,
    bool categorySet = false,
    bool northWest = false,
    bool southEast = false,
    bool locationName = false,
    bool queryText = false,
    bool userType = false,
    bool maximumFee = false,
    bool channels = false,
  }) {
    return UserFilter(
      viewportZoomLevel: viewportZoomLevel ? null : this.viewportZoomLevel,
      viewportNorthWest: viewportNorthWest ? null : this.viewportNorthWest,
      viewportSouthEast: viewportSouthEast ? null : this.viewportSouthEast,
      categorySet: categorySet ? null : this.categorySet,
      northWest: northWest ? null : this.northWest,
      southEast: southEast ? null : this.southEast,
      locationName: locationName ? null : this.locationName,
      queryText: queryText ? null : this.queryText,
      userType: userType ? null : this.userType,
      maximumFee: maximumFee ? null : this.maximumFee,
      channels: channels ? null : this.channels,
    );
  }

  @override
  MapViewportFilter withNewMapViewport({
    int viewportZoomLevel,
    LatLng viewportNorthWest,
    LatLng viewportSouthEast,
  }) {
    return copyWith(
      viewportZoomLevel: viewportZoomLevel,
      viewportNorthWest: viewportNorthWest,
      viewportSouthEast: viewportSouthEast,
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

    // Maximum Fee
    if (maximumFee != null) {
      filter.maximumValue = maximumFee.toDto();
    }

    // Effective geo bounding box
    var viewportBoundingBox = GeoBoundingBox.empty();
    var boundingBox = GeoBoundingBox.empty();
    GeoBoundingBox effectiveBoundingBox;

    if (viewportNorthWest != null && viewportSouthEast != null) {
      filter.mapLevel = viewportZoomLevel;
      viewportBoundingBox = GeoBoundingBox(
        northWest: GeoPoint(viewportNorthWest.latitude, viewportNorthWest.longitude),
        southEast: GeoPoint(viewportSouthEast.latitude, viewportSouthEast.longitude),
      );
    }

    if (northWest != null && southEast != null) {
      boundingBox = GeoBoundingBox(
        northWest: GeoPoint(northWest.latitude, northWest.longitude),
        southEast: GeoPoint(southEast.latitude, southEast.longitude),
      );
    }

    if (viewportBoundingBox.isNotEmpty && boundingBox.isNotEmpty) {
      effectiveBoundingBox = viewportBoundingBox.intersect(boundingBox);
    } else if (viewportBoundingBox.isNotEmpty) {
      effectiveBoundingBox = viewportBoundingBox;
    } else if (boundingBox.isNotEmpty) {
      effectiveBoundingBox = boundingBox;
    }

    if (effectiveBoundingBox != null) {
      if (effectiveBoundingBox.isEmpty) {
        // bounding box effectively excludes everything. TODO: it might be nice to recognize this formally on the client and avoid sending to server.
        filter.northWest = GeoPointDto()
          ..latitude = 0
          ..longitude = 0;
        filter.southEast = GeoPointDto()
          ..latitude = 0
          ..longitude = 0;
      } else {
        filter.northWest = GeoPointDto()
          ..latitude = effectiveBoundingBox.northWest.latitude
          ..longitude = effectiveBoundingBox.northWest.longitude;
        filter.southEast = GeoPointDto()
          ..latitude = effectiveBoundingBox.southEast.latitude
          ..longitude = effectiveBoundingBox.southEast.longitude;
      }
    }

    debugPrint("Filter DTO: $dto");

    return dto;
  }

  @override
  String toString() {
    return 'UserFilter{viewportZoomLevel: $viewportZoomLevel, viewportNorthWest: $viewportNorthWest, viewportSouthEast: $viewportSouthEast, '
        'maximumFee: $maximumFee, categorySet: $categorySet, northWest, $northWest, southEast: $southEast, queryText: $queryText, userType: $userType, channels: $channels}';
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

  @override
  Filter clone() => copyWith();

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
  const MessageFilter({
    this.conversationId,
  });

  final String conversationId;

  @override
  Filter clone() => copyWith();

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

enum SingleItemType {
  offer,
  user,
  conversation,
  message,
}

@immutable
class SingleItemFilter {
  const SingleItemFilter(this.id, this.type) : assert(id != null && type != null);

  final String id;
  final SingleItemType type;

  SingleItemFilterDto toDto() {
    SingleItemFilterDto_Type dtoType;
    switch (type) {
      case SingleItemType.offer:
        dtoType = SingleItemFilterDto_Type.offer;
        break;
      case SingleItemType.user:
        dtoType = SingleItemFilterDto_Type.user;
        break;
      case SingleItemType.conversation:
        dtoType = SingleItemFilterDto_Type.conversation;
        break;
      case SingleItemType.message:
        dtoType = SingleItemFilterDto_Type.message;
        break;
    }
    return SingleItemFilterDto()
      ..id = id
      ..type = dtoType;
  }
}
