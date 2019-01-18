///
//  Generated code. Do not modify.
//  source: inf_auth.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const InvitationCodeStates$json = const {
  '1': 'InvitationCodeStates',
  '2': const [
    const {'1': 'valid', '2': 0},
    const {'1': 'invalid', '2': 1},
    const {'1': 'expired', '2': 2},
  ],
};

const LoginEmailRequest$json = const {
  '1': 'LoginEmailRequest',
  '2': const [
    const {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

const RefreshTokenRequest$json = const {
  '1': 'RefreshTokenRequest',
  '2': const [
    const {'1': 'oneTimeToken', '3': 1, '4': 1, '5': 9, '10': 'oneTimeToken'},
  ],
};

const RefreshTokenMessage$json = const {
  '1': 'RefreshTokenMessage',
  '2': const [
    const {'1': 'refreshToken', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

const LoginResultMessage$json = const {
  '1': 'LoginResultMessage',
  '2': const [
    const {'1': 'authorizationToken', '3': 1, '4': 1, '5': 9, '10': 'authorizationToken'},
    const {'1': 'userData', '3': 2, '4': 1, '5': 11, '6': '.api.User', '10': 'userData'},
  ],
};

const InvitationCode$json = const {
  '1': 'InvitationCode',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

const InvitationCodeState$json = const {
  '1': 'InvitationCodeState',
  '2': const [
    const {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.api.InvitationCodeStates', '10': 'state'},
  ],
};

const CreateNewUserRequest$json = const {
  '1': 'CreateNewUserRequest',
  '2': const [
    const {'1': 'oneTimeToken', '3': 1, '4': 1, '5': 9, '10': 'oneTimeToken'},
    const {'1': 'userData', '3': 2, '4': 1, '5': 11, '6': '.api.User', '10': 'userData'},
    const {'1': 'deviceID', '3': 3, '4': 1, '5': 9, '10': 'deviceID'},
  ],
};

const SocialMediaRequest$json = const {
  '1': 'SocialMediaRequest',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 5, '10': 'userId'},
  ],
};

const SocialMediaAccounts$json = const {
  '1': 'SocialMediaAccounts',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 5, '10': 'userId'},
    const {'1': 'accounts', '3': 2, '4': 3, '5': 11, '6': '.api.SocialMediaAccount', '10': 'accounts'},
  ],
};

const UpdateUserRequest$json = const {
  '1': 'UpdateUserRequest',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.api.User', '10': 'user'},
    const {'1': 'socialMediaAccountsToAdd', '3': 2, '4': 3, '5': 11, '6': '.api.SocialMediaAccount', '10': 'socialMediaAccountsToAdd'},
    const {'1': 'socialMediaAccountsToRemove', '3': 3, '4': 3, '5': 11, '6': '.api.SocialMediaAccount', '10': 'socialMediaAccountsToRemove'},
  ],
};

