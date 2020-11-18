/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/api.dart';
import 'package:inf/network_generic/api_internals.dart';
import 'package:inf_common/inf_common.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:pedantic/pedantic.dart';

class _CachedProposal {
  bool loading = false;
  bool dirty = false;
  DataProposal proposal;
  DataProposal fallback;
  bool chatLoading = false;
  bool chatLoaded = false;
  Map<Int64, DataProposalChat> chats = <Int64, DataProposalChat>{};
  Map<int, DataProposalChat> ghostChats = <int, DataProposalChat>{};
}

abstract class ApiProposals implements Api, ApiInternals {
  Completer<void> __clientReady = Completer<void>();
  ApiProposalsClient _proposalsClient;
  ApiProposalClient _proposalClient;
  Future<void> get _clientReady {
    return __clientReady.future;
  }

  StreamSubscription<ApiSessionToken> _sessionSubscription;
  void _onSessionChanged(ApiSessionToken session) {
    if (session == null) {
      if (__clientReady.isCompleted) {
        __clientReady = Completer<void>();
      }
      _proposalsClient = null;
      _proposalClient = null;
    } else {
      if (!__clientReady.isCompleted) {
        __clientReady.complete();
      }
      _proposalsClient = ApiProposalsClient(
        session.channel,
        options: grpc.CallOptions(
          metadata: <String, String>{
            'authorization': 'Bearer ${session.token}'
          },
        ),
      );
      _proposalClient = ApiProposalClient(
        session.channel,
        options: grpc.CallOptions(
          metadata: <String, String>{
            'authorization': 'Bearer ${session.token}'
          },
        ),
      );
    }
  }

  @override
  void initProposals() {
    _sessionSubscription = sessionChanged.listen(_onSessionChanged);
  }

  @override
  void disposeProposals() {
    _sessionSubscription.cancel();
    _sessionSubscription = null;
  }

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////

  final Map<Int64, _CachedProposal> _cachedProposals =
      <Int64, _CachedProposal>{};

  @override
  void resetProposalsState() {
    _proposals.clear();
    _proposalsLoaded = false;
    _cachedProposals.clear();
  }

  @override
  void markProposalsDirty() {
    _proposalsLoaded = false;
    for (_CachedProposal cached in _cachedProposals.values) {
      cached.dirty = true;
      cached.chatLoaded = false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle
  /////////////////////////////////////////////////////////////////////////////

  void _cacheProposal(DataProposal proposal, {bool delta = false}) {
    _CachedProposal cached = _cachedProposals[proposal.proposalId];
    if (cached == null) {
      cached = _CachedProposal();
      _cachedProposals[proposal.proposalId] = cached;
    }
    if (delta && cached.proposal == null) {
      // Don't have this proposal yet, can't apply delta
      return;
    }
    cached.fallback = null;
    if (delta) {
      final DataProposal result = cached.proposal.clone();
      result.mergeFromMessage(proposal);
      result.freeze();
      cached.proposal = result;
    } else {
      cached.proposal = proposal;
    }
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
          //cached.fallback.freeze();
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
    await _clientReady;
    // TODO: Specific requests for higher and lower refreshing
    final NetListProposals request = NetListProposals();
    await for (NetProposal response in _proposalsClient.list(request)) {
      _cacheProposal(response.proposal);
      for (DataProposalChat chat in response.chats) {
        _cacheProposalChat(chat);
      }
    }
  }

  @override
  bool proposalsLoading = false;
  bool _proposalsLoaded = false;
  final Map<Int64, DataProposal> _proposals = <Int64, DataProposal>{};

  @override
  Iterable<DataProposal> get proposals {
    if (_proposalsLoaded == false &&
        connected == NetworkConnectionState.ready) {
      _proposalsLoaded = true;
      proposalsLoading = true;
      refreshProposals().catchError((Object error, StackTrace stackTrace) {
        log.severe('Failed to get proposals.', error, stackTrace);
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
      final NetApplyProposal request = NetApplyProposal();
      request.offerId = offerId;
      request.sessionGhostId = ++nextSessionGhostId;
      request.remarks = remarks;
      await _clientReady;
      final NetProposal response = await _proposalsClient.apply(request);
      _cacheProposal(response.proposal);
      for (DataProposalChat chat in response.chats) {
        _cacheProposalChat(chat);
      }
      return response.proposal;
    } catch (error) {
      markOfferDirty(offerId);
      rethrow;
    }
  }

  @override
  Future<DataProposal> getProposal(Int64 proposalId) async {
    final NetGetProposal request = NetGetProposal();
    request.proposalId = proposalId;
    await _clientReady;
    final NetProposal reponse = await _proposalsClient.get(request);
    _cacheProposal(reponse.proposal);
    for (DataProposalChat chat in reponse.chats) {
      log.fine(chat);
      _cacheProposalChat(chat);
    }
    return reponse.proposal;
  }

  Future<void> _loadProposalChats(Int64 proposalId) async {
    final NetListChats request = NetListChats();
    request.proposalId = proposalId;
    log.fine(proposalId);
    log.fine('LISTCHAT');
    await _clientReady;
    await for (NetProposalChat response
        in _proposalsClient.listChats(request)) {
      _cacheProposalChat(response.chat);
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
        getProposal(proposalId).then((_) {
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

  void _receivedUpdateProposal(DataProposal proposal, {bool delta = false}) {
    _cacheProposal(proposal, delta: delta);
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
      // _notifyNewProposalChat(chat);
    }
  }

  @override
  void liveNewProposal(NetProposal push) {
    _receivedUpdateProposal(push.proposal);
    for (DataProposalChat chat in push.chats) {
      _receivedUpdateProposalChat(chat);
      _notifyNewProposalChat(chat);
    }
  }

  @override
  void liveUpdateProposal(NetProposal push, {bool delta = false}) {
    _receivedUpdateProposal(push.proposal, delta: delta);
    for (DataProposalChat chat in push.chats) {
      _receivedUpdateProposalChat(chat);
    }
  }

  @override
  void liveNewProposalChat(NetProposalChat push) {
    _receivedUpdateProposalChat(push.chat);
    _notifyNewProposalChat(push.chat);
  }

  @override
  void liveUpdateProposalChat(NetProposalChat push) {
    _receivedUpdateProposalChat(push.chat);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> reportProposal(Int64 proposalId, String text) async {
    final NetProposalReport request = NetProposalReport();
    request.proposalId = proposalId;
    request.text = text;
    // Response blank. Exception on issue
    await _clientReady;
    await _proposalClient.report(request);
  }

  @override
  Future<void> resubmitGhostChats() async {
    await _clientReady;
    for (_CachedProposal cached in _cachedProposals.values) {
      for (DataProposalChat ghostChat in cached.ghostChats.values) {
        switch (ghostChat.type) {
          case ProposalChatType.plain:
            {
              final NetChatPlain request = NetChatPlain();
              request.proposalId = ghostChat.proposalId;
              request.sessionGhostId = ghostChat.senderSessionGhostId;
              request.text = ghostChat.plainText;
              liveUpdateProposalChat(await _proposalClient.chatPlain(request));
            }
            break;
          case ProposalChatType.negotiate:
            {
              final NetChatNegotiate request = NetChatNegotiate();
              request.proposalId = ghostChat.proposalId;
              request.sessionGhostId = ghostChat.senderSessionGhostId;
              request.terms = ghostChat.terms;
              request.remarks = ghostChat.plainText;
              liveUpdateProposal(await _proposalClient.chatNegotiate(request),
                  delta: true);
            }
            break;
          case ProposalChatType.imageKey:
            {
              final NetChatImageKey request = NetChatImageKey();
              request.proposalId = ghostChat.proposalId;
              request.sessionGhostId = ghostChat.senderSessionGhostId;
              request.imageKey = ghostChat.imageKey;
              liveUpdateProposalChat(
                  await _proposalClient.chatImageKey(request));
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
    final int ghostId = ++nextSessionGhostId;
    if (connected == NetworkConnectionState.ready) {
      final NetChatPlain request = NetChatPlain();
      request.proposalId = proposalId;
      request.sessionGhostId = ghostId;
      request.text = text;
      unawaited(() async {
        liveUpdateProposalChat(await _proposalClient.chatPlain(request));
      }());
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
    final int ghostId = ++nextSessionGhostId;
    final DataTerms terms = DataTerms();
    terms.deliverablesDescription = deliverables;
    terms.rewardItemOrServiceDescription = reward;
    if (connected == NetworkConnectionState.ready) {
      final NetChatNegotiate request = NetChatNegotiate();
      request.proposalId = proposalId;
      request.sessionGhostId = ghostId;
      request.terms = terms;
      request.remarks = remarks;
      unawaited(() async {
        liveUpdateProposal(await _proposalClient.chatNegotiate(request),
            delta: true);
      }());
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
    final int ghostId = ++nextSessionGhostId;
    if (connected == NetworkConnectionState.ready) {
      final NetChatImageKey request = NetChatImageKey();
      request.proposalId = proposalId;
      request.sessionGhostId = ghostId;
      request.imageKey = imageKey;
      unawaited(() async {
        liveUpdateProposalChat(await _proposalClient.chatImageKey(request));
      }());
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
    final NetProposalWantDeal request = NetProposalWantDeal();
    request.proposalId = proposalId;
    request.termsChatId = termsChatId;
    await _clientReady;
    final NetProposal response = await _proposalClient.wantDeal(request);
    _receivedProposalCommonRes(response);
  }

  @override
  Future<void> markCompletion(Int64 proposalId, int rating) async {
    final NetProposalCompletion request = NetProposalCompletion();
    request.proposalId = proposalId;
    request.rating = rating;
    await _clientReady;
    final NetProposal response = await _proposalClient.complete(request);
    _receivedProposalCommonRes(response);
  }
}

/* end of file */
