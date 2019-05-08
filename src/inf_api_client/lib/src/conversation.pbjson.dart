///
//  Generated code. Do not modify.
//  source: conversation.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

const ConversationDto$json = const {
  '1': 'ConversationDto',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'topicId', '3': 2, '4': 1, '5': 9, '10': 'topicId'},
    const {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.api.ConversationDto.Status', '10': 'status'},
    const {'1': 'latestMessage', '3': 4, '4': 1, '5': 11, '6': '.api.MessageDto', '10': 'latestMessage'},
    const {'1': 'latestMessageWithAction', '3': 5, '4': 1, '5': 11, '6': '.api.MessageDto', '10': 'latestMessageWithAction'},
    const {'1': 'metadata', '3': 6, '4': 3, '5': 11, '6': '.api.ConversationDto.MetadataEntry', '10': 'metadata'},
  ],
  '3': const [ConversationDto_MetadataEntry$json],
  '4': const [ConversationDto_Status$json],
};

const ConversationDto_MetadataEntry$json = const {
  '1': 'MetadataEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

const ConversationDto_Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'closed', '2': 0},
    const {'1': 'open', '2': 1},
  ],
};

