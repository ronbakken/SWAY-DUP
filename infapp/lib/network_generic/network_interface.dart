/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/protobuf/inf_protobuf.dart';

enum NetworkConnectionState { connecting, failing, offline, ready }

abstract class NetworkInterface {
  /* Cached Data */
  /// Cached account state. Use this data directly from your build function
  DataAccount account;

  /// Whether we are connected to the network.
  NetworkConnectionState connected;

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

  /// Refresh all applicants (currently all latest applicants)
  Future<void> refreshApplicants();

  /// List of applicants for this account (may or may not be complete depending on loading status)
  Iterable<DataApplicant> get applicants;

  /// Whether [offers] is in the process of loading. Not set by refreshOffers call
  bool get applicantsLoading;

  /// Apply for an offer
  Future<DataApplicant> applyForOffer(int offerId, String remarks);

  /// Get applicant from the server, acts like refresh
  Future<DataApplicant> getApplicant(Int64 applicantId);

  /// Fetch latest applicant from cache by id, fetch in background if non-existent and return empty fallback
  DataApplicant tryGetApplicant(Int64 applicantId,
      {DataBusinessOffer fallbackOffer});

  /// Fetch latest applicant from cache, fetch in background if non-existent and return given fallback
  DataApplicant latestApplicant(DataApplicant applicant);

  /// Fetch latest known applicant chats from cache, fetch in background if not loaded yet
  Iterable<DataApplicantChat> tryGetApplicantChats(Int64 applicantId);

  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  /// Sends a report about an applicant to support
  Future<void> reportApplicant(int applicantId, String text);

  void chatPlain(int applicantId, String text);
  void chatHaggle(
      int applicantId, String deliverables, String reward, String remarks);
  void chatImageKey(int applicantId, String imageKey);

  Future<void> wantDeal(int applicantId, int haggleChatId);
}

/* end of file */
