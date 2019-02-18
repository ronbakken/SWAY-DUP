///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const SendLoginEmailRequest$json = const {
  '1': 'SendLoginEmailRequest',
  '2': const [
    const {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'userType', '3': 2, '4': 1, '5': 14, '6': '.api.UserType', '10': 'userType'},
    const {'1': 'invitationCode', '3': 3, '4': 1, '5': 9, '10': 'invitationCode'},
  ],
};

const ActivateUserRequest$json = const {
  '1': 'ActivateUserRequest',
  '2': const [
    const {'1': 'loginToken', '3': 1, '4': 1, '5': 9, '10': 'loginToken'},
    const {'1': 'userData', '3': 2, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'userData'},
  ],
};

const ActivateUserResponse$json = const {
  '1': 'ActivateUserResponse',
  '2': const [
    const {'1': 'userData', '3': 2, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'userData'},
  ],
};

const LoginWithLoginTokenRequest$json = const {
  '1': 'LoginWithLoginTokenRequest',
  '2': const [
    const {'1': 'loginToken', '3': 1, '4': 1, '5': 9, '10': 'loginToken'},
  ],
};

const LoginWithLoginTokenResponse$json = const {
  '1': 'LoginWithLoginTokenResponse',
  '2': const [
    const {'1': 'refreshToken', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
    const {'1': 'userData', '3': 2, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'userData'},
  ],
};

const GetAccessTokenRequest$json = const {
  '1': 'GetAccessTokenRequest',
  '2': const [
    const {'1': 'refreshToken', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

const GetAccessTokenResponse$json = const {
  '1': 'GetAccessTokenResponse',
  '2': const [
    const {'1': 'accessToken', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

const LoginWithRefreshTokenRequest$json = const {
  '1': 'LoginWithRefreshTokenRequest',
  '2': const [
    const {'1': 'refreshToken', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

const LoginWithRefreshTokenResponse$json = const {
  '1': 'LoginWithRefreshTokenResponse',
  '2': const [
    const {'1': 'accessToken', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    const {'1': 'userData', '3': 2, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'userData'},
  ],
};

const LogoutRequest$json = const {
  '1': 'LogoutRequest',
  '2': const [
    const {'1': 'refreshToken', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

