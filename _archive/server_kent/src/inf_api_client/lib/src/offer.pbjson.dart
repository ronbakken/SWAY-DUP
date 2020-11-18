///
//  Generated code. Do not modify.
//  source: offer.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

const OfferDto$json = const {
  '1': 'OfferDto',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'revision', '3': 2, '4': 1, '5': 13, '10': 'revision'},
    const {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.api.OfferDto.Status', '10': 'status'},
    const {'1': 'statusReason', '3': 5, '4': 1, '5': 14, '6': '.api.OfferDto.StatusReason', '10': 'statusReason'},
    const {'1': 'location', '3': 6, '4': 1, '5': 11, '6': '.api.LocationDto', '10': 'location'},
    const {'1': 'list', '3': 7, '4': 1, '5': 11, '6': '.api.OfferDto.ListDataDto', '9': 0, '10': 'list'},
    const {'1': 'full', '3': 8, '4': 1, '5': 11, '6': '.api.OfferDto.FullDataDto', '9': 0, '10': 'full'},
  ],
  '3': const [OfferDto_ListDataDto$json, OfferDto_FullDataDto$json],
  '4': const [OfferDto_Status$json, OfferDto_StatusReason$json, OfferDto_AcceptancePolicy$json],
  '8': const [
    const {'1': 'data'},
  ],
};

const OfferDto_ListDataDto$json = const {
  '1': 'ListDataDto',
  '2': const [
    const {'1': 'businessAccountId', '3': 1, '4': 1, '5': 9, '10': 'businessAccountId'},
    const {'1': 'businessName', '3': 2, '4': 1, '5': 9, '10': 'businessName'},
    const {'1': 'businessDescription', '3': 3, '4': 1, '5': 9, '10': 'businessDescription'},
    const {'1': 'businessAvatarThumbnailUrl', '3': 4, '4': 1, '5': 9, '10': 'businessAvatarThumbnailUrl'},
    const {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'created', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    const {'1': 'start', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'start'},
    const {'1': 'end', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'end'},
    const {'1': 'numberOffered', '3': 10, '4': 1, '5': 5, '10': 'numberOffered'},
    const {'1': 'numberRemaining', '3': 11, '4': 1, '5': 5, '10': 'numberRemaining'},
    const {'1': 'thumbnail', '3': 12, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'thumbnail'},
    const {'1': 'featuredImage', '3': 13, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'featuredImage'},
    const {'1': 'featuredCategoryId', '3': 15, '4': 1, '5': 9, '10': 'featuredCategoryId'},
    const {'1': 'terms', '3': 14, '4': 1, '5': 11, '6': '.api.DealTermsDto', '10': 'terms'},
  ],
};

const OfferDto_FullDataDto$json = const {
  '1': 'FullDataDto',
  '2': const [
    const {'1': 'businessAccountId', '3': 1, '4': 1, '5': 9, '10': 'businessAccountId'},
    const {'1': 'businessName', '3': 2, '4': 1, '5': 9, '10': 'businessName'},
    const {'1': 'businessDescription', '3': 3, '4': 1, '5': 9, '10': 'businessDescription'},
    const {'1': 'businessAvatarThumbnailUrl', '3': 4, '4': 1, '5': 9, '10': 'businessAvatarThumbnailUrl'},
    const {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'created', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    const {'1': 'start', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'start'},
    const {'1': 'end', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'end'},
    const {'1': 'minFollowers', '3': 10, '4': 1, '5': 5, '10': 'minFollowers'},
    const {'1': 'numberOffered', '3': 11, '4': 1, '5': 5, '10': 'numberOffered'},
    const {'1': 'numberRemaining', '3': 12, '4': 1, '5': 5, '10': 'numberRemaining'},
    const {'1': 'thumbnail', '3': 13, '4': 1, '5': 11, '6': '.api.ImageDto', '10': 'thumbnail'},
    const {'1': 'terms', '3': 14, '4': 1, '5': 11, '6': '.api.DealTermsDto', '10': 'terms'},
    const {'1': 'acceptancePolicy', '3': 15, '4': 1, '5': 14, '6': '.api.OfferDto.AcceptancePolicy', '10': 'acceptancePolicy'},
    const {'1': 'images', '3': 17, '4': 3, '5': 11, '6': '.api.ImageDto', '10': 'images'},
    const {'1': 'categoryIds', '3': 18, '4': 3, '5': 9, '10': 'categoryIds'},
  ],
};

const OfferDto_Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'unknown', '2': 0},
    const {'1': 'active', '2': 1},
    const {'1': 'inactive', '2': 2},
    const {'1': 'closed', '2': 3},
    const {'1': 'archived', '2': 4},
  ],
};

const OfferDto_StatusReason$json = const {
  '1': 'StatusReason',
  '2': const [
    const {'1': 'open', '2': 0},
    const {'1': 'userClosed', '2': 1},
    const {'1': 'maximumReached', '2': 2},
    const {'1': 'tosViolation', '2': 3},
    const {'1': 'completed', '2': 4},
    const {'1': 'expired', '2': 5},
  ],
};

const OfferDto_AcceptancePolicy$json = const {
  '1': 'AcceptancePolicy',
  '2': const [
    const {'1': 'manualReview', '2': 0},
    const {'1': 'automaticAcceptMatching', '2': 1},
    const {'1': 'allowNegotiation', '2': 2},
  ],
};

