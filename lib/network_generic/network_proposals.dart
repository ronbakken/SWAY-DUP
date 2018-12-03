/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:async/async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf_app/network_generic/change.dart';
import 'package:inf_app/network_generic/api_client.dart';
import 'package:inf_app/network_generic/network_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:switchboard/switchboard.dart';

class _CachedProposal {
  bool loading = false;
  bool dirty = false;
  DataProposal proposal;
  DataProposal fallback;
  bool chatLoading = false;
  bool chatLoaded = false;
  Map<Int64, DataProposalChat> chats = new Map<Int64, DataProposalChat>();
  Map<int, DataProposalChat> ghostChats = new Map<int, DataProposalChat>();
}

abstract class NetworkProposals implements ApiClient, NetworkInternals {
  Map<Int64, _CachedProposal> _cachedProposals =
      new Map<Int64, _CachedProposal>();

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
      cached = new _CachedProposal();
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
    onProposalChanged(ChangeAction.upsert, proposal.proposalId);
  }

  @override
  void hintProposalOffer(DataOffer offer) {
    // For influencers that open an offer that they already applied to, accelerate some data on the proposal
    if (offer.proposalId != null && offer.proposalId != 0) {
      _CachedProposal cached = _cachedProposals[offer.proposalId];
      if (cached == null) {
        cached = new _CachedProposal();
        _cachedProposals[offer.proposalId] = cached;
      }
      if (cached.proposal == null) {
        if (cached.fallback == null ||
            cached.fallback.offerId != offer.offerId ||
            cached.fallback.offerTitle != offer.title ||
            cached.fallback.businessName != offer.senderName ||
            cached.fallback.businessAccountId != offer.senderId ||
            cached.fallback.influencerAccountId != account.accountId) {
          if (cached.fallback == null) {
            cached.fallback = new DataProposal();
            cached.fallback.proposalId = offer.proposalId;
          } else {
            cached.fallback = new DataProposal()
              ..mergeFromMessage(cached.fallback);
          }
          cached.fallback.offerId = offer.offerId;
          cached.fallback.offerTitle = offer.title;
          cached.fallback.businessName = offer.senderName;
          cached.fallback.businessAccountId = offer.senderId;
          cached.fallback.influencerAccountId = account.accountId;
          cached.fallback.influencerName = account.name;
          cached.fallback.freeze();
          onProposalChanged(ChangeAction.upsert, offer.proposalId);
        }
      }
    }
  }

  void _cacheProposalChat(DataProposalChat chat) {
    _CachedProposal cached = _cachedProposals[chat.proposalId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[chat.proposalId] = cached;
    }
    if (chat.sessionId == account.sessionId) {
      cached.ghostChats.remove(chat.sessionGhostId);
    }
    cached.chats[chat.chatId] = chat;
    onProposalChatChanged(ChangeAction.upsert, chat);
  }

  @override
  Future<void> refreshProposals() async {
    NetListOffers req = // TODO: Send the correct request
        new NetListOffers(); // TODO: Specific requests for higher and lower refreshing
    // await for (TalkMessage res
    //     in channel.sendStreamRequest("L_APPLIS", req.writeToBuffer())) {
    StreamQueue<TalkMessage> sq = StreamQueue<TalkMessage>(
        channel.sendStreamRequest("L_APPLIS", req.writeToBuffer()));
    while (await sq.hasNext) {
      TalkMessage res = await sq.next;
      DataProposal pb = new DataProposal();
      pb.mergeFromBuffer(res.data);
      _cacheProposal(pb);
    }
  }

  bool proposalsLoading = false;
  bool _proposalsLoaded = false;
  Map<Int64, DataProposal> _proposals = new Map<Int64, DataProposal>();

  @override
  Iterable<DataProposal> get proposals {
    if (_proposalsLoaded == false &&
        connected == NetworkConnectionState.ready) {
      _proposalsLoaded = true;
      proposalsLoading = true;
      refreshProposals().catchError((error, stack) {
        log.severe("Failed to get proposals: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          _proposalsLoaded =
              false; // Not using setState since we don't want to broadcast failure state
        });
      }).whenComplete(() {
        proposalsLoading = false;
        onProposalChanged(ChangeAction.refreshAll, Int64.ZERO);
      });
    }
    return _proposals.values;
  }

  /// Create proposal
  @override
  Future<DataProposal> sendProposal(Int64 offerId, String remarks) async {
    try {
      NetOfferApplyReq pbReq = new NetOfferApplyReq();
      pbReq.offerId = offerId;
      pbReq.sessionGhostId = ++nextSessionGhostId;
      pbReq.remarks = remarks;
      TalkMessage res =
          await channel.sendRequest("O_APPLYY", pbReq.writeToBuffer());
      DataProposal pbRes = new DataProposal();
      pbRes.mergeFromBuffer(res.data);
      _cacheProposal(pbRes); // FIXME: Chat not cached directly!
      return pbRes;
    } catch (error) {
      markOfferDirty(offerId);
      rethrow;
    }
  }

  @override
  Future<DataProposal> getProposal(Int64 proposalId) async {
    NetLoadProposalReq pbReq = new NetLoadProposalReq();
    pbReq.proposalId = proposalId;
    TalkMessage res =
        await channel.sendRequest("L_APPLIC", pbReq.writeToBuffer());
    DataProposal proposal = new DataProposal();
    proposal.mergeFromBuffer(res.data);
    _cacheProposal(proposal);
    return proposal;
  }

  Future<void> _loadProposalChats(Int64 proposalId) async {
    NetLoadProposalChatsReq pbReq = new NetLoadProposalChatsReq();
    pbReq.proposalId = proposalId;
    log.fine(proposalId);
    // await for (TalkMessage res in channel.sendStreamRequest(
    //     "L_APCHAT", pbReq.writeToBuffer())) {
    StreamQueue<TalkMessage> sq = StreamQueue<TalkMessage>(
        channel.sendStreamRequest("L_APCHAT", pbReq.writeToBuffer()));
    while (await sq.hasNext) {
      TalkMessage res = await sq.next;
      DataProposalChat chat = new DataProposalChat();
      chat.mergeFromBuffer(res.data);
      log.fine(chat);
      _cacheProposalChat(chat);
    }
    log.fine("done");
  }

  DataProposal _tryGetProposal(Int64 proposalId,
      {DataProposal fallback, DataOffer fallbackOffer}) {
    _CachedProposal cached = _cachedProposals[proposalId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[proposalId] = cached;
    }
    if (cached.proposal == null || cached.dirty) {
      if (!cached.loading && connected == NetworkConnectionState.ready) {
        cached.loading = true;
        getProposal(proposalId).then((proposal) {
          cached.loading = false;
        }).catchError((error, stack) {
          log.severe("Failed to get proposal: $error, $stack");
          new Timer(new Duration(seconds: 3), () {
            cached.loading = false;
            onProposalChanged(ChangeAction.retry, proposalId);
          });
        });
      }
      if (cached.proposal != null) {
        return cached.proposal; // Return dirty
      }
      if (cached.fallback == null) {
        cached.fallback = new DataProposal();
        cached.fallback.proposalId = proposalId;
      }
      if (fallback != null) {
        cached.fallback.mergeFromMessage(fallback);
      }
      if (fallbackOffer != null) {
        cached.fallback.offerId = fallbackOffer.offerId;
        cached.fallback.businessAccountId = fallbackOffer.senderId;
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
      cached = new _CachedProposal();
      _cachedProposals[proposalId] = cached;
    }
    if (!cached.chatLoaded &&
        !cached.chatLoading &&
        connected == NetworkConnectionState.ready) {
      log.fine("fetch chat");
      cached.chatLoading = true;
      _loadProposalChats(proposalId).then((proposal) {
        cached.chatLoading = false;
        cached.chatLoaded = true;
      }).catchError((error, stack) {
        log.fine("Failed to get proposal chats: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          cached.chatLoading = false;
          onProposalChanged(ChangeAction.retry, proposalId);
          onProposalChatChanged(ChangeAction.retry, null);
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
    log.fine("Notify: ${chat.text}");
  }

  void _receivedProposalCommonRes(NetProposalCommonRes res) {
    _receivedUpdateProposal(res.updateProposal);
    for (DataProposalChat chat in res.newChats) {
      _receivedUpdateProposalChat(chat);
      _notifyNewProposalChat(chat);
    }
  }

  void liveNewProposal(TalkMessage message) {
    DataProposal pb = new DataProposal();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposal(pb);
  }

  void liveNewProposalChat(TalkMessage message) {
    DataProposalChat pb = new DataProposalChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposalChat(pb);
    _notifyNewProposalChat(pb);
  }

  void liveUpdateProposal(TalkMessage message) {
    DataProposal pb = new DataProposal();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposal(pb);
  }

  void liveUpdateProposalChat(TalkMessage message) {
    DataProposalChat pb = new DataProposalChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateProposalChat(pb);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> reportProposal(Int64 proposalId, String text) async {
    NetProposalReportReq pbReq = new NetProposalReportReq();
    pbReq.proposalId = proposalId;
    pbReq.text = text;
    // Response blank. Exception on issue
    await channel.sendRequest("AP_REPOR", pbReq.writeToBuffer());
  }

  void resubmitGhostChats() {
    for (_CachedProposal cached in _cachedProposals.values) {
      for (DataProposalChat ghostChat in cached.ghostChats.values) {
        switch (ghostChat.type) {
          case ProposalChatType.plain:
            {
              NetChatPlain pbReq = new NetChatPlain();
              pbReq.proposalId = ghostChat.proposalId;
              pbReq.sessionGhostId = ghostChat.sessionGhostId;
              pbReq.text = ghostChat.text;
              channel.sendMessage("CH_PLAIN", pbReq.writeToBuffer());
            }
            break;
          case ProposalChatType.terms:
            {
              NetChatHaggle pbReq = new NetChatHaggle();
              pbReq.proposalId = ghostChat.proposalId;
              pbReq.sessionGhostId = ghostChat.sessionGhostId;
              Map<String, String> query = Uri.splitQueryString(ghostChat.text);
              pbReq.deliverables = query['deliverables'];
              pbReq.reward = query['reward'];
              pbReq.remarks = query['remarks'];
              channel.sendMessage("CH_HAGGLE", pbReq.writeToBuffer());
            }
            break;
          case ProposalChatType.imageKey:
            {
              NetChatImageKey pbReq = new NetChatImageKey();
              pbReq.proposalId = ghostChat.proposalId;
              pbReq.sessionGhostId = ghostChat.sessionGhostId;
              Map<String, String> query = Uri.splitQueryString(ghostChat.text);
              pbReq.imageKey = query['key'];
              channel.sendMessage("CH_IMAGE", pbReq.writeToBuffer());
            }
            break;
        }
      }
    }
  }

  void _createGhostChat(Int64 proposalId, int sessionGhostId,
      ProposalChatType type, String text) {
    _CachedProposal cached = _cachedProposals[proposalId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[proposalId] = cached;
    }
    DataProposalChat ghostChat = new DataProposalChat();
    ghostChat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    ghostChat.senderId = account.accountId;
    ghostChat.proposalId = proposalId;
    ghostChat.sessionId = account.sessionId;
    ghostChat.sessionGhostId = sessionGhostId;
    ghostChat.type = type;
    ghostChat.text = text;
    cached.ghostChats[sessionGhostId] = ghostChat;
    onProposalChatChanged(ChangeAction.add, ghostChat);

    // TODO: Store ghost chats offline
  }

  @override
  void chatPlain(Int64 proposalId, String text) {
    int ghostId = ++nextSessionGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatPlain pbReq = new NetChatPlain();
      pbReq.proposalId = proposalId;
      pbReq.sessionGhostId = ghostId;
      pbReq.text = text;
      channel.sendMessage("CH_PLAIN", pbReq.writeToBuffer());
    }
    _createGhostChat(proposalId, ghostId, ProposalChatType.plain, text);
  }

  @override
  void chatHaggle(
      Int64 proposalId, String deliverables, String reward, String remarks) {
    int ghostId = ++nextSessionGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatHaggle pbReq = new NetChatHaggle();
      pbReq.proposalId = proposalId;
      pbReq.sessionGhostId = ghostId;
      pbReq.deliverables = deliverables;
      pbReq.reward = reward;
      pbReq.remarks = remarks;
      channel.sendMessage("CH_HAGGLE", pbReq.writeToBuffer());
    }
    _createGhostChat(
      proposalId,
      ghostId,
      ProposalChatType.terms,
      "deliverables=" +
          Uri.encodeQueryComponent(deliverables) +
          "&reward=" +
          Uri.encodeQueryComponent(reward) +
          "&remarks=" +
          Uri.encodeQueryComponent(remarks),
    );
  }

  @override
  void chatImageKey(Int64 proposalId, String imageKey) {
    int ghostId = ++nextSessionGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatImageKey pbReq = new NetChatImageKey();
      pbReq.proposalId = proposalId;
      pbReq.sessionGhostId = ghostId;
      pbReq.imageKey = imageKey;
      channel.sendMessage("CH_IMAGE", pbReq.writeToBuffer());
    }
    _createGhostChat(
      proposalId,
      ghostId,
      ProposalChatType.imageKey,
      "key=" + Uri.encodeQueryComponent(imageKey),
    );
  }

  @override
  Future<void> wantDeal(Int64 proposalId, Int64 termsChatId) async {
    NetProposalWantDealReq pbReq = NetProposalWantDealReq();
    pbReq.proposalId = proposalId;
    pbReq.termsChatId = termsChatId;
    TalkMessage res =
        await channel.sendRequest("AP_WADEA", pbReq.writeToBuffer());
    NetProposalCommonRes pbRes = new NetProposalCommonRes();
    pbRes.mergeFromBuffer(res.data);
    _receivedProposalCommonRes(pbRes);
  }
}

/* end of file */
