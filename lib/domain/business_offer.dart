import 'dart:typed_data';

import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/domain/social_network_provider.dart';
import 'package:inf/utils/date_time_helpers.dart';
import 'package:inf_api_client/inf_api_client.dart';

class BusinessOffer {
  final String id;
  final int revision;
  final bool isPartial;
  final Location location;
  // State
  final OfferDto_Status status;
  final OfferDto_StatusReason statusReason;

  final String businessAccountId;
  final String businessName;
  final String businessDescription;
  final String businessAvatarThumbnailUrl;

  final String title;
  final String description;
  final DateTime created;
  final DateTime startDate;
  final DateTime endDate;
  final int minFolllowers;

  final int numberOffered;
  final int numberRemaining;
  bool get unlimitedAvailable => numberOffered == 0;

  final String thumbnailUrl;
  final String thumbnailLowResUrl;

  final DealTerms terms;

  final OfferDto_AcceptancePolicy acceptancePolicy;

  final OfferDto_ProposalStatus proposalStatus;

  // Detail info
  final List<String> imageUrls;
  final List<String> imagesLowResUrls;

  final List<Category> categories;

  // For later: Info for business
  // final int proposalsCountNew;
  // final int proposalsCountAccepted;
  // final int proposalsCountCompleted;
  // final int proposalsCountRefused;

  BusinessOffer(
      {this.id,
      this.revision,
      this.isPartial = false,
      this.businessAccountId,
      this.businessName,
      this.businessDescription,
      this.businessAvatarThumbnailUrl,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.created,
      this.minFolllowers,
      this.numberOffered = 0,
      this.numberRemaining,
      this.proposalStatus,
      this.thumbnailUrl,
      this.thumbnailLowResUrl,
      this.terms,
      this.location,
      this.imageUrls,
      this.imagesLowResUrls,
      this.categories,
      this.status,
      this.statusReason,
      this.acceptancePolicy});

  // BusinessOffer copyWith({
  //   int id,
  //   bool isPartial,
  //   int businessAccountId,
  //   String businessName,
  //   String businessDescription,
  //   String businessAvatarThumbnailUrl,
  //   bool isDirectOffer,
  //   String title,
  //   String description,
  //   DateTime created,
  //   DateTime startDate,
  //   DateTime endDate,
  //   int minFollowers,
  //   int numberOffered,
  //   bool unlimitedAvailable,
  //   int numberRemaining,
  //   String thumbnailUrl,
  //   Uint8List thumbnailLowRes,
  //   DealTerms terms,
  //   Location location,
  //   List<String> imageUrls,
  //   List<Uint8List> imagesLowRes,
  //   List<Category> categories,
  //   BusinessOfferState state,
  //   BusinessOfferStateReason stateReason,
  //   int newChatMessages,
  //   int influencerProposalId,
  // }) {
  //   return BusinessOffer(
  //     id: id ?? this.id,
  //     isPartial: isPartial ?? this.isPartial,
  //     businessAccountId: businessAccountId ?? this.businessAccountId,
  //     businessName: businessName ?? this.businessName,
  //     businessDescription: businessDescription ?? this.businessDescription,
  //     businessAvatarThumbnailUrl: businessAvatarThumbnailUrl ?? this.businessAvatarThumbnailUrl,
  //     title: title ?? this.title,
  //     description: description ?? this.description,
  //     startDate: startDate ?? this.startDate,
  //     endDate: endDate ?? this.endDate,
  //     minFolllowers: minFollowers ?? this.minFolllowers,
  //     created: created ?? this.created,
  //     isDirectOffer: isDirectOffer ?? this.isDirectOffer,
  //     numberOffered: numberOffered ?? this.numberOffered,

  //     unlimitedAvailable: unlimitedAvailable ?? this.unlimitedAvailable,
  //     thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
  //     thumbnailLowRes: thumbnailLowRes ?? this.thumbnailLowRes,
  //     terms: terms ?? this.terms,
  //     location: location ?? this.location,
  //     imageUrls: imageUrls ??  this.imageUrls,
  //     imagesLowRes: imagesLowRes ?? this.imagesLowRes,
  //     categories: categories ?? this.categories,
  //     state: state ?? this.state,
  //     stateReason: stateReason ?? this.stateReason,
  //   );
  // }

  static BusinessOffer fromDto(OfferDto dto) {
    if (dto.hasList()) {
      return BusinessOffer(
        acceptancePolicy: null,
        businessAccountId: dto.list.businessAccountId,
        businessAvatarThumbnailUrl: dto.list.businessAvatarThumbnailUrl,
        businessDescription: dto.list.businessDescription,
        businessName: dto.list.businessName,
        categories: null,
        created: fromTimeStamp(dto.list.created),
        startDate: fromTimeStamp(dto.list.start),
        endDate: fromTimeStamp(dto.list.end),
        description: dto.list.description,
        id: dto.id,
        imagesLowResUrls: [dto.list.featuredImage.lowResUrl],
        imageUrls: [dto.list.featuredImage.url],
        isPartial: true,
        location: Location.fromDto(dto.location),
        minFolllowers: null,
        numberOffered: dto.list.numberOffered,
        numberRemaining: dto.list.numberRemaining,
        proposalStatus: dto.list.proposalStatus,
        revision: dto.revision,
        status: dto.status,
        statusReason: dto.statusReason,
        terms: DealTerms.fromDto(dto.list.terms),
        thumbnailLowResUrl: dto.list.thumbnail.lowResUrl,
        thumbnailUrl: dto.list.thumbnail.lowResUrl,
        title: dto.list.title,
      );
    } else {
      return BusinessOffer(
        acceptancePolicy: dto.full.acceptancePolicy,
        businessAccountId: dto.full.businessAccountId,
        businessAvatarThumbnailUrl: dto.full.businessAvatarThumbnailUrl,
        businessDescription: dto.full.businessDescription,
        businessName: dto.full.businessName,
        categories: backend.get<ConfigService>().getCategoriesFromIds(dto.full.categoryIds),
        created: fromTimeStamp(dto.full.created),
        startDate: fromTimeStamp(dto.full.start),
        endDate: fromTimeStamp(dto.full.end),
        description: dto.full.description,
        id: dto.id,
        imagesLowResUrls: dto.full.images.map<String>((x) => x.lowResUrl).toList(),
        imageUrls: dto.full.images.map<String>((x) => x.url).toList(),
        isPartial: false,
        location: Location.fromDto(dto.location),
        minFolllowers: dto.full.minFollowers,
        numberOffered: dto.full.numberOffered,
        numberRemaining: dto.full.numberRemaining,
        proposalStatus: dto.full.proposalStatus,
        revision: dto.revision,
        status: dto.status,
        statusReason: dto.statusReason,
        terms: DealTerms.fromDto(dto.full.terms),
        thumbnailLowResUrl: dto.full.thumbnail.lowResUrl,
        thumbnailUrl: dto.full.thumbnail.lowResUrl,
        title: dto.full.title,
      );
    }
  }
}
