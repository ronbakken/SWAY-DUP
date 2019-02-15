///
//  Generated code. Do not modify.
//  source: inf_mapping.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const SearchRequest$json = const {
  '1': 'SearchRequest',
  '2': const [
    const {'1': 'itemTypes', '3': 1, '4': 3, '5': 14, '6': '.api.SearchRequest.ItemType', '10': 'itemTypes'},
    const {'1': 'mapLevel', '3': 2, '4': 1, '5': 5, '10': 'mapLevel'},
    const {'1': 'northWest', '3': 3, '4': 1, '5': 11, '6': '.api.GeoPointDto', '10': 'northWest'},
    const {'1': 'southEast', '3': 4, '4': 1, '5': 11, '6': '.api.GeoPointDto', '10': 'southEast'},
  ],
  '4': const [SearchRequest_ItemType$json],
};

const SearchRequest_ItemType$json = const {
  '1': 'ItemType',
  '2': const [
    const {'1': 'offers', '2': 0},
    const {'1': 'users', '2': 1},
  ],
};

const SearchResponse$json = const {
  '1': 'SearchResponse',
  '2': const [
    const {'1': 'mapItems', '3': 1, '4': 3, '5': 11, '6': '.api.MapItemDto', '10': 'mapItems'},
  ],
};

const MapItemDto$json = const {
  '1': 'MapItemDto',
  '2': const [
    const {'1': 'geoPoint', '3': 1, '4': 1, '5': 11, '6': '.api.GeoPointDto', '10': 'geoPoint'},
    const {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.api.MapItemDto.MapItemStatus', '10': 'status'},
    const {'1': 'parentClusterId', '3': 3, '4': 1, '5': 9, '10': 'parentClusterId'},
    const {'1': 'offer', '3': 4, '4': 1, '5': 11, '6': '.api.OfferMapItemDto', '9': 0, '10': 'offer'},
    const {'1': 'user', '3': 5, '4': 1, '5': 11, '6': '.api.UserMapItemDto', '9': 0, '10': 'user'},
    const {'1': 'cluster', '3': 6, '4': 1, '5': 11, '6': '.api.ClusterMapItemDto', '9': 0, '10': 'cluster'},
  ],
  '4': const [MapItemDto_MapItemStatus$json],
  '8': const [
    const {'1': 'payload'},
  ],
};

const MapItemDto_MapItemStatus$json = const {
  '1': 'MapItemStatus',
  '2': const [
    const {'1': 'inactive', '2': 0},
    const {'1': 'active', '2': 1},
  ],
};

const OfferMapItemDto$json = const {
  '1': 'OfferMapItemDto',
  '2': const [
    const {'1': 'offerId', '3': 1, '4': 1, '5': 9, '10': 'offerId'},
    const {'1': 'userId', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

const UserMapItemDto$json = const {
  '1': 'UserMapItemDto',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

const ClusterMapItemDto$json = const {
  '1': 'ClusterMapItemDto',
  '2': const [
    const {'1': 'clusterId', '3': 1, '4': 1, '5': 9, '10': 'clusterId'},
    const {'1': 'itemCount', '3': 2, '4': 1, '5': 5, '10': 'itemCount'},
  ],
};

