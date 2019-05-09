///
//  Generated code. Do not modify.
//  source: inf_messaging.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

const CreateConversationRequest$json = const {
  '1': 'CreateConversationRequest',
  '2': const [
    const {'1': 'participantIds', '3': 1, '4': 3, '5': 9, '10': 'participantIds'},
    const {'1': 'topicId', '3': 2, '4': 1, '5': 9, '10': 'topicId'},
    const {'1': 'firstMessage', '3': 3, '4': 1, '5': 11, '6': '.api.MessageDto', '10': 'firstMessage'},
    const {'1': 'metadata', '3': 4, '4': 3, '5': 11, '6': '.api.CreateConversationRequest.MetadataEntry', '10': 'metadata'},
  ],
  '3': const [CreateConversationRequest_MetadataEntry$json],
};

const CreateConversationRequest_MetadataEntry$json = const {
  '1': 'MetadataEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
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

