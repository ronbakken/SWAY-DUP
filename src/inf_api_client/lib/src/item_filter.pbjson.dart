///
//  Generated code. Do not modify.
//  source: item_filter.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const ItemFilterDto$json = const {
  '1': 'ItemFilterDto',
  '2': const [
    const {'1': 'itemTypes', '3': 1, '4': 3, '5': 14, '6': '.api.ItemFilterDto.ItemType', '10': 'itemTypes'},
    const {'1': 'northWest', '3': 2, '4': 1, '5': 11, '6': '.api.GeoPointDto', '10': 'northWest'},
    const {'1': 'southEast', '3': 3, '4': 1, '5': 11, '6': '.api.GeoPointDto', '10': 'southEast'},
    const {'1': 'mapLevel', '3': 4, '4': 1, '5': 5, '10': 'mapLevel'},
    const {'1': 'categoryIds', '3': 5, '4': 3, '5': 9, '10': 'categoryIds'},
    const {'1': 'phrase', '3': 6, '4': 1, '5': 9, '10': 'phrase'},
    const {'1': 'offerFilter', '3': 10, '4': 1, '5': 11, '6': '.api.ItemFilterDto.OfferFilterDto', '10': 'offerFilter'},
    const {'1': 'userFilter', '3': 11, '4': 1, '5': 11, '6': '.api.ItemFilterDto.UserFilterDto', '10': 'userFilter'},
  ],
  '3': const [ItemFilterDto_OfferFilterDto$json, ItemFilterDto_UserFilterDto$json],
  '4': const [ItemFilterDto_ItemType$json],
};

const ItemFilterDto_OfferFilterDto$json = const {
  '1': 'OfferFilterDto',
  '2': const [
    const {'1': 'businessAccountId', '3': 1, '4': 1, '5': 9, '10': 'businessAccountId'},
    const {'1': 'offerStatuses', '3': 2, '4': 3, '5': 14, '6': '.api.OfferDto.Status', '10': 'offerStatuses'},
    const {'1': 'deliverableTypes', '3': 3, '4': 3, '5': 14, '6': '.api.DeliverableType', '10': 'deliverableTypes'},
    const {'1': 'acceptancePolicies', '3': 4, '4': 3, '5': 14, '6': '.api.OfferDto.AcceptancePolicy', '10': 'acceptancePolicies'},
    const {'1': 'rewardTypes', '3': 5, '4': 3, '5': 14, '6': '.api.RewardDto.Type', '10': 'rewardTypes'},
    const {'1': 'minimumReward', '3': 6, '4': 1, '5': 11, '6': '.api.MoneyDto', '10': 'minimumReward'},
  ],
};

const ItemFilterDto_UserFilterDto$json = const {
  '1': 'UserFilterDto',
  '2': const [
    const {'1': 'userTypes', '3': 1, '4': 3, '5': 14, '6': '.api.UserType', '10': 'userTypes'},
    const {'1': 'socialMediaNetworkIds', '3': 2, '4': 3, '5': 9, '10': 'socialMediaNetworkIds'},
  ],
};

const ItemFilterDto_ItemType$json = const {
  '1': 'ItemType',
  '2': const [
    const {'1': 'offers', '2': 0},
    const {'1': 'users', '2': 1},
  ],
};

