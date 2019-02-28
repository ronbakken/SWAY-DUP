///
//  Generated code. Do not modify.
//  source: inf_listen.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const SingleItemFilterDto$json = const {
  '1': 'SingleItemFilterDto',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.api.SingleItemFilterDto.Type', '10': 'type'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
  '4': const [SingleItemFilterDto_Type$json],
};

const SingleItemFilterDto_Type$json = const {
  '1': 'Type',
  '2': const [
    const {'1': 'offer', '2': 0},
    const {'1': 'user', '2': 1},
  ],
};

const ListenRequest$json = const {
  '1': 'ListenRequest',
  '2': const [
    const {'1': 'action', '3': 1, '4': 1, '5': 14, '6': '.api.ListenRequest.Action', '10': 'action'},
    const {'1': 'singleItemFilter', '3': 2, '4': 1, '5': 11, '6': '.api.SingleItemFilterDto', '9': 0, '10': 'singleItemFilter'},
    const {'1': 'filter', '3': 3, '4': 1, '5': 11, '6': '.api.ItemFilterDto', '9': 0, '10': 'filter'},
  ],
  '4': const [ListenRequest_Action$json],
  '8': const [
    const {'1': 'target'},
  ],
};

const ListenRequest_Action$json = const {
  '1': 'Action',
  '2': const [
    const {'1': 'register', '2': 0},
    const {'1': 'deregister', '2': 1},
  ],
};

const ListenResponse$json = const {
  '1': 'ListenResponse',
  '2': const [
    const {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.api.ItemDto', '10': 'items'},
  ],
};

