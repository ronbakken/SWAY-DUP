///
//  Generated code. Do not modify.
//  source: inf_invitation_codes.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

const GenerateInvitationCodeResponse$json = const {
  '1': 'GenerateInvitationCodeResponse',
  '2': const [
    const {'1': 'invitationCode', '3': 1, '4': 1, '5': 9, '10': 'invitationCode'},
  ],
};

const GetInvitationCodeStatusRequest$json = const {
  '1': 'GetInvitationCodeStatusRequest',
  '2': const [
    const {'1': 'invitationCode', '3': 1, '4': 1, '5': 9, '10': 'invitationCode'},
  ],
};

const GetInvitationCodeStatusResponse$json = const {
  '1': 'GetInvitationCodeStatusResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.api.GetInvitationCodeStatusResponse.InvitationCodeStatus', '10': 'status'},
  ],
  '4': const [GetInvitationCodeStatusResponse_InvitationCodeStatus$json],
};

const GetInvitationCodeStatusResponse_InvitationCodeStatus$json = const {
  '1': 'InvitationCodeStatus',
  '2': const [
    const {'1': 'DOES_NOT_EXIST', '2': 0},
    const {'1': 'PENDING_USE', '2': 1},
    const {'1': 'USED', '2': 2},
    const {'1': 'EXPIRED', '2': 3},
  ],
};

