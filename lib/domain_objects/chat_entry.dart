import 'package:inf/domain_objects/enums.dart';

class ChatEntry {
  int id; // Sequential identifier in the chat stream
  DateTime sent; // Sent timestamp
  int senderId; // Account which sent
  int applicantId; // One chat per applicant
  
  // Question: Should we add avatarUrls here?
  
  ChatEntryType type;
  String text; // The written text
  // Jan
  String attachmentUrl;

  // Jan: why an int?
  int seen; // 0 if not seen
  
}