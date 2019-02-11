import 'package:inf/domain/deal_terms.dart';

enum ChatEntryType {
  plain,
  haggle,
  image,
  markerCheck,
  markerReject,
}

/// the cumulated number of offers whith waiting chats
class WaitingChats {
  int inAppliedAndDirectOffers;
  int inDeals;
  int inDone;
}

class ChatEntry {
  final String id; // Sequential identifier in the chat stream
  final DateTime sent; // Sent timestamp
  final int senderId; // Account which sent

  // Question: Should we add avatarUrls here?

  final ChatEntryType type;
  final String text; // The written text
  final String attachmentUrl;
  final DealTerms newTerms;

  ChatEntry({
    this.id,
    this.sent,
    this.senderId,
    this.type,
    this.text,
    this.attachmentUrl,
    this.newTerms,
  });
}

class Chat {
  final String id;
  final DateTime lastTimeRead;
  final String proposalId;
  final List<ChatEntry> entries = [];

  Chat({this.id, this.lastTimeRead, this.proposalId});
}
