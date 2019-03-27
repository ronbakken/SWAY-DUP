///
//  Generated code. Do not modify.
//  source: inf_messaging.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const CreateConversationRequest$json = const {
  '1': 'CreateConversationRequest',
  '2': const [
    const {'1': 'participantIds', '3': 1, '4': 3, '5': 9, '10': 'participantIds'},
    const {'1': 'topicId', '3': 2, '4': 1, '5': 9, '10': 'topicId'},
    const {'1': 'firstMessage', '3': 3, '4': 1, '5': 11, '6': '.api.MessageDto', '10': 'firstMessage'},
  ],
};

const CreateConversationResponse$json = const {
  '1': 'CreateConversationResponse',
  '2': const [
    const {'1': 'conversation', '3': 1, '4': 1, '5': 11, '6': '.api.ConversationDto', '10': 'conversation'},
  ],
};

const CloseConversationRequest$json = const {
  '1': 'CloseConversationRequest',
  '2': const [
    const {'1': 'conversationId', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
  ],
};

const CloseConversationResponse$json = const {
  '1': 'CloseConversationResponse',
  '2': const [
    const {'1': 'conversation', '3': 1, '4': 1, '5': 11, '6': '.api.ConversationDto', '10': 'conversation'},
  ],
};

const CreateMessageRequest$json = const {
  '1': 'CreateMessageRequest',
  '2': const [
    const {'1': 'conversationId', '3': 1, '4': 1, '5': 9, '10': 'conversationId'},
    const {'1': 'message', '3': 2, '4': 1, '5': 11, '6': '.api.MessageDto', '10': 'message'},
  ],
};

const CreateMessageResponse$json = const {
  '1': 'CreateMessageResponse',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 11, '6': '.api.MessageDto', '10': 'message'},
  ],
};

