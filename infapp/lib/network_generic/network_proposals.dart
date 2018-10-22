/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:async/async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:inf/network_generic/change.dart';
import 'package:inf/network_generic/network_interface.dart';
import 'package:inf/network_generic/network_internals.dart';
import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:wstalk/wstalk.dart';

class _CachedProposal {
  bool loading = false;
  bool dirty = false;
  DataApplicant applicant;
  DataApplicant fallback;
  bool chatLoading = false;
  bool chatLoaded = false;
  Map<int, DataApplicantChat> chats = new Map<int, DataApplicantChat>();
  Map<int, DataApplicantChat> ghostChats = new Map<int, DataApplicantChat>();
}

abstract class NetworkProposals implements NetworkInterface, NetworkInternals {
  Map<int, _CachedProposal> _cachedProposals = new Map<int, _CachedProposal>();

  void resetProposalsState() {
    _applicants.clear();
    _applicantsLoaded = false;
    _cachedProposals.clear();
  }

  void markProposalsDirty() {
    _applicantsLoaded = false;
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

  void _cacheApplicant(DataApplicant applicant) {
    _CachedProposal cached = _cachedProposals[applicant.applicantId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[applicant.applicantId] = cached;
    }
    cached.fallback = null;
    cached.applicant = applicant;
    cached.dirty = false;
    if (applicant.businessAccountId == account.state.accountId ||
        applicant.influencerAccountId == account.state.accountId) {
      // Add received offer to known offers
      _applicants[applicant.applicantId] = applicant;
    }
    hintOfferProposal(applicant);
    onProposalChanged(ChangeAction.upsert, new Int64(applicant.applicantId));
  }

  void _cacheApplicantChat(DataApplicantChat chat) {
    _CachedProposal cached = _cachedProposals[chat.applicantId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[chat.applicantId] = cached;
    }
    if (chat.deviceId == account.state.deviceId) {
      cached.ghostChats.remove(chat.deviceGhostId);
    }
    cached.chats[chat.chatId.toInt()] = chat;
    onProposalChatChanged(ChangeAction.upsert, chat);
  }

  static int _netLoadApplicantsReq = TalkSocket.encode("L_APPLIS");
  @override
  Future<void> refreshApplicants() async {
    NetLoadOffersReq req =
        new NetLoadOffersReq(); // TODO: Specific requests for higher and lower refreshing
    // await for (TalkMessage res
    //     in ts.sendStreamRequest(_netLoadApplicantsReq, req.writeToBuffer())) {
    StreamQueue<TalkMessage> sq = StreamQueue<TalkMessage>(
        ts.sendStreamRequest(_netLoadApplicantsReq, req.writeToBuffer()));
    while (await sq.hasNext) {
      TalkMessage res = await sq.next;
      DataApplicant pb = new DataApplicant();
      pb.mergeFromBuffer(res.data);
      _cacheApplicant(pb);
    }
  }

  bool applicantsLoading = false;
  bool _applicantsLoaded = false;
  Map<int, DataApplicant> _applicants = new Map<int, DataApplicant>();

  @override
  Iterable<DataApplicant> get applicants {
    if (_applicantsLoaded == false &&
        connected == NetworkConnectionState.ready) {
      _applicantsLoaded = true;
      applicantsLoading = true;
      refreshApplicants().catchError((error, stack) {
        print("[INF] Failed to get applicants: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          _applicantsLoaded =
              false; // Not using setState since we don't want to broadcast failure state
        });
      }).whenComplete(() {
        applicantsLoading = false;
        onProposalChanged(ChangeAction.refreshAll, Int64.ZERO);
      });
    }
    return _applicants.values;
  }

  static int _netOfferApplyReq = TalkSocket.encode("O_APPLYY");

  /// Create proposal
  @override
  Future<DataApplicant> applyForOffer(int offerId, String remarks) async {
    try {
      NetOfferApplyReq pbReq = new NetOfferApplyReq();
      pbReq.offerId = offerId;
      pbReq.deviceGhostId = ++nextDeviceGhostId;
      pbReq.remarks = remarks;
      TalkMessage res =
          await ts.sendRequest(_netOfferApplyReq, pbReq.writeToBuffer());
      DataApplicant pbRes = new DataApplicant();
      pbRes.mergeFromBuffer(res.data);
      _cacheApplicant(pbRes); // FIXME: Chat not cached directly!
      return pbRes;
    } catch (error) {
      markOfferDirty(new Int64(offerId));
      rethrow;
    }
  }

  static int _netLoadApplicantReq = TalkSocket.encode("L_APPLIC");
  @override
  Future<DataApplicant> getApplicant(Int64 applicantId) async {
    NetLoadApplicantReq pbReq = new NetLoadApplicantReq();
    pbReq.applicantId = applicantId.toInt();
    TalkMessage res =
        await ts.sendRequest(_netLoadApplicantReq, pbReq.writeToBuffer());
    DataApplicant applicant = new DataApplicant();
    applicant.mergeFromBuffer(res.data);
    _cacheApplicant(applicant);
    return applicant;
  }

  static int _netLoadApplicantChatReq = TalkSocket.encode("L_APCHAT");
  Future<void> _loadApplicantChats(int applicantId) async {
    NetLoadApplicantChatsReq pbReq = new NetLoadApplicantChatsReq();
    pbReq.applicantId = applicantId;
    print(applicantId);
    // await for (TalkMessage res in ts.sendStreamRequest(
    //     _netLoadApplicantChatReq, pbReq.writeToBuffer())) {
    StreamQueue<TalkMessage> sq = StreamQueue<TalkMessage>(
        ts.sendStreamRequest(_netLoadApplicantChatReq, pbReq.writeToBuffer()));
    while (await sq.hasNext) {
      TalkMessage res = await sq.next;
      DataApplicantChat chat = new DataApplicantChat();
      chat.mergeFromBuffer(res.data);
      print(chat);
      _cacheApplicantChat(chat);
    }
    print("done");
  }

  DataApplicant _tryGetApplicant(int applicantId,
      {DataApplicant fallback, DataBusinessOffer fallbackOffer}) {
    _CachedProposal cached = _cachedProposals[applicantId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[applicantId] = cached;
    }
    if (cached.applicant == null || cached.dirty) {
      if (!cached.loading && connected == NetworkConnectionState.ready) {
        cached.loading = true;
        getApplicant(new Int64(applicantId)).then((applicant) {
          cached.loading = false;
        }).catchError((error, stack) {
          print("[INF] Failed to get applicant: $error, $stack");
          new Timer(new Duration(seconds: 3), () {
            cached.loading = false;
            onProposalChanged(ChangeAction.retry, new Int64(applicantId));
          });
        });
      }
      if (cached.applicant != null) {
        return cached.applicant; // Return dirty
      }
      if (cached.fallback == null) {
        cached.fallback = new DataApplicant();
        cached.fallback.applicantId = applicantId;
      }
      if (fallback != null) {
        cached.fallback.mergeFromMessage(fallback);
      }
      if (fallbackOffer != null) {
        cached.fallback.offerId = fallbackOffer.offerId;
        cached.fallback.businessAccountId = fallbackOffer.accountId;
      }
      return cached.fallback;
    }
    return cached.applicant;
  }

  /// Fetch latest applicant from cache by id, fetch in background if non-existent
  @override
  DataApplicant tryGetApplicant(Int64 applicantId,
      {DataBusinessOffer fallbackOffer}) {
    return _tryGetApplicant(applicantId.toInt(), fallbackOffer: fallbackOffer);
  }

  /// Fetch latest applicant from cache, fetch in background if non-existent
  @override
  DataApplicant latestApplicant(DataApplicant applicant) {
    return _tryGetApplicant(applicant.applicantId, fallback: applicant);
  }

  /// Fetch latest known applicant chats from cache, fetch in background if not loaded yet
  @override
  Iterable<DataApplicantChat> tryGetApplicantChats(Int64 applicantId) {
    _CachedProposal cached = _cachedProposals[applicantId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[applicantId.toInt()] = cached;
    }
    if (!cached.chatLoaded &&
        !cached.chatLoading &&
        connected == NetworkConnectionState.ready) {
      print("fetch chat");
      cached.chatLoading = true;
      _loadApplicantChats(applicantId.toInt()).then((applicant) {
        cached.chatLoading = false;
        cached.chatLoaded = true;
      }).catchError((error, stack) {
        print("[INF] Failed to get applicant chats: $error, $stack");
        new Timer(new Duration(seconds: 3), () {
          cached.chatLoading = false;
          onProposalChanged(ChangeAction.retry, applicantId);
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

  void _receivedUpdateApplicant(DataApplicant applicant) {
    _cacheApplicant(applicant);
  }

  void _receivedUpdateApplicantChat(DataApplicantChat chat) {
    _cacheApplicantChat(chat);
  }

  void _notifyNewApplicantChat(DataApplicantChat chat) {
    // TODO: Notify the user of a new applicant chat message if not own
    print("[INF] Notify: ${chat.text}");
  }

  void _receivedApplicantCommonRes(NetApplicantCommonRes res) {
    _receivedUpdateApplicant(res.updateApplicant);
    for (DataApplicantChat chat in res.newChats) {
      _receivedUpdateApplicantChat(chat);
      _notifyNewApplicantChat(chat);
    }
  }

  void liveNewApplicant(TalkMessage message) {
    DataApplicant pb = new DataApplicant();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicant(pb);
  }

  void liveNewApplicantChat(TalkMessage message) {
    DataApplicantChat pb = new DataApplicantChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicantChat(pb);
    _notifyNewApplicantChat(pb);
  }

  void liveUpdateApplicant(TalkMessage message) {
    DataApplicant pb = new DataApplicant();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicant(pb);
  }

  void liveUpdateApplicantChat(TalkMessage message) {
    DataApplicantChat pb = new DataApplicantChat();
    pb.mergeFromBuffer(message.data);
    _receivedUpdateApplicantChat(pb);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  static int _netApplicantReportReq = TalkSocket.encode("AP_REPOR");
  @override
  Future<void> reportApplicant(int applicantId, String text) async {
    NetApplicantReportReq pbReq = new NetApplicantReportReq();
    pbReq.applicantId = applicantId;
    pbReq.text = text;
    // Response blank. Exception on issue
    await ts.sendRequest(_netApplicantReportReq, pbReq.writeToBuffer());
  }

  void resubmitGhostChats() {
    for (_CachedProposal cached in _cachedProposals.values) {
      for (DataApplicantChat ghostChat in cached.ghostChats.values) {
        switch (ghostChat.type) {
          case ApplicantChatType.ACT_PLAIN:
            {
              NetChatPlain pbReq = new NetChatPlain();
              pbReq.applicantId = ghostChat.applicantId;
              pbReq.deviceGhostId = ghostChat.deviceGhostId;
              pbReq.text = ghostChat.text;
              ts.sendMessage(_netChatPlain, pbReq.writeToBuffer());
            }
            break;
          case ApplicantChatType.ACT_HAGGLE:
            {
              NetChatHaggle pbReq = new NetChatHaggle();
              pbReq.applicantId = ghostChat.applicantId;
              pbReq.deviceGhostId = ghostChat.deviceGhostId;
              Map<String, String> query = Uri.splitQueryString(ghostChat.text);
              pbReq.deliverables = query['deliverables'];
              pbReq.reward = query['reward'];
              pbReq.remarks = query['remarks'];
              ts.sendMessage(_netChatHaggle, pbReq.writeToBuffer());
            }
            break;
          case ApplicantChatType.ACT_IMAGE_KEY:
            {
              NetChatImageKey pbReq = new NetChatImageKey();
              pbReq.applicantId = ghostChat.applicantId;
              pbReq.deviceGhostId = ghostChat.deviceGhostId;
              Map<String, String> query = Uri.splitQueryString(ghostChat.text);
              pbReq.imageKey = query['key'];
              ts.sendMessage(_netChatImageKey, pbReq.writeToBuffer());
            }
            break;
        }
      }
    }
  }

  void _createGhostChat(
      int applicantId, int deviceGhostId, ApplicantChatType type, String text) {
    _CachedProposal cached = _cachedProposals[applicantId];
    if (cached == null) {
      cached = new _CachedProposal();
      _cachedProposals[applicantId] = cached;
    }
    DataApplicantChat ghostChat = new DataApplicantChat();
    ghostChat.sent =
        new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);
    ghostChat.senderId = account.state.accountId;
    ghostChat.applicantId = applicantId;
    ghostChat.deviceId = account.state.deviceId;
    ghostChat.deviceGhostId = deviceGhostId;
    ghostChat.type = type;
    ghostChat.text = text;
    cached.ghostChats[deviceGhostId] = ghostChat;
    onProposalChatChanged(ChangeAction.add, ghostChat);

    // TODO: Store ghost chats offline
  }

  static int _netChatPlain = TalkSocket.encode("CH_PLAIN");
  @override
  void chatPlain(int applicantId, String text) {
    int ghostId = ++nextDeviceGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatPlain pbReq = new NetChatPlain();
      pbReq.applicantId = applicantId;
      pbReq.deviceGhostId = ghostId;
      pbReq.text = text;
      ts.sendMessage(_netChatPlain, pbReq.writeToBuffer());
    }
    _createGhostChat(applicantId, ghostId, ApplicantChatType.ACT_PLAIN, text);
  }

  static int _netChatHaggle = TalkSocket.encode("CH_HAGGLE");
  @override
  void chatHaggle(
      int applicantId, String deliverables, String reward, String remarks) {
    int ghostId = ++nextDeviceGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatHaggle pbReq = new NetChatHaggle();
      pbReq.applicantId = applicantId;
      pbReq.deviceGhostId = ghostId;
      pbReq.deliverables = deliverables;
      pbReq.reward = reward;
      pbReq.remarks = remarks;
      ts.sendMessage(_netChatHaggle, pbReq.writeToBuffer());
    }
    _createGhostChat(
      applicantId,
      ghostId,
      ApplicantChatType.ACT_HAGGLE,
      "deliverables=" +
          Uri.encodeQueryComponent(deliverables) +
          "&reward=" +
          Uri.encodeQueryComponent(reward) +
          "&remarks=" +
          Uri.encodeQueryComponent(remarks),
    );
  }

  static int _netChatImageKey = TalkSocket.encode("CH_IMAGE");
  @override
  void chatImageKey(int applicantId, String imageKey) {
    int ghostId = ++nextDeviceGhostId;
    if (connected == NetworkConnectionState.ready) {
      NetChatImageKey pbReq = new NetChatImageKey();
      pbReq.applicantId = applicantId;
      pbReq.deviceGhostId = ghostId;
      pbReq.imageKey = imageKey;
      ts.sendMessage(_netChatImageKey, pbReq.writeToBuffer());
    }
    _createGhostChat(
      applicantId,
      ghostId,
      ApplicantChatType.ACT_IMAGE_KEY,
      "key=" + Uri.encodeQueryComponent(imageKey),
    );
  }

  static int _netApplicantWantDealReq = TalkSocket.encode("AP_WADEA");
  @override
  Future<void> wantDeal(int applicantId, int haggleChatId) async {
    NetApplicantWantDealReq pbReq = NetApplicantWantDealReq();
    pbReq.applicantId = applicantId;
    pbReq.haggleChatId = new Int64(haggleChatId);
    TalkMessage res =
        await ts.sendRequest(_netApplicantWantDealReq, pbReq.writeToBuffer());
    NetApplicantCommonRes pbRes = new NetApplicantCommonRes();
    pbRes.mergeFromBuffer(res.data);
    _receivedApplicantCommonRes(pbRes);
  }
}

/* end of file */
