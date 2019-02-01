///
//  Generated code. Do not modify.
//  source: inf_users.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const GetUserRequest$json = const {
  '1': 'GetUserRequest',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

const GetUserResponse$json = const {
  '1': 'GetUserResponse',
  '2': const [
    const {'1': 'userData', '3': 1, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'userData'},
  ],
};

const UpdateUserRequest$json = const {
  '1': 'UpdateUserRequest',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'user'},
  ],
};

const UpdateUserResponse$json = const {
  '1': 'UpdateUserResponse',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'user'},
  ],
};

const SearchUsersRequest$json = const {
  '1': 'SearchUsersRequest',
  '2': const [
    const {'1': 'userTypes', '3': 1, '4': 3, '5': 14, '6': '.api.UserType', '10': 'userTypes'},
    const {'1': 'categories', '3': 2, '4': 3, '5': 5, '10': 'categories'},
    const {'1': 'socialMediaNetworkIds', '3': 3, '4': 3, '5': 5, '10': 'socialMediaNetworkIds'},
    const {'1': 'location', '3': 4, '4': 1, '5': 11, '6': '.api.LocationDto', '10': 'location'},
    const {'1': 'locationDistanceKms', '3': 5, '4': 1, '5': 1, '10': 'locationDistanceKms'},
    const {'1': 'minimumValue', '3': 6, '4': 1, '5': 5, '10': 'minimumValue'},
    const {'1': 'phrase', '3': 7, '4': 1, '5': 9, '10': 'phrase'},
  ],
};

const SearchUsersResponse$json = const {
  '1': 'SearchUsersResponse',
  '2': const [
    const {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.UserDto', '10': 'results'},
  ],
};

