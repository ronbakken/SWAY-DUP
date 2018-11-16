///
//  Generated code. Do not modify.
//  source: net_offer_business_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const NetCreateOfferReq$json = const {
  '1': 'NetCreateOfferReq',
  '2': const [
    const {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'imageKeys', '3': 2, '4': 3, '5': 9, '10': 'imageKeys'},
    const {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'deliverables', '3': 4, '4': 1, '5': 9, '10': 'deliverables'},
    const {'1': 'reward', '3': 5, '4': 1, '5': 9, '10': 'reward'},
    const {'1': 'locationId', '3': 6, '4': 1, '5': 5, '10': 'locationId'},
  ],
};

const NetLoadOffersReq$json = const {
  '1': 'NetLoadOffersReq',
  '2': const [
    const {'1': 'before', '3': 1, '4': 1, '5': 5, '10': 'before'},
    const {'1': 'after', '3': 2, '4': 1, '5': 5, '10': 'after'},
    const {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

const NetLoadOffersRes$json = const {
  '1': 'NetLoadOffersRes',
  '2': const [
    const {'1': 'oldest', '3': 1, '4': 1, '5': 5, '10': 'oldest'},
    const {'1': 'newest', '3': 2, '4': 1, '5': 5, '10': 'newest'},
  ],
};

const NetOfferApplyReq$json = const {
  '1': 'NetOfferApplyReq',
  '2': const [
    const {'1': 'offerId', '3': 1, '4': 1, '5': 5, '10': 'offerId'},
    const {'1': 'deviceGhostId', '3': 8, '4': 1, '5': 5, '10': 'deviceGhostId'},
    const {'1': 'remarks', '3': 2, '4': 1, '5': 9, '10': 'remarks'},
  ],
};
