/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:async/async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/api_client.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:switchboard/switchboard.dart';

class _CachedProposal {
  bool loading = false;
  bool dirty = false;
  DataProposal proposal;
  DataProposal fallback;
  bool chatLoading = false;
  bool chatLoaded = false;
  Map<Int64, DataProposalChat> chats = Map<Int64, DataProposalChat>();
  Map<int, DataProposalChat> ghostChats = Map<int, DataProposalChat>();
}

abstract class NetworkProposals implements ApiClient, NetworkInternals {
  Map<Int64, _CachedProposal> _cachedProposals = Map<Int64, _CachedProposal>();

  void resetProposalsState() {
    _proposals.clear();
    _proposalsLoaded = false;
    _cachedProposals.clear();
  }

  void markProposalsDirty() {
    _proposalsLoaded = false;
    _cachedProposals.values.forEach((cached) {
      cached.dirty = true;
      cached.chatLoaded = false;
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle
  /////////////////////////////////////////////////////////////////////////////

  void _cacheProposal(DataProposal proposal) {
    _CachedProposal cached = _cachedProposals[proposal.proposalId];
    if (cached == null) {
      cached = _CachedProposal();
      _cachedProposals[proposal.proposalId] = cached;
    }
    cached.fallback = null;
    cached.proposal = proposal;
    cached.dirty = false;
    if (proposal.businessAccountId == account.accountId ||
        proposal.influencerAccountId == account.accountId) {
      // Add received offer to known offers
      _proposals[proposal.proposalId] = proposal;
    }
    hintOfferProposal(proposal);
    onProposalChanged(proposal.proposalId);
    onProposalsChanged();
  }

  @override
  void hintProposalOffer(DataOffer offer) {
    // For influencers that open an offer that they already applied to, accelerate some data on the proposal
    if (offer.proposalId != null && offer.proposalId != 0) {
      _CachedProposal cached = _cachedProposals[offer.proposalId];
      if (cached == null) {
        cached = _CachedProposal();
        _cachedProposals[offer.proposalId] = cached;
      }
      if (cached.proposal == null) {
        if (cached.fallback == null ||
            cached.fallback.offerId != offer.offerId ||
            cached.fallback.offerTitle != offer.title ||
            cached.fallback.businessName != offer.senderName ||
            cached.fallback.businessAccountId != offer.senderAccountId ||
            cached.fallback.influencerAccountId != account.accountId) {
          if (cached.fallback == null) {
            cached.fallback = DataProposal();
            cached.fallback.proposalId = offer.proposalId;
          } else {
            cached.fallback = DataProposal()..mergeFromMessage(cached.fallback);
          }
          cached.fallback.offerId = offer.offerId;
          cached.fallback.offerTitle = offer.title;
          cached.fallback.businessName = offer.senderName;
          cached.fallback.businessAccountId = offer.senderAccountId;
          cached.fallback.influencerAccountId = account.accountId;
          cached.fallback.influencerName = account.name;
          cached.fallback.freeze();
          onProposalChanged(offer.proposalId);
        }
      }
    }
  }

  void _cacheProposalChat(DataProposalChat chat) {
    _CachedProposal cached = _cachedProposals[chat.proposalId];
    if (cached == null) {
      cached = _CachedProposal();
      _cachedProposals[chat.proposalId] = cached;
    }
    if (chat.senderSessionId == account.sessionId) {
      cached.ghostChats.remove(chat.senderSessionGhostId);
    }
    cached.chats[chat.chatId] = chat;
    onProposalChatsChanged(chat.proposalId);
  }

  @override
  Future<void> refreshProposals() async {
    NetListOffers req = // TODO: Send the correct request
        NetListOffers(); // TODO: Specific requests for higher and lower refreshing
    // await for (TalkMessage res
    //     in channel.sendStreamRequest("L_APPLIS", req.writeToBuffer())) {
    StreamQueue<TalkMessage> sq = StreamQueue<TalkMessage>(
        channel.sendStreamRequest("LISTPROP", req.writeToBuffer()));
    while (await sq.hasNext) {
      TalkMessage res = await sq.next;
      DataProposal pb = DataProposal();
      pb.mergeFromBuffer(res.data);
      _cacheProposal(pb);
    }
  }

  bool proposalsLoading = false;
  bool _proposalsLoaded = false;
  Map<Int64, DataProposal> _proposals = Map<Int64, DataProposal>();

  @override
  Iterable<DataProposal> get proposals {
    if (_proposalsLoaded == false &&
        connected == NetworkConnectionState.ready) {
      _proposalsLoaded = true;
      proposalsLoading = true;
      refreshProposals().catchError((Object error, StackTrace stackTrace) {
        log.severe("Failed to get proposals.", error, stackTrace);
        Timer(Duration(seconds: 3), () {
          _proposalsLoaded =
              false; // Not using setState since we don't want to broadcast failure state
        });
      }).whenComplete(() {
        proposalsLoading = false;
        onProposalsChanged();
      });
    }
    return _proposals.values;
  }

  /// Create proposal
  @override
  Future<DataProposal> applyProposal(Int64 offerId, String remarks) async {
    try {
      NetApplyProposal request = NetApplyProposal();
      request.offerId = offerId;
      request.sessionGhostId = ++nextSessionGhostId;
      request.remarks = remarks;
      TalkMessage res = await switchboard.sendRequest(
          'api', 'APLYPROP', request.writeToBuffer());
      NetProposal pbRes = NetProposal();
      pbRes.mergeFromBuffer(res.data);
      _cacheProposal(pbRes.proposal);
      for (DataProposalChat chat in pbRes.chats) {
        _cacheProposalChat(chat);
      }
      return pbRes.proposal;
    } catch (error) {
      markOfferDirty(offerId);
      rethrow;
    }
  }

  @override
  Future<DataProposal> getProposal(Int64 proposalId) async {
    final NetGetProposal request = NetGetProposal();
    request.proposalId = proposalId;
    final TalkMessage res =
        await channel.sendRequest('GETPRPSL', request.writeToBuffer());
    final NetProposal proposal = NetProposal();
    proposal.mergeFromBuffer(res.data);
    _cacheProposal(proposal.proposal);
    for (DataProposalChat chat in proposal.chats) {
      log.fine(chat);
      _cacheProposalChat(chat);
    }
    return proposal.proposal;
  }

  Future<void> _loadProposalChats(Int64 proposalId) async {
    final NetListChats request = NetListChats();
    request.proposalId = proposalId;
    log.fine(proposalId);
    log.fine('LISTCHAT');
    await for (TalkMessage res
        in channel.sendStreamRequest('LISTCHAT', request.writeToBuffer())) {
      final NetProposalChat chat = NetProposalChat();
      chat.mergeFromBuffer(res.data);
      log.fine(chat);
      _cacheProposalChat(chat.chat);
    }
    log.fine('done');
  }

  DataProposal _tryGetProposal(Int64 proposalId,
      {DataProposal fallback, DataOffer fallbackOffer}) {
    _CachedProposal cached = _cachedProposals[proposalId];
    if (cached == null) {
      cached = _CachedProposal();
      _cachedProposals[proposalId] = cached;
    }
    if (cached.proposal == null || cached.dirty) {
      if (!cached.loading && connected == NetworkConnectionState.ready) {
        cached.loading = true;
        getProposal(proposalId).then((proposal) {
          cached.loading = false;
        }).catchError((Object error, StackTrace stackTrace) {
          log.severe('Failed to get proposal.', error, stackTrace);
          Timer(Duration(seconds: 3), () {
            cached.loading = false;
            onProposalChanged(proposalId);
          });
        });
      }
      if (cached.proposal != null) {
        return cached.proposal; // Return dirty
      }
      if (cached.fallback == null) {
        cached.fallback = DataProposal();
        cached.fallback.proposalId = proposalId;
      }
      if (fallback != null) {
        cached.fallback.mergeFromMessage(fallback);
      }
      if (fallbackOffer != null) {
        cached.fallback.offerId = fallbackOffer.offerId;
        cached.fallback.businessAccountId = fallbackOffer.senderAccountId;
      }
      return cached.fallback;
    }
    return cached.proposal;
  }

  /// Fetch latest proposal from cache by id, fetch in background if non-existent
  @override
  DataProposal tryGetProposal(Int64 proposalId) {
    return _tryGetProposal(proposalId);
  }

  /// Fetch latest proposal from cache, fetch in background if non-existent
  /*DataProposal latestProposal(DataProposal proposal) {
    return _tryGetProposal(proposal.proposalId, fallback: proposal);
  }*/

  /// Fetch latest known proposal chats from cache, fetch in background if not loaded yet
  @override
  Iterable<DataProposalChat> tryGetProposalChats(Int64 proposalId) {
    _CachedProposal cached = _cachedProposals[proposalId];
    if (cached == null) {
      cached = _CachedProposal();
      _cachedProposals[proposalId] = cached;
    }
    if (!cached.chatLoaded &&
        !cached.chatLoading &&
        connected == NetworkConnectionState.ready) {
      log.fine('fetch chat');
      cached.chatLoading = true;
      _loadProposalChats(proposalId).then((_) {
        cached.chatLoading = false;
        cached.chatLoaded = true;
      }).catchError((Object error, StackTrace stackTrace) {
        log.fine('Failed to get proposal chats.', error, stackTrace);
        Timer(Duration(seconds: 3), () {
          cached.chatLoading = false;
          onProposalChanged(proposalId);
          onProposalChatsChanged(proposalId);
        });
      });
    }
    return cached.chats.values.followedBy(cached.ghostChats.values);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle Notifications
  /////////////////////////////////////////////////////////////////////////////

  void _receivedUpdateProposal(DataProposal proposal) {
    _cacheProposal(proposal);
  }

  void _receivedUpdateProposalChat(DataProposalChat chat) {
    _cacheProposalChat(chat);
  }

  void _notifyNewProposalChat(DataProposalChat chat) {
    // TODO: Notify the user of a new proposal chat message if not own
    log.fine('Notify locally: ${chat.plainText}');
    onProposalChatNotification(chat);
  }

  void _receivedProposalCommonRes(NetProposal res) {
    _receivedUpdateProposal(res.proposal);
    for (DataProposalChat chat in res.chats) {
      _receivedUpdateProposalChat(chat);
      _notifyNewProposalChat(chat);
    }
  }

  @override
  Future<void> liveNewProposal(TalkMessage message) async {
    final NetProposal pb = NetProposal();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposal(pb.proposal);
    for (DataProposalChat chat in pb.chats) {
      _receivedUpdateProposalChat(chat);
      _notifyNewProposalChat(chat);
    }
  }

  @override
  Future<void> liveUpdateProposal(TalkMessage message) async {
    final NetProposal pb = NetProposal();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposal(pb.proposal);
    for (DataProposalChat chat in pb.chats) {
      _receivedUpdateProposalChat(chat);
    }
  }

  @override
  Future<void> liveNewProposalChat(TalkMessage message) async {
    final NetProposalChat pb = NetProposalChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposalChat(pb.chat);
    _notifyNewProposalChat(pb.chat);
  }

  @override
  Future<void> liveUpdateProposalChat(TalkMessage message) async {
    final NetProposalChat pb = NetProposalChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposalChat(pb.chat);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> reportProposal(Int64 proposalId, String text) async {
    NetProposalReport pbReq = NetProposalReport();
    pbReq.proposalId = proposalId;
    pbReq.text = text;
    // Response blank. Exception on issue
    await channel.sendRequest("PR_RPORT", pbReq.writeToBuffer());
  }

  void resubmitGhostChats() {
    for (_CachedProposal cached in _cachedProposals.values) {
      for (DataProposalChat ghostChat in cached.ghostChats.values) {
        switch (ghostChat.type) {
          case ProposalChatType.plain:
            {
              NetChatPlain pbReq = NetChatPlain();
              pbReq.proposalId = ghostChat.proposalId;
              pbReq.sessionGhostId = ghostChat.senderSessionGhostId;
              pbReq.text = ghostChat.plainText;
              channel.sendMessage("CH_PLAIN", pbReq.writeToBuffer());
            }
            break;
          case ProposalChatType.negotiate:
            {
              NetChatNegotiate pbReq = NetChatNegotiate();
              pbReq.proposalId = ghostChat.proposalId;
              pbReq.sessionGhostId = ghostChat.senderSessionGhostId;
              pbReq.terms = ghostChat.terms;
              pbReq.remarks = ghostChat.plainText;
              channel.sendMessage("CH_HAGGLE", pbReq.writeToBuffer());
            }
            break;
          case ProposalChatType.imageKey:
            {
              NetChatImageKey pbReq = NetChatImageKey();
              pbReq.proposalId = ghostChat.proposalId;
              pbReq.sessionGhostId = ghostChat.senderSessionGhostId;
              pbReq.imageKey = ghostChat.imageKey;
              channel.sendMessage("CH_IMAGE", pbReq.writeToBuffer());
            }
            break;
        }
      }
    }
  }

  void _createGhostChat(
      Int64 proposalId, int sessionGhostId, ProposalChatType type,
      {String plainText, DataTerms terms, String imageKey}) {
    _CachedProposal cached = _cachedProposals[proposalId];
    if (cached == null) {
      cached = _CachedProposal();
      _cachedProposals[proposalId] = cached;
    }
    final DataProposalChat ghostChat = DataProposalChat();
    ghostChat.sent =
        Int64(DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    ghostChat.senderAccountId = account.accountId;
    ghostChat.proposalId = proposalId;
    ghostChat.senderSessionId = account.sessionId;
    ghostChat.senderSessionGhostId = sessionGhostId;
    ghostChat.type = type;
    if (plainText != null) {
      ghostChat.plainText = plainText;
    }
    if (terms != null) {
      ghostChat.terms = terms;
    }
    if (imageKey != null) {
      ghostChat.imageKey = imageKey;
    }
    cached.ghostChats[sessionGhostId] = ghostChat;
    onProposalChatsChanged(proposalId);

    // TODO: Store ghost chats offline
  }

  @override
  void chatPlain(Int64 proposalId, String text) {
    int ghostId = ++nextSessionGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatPlain pbReq = NetChatPlain();
      pbReq.proposalId = proposalId;
      pbReq.sessionGhostId = ghostId;
      pbReq.text = text;
      channel.sendMessage('CH_PLAIN', pbReq.writeToBuffer());
    }
    _createGhostChat(
      proposalId,
      ghostId,
      ProposalChatType.plain,
      plainText: text,
    );
  }

  @override
  void chatHaggle(
      Int64 proposalId, String deliverables, String reward, String remarks) {
    int ghostId = ++nextSessionGhostId;
    DataTerms terms = DataTerms();
    terms.deliverablesDescription = deliverables;
    terms.rewardItemOrServiceDescription = reward;
    if (connected == NetworkConnectionState.ready) {
      NetChatNegotiate pbReq = NetChatNegotiate();
      pbReq.proposalId = proposalId;
      pbReq.sessionGhostId = ghostId;
      pbReq.terms = terms;
      pbReq.remarks = remarks;
      channel.sendMessage('CH_HAGGLE', pbReq.writeToBuffer());
    }
    _createGhostChat(
      proposalId,
      ghostId,
      ProposalChatType.negotiate,
      terms: terms,
      plainText: remarks,
    );
  }

  @override
  void chatImageKey(Int64 proposalId, String imageKey) {
    int ghostId = ++nextSessionGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatImageKey pbReq = NetChatImageKey();
      pbReq.proposalId = proposalId;
      pbReq.sessionGhostId = ghostId;
      pbReq.imageKey = imageKey;
      channel.sendMessage('CH_IMAGE', pbReq.writeToBuffer());
    }
    _createGhostChat(
      proposalId,
      ghostId,
      ProposalChatType.imageKey,
      imageKey: imageKey,
    );
  }

  @override
  Future<void> wantDeal(Int64 proposalId, Int64 termsChatId) async {
    NetProposalWantDeal pbReq = NetProposalWantDeal();
    pbReq.proposalId = proposalId;
    pbReq.termsChatId = termsChatId;
    TalkMessage res =
        await channel.sendRequest('AP_WADEA', pbReq.writeToBuffer());
    NetProposal pbRes = NetProposal();
    pbRes.mergeFromBuffer(res.data);
    _receivedProposalCommonRes(pbRes);
  }
}

/* end of file */
