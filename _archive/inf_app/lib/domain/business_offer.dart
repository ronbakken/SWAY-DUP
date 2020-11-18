import 'package:inf/app/assets.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/category.dart';
import 'package:inf/domain/domain.dart';
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
  final int minFollowers;

  final int numberOffered;
  final int numberRemaining;

  bool get unlimitedAvailable => numberOffered == 0;

  final ImageReference thumbnailImage;

  final DealTerms terms;

  final OfferDto_AcceptancePolicy acceptancePolicy;

  // Detail info
  final List<ImageReference> images;

  final List<Category> categories;

  // For later: Info for business
  // final int proposalsCountNew;
  // final int proposalsCountAccepted;
  // final int proposalsCountCompleted;
  // final int proposalsCountRefused;

  AppAsset get categoryIconAsset {
    if (categories?.isEmpty ?? true) {
      return null;
    }
    if (categories[0].parentId.isEmpty) {
      return categories[0].iconAsset;
    } else {
      var parentCategory = backend<ConfigService>()
          .topLevelCategories
          .firstWhere((category) => category.id == categories[0].parentId, orElse: () => null);
      return parentCategory?.iconAsset;
    }
  }

  String get topicId => 'offer-$id';

  BusinessOffer({
    this.id,
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
    this.minFollowers,
    this.numberOffered = 0,
    this.numberRemaining,
    this.thumbnailImage,
    this.terms,
    this.location,
    this.images,
    this.categories,
    this.status,
    this.statusReason,
    this.acceptancePolicy,
  });

  static BusinessOffer fromDto(OfferDto dto) {
    if (dto.hasList()) {
      return BusinessOffer(
        acceptancePolicy: null,
        businessAccountId: dto.list.businessAccountId,
        businessAvatarThumbnailUrl: dto.list.businessAvatarThumbnailUrl,
        businessDescription: dto.list.businessDescription,
        businessName: dto.list.businessName,
        categories: backend<ConfigService>().getCategoriesFromIds([dto.list.featuredCategoryId]),
        created: dto.list.created.toDateTime(),
        startDate: dto.list.start.toDateTime(),
        endDate: dto.list.end.toDateTime(),
        description: dto.list.description,
        id: dto.id,
        images: [ImageReference.fromImageDto(dto.list.featuredImage)],
        isPartial: true,
        location: Location.fromDto(dto.location),
        minFollowers: null,
        numberOffered: dto.list.numberOffered,
        numberRemaining: dto.list.numberRemaining,
        revision: dto.revision,
        status: dto.status,
        statusReason: dto.statusReason,
        terms: DealTerms.fromDto(dto.list.terms),
        thumbnailImage: ImageReference.fromImageDto(dto.list.thumbnail),
        title: dto.list.title,
      );
    } else {
      return BusinessOffer(
        acceptancePolicy: dto.full.acceptancePolicy,
        businessAccountId: dto.full.businessAccountId,
        businessAvatarThumbnailUrl: dto.full.businessAvatarThumbnailUrl,
        businessDescription: dto.full.businessDescription,
        businessName: dto.full.businessName,
        categories: backend<ConfigService>().getCategoriesFromIds(dto.full.categoryIds),
        created: dto.full.created.toDateTime(),
        startDate: dto.full.start.toDateTime(),
        endDate: dto.full.end.toDateTime(),
        description: dto.full.description,
        id: dto.id,
        images: dto.full.images.map<ImageReference>((x) => ImageReference.fromImageDto(x)).toList(),
        isPartial: false,
        location: Location.fromDto(dto.location),
        minFollowers: dto.full.minFollowers,
        numberOffered: dto.full.numberOffered,
        numberRemaining: dto.full.numberRemaining,
        revision: dto.revision,
        status: dto.status,
        statusReason: dto.statusReason,
        terms: DealTerms.fromDto(dto.full.terms),
        thumbnailImage: ImageReference.fromImageDto(dto.full.thumbnail),
        title: dto.full.title,
      );
    }
  }
}
