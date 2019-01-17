/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <jan.boon@kaetemi.be>
*/

import 'dart:convert';
import 'dart:core';

import 'package:fixnum/fixnum.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf_server_explore/common_categories.dart';
import 'package:s2geometry/s2geometry.dart';
import 'package:geohash/geohash.dart';

class ElasticsearchOffer {
  static Int64 wangHash(Int64 key) {
    Int64 hash = key;
    hash = (~hash) + (hash << 21); // hash = (hash << 21) - hash - 1;
    hash = hash ^ (hash >> 24);
    hash = (hash + (hash << 3)) + (hash << 8); // hash * 265
    hash = hash ^ (hash >> 14);
    hash = (hash + (hash << 2)) + (hash << 4); // hash * 21
    hash = hash ^ (hash >> 28);
    hash = hash + (hash << 31);
    return hash;
  }

  static int shardHash(Int64 key) {
    // Sharding based on 16k shard slots
    Int64 hash = wangHash(key);
    hash = hash ^ (hash >> 32);
    hash = hash ^ (hash >> 16);
    hash = hash & Int64(0x3FFF);
    return hash.toInt();
  }

  static int shardHashString(String key) {
    // Sharding based on 16k shard slots
    int hash = key.hashCode;
    hash = hash ^ (hash >> 16);
    hash = hash & 0x3FFF;
    return hash;
  }

  static const int kSearchSize = 255;

  static const List<String> kPrivateFields = <String>[
    // Summary
    'location_id', // Private
    // State
    'state',
    'state_reason',
    'archived',
    'proposals_proposing',
    'proposals_negotiating',
    'proposals_deal',
    'proposals_rejected',
    'proposals_dispute',
    'proposals_resolved',
    'proposals_complete',
  ];

  static const List<String> kSummaryFields = <String>[
    // Summary
    'offer_id',
    'sender_account_id',
    'sender_account_type',
    'title',
    'thumbnail_key',
    'thumbnail_blurred',
    'deliverable_social_platforms',
    'deliverable_content_formats',
    'reward_cash_value',
    'reward_item_or_service_value',
    'primary_categories',
    'sender_name',
    'sender_avatar_url', // TODO: Fix this
    'sender_avatar_key', // TODO: Fix this
    'sender_avatar_blurred',
    'location_address',
    'location',
  ];

  static final List<String> kPrivateSummaryFields =
      (kPrivateFields + kSummaryFields).toList();

  static dynamic toJson(
    ConfigData config,
    DataOffer offer, {
    DataAccount sender,
    DataLocation location,
    AccountType senderAccountType,
    bool create = false, // Include created timestamp, and creation fields
    bool modify = true,
    Int64 sessionId,
    bool state =
        false, // Include updating state values, only for server side state updates (must have direct, state, archived options set to update published)
    bool verbose =
        false, // Include updating embedded and creation values from offer, not safe
  }) {
    final Map<String, dynamic> doc = <String, dynamic>{};
    final int millis = DateTime.now().toUtc().millisecondsSinceEpoch;
    /*
    // Not part of the document
    if (offer.hasOfferId()) {
      doc['offer_id'] = offer.offerId.toInt();
    }
    */
    if (create || verbose) {
      if (sender != null && sender.hasAccountId()) {
        doc['sender_account_id'] = sender.accountId.toInt();
      } else if (offer.hasSenderAccountId()) {
        doc['sender_account_id'] = offer.senderAccountId.toInt();
      }
    }
    AccountType senderAccountTypeUpdated = senderAccountType;
    if (sender != null && sender.hasAccountType()) {
      senderAccountTypeUpdated = sender.accountType;
    } else if (offer.hasSenderAccountType()) {
      senderAccountTypeUpdated = offer.senderAccountType;
    }
    if ((create || verbose) && senderAccountTypeUpdated != null) {
      doc['sender_account_type'] = senderAccountTypeUpdated.value;
    }
    if (location != null && sender.hasLocationId()) {
      doc['location_id'] = location.locationId.toInt();
    } else if (offer.hasLocationId()) {
      doc['location_id'] = offer.locationId.toInt();
    }
    if ((create || verbose) && offer.hasDirect()) {
      doc['direct'] = offer.direct;
    }
    if ((create || verbose) && offer.hasAcceptMatchingProposals()) {
      doc['accept_matching_proposals'] = offer.acceptMatchingProposals;
    }
    if ((create || verbose) && offer.hasAllowNegotiatingProposals()) {
      doc['allow_negotiating_proposals'] = offer.allowNegotiatingProposals;
    }
    if ((create || verbose) && sessionId != null) {
      doc['sender_session_id'] = sessionId.toInt();
    }
    if (create) {
      doc['created'] = millis;
    }
    if (create || modify) {
      doc['modified'] = millis;
    }
    if (offer.hasTitle()) {
      doc['title'] = offer.title;
    }
    if (offer.hasThumbnailKey()) {
      doc['thumbnail_key'] = offer.thumbnailKey;
    }
    if (offer.hasThumbnailBlurred()) {
      doc['thumbnail_blurred'] = base64.encode(offer.thumbnailBlurred);
    }
    if (offer.hasTerms()) {
      if (offer.terms.deliverableSocialPlatforms.isNotEmpty) {
        doc['deliverable_social_platforms'] =
            offer.terms.deliverableSocialPlatforms;
        final Set<String> keywords = Set<String>();
        for (int id in offer.terms.deliverableSocialPlatforms)
          keywords.addAll(config.oauthProviders[id].keywords);
        doc['deliverable_social_platforms_keywords'] = keywords.toList();
      }
      if (offer.terms.deliverableContentFormats.isNotEmpty) {
        doc['deliverable_content_formats'] =
            offer.terms.deliverableContentFormats;
        final Set<String> keywords = Set<String>();
        for (int id in offer.terms.deliverableContentFormats)
          keywords.addAll(config.contentFormats[id].keywords);
        doc['deliverable_content_formats_keywords'] = keywords.toList();
      }
      if (offer.terms.hasDeliverablesDescription()) {
        doc['deliverables_description'] = offer.terms.deliverablesDescription;
      }
      if (offer.terms.hasRewardCashValue()) {
        doc['reward_cash_value'] = offer.terms.rewardCashValue;
      }
      if (offer.terms.hasRewardItemOrServiceValue()) {
        doc['reward_item_or_service_value'] =
            offer.terms.rewardItemOrServiceValue;
      }
      if (offer.terms.hasRewardCashValue() ||
          offer.terms.hasRewardItemOrServiceValue()) {
        doc['reward_total_value'] =
            offer.terms.rewardCashValue + offer.terms.rewardItemOrServiceValue;
      }
      if (offer.terms.hasRewardItemOrServiceDescription()) {
        doc['reward_item_or_service_description'] =
            offer.terms.rewardItemOrServiceDescription;
      }
    }
    if (sender != null && sender.hasName()) {
      doc['sender_name'] = sender.name;
    } else if (verbose && offer.hasSenderName()) {
      doc['sender_name'] = offer.senderName;
    }
    if (sender != null && sender.hasAvatarUrl()) {
      doc['sender_avatar_url'] = sender.avatarUrl;
    } else if (verbose && offer.hasSenderAvatarUrl()) {
      doc['sender_avatar_url'] = offer.senderAvatarUrl;
    }
    // TODO(kaetemi): sender.avatarBlurred
    /*if (sender != null && sender.hasBlurredAvatarUrl()) {
      doc['sender_avatar_blurred'] = sender.blurredAvatarUrl;
    }*/
    if (offer.hasSenderAvatarBlurred()) {
      doc['sender_avatar_blurred'] = base64.encode(offer.senderAvatarBlurred);
    }
    if (senderAccountTypeUpdated == AccountType.influencer &&
        location != null &&
        location.hasApproximate()) {
      doc['location_address'] = location.approximate;
    } else if (senderAccountTypeUpdated == AccountType.business &&
        location != null &&
        location.hasDetail()) {
      doc['location_address'] = location.detail;
    } else if (verbose && offer.hasLocationAddress()) {
      doc['location_address'] = offer.locationAddress;
    }
    /*
    // Not accurate: Sender location is not offer location
    // Do not include the following
    else if (sender.hasLocationAddress()) {
      doc['location_address'] = sender.locationAddress;
    }
    */
    double latitude;
    double longitude;
    if (location != null && location.hasLatitude() && location.hasLongitude()) {
      doc['location'] = <String, double>{
        'lat': location.latitude,
        'lon': location.longitude
      };
      latitude = location.latitude;
      longitude = location.longitude;
    } else if (verbose && offer.hasLatitude() && offer.hasLongitude()) {
      doc['location'] = <String, double>{
        'lat': offer.latitude,
        'lon': offer.longitude
      };
      latitude = offer.latitude;
      longitude = offer.longitude;
    }
    /*
    // Not accurate: Sender location is not offer location
    // Do not include the following
    else if (sender.hasLatitude() && sender.hasLongitude()) {
      doc['location'] = {
        'lat': sender.latitude,
        'lon': sender.longitude
      };
    }
    */
    if (offer.hasDescription()) {
      doc['description'] = offer.description;
    }
    if (offer.coverKeys.isNotEmpty) {
      doc['cover_keys'] = offer.coverKeys;
    }
    if (offer.coversBlurred.isNotEmpty) {
      doc['covers_blurred'] = offer.coversBlurred
          .map<String>((List<int> coverBlurred) => base64.encode(coverBlurred))
          .toList();
    }
    /*
    TODO
    date scheduled_open
    date scheduled_close
    */
    if (offer.categories.isNotEmpty) {
      final List<int> leafCategories =
          Categories.getLeafCategories(config, offer.categories);
      final List<int> rootCategories =
          Categories.getRootCategories(config, offer.categories);
      final List<int> extendedCategories =
          Categories.getExtendedCategories(config, offer.categories);
      doc['categories'] = leafCategories;
      doc['category_keywords'] = Categories.getKeywords(config, leafCategories);
      doc['primary_categories'] = rootCategories;
      doc['primary_category_keywords'] =
          Categories.getKeywords(config, rootCategories);
      doc['expanded_categories'] = extendedCategories;
      doc['expanded_category_keywords'] =
          Categories.getKeywords(config, extendedCategories);
    }
    if ((verbose || state || create) && offer.hasState()) {
      doc['state'] = offer.state.value;
    }
    if ((verbose || state || create) && offer.hasStateReason()) {
      doc['state_reason'] = offer.stateReason.value;
    }
    if ((verbose || state) && offer.archived) {
      doc['archived'] = offer.archived;
    }
    if ((verbose || state) &&
        offer.hasState() &&
        offer.hasDirect() &&
        offer.hasArchived()) {
      doc['published'] =
          !offer.direct && !offer.archived && offer.state == OfferState.open;
    }
    if ((verbose || state) && offer.hasProposalsProposing()) {
      doc['proposals_proposing'] = offer.proposalsProposing;
    }
    if ((verbose || state) && offer.hasProposalsNegotiating()) {
      doc['proposals_negotiating'] = offer.proposalsNegotiating;
    }
    if ((verbose || state) && offer.hasProposalsDeal()) {
      doc['proposals_deal'] = offer.proposalsDeal;
    }
    if ((verbose || state) && offer.hasProposalsRejected()) {
      doc['proposals_rejected'] = offer.proposalsRejected;
    }
    if ((verbose || state) && offer.hasProposalsDispute()) {
      doc['proposals_dispute'] = offer.proposalsDispute;
    }
    if ((verbose || state) && offer.hasProposalsResolved()) {
      doc['proposals_resolved'] = offer.proposalsResolved;
    }
    if ((verbose || state) && offer.hasProposalsComplete()) {
      doc['proposals_complete'] = offer.proposalsComplete;
    }
    if (latitude != null && longitude != null) {
      final S2LatLng latLng = S2LatLng.fromDegrees(latitude, longitude);
      final S2CellId cellId = S2CellId.fromLatLng(latLng);
      final List<int> s2CellIds = <int>[];
      for (int level = 0; level <= 30; ++level) {
        s2CellIds.add(cellId.parent(level).id);
      }
      final List<int> s2CellIdShards =
          s2CellIds.map((int s2CellId) => shardHash(Int64(s2CellId))).toList();
      doc['s2cell_ids'] = s2CellIds;
      doc['s2cell_id_shards'] = s2CellIdShards;
      final List<String> geohashes = <String>[];
      for (int level = 1; level <= 20; ++level) {
        geohashes.add(Geohash.encode(latitude, longitude, codeLength: level));
      }
      final List<int> geohashShards =
          geohashes.map((String geohash) => shardHashString(geohash)).toList();
      doc['geohashes'] = geohashes;
      doc['geohash_shards'] = geohashShards;
    }
    /*
    // TODO: Geohash int
    (denormalized) array long geohash_ints
    (denormalized) array short geohash_int_shards
    // Not done here. Incrementally updated
    (denormalized) array long proposal_sender_ids
    // TODO: Keywords from images
    (ai) array keyword image_keywords (keywords pulled from images)
    */
    return doc;
  }

  static DataOffer fromJson(
    ConfigData config,
    Map<dynamic, dynamic> doc, {
    bool state = false,
    bool summary = false,
    bool detail = false,
    bool private = false,
    Int64 offerId,
    Int64 receiver,
  }) {
    final DataOffer offer = DataOffer();
    offer.terms = DataTerms();
    if (offerId != null) {
      offer.offerId = offerId;
    }
    /*
    Not part of the document
    if (doc.containsKey('offer_id')) {
      offer.offerId = new Int64(doc['offer_id']);
    }
    */
    if (doc.containsKey('sender_account_id')) {
      offer.senderAccountId = Int64(doc['sender_account_id']);
    }
    if (doc.containsKey('sender_account_type')) {
      offer.senderAccountType = AccountType.valueOf(doc['sender_account_type']);
    }
    final bool receiverIsOwner = receiver != null &&
        receiver != Int64.ZERO &&
        receiver == offer.senderAccountId;
    if ((private && receiverIsOwner) && doc.containsKey('location_id')) {
      offer.locationId = Int64(doc['location_id']);
    }
    if ((state || detail) && doc.containsKey('direct')) {
      offer.direct = doc['direct'];
    }
    if ((state || detail) && doc.containsKey('accept_matching_proposals')) {
      offer.acceptMatchingProposals = doc['accept_matching_proposals'];
    }
    if ((state || detail) && doc.containsKey('allow_negotiating_proposals')) {
      offer.allowNegotiatingProposals = doc['allow_negotiating_proposals'];
    }
    if ((summary || detail) && doc.containsKey('title')) {
      offer.title = doc['title'];
    }
    if ((summary || detail) && doc.containsKey('thumbnail_key')) {
      if (private && receiverIsOwner) {
        offer.thumbnailKey = doc['thumbnail_key'];
      }
      offer.thumbnailUrl = config.services.galleryThumbnailUrl
          .replaceAll('{key}', doc['thumbnail_key']);
    }
    if ((summary || detail) && doc.containsKey('thumbnail_blurred')) {
      offer.thumbnailBlurred = base64.decode(doc['thumbnail_blurred']);
    }
    if (summary || detail) {
      if (doc.containsKey('deliverable_social_platforms')) {
        offer.terms.deliverableSocialPlatforms.addAll(
            doc['deliverable_social_platforms']
                .map<int>((dynamic value) => value as int));
      }
      if (doc.containsKey('deliverable_content_formats')) {
        offer.terms.deliverableContentFormats.addAll(
            doc['deliverable_content_formats']
                .map<int>((dynamic value) => value as int));
      }
      if (detail && doc.containsKey('deliverables_description')) {
        offer.terms.deliverablesDescription = doc['deliverables_description'];
      }
      if (doc.containsKey('reward_cash_value')) {
        offer.terms.rewardCashValue = doc['reward_cash_value'];
      }
      if (doc.containsKey('reward_item_or_service_value')) {
        offer.terms.rewardItemOrServiceValue =
            doc['reward_item_or_service_value'];
      }
      if (detail && doc.containsKey('reward_item_or_service_description')) {
        offer.terms.rewardItemOrServiceDescription =
            doc['reward_item_or_service_description'];
      }
    }
    if ((summary || detail) && doc.containsKey('primary_categories')) {
      offer.primaryCategories.addAll(
          doc['primary_categories'].map<int>((dynamic value) => value as int));
    }
    if ((summary || detail) && doc.containsKey('sender_name')) {
      offer.senderName = doc['sender_name'];
    }
    if ((summary || detail) && doc.containsKey('sender_avatar_url')) {
      offer.senderAvatarUrl = doc['sender_avatar_url'];
    }
    if ((summary || detail) && doc.containsKey('sender_avatar_blurred')) {
      offer.senderAvatarBlurred = base64.decode(doc['sender_avatar_blurred']);
    }
    // TODO(kaetemi): sender_avatar_key
    if ((summary || detail) && doc.containsKey('location_address')) {
      offer.locationAddress = doc['location_address'];
    }
    if ((summary || detail) &&
        doc.containsKey('location') &&
        doc['location'].containsKey('lat') &&
        doc['location'].containsKey('lon')) {
      offer.latitude = doc['location']['lat'];
      offer.longitude = doc['location']['lon'];
    }
    if (detail && doc.containsKey('description')) {
      offer.description = doc['description'];
    }
    if (detail && doc.containsKey('cover_keys')) {
      if (private && receiverIsOwner) {
        offer.coverKeys.addAll(
            doc['cover_keys'].map<String>((dynamic value) => value as String));
      }
      offer.coverUrls.addAll((doc['cover_keys'] as List<dynamic>).map<String>(
          (dynamic coverKey) =>
              config.services.galleryCoverUrl.replaceAll('{key}', coverKey)));
    }
    if (detail && doc.containsKey('covers_blurred')) {
      offer.coversBlurred.addAll((doc['covers_blurred'] as List<dynamic>)
          .map<List<int>>(
              (dynamic coverBlurred) => base64.decode(coverBlurred)));
    }
    if (detail && doc.containsKey('categories')) {
      offer.categories
          .addAll(doc['categories'].map<int>((dynamic value) => value as int));
    }
    if (private && doc.containsKey('state')) {
      offer.state = OfferState.valueOf(doc['state']);
    }
    if ((private && receiverIsOwner) && doc.containsKey('state_reason')) {
      offer.stateReason = OfferStateReason.valueOf(doc['state_reason']);
    }
    if ((private && receiverIsOwner) && doc.containsKey('archived')) {
      offer.archived = doc['archived'];
    }
    if ((private && receiverIsOwner) &&
        doc.containsKey('proposals_proposing')) {
      offer.proposalsProposing = doc['proposals_proposing'];
    }
    if ((private && receiverIsOwner) &&
        doc.containsKey('proposals_negotiating')) {
      offer.proposalsNegotiating = doc['proposals_negotiating'];
    }
    if ((private && receiverIsOwner) && doc.containsKey('proposals_deal')) {
      offer.proposalsDeal = doc['proposals_deal'];
    }
    if ((private && receiverIsOwner) && doc.containsKey('proposals_rejected')) {
      offer.proposalsRejected = doc['proposals_rejected'];
    }
    if ((private && receiverIsOwner) && doc.containsKey('proposals_dispute')) {
      offer.proposalsDispute = doc['proposals_dispute'];
    }
    if ((private && receiverIsOwner) && doc.containsKey('proposals_resolved')) {
      offer.proposalsResolved = doc['proposals_resolved'];
    }
    if ((private && receiverIsOwner) && doc.containsKey('proposals_complete')) {
      offer.proposalsComplete = doc['proposals_complete'];
    }
    if (receiver != null) {
      // proposalId can be obtained by checking the embedded proposal_sender_ids map
      if (doc.containsKey('proposal_sender_ids') &&
          doc['proposal_sender_ids'].containsKey('$receiver')) {
        offer.proposalId = Int64(doc['proposal_sender_ids']['$receiver']);
      }
    }
    return offer;
  }
}

/* end of file */
