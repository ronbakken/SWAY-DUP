///
//  Generated code. Do not modify.
//  source: backend_push.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const ReqPush$json = const {
  '1': 'ReqPush',
  '2': const [
    const {
      '1': 'message',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.NetPush',
      '10': 'message'
    },
    const {
      '1': 'receiver_account_id',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'receiverAccountId'
    },
    const {
      '1': 'sender_session_id',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'senderSessionId'
    },
    const {
      '1': 'skip_sender_session',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'skipSenderSession'
    },
    const {
      '1': 'send_notifications',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'sendNotifications'
    },
    const {
      '1': 'skip_notifications_when_online',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'skipNotificationsWhenOnline'
    },
  ],
};

const ResPush$json = const {
  '1': 'ResPush',
  '2': const [
    const {
      '1': 'online_sessions',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'onlineSessions'
    },
    const {
      '1': 'platform_notifications_attempted',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'platformNotificationsAttempted'
    },
    const {
      '1': 'platform_notifications_succeeded',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'platformNotificationsSucceeded'
    },
  ],
};

const ReqSetFirebaseToken$json = const {
  '1': 'ReqSetFirebaseToken',
  '2': const [
    const {
      '1': 'token',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.inf.NetSetFirebaseToken',
      '10': 'token'
    },
    const {'1': 'session_id', '3': 2, '4': 1, '5': 3, '10': 'sessionId'},
    const {'1': 'account_id', '3': 3, '4': 1, '5': 3, '10': 'accountId'},
  ],
};

const ResSetFirebaseToken$json = const {
  '1': 'ResSetFirebaseToken',
};
