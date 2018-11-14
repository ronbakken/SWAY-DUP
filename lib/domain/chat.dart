
enum ChatEntryType {
  plain,
  haggle, // url-encoded haggle message (deliverable=...&reward=...&remarks=...)
  image,
  marker // system marker (id=...)
}

/// the cumulated number of offers whith waiting chats
class WaitingChats
{
  int inAppliedAndDirectOffers;
  int inDeals;
  int inDone;
}


class ChatEntry {
  int id; // Sequential identifier in the chat stream
  DateTime sent; // Sent timestamp
  int senderId; // Account which sent
  int applicantId; // One chat per applicant
  
  // Question: Should we add avatarUrls here?
  
  ChatEntryType type;
  String text; // The written text
  String attachmentUrl;

  DateTime seen; // null if not seen
  
}

class Chat
{
  List<ChatEntry> entries;
}