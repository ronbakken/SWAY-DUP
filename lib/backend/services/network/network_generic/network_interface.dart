/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/backend/services/network/network_generic/change.dart';
import 'package:inf/backend/services/network/protobuf/inf_protobuf.dart';

enum NetworkConnectionState { connecting, failing, offline, ready }

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  String toString() {
    return "NetworkException { message: \"$message\" }";
  }
}

abstract class NetworkInterface {
  /* Cached Data */
  /// Cached account state. Use this data directly from your build function.
  DataAccount account;

  /// Whether we are connected to the network.
  NetworkConnectionState connected;

  /////////////////////////////////////////////////////////////////////////////
  // Streams
  /////////////////////////////////////////////////////////////////////////////

  /// Called when any profile data has changed in some way, passes the id.
  Stream<Change<Int64>> get profileChanged;

  /// Called when any offer data has changed in some way, passes the id.
  Stream<Change<Int64>> get offerChanged;

  /// Called when the list of offers owned by the business has changed, passes the id of the affected entry.
  Stream<Change<Int64>> get offerBusinessChanged;

  /// Called when the list of demo offers has changed, passes the id of the affected entry.
  Stream<Change<Int64>> get offerDemoChanged;

  /// Called when the list of proposals attached to this user has changed, passes the id of the affected entry.
  Stream<Change<Int64>> get offerProposalChanged;

  /// Called when a change has occured to a chat entry in a proposal. Match by id if available, by ghost id if the id is not set or 0.
  Stream<Change<DataApplicantChat>> get offerProposalChatChanged;

  /// Called when either the account or network connection status has changed.
  Stream<void> get commonChanged;

  /////////////////////////////////////////////////////////////////////////////
  // Common
  /////////////////////////////////////////////////////////////////////////////

  /// Override the configured server uri
  void overrideUri(String serverUri);

  /////////////////////////////////////////////////////////////////////////////
  // Onboarding and OAuth
  /////////////////////////////////////////////////////////////////////////////

  /* Device Registration */
  /// Set account type. Only possible when not yet created.
  void setAccountType(AccountType accountType);

  /* OAuth */
  /// Get the URLs to use for the OAuth process
  Future<NetOAuthUrlRes> getOAuthUrls(int oauthProvider);

  /// Try to connect an OAuth provider with the received callback query
  Future<bool> connectOAuth(int oauthProvider, String callbackQuery);

  /// Create an account
  Future<void> createAccount(double latitude, double longitude);

  /////////////////////////////////////////////////////////////////////////////
  // Image upload
  /////////////////////////////////////////////////////////////////////////////

  /// Upload an image. Disregard the returned request options. Throws error in case of failure
  Future<NetUploadImageRes> uploadImage(FileImage fileImage);

  // Image selection switches out of the application, so we need to flag to keep the connection alive
  void pushKeepAlive();
  void popKeepAlive();

  /////////////////////////////////////////////////////////////////////////////
  // Business offers
  /////////////////////////////////////////////////////////////////////////////

  /// Create an offer.
  Future<DataBusinessOffer> createOffer(NetCreateOfferReq createOfferReq);

  /// Refresh all offers (currently latest offers)
  Future<void> refreshOffers();

  /// List of offers owned by this account (applicable for AT_BUSINESS)
  Map<int, DataBusinessOffer> get offers;

  /// Whether [offers] is in the process of loading. Not set by refreshOffers call
  bool get offersLoading;

  /////////////////////////////////////////////////////////////////////////////
  // Demo all offers
  /////////////////////////////////////////////////////////////////////////////

  /// Refresh all offers
  Future<void> refreshDemoAllOffers();

  /// List of all offers on the server
  Map<int, DataBusinessOffer> get demoAllOffers;

  /// Whether [offers] is in the process of loading. Not set by refreshOffers call
  bool demoAllOffersLoading;

  /////////////////////////////////////////////////////////////////////////////
  // Synchronization utilities
  /////////////////////////////////////////////////////////////////////////////

  /// Returns dummy based on fallback in case not yet available, and fetches latest, otherwise returns cached offer, never returns null, never throws exception
  DataBusinessOffer tryGetOffer(Int64 offerId);

  /// Get an offer, refresh set to true to always get from server, use sparingly to refresh the cache, may fail and throw exceptions
  Future<DataBusinessOffer> getOffer(Int64 offerId, {bool refresh = true});

  /// Reload business offer silently in the background, call when opening a window
  // void backgroundReloadBusinessOffer(Int64 offerId);

  /////////////////////////////////////////////////////////////////////////////
  // Get profile
  /////////////////////////////////////////////////////////////////////////////

  /// Retreives the profile summary. This is sufficient for displaying a thumbnail, card, or tile of the profile, without fetching all the profile details.
  /// Returns best guess placeholder in case not yet available, and fetches latest, otherwise returns cached account, never returns null, never throws exception.
  DataAccount tryGetProfileSummary(Int64 accountId);

  /// Retrieves the profile details. Adds a larger cover image, list of categories, social media information, other descriptive elements, and user location information.
  /// Returns best guess placeholder in case not yet available, and fetches latest, otherwise returns cached account, never returns null, never throws exception.
  DataAccount tryGetProfileDetail(Int64 accountId);

  /// Retrieves the extended profile information. Access may be restricted.
  // DataAccount tryGetProfileExtended(Int64 accountId);

  /// Returns dummy based on fallback in case not yet available, and fetches latest, otherwise returns cached account, never returns null, never throws exception
  /// Simply retry anytime network state updates
  // DataAccount tryGetPublicProfile(Int64 accountId);

  /// Get public profile, refresh set to true to always get from server, use sparingly to refresh the cache, may fail and throw exceptions
  Future<DataAccount> getPublicProfile(Int64 accountId, {bool refresh = true});

  /////////////////////////////////////////////////////////////////////////////
  // Haggle

  /// Suppress notifications
  void pushSuppressChatNotifications(Int64 proposalId);
  void popSuppressChatNotifications();

  /// Refresh all proposals (currently all latest proposals) (actually not necessary, but users like refreshing, so there it is)
  Future<void> refreshProposals();

  /// List of proposals for this account (may or may not be complete depending on loading status)
  Iterable<DataApplicant> get proposals;

  /// Whether [proposals] is in the process of loading. Not set by refreshOffers call
  bool get proposalsLoading;

  /// Apply for an offer, or send a direct offer proposal (TODO: Target influencer id for direct offers)
  Future<DataApplicant> sendProposal(Int64 offerId, String remarks);

  /// Get proposal from the server, acts like refresh
  Future<DataApplicant> getProposal(Int64 proposalId);

  /// Fetch latest proposal from cache by id, fetch in background if non-existent and return empty fallback
  DataApplicant tryGetProposal(Int64 proposalId);

  /// Fetch latest known applicant chats from cache, fetch in background if not loaded yet
  Iterable<DataApplicantChat> tryGetApplicantChats(Int64 proposalId);

  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  /// Sends a report about an applicant to support. May fail, must provide error feedback to the user.
  Future<void> reportApplicant(int applicantId, String text);

  /// Chat. Returns immediately, adding ghost data locally.
  void chatPlain(int applicantId, String text);
  void chatHaggle(
      int applicantId, String deliverables, String reward, String remarks);
  void chatImageKey(int applicantId, String imageKey);

  /// TODO: Provide image chat functions that takes file directly and handles background upload.

  /// Signify that the user wants a deal. May fail, must provide error feedback to the user.
  Future<void> wantDeal(int applicantId, int haggleChatId);
}

/* end of file */
