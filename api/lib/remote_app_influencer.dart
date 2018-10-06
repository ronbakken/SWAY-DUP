/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';
import 'package:wstalk/wstalk.dart';

import 'package:sqljocky5/sqljocky.dart' as sqljocky;
import 'package:dospace/dospace.dart' as dospace;

import 'broadcast_center.dart';
import 'protobuf/inf_protobuf.dart';
import 'remote_app.dart';

class RemoteAppInfluencer {
  //////////////////////////////////////////////////////////////////////////////
  // Inherited properties
  //////////////////////////////////////////////////////////////////////////////

  RemoteApp _r;
  ConfigData get config {
    return _r.config;
  }

  sqljocky.ConnectionPool get sql {
    return _r.sql;
  }

  TalkSocket get ts {
    return _r.ts;
  }

  BroadcastCenter get bc {
    return _r.bc;
  }

  DataAccount get account {
    return _r.account;
  }

  int get accountId {
    return _r.account.state.accountId.toInt();
  }

  GlobalAccountState get globalAccountState {
    return _r.account.state.globalAccountState;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Construction
  //////////////////////////////////////////////////////////////////////////////

  static final Logger opsLog = new Logger('InfOps.RemoteAppInfluencer');
  static final Logger devLog = new Logger('InfDev.RemoteAppInfluencer');

  RemoteAppInfluencer(this._r) {
    _netLoadOffersReq = _r.saferListen(
        "L_OFFERS", GlobalAccountState.GAS_READ_ONLY, true, netLoadOffersReq);
    _netOfferApplyReq = _r.saferListen(
        "O_APPLYY", GlobalAccountState.GAS_READ_ONLY, true, netOfferApplyReq);
  }

  void dispose() {
    if (_netLoadOffersReq != null) {
      _netLoadOffersReq.cancel();
      _netLoadOffersReq = null;
    }
    if (_netOfferApplyReq != null) {
      _netOfferApplyReq.cancel();
      _netOfferApplyReq = null;
    }
    _r = null;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Database utilities
  //////////////////////////////////////////////////////////////////////////////

  // ...

  //////////////////////////////////////////////////////////////////////////////
  // Network messages
  //////////////////////////////////////////////////////////////////////////////

  // Demo function to get all offers
  StreamSubscription<TalkMessage> _netLoadOffersReq; // C_OFFERR
  static int _demoAllBusinessOffer = TalkSocket.encode("DE_OFFER");
  static int _netLoadOffersRes = TalkSocket.encode("L_R_OFFE");
  Future<void> netLoadOffersReq(TalkMessage message) async {
    NetLoadOffersReq pb = new NetLoadOffersReq();
    pb.mergeFromBuffer(message.data);
    devLog.finest(pb);
    // TODO: Limit number of results
    ts.sendExtend(message);
    sqljocky.RetainedConnection connection = await sql.getConnection();
    try {
      ts.sendExtend(message);
      sqljocky.Query selectImageKeys = await connection.prepare(
          "SELECT `image_key` FROM `offer_images` WHERE `offer_id` = ?");
      try {
        String selectOffers =
            "SELECT `offers`.`offer_id`, `offers`.`account_id`, " // 0 1
            "`offers`.`title`, `offers`.`description`, `offers`.`deliverables`, `offers`.`reward`, " // 2 3 4 5
            "`offers`.`location_id`, `addressbook`.`detail`, `addressbook`.`point`, " // 6 7 8
            "`offers`.`state`, `offers`.`state_reason`, " // 9 10
            "`addressbook`.`offer_count`, `addressbook`.`name`, " // 11 12
            // "(SELECT `applicants`.`applicant_id` FROM `applicants` WHERE `applicants`.`offer_id` = `offers`.`offer_id` AND `applicants`.`influencer_account_id` = ?) " // 13
            "`applicants`.`applicant_id` " // 13
            "FROM `offers` "
            "INNER JOIN `addressbook` ON `addressbook`.`location_id` = `offers`.`location_id` "
            "LEFT OUTER JOIN `applicants` "
            "ON `applicants`.`offer_id` = `offers`.`offer_id` AND `applicants`.`influencer_account_id` = ? "
            "WHERE `offers`.`state` = ? "
            "ORDER BY `offer_id` DESC";
        sqljocky.Results offerResults = await sql.prepareExecute(selectOffers, [
          accountId,
          BusinessOfferState.BOS_OPEN.value.toInt(),
        ]);
        await for (sqljocky.Row offerRow in offerResults) {
          ts.sendExtend(message);
          DataBusinessOffer offer = new DataBusinessOffer();
          offer.offerId = offerRow[0].toInt();
          offer.accountId = offerRow[1].toInt();
          offer.locationId = offerRow[6].toInt();
          offer.title = offerRow[2].toString();
          offer.description = offerRow[3].toString();
          offer.deliverables = offerRow[4].toString();
          offer.reward = offerRow[5].toString();
          offer.locationName = offerRow[12].toString();
          offer.location = offerRow[7].toString();
          Uint8List point = offerRow[8];
          if (point != null) {
            // Attempt to parse point, see https://dev.mysql.com/doc/refman/5.7/en/gis-data-formats.html#gis-wkb-format
            ByteData data = new ByteData.view(point.buffer);
            Endian endian = data.getInt8(4) == 0 ? Endian.big : Endian.little;
            int type = data.getUint32(4 + 1, endian = endian);
            if (type == 1) {
              offer.latitude = data.getFloat64(4 + 5 + 8, endian = endian);
              offer.longitude = data.getFloat64(4 + 5, endian = endian);
            }
          }
          offer.locationOfferCount = offerRow[11].toInt();
          // offer.coverUrls.addAll(filteredImageKeys.map((v) => _r.makeCloudinaryCoverUrl(v)));
          // TODO: categories
          offer.state = BusinessOfferState.valueOf(offerRow[9].toInt());
          offer.stateReason =
              BusinessOfferStateReason.valueOf(offerRow[10].toInt());
          sqljocky.Results imageKeyResults =
              await selectImageKeys.execute([offer.offerId.toInt()]);
          await for (sqljocky.Row imageKeyRow in imageKeyResults) {
            if (!offer.hasThumbnailUrl()) {
              offer.thumbnailUrl =
                  _r.makeCloudinaryThumbnailUrl(imageKeyRow[0]);
              offer.blurredThumbnailUrl =
                  _r.makeCloudinaryBlurredThumbnailUrl(imageKeyRow[0]);
            }
            offer.coverUrls.add(_r.makeCloudinaryCoverUrl(imageKeyRow[0]));
            offer.blurredCoverUrls
                .add(_r.makeCloudinaryBlurredCoverUrl(imageKeyRow[0]));
          }
          if (offerRow[13] != null) {
            offer.influencerApplicantId = offerRow[13].toInt();
          }
          // Cache offer for use (is this really necessary?)
          // offers[offer.offerId] = offer;
          // Send offer to user
          devLog.finest("Send offer '${offer.title}'");
          ts.sendMessage(_demoAllBusinessOffer, offer.writeToBuffer(),
              replying: message);
        }
        ts.sendExtend(message);
      } finally {
        await selectImageKeys.close();
      }
    } finally {
      await connection.release();
    }

    devLog.finest("Done sending demo offers");
    //NetLoadOffersRes loadOffersRes = new NetLoadOffersRes();
    //ts.sendMessage(_netLoadOffersRes, loadOffersRes.writeToBuffer(),
    //    replying: message);
    ts.sendEndOfStream(message);
  }

  StreamSubscription<TalkMessage> _netOfferApplyReq; // C_OFFERR
  static int _netOfferApplyRes = TalkSocket.encode("O_R_APPL");
  Future<void> netOfferApplyReq(TalkMessage message) async {
    NetOfferApplyReq pb = new NetOfferApplyReq();
    pb.mergeFromBuffer(message.data);

    print("NetOfferApplyReq: $pb");

    DataApplicant applicant = new DataApplicant();
    applicant.offerId = pb.offerId;
    applicant.influencerAccountId = accountId;
    applicant.state = ApplicantState.AS_HAGGLING;
    DataApplicantChat chat = new DataApplicantChat();
    chat.senderId = accountId;
    chat.deviceId = account.state.deviceId;
    chat.deviceGhostId = pb.deviceGhostId;
    chat.type = ApplicantChatType.ACT_HAGGLE;

    // Fetch some offer info
    ts.sendExtend(message);
    int businessAccountId;
    String deliverables;
    String reward;
    String selectOrder =
        "SELECT " // Okay to just check `state` here since it's fine if more applications arrive than needed
        "`account_id`, `deliverables`, `reward`, `state` FROM `offers` WHERE `offer_id` = ?";
    await for (sqljocky.Row row
        in await sql.prepareExecute(selectOrder, [pb.offerId])) {
      businessAccountId = row[0].toInt();
      deliverables = row[1].toString();
      reward = row[2].toString();
      BusinessOfferState state = BusinessOfferState.valueOf(row[3].toInt());
      if (state != BusinessOfferState.BOS_OPEN) {
        throw new Exception("Business offer not open for new applications");
      }
    }
    if (businessAccountId == null || businessAccountId == 0) {
      throw new Exception("Business account for offer not found");
    }
    applicant.businessAccountId = businessAccountId;

    String chatText = 'deliverables=${Uri.encodeQueryComponent(deliverables)}&'
        'reward=${Uri.encodeQueryComponent(reward)}&'
        'remarks=${Uri.encodeQueryComponent(pb.remarks.trim())}';
    chat.text = chatText;

    ts.sendExtend(message);
    await sql.startTransaction((transaction) async {
      // 1. Insert into applicants
      ts.sendExtend(message);
      String insertApplicant = "INSERT INTO `applicants`("
          "`offer_id`, `influencer_account_id`, `business_account_id`, `sender_account_id`, `state`) "
          "VALUES (?, ?, ?, ?, ?)";
      sqljocky.Results resultApplicant =
          await transaction.prepareExecute(insertApplicant, [
        pb.offerId.toInt(),
        accountId,
        businessAccountId,
        accountId,
        ApplicantState.AS_HAGGLING.value,
      ]);
      int applicantId = resultApplicant.insertId;
      if (applicantId == null || applicantId == 0) {
        throw new Exception("Applicant not inserted");
      }
      applicant.applicantId = applicantId;
      chat.applicantId = applicantId;

      // 2. Insert haggle into chat
      ts.sendExtend(message);
      var chatHaggle = new Map<String, String>();
      chatHaggle['deliverables'] = "Deliverables";
      chatHaggle['reward'] = "Reward";
      chatHaggle['remarks'] = pb.remarks;
      String insertHaggle = "INSERT INTO `applicant_haggling`("
          "`sender_id`, `applicant_id`, "
          "`device_id`, `device_ghost_id`, "
          "`type`, `text`) "
          "VALUES (?, ?, ?, ?, ?, ?)";
      sqljocky.Results resultHaggle =
          await transaction.prepareExecute(insertHaggle, [
        accountId,
        applicantId,
        account.state.deviceId,
        pb.deviceGhostId, // Not actually used for apply chat, but need it for consistency
        ApplicantChatType.ACT_HAGGLE.value,
        chatText,
      ]);
      int haggleChatId = resultHaggle.insertId;
      if (haggleChatId == null || haggleChatId == 0) {
        throw new Exception("Haggle chat not inserted");
      }
      applicant.haggleChatId = new Int64(haggleChatId);
      chat.chatId = new Int64(haggleChatId);
      chat.sent =
          new Int64(new DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000);

      // 3. Update haggle on applicant
      ts.sendExtend(message);
      String updateHaggleChatId = "UPDATE `applicants` "
          "SET `haggle_chat_id` = ? "
          "WHERE `applicant_id` = ?";
      sqljocky.Results resultUpdateHaggleChatId =
          await transaction.prepareExecute(updateHaggleChatId, [
        haggleChatId,
        applicantId,
      ]);
      if (resultUpdateHaggleChatId.affectedRows == null ||
          resultUpdateHaggleChatId.affectedRows == 0) {
        throw new Exception("Failed to update haggle chat id");
      }

      ts.sendExtend(message);
      transaction.commit();
    });

    devLog.finest("Applied for offer successfully: $applicant");
    ts.sendMessage(_netOfferApplyRes, applicant.writeToBuffer(),
        replying: message);

    // Clear private information from broadcast
    chat.deviceId = 0;
    chat.deviceGhostId = 0;

    // Broadcast
    await bc.applicantPosted(account.state.deviceId, applicant, account);
    await bc.applicantChatPosted(account.state.deviceId, chat, account);

    // TODO: Update offer applicant count
  }
}
