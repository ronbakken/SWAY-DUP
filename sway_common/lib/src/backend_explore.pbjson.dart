///
//  Generated code. Do not modify.
//  source: backend_explore.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

const InsertProfileRequest$json = const {
  '1': 'InsertProfileRequest',
  '2': const [
    const {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.DataAccount',
      '10': 'account'
    },
  ],
};

const InsertProfileResponse$json = const {
  '1': 'InsertProfileResponse',
};

const UpdateProfileRequest$json = const {
  '1': 'UpdateProfileRequest',
  '2': const [
    const {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.DataAccount',
      '10': 'account'
    },
  ],
};

const UpdateProfileResponse$json = const {
  '1': 'UpdateProfileResponse',
};

const GetProfileRequest$json = const {
  '1': 'GetProfileRequest',
  '2': const [
    const {'1': 'account_id', '3': 1, '4': 1, '5': 3, '10': 'accountId'},
    const {
      '1': 'receiver_account_id',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'receiverAccountId'
    },
    const {'1': 'private', '3': 3, '4': 1, '5': 8, '10': 'private'},
    const {'1': 'summary', '3': 4, '4': 1, '5': 8, '10': 'summary'},
    const {'1': 'detail', '3': 5, '4': 1, '5': 8, '10': 'detail'},
    const {'1': 'state', '3': 6, '4': 1, '5': 8, '10': 'state'},
  ],
};

const GetProfileResponse$json = const {
  '1': 'GetProfileResponse',
  '2': const [
    const {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.NetAccount',
      '10': 'account'
    },
  ],
};

const InsertOfferRequest$json = const {
  '1': 'InsertOfferRequest',
  '2': const [
    const {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.DataOffer',
      '10': 'offer'
    },
    const {
      '1': 'sender_account',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.inf.DataAccount',
      '10': 'senderAccount'
    },
    const {
      '1': 'sender_location',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.inf.DataLocation',
      '10': 'senderLocation'
    },
  ],
};

const InsertOfferResponse$json = const {
  '1': 'InsertOfferResponse',
};

const UpdateOfferRequest$json = const {
  '1': 'UpdateOfferRequest',
  '2': const [
    const {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.DataOffer',
      '10': 'offer'
    },
  ],
};

const UpdateOfferResponse$json = const {
  '1': 'UpdateOfferResponse',
};

const GetOfferRequest$json = const {
  '1': 'GetOfferRequest',
  '2': const [
    const {'1': 'offer_id', '3': 1, '4': 1, '5': 3, '10': 'offerId'},
    const {
      '1': 'receiver_account_id',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'receiverAccountId'
    },
    const {'1': 'private', '3': 3, '4': 1, '5': 8, '10': 'private'},
    const {'1': 'summary', '3': 4, '4': 1, '5': 8, '10': 'summary'},
    const {'1': 'detail', '3': 5, '4': 1, '5': 8, '10': 'detail'},
    const {'1': 'state', '3': 6, '4': 1, '5': 8, '10': 'state'},
  ],
};

const GetOfferResponse$json = const {
  '1': 'GetOfferResponse',
  '2': const [
    const {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.NetOffer',
      '10': 'offer'
    },
  ],
};

const ListOffersFromSenderRequest$json = const {
  '1': 'ListOffersFromSenderRequest',
  '2': const [
    const {'1': 'account_id', '3': 1, '4': 1, '5': 3, '10': 'accountId'},
    const {
      '1': 'receiver_account_id',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'receiverAccountId'
    },
    const {'1': 'private', '3': 3, '4': 1, '5': 8, '10': 'private'},
    const {'1': 'summary', '3': 4, '4': 1, '5': 8, '10': 'summary'},
    const {'1': 'detail', '3': 5, '4': 1, '5': 8, '10': 'detail'},
    const {'1': 'state', '3': 6, '4': 1, '5': 8, '10': 'state'},
  ],
};

const ListOffersFromSenderResponse$json = const {
  '1': 'ListOffersFromSenderResponse',
  '2': const [
    const {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.NetOffer',
      '10': 'offer'
    },
  ],
};
