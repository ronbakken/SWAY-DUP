/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'package:fixnum/fixnum.dart';
import 'package:sway_common/inf_common.dart';
import 'package:file/file.dart';

enum NetworkConnectionState { waiting, connecting, failing, offline, ready }

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  @override
  String toString() {
    return 'NetworkException { message: \"$message\" }';
  }
}

abstract class Api {
  /////////////////////////////////////////////////////////////////////////////
  // Common
  /////////////////////////////////////////////////////////////////////////////

  /// Override the configured end point
  void overrideEndPoint(String endPoint);

  /// Account state. Use this data directly from your build function.
  DataAccount account;

  /// Whether we are connected to the network.
  NetworkConnectionState connected;

  /////////////////////////////////////////////////////////////////////////////
  // Streams
  /////////////////////////////////////////////////////////////////////////////

  /// Called when any profile data has changed in some way, passes the id, if the id is Int64.ZERO it means all profiles have changed
  Stream<Int64> get profileChanged;

  /// Called when any offer data has changed in some way, passes the id, if the id is Int64.ZERO it means all offers have changed
  Stream<Int64> get offerChanged;

  /// Called when one of the user's proposals has been updated, if the id is Int64.ZERO it means all proposals have changed
  Stream<Int64> get proposalChanged;

  /// Called when the list of offers owned by the business has changed
  Stream<void> get offersChanged;

  /// Called when the list of demo offers has changed
  Stream<void> get demoAllOffersChanged;

  /// Called when the list of proposals has changed
  Stream<void> get proposalsChanged;

  /// Called when a list of proposal chats has changed, passes the id of the proposal
  Stream<Int64> get proposalChatsChanged;

  /// Called when a new proposal chat is available only when it requires a local UI notification. Also triggers proposalChatChanged for regular use
  Stream<DataProposalChat> get proposalChatNotification;

  /// Called when either the account or network connection status has changed
  Stream<void> get commonChanged;

  /////////////////////////////////////////////////////////////////////////////
  // Onboarding and OAuth
  /////////////////////////////////////////////////////////////////////////////

  /* Account Registration */
  /// Set account type. Only possible when not yet created.
  Future<void> setAccountType(AccountType accountType);

  /* OAuth */
  /// Get the URLs to use for the OAuth process
  Future<NetOAuthUrl> getOAuthUrls(int oauthProvider);

  /// Get the secrets or identifiers to use for the OAuth process
  Future<NetOAuthSecrets> getOAuthSecrets(int oauthProvider);

  /// Try to connect an OAuth provider with the received callback query
  Future<NetOAuthConnection> connectOAuth(
      int oauthProvider, String callbackQuery);

  /// Create an account
  Future<void> createAccount(double latitude, double longitude);

  /* Account changes */
  /// Set Firebase cloud messaging token
  Future<void> setFirebaseToken(String oldFirebaseToken, String firebaseToken);

  /// Update account. Pass only any values that need to be changed
  Future<void> updateAccount(DataAccount accountChanged);

  /////////////////////////////////////////////////////////////////////////////
  // Image upload
  /////////////////////////////////////////////////////////////////////////////

  /// Upload an image. Disregard the returned request options. Throws error in case of failure
  Future<NetUploadSigned> uploadImage(File file);

  // Image selection switches out of the application, so we need to flag to keep the connection alive
  void pushKeepAlive();
  void popKeepAlive();

  /////////////////////////////////////////////////////////////////////////////
  // Offer
  /////////////////////////////////////////////////////////////////////////////

  /// Returns dummy based on fallback in case not yet available, and fetches latest, otherwise returns cached offer, never returns null, never throws exception
  DataOffer tryGetOffer(Int64 offerId, {bool detail = true});

  /// Get an offer, refresh set to true to always get from server, use sparingly to refresh the cache, may fail and throw exceptions
  Future<DataOffer> getOffer(Int64 offerId, {bool refresh = true});

  /// Create an offer.
  Future<DataOffer> createOffer(NetCreateOffer createOfferReq);

  /// Refresh all offers owned by this account (currently latest offers)
  Future<void> refreshOffers();

  /// List of offers owned by this account (applicable for business)
  List<Int64> get offers;

  /// Whether [offers] is in the process of loading. Not set by refreshOffers call
  bool get offersLoading;

  /////////////////////////////////////////////////////////////////////////////
  // Demo all offers
  /////////////////////////////////////////////////////////////////////////////

  /// Refresh all offers
  Future<void> refreshDemoAllOffers();

  /// List of all offers on the server
  List<Int64> get demoAllOffers;

  /// Whether [offers] is in the process of loading. Not set by refreshOffers call
  bool get demoAllOffersLoading;

  /////////////////////////////////////////////////////////////////////////////
  // Synchronization utilities
  /////////////////////////////////////////////////////////////////////////////

  /// Reload business offer silently in the background, call when opening a window
  // void backgroundReloadOffer(Int64 offerId);

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
  Iterable<DataProposal> get proposals;

  /// Whether [proposals] is in the process of loading. Not set by refreshOffers call
  bool get proposalsLoading;

  /// Apply for an offer, or send a direct offer proposal (TODO: Target influencer id for direct offers)
  Future<DataProposal> applyProposal(Int64 offerId, String remarks);

  /// Get proposal from the server, acts like refresh
  Future<DataProposal> getProposal(Int64 proposalId);

  /// Fetch latest proposal from cache by id, fetch in background if non-existent and return empty fallback
  DataProposal tryGetProposal(Int64 proposalId);

  /// Fetch latest known proposal chats from cache, fetch in background if not loaded yet
  Iterable<DataProposalChat> tryGetProposalChats(Int64 proposalId);

  /////////////////////////////////////////////////////////////////////////////
  // Haggle Actions
  /////////////////////////////////////////////////////////////////////////////

  /// Sends a report about an proposal to support. May fail, must provide error feedback to the user.
  Future<void> reportProposal(Int64 proposalId, String text);

  /// Chat. Returns immediately, adding ghost data locally.
  void chatPlain(Int64 proposalId, String text);
  void chatHaggle(
      Int64 proposalId, String deliverables, String reward, String remarks);
  void chatImageKey(Int64 proposalId, String imageKey);

  // TODO: Provide image chat functions that takes file directly and handles background upload.

  /// Signify that the user wants a deal. May fail, must provide error feedback to the user.
  Future<void> wantDeal(Int64 proposalId, Int64 termsChatId);

  /// Mark completion.
  Future<void> markCompletion(
      Int64 proposalId, int rating); // TODO: Review text content

  /////////////////////////////////////////////////////////////////////////////
  // Push
  /////////////////////////////////////////////////////////////////////////////

  /// Connection state of the push service
  NetworkConnectionState get receiving;
}

/* end of file */
