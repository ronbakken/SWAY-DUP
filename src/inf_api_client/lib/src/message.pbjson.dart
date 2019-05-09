///
//  Generated code. Do not modify.
//  source: message.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

const MessageDto$json = const {
  '1': 'MessageDto',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'user', '3': 2, '4': 1, '5': 11, '6': '.api.UserDto', '10': 'user'},
    const {'1': 'action', '3': 3, '4': 1, '5': 9, '10': 'action'},
    const {'1': 'timestamp', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    const {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    const {'1': 'attachments', '3': 6, '4': 3, '5': 11, '6': '.api.MessageAttachmentDto', '10': 'attachments'},
  ],
};

const MessageAttachmentDto$json = const {
  '1': 'MessageAttachmentDto',
  '2': const [
    const {'1': 'contentType', '3': 1, '4': 1, '5': 9, '10': 'contentType'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'metadata', '3': 3, '4': 3, '5': 11, '6': '.api.MessageAttachmentDto.MetadataEntry', '10': 'metadata'},
  ],
  '3': const [MessageAttachmentDto_MetadataEntry$json],
};

const MessageAttachmentDto_MetadataEntry$json = const {
  '1': 'MetadataEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

