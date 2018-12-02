///
//  Generated code. Do not modify.
//  source: net_offer_protobuf.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const NetOffer$json = const {
  '1': 'NetOffer',
  '2': const [
    const {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataOffer',
      '10': 'offer'
    },
    const {'1': 'state', '3': 2, '4': 1, '5': 8, '10': 'state'},
    const {'1': 'summary', '3': 3, '4': 1, '5': 8, '10': 'summary'},
    const {'1': 'detail', '3': 4, '4': 1, '5': 8, '10': 'detail'},
  ],
};

const NetCreateOffer$json = const {
  '1': 'NetCreateOffer',
  '2': const [
    const {
      '1': 'sessionGhostId',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf_common.DataOffer',
      '10': 'offer'
    },
  ],
};

const NetListOffers$json = const {
  '1': 'NetListOffers',
};

const NetGetOffer$json = const {
  '1': 'NetGetOffer',
  '2': const [
    const {'1': 'offerId', '3': 1, '4': 1, '5': 3, '10': 'offerId'},
  ],
};

const NetOfferApplyReq$json = const {
  '1': 'NetOfferApplyReq',
  '2': const [
    const {'1': 'offerId', '3': 1, '4': 1, '5': 3, '10': 'offerId'},
    const {
      '1': 'sessionGhostId',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'sessionGhostId'
    },
    const {'1': 'remarks', '3': 2, '4': 1, '5': 9, '10': 'remarks'},
  ],
};
