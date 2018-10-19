/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inf/applicants_list_influencer.dart';

import 'package:inf/offers_showcase.dart';
import 'package:inf/offers_map.dart';
import 'package:latlong/latlong.dart';

import 'protobuf/inf_protobuf.dart';
import 'network/config_manager.dart';
import 'network/network_manager.dart';

import 'utility/progress_dialog.dart';

import 'profile/profile_view.dart';
import 'profile/profile_edit.dart';

import 'dashboard_common.dart';
import 'offer_view.dart';
import 'business_offer_list.dart';
import 'debug_account.dart';
import 'page_transition.dart';
import 'haggle_view.dart';
import "applicants_list_placeholder.dart";

import 'search/search_page_common.dart';
import 'cards/offer_card.dart';

// Influencer user
class AppInfluencer extends StatefulWidget {
  const AppInfluencer({
    Key key,
  }) : super(key: key);

  @override
  _AppInfluencerState createState() => new _AppInfluencerState();
}

class _AppInfluencerState extends State<AppInfluencer> {
  NetworkInterface _network;
  ConfigData _config;
  StreamSubscription<NotificationNavigateApplicant>
      _notificationNavigateApplicantSubscription;

  @override
  void initState() {
    super.initState();
    if (unhandledNotificationNavigateApplicant != null) {
      NotificationNavigateApplicant notification =
          unhandledNotificationNavigateApplicant;
      unhandledNotificationNavigateApplicant = null;
      onNotificationNavigateApplicant(notification);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NetworkInterface network = NetworkManager.of(context);
    if (network != _network) {
      _network = network;
      /*if (_notificationNavigateApplicantSubscription != null) {
        _notificationNavigateApplicantSubscription.cancel();
        _notificationNavigateApplicantSubscription = null;
      }*/
      _notificationNavigateApplicantSubscription = network
          .notificationNavigateApplicantListen(onNotificationNavigateApplicant);
    }
    _config = ConfigManager.of(context);
  }

  @override
  void dispose() {
    /*if (_notificationNavigateApplicantSubscription != null) {
      _notificationNavigateApplicantSubscription.cancel();
      _notificationNavigateApplicantSubscription = null;
    }*/
    super.dispose();
  }

  void onNotificationNavigateApplicant(
      NotificationNavigateApplicant notification) {
    if (!mounted ||
        notification.domain != _config.services.domain ||
        notification.accountId != _network.account.state.accountId) {
      // TODO: Swap domain and account if necessary
      unhandledNotificationNavigateApplicant = notification;
    } else {
      // Navigate to applicant
      DataApplicant applicant =
          _network.tryGetApplicant(notification.applicantId);
      navigateToApplicantView(applicant, null, null, null);
    }
  }

  int offerViewCount = 0;
  int offerViewOpen;
  void navigateToOfferView(DataAccount account, DataBusinessOffer offer) {
    NetworkInterface network = NetworkManager.of(context);
    if (offerViewOpen != null) {
      print("[INF] Pop previous offer route");
      Navigator.popUntil(context, (Route<dynamic> route) {
        return route.settings.name
            .startsWith('/offer/' + offerViewOpen.toString());
      });
      if (offerViewOpen == offer.offerId) {
        network.backgroundReloadBusinessOffer(offer.offerId);
        return;
      }
      Navigator.pop(context);
    }
    network.backgroundReloadBusinessOffer(offer.offerId);
    int count = ++offerViewCount;
    offerViewOpen = offer.offerId;
    Navigator.push(
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      context,
      new MaterialPageRoute(
        settings: new RouteSettings(name: '/offer/' + offer.offerId.toString()),
        builder: (context) {
          ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          NavigatorState navigator = Navigator.of(context);
          return new OfferView(
            account: network.account,
            businessAccount: network.latestAccount(account),
            businessOffer: network.latestBusinessOffer(offer),
            onBusinessAccountPressed: () {
              navigateToPublicProfile(network
                  .tryGetPublicProfile(offer.accountId, fallback: account));
            },
            onApplicantPressed: (int applicantId) {
              navigateToApplicantView(network.tryGetApplicant(applicantId),
                  offer, account, network.account);
            },
            onApply: (remarks) async {
              var progressDialog = showProgressDialog(
                  context: this.context,
                  builder: (BuildContext context) {
                    return new Dialog(
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Container(
                              padding: new EdgeInsets.all(24.0),
                              child: new CircularProgressIndicator()),
                          new Text("Applying for offer..."),
                        ],
                      ),
                    );
                  });
              DataApplicant applicant;
              try {
                // Create the offer
                applicant = await network.applyForOffer(offer.offerId, remarks);
              } catch (error, stack) {
                print("[INF] Exception applying for offer': $error\n$stack");
              }
              closeProgressDialog(progressDialog);
              if (applicant == null) {
                // TODO: Request refreshing the offer!!!
                await showDialog<Null>(
                  context: this.context,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: new Text('Failed to apply for offer'),
                      content: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            new Text('An error has occured.'),
                            new Text('Please try again later.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [new Text('Ok'.toUpperCase())],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Navigator.of(this.context).pop();
                navigateToApplicantView(
                    applicant,
                    offer,
                    network.tryGetPublicProfile(applicant.businessAccountId),
                    network.tryGetPublicProfile(applicant.influencerAccountId));
              }
              return applicant;
            },
          );
        },
      ),
    ).whenComplete(() {
      if (count == offerViewCount) {
        offerViewOpen = null;
      }
    });
  }

  int applicantViewCount = 0;
  int applicantViewOpen;
  void navigateToApplicantView(DataApplicant applicant, DataBusinessOffer offer,
      DataAccount businessAccount, DataAccount influencerAccount) {
    NetworkInterface network = NetworkManager.of(context);
    if (applicantViewOpen != null) {
      print("[INF] Pop previous applicant route");
      Navigator.popUntil(context, (Route<dynamic> route) {
        return route.settings.name
            .startsWith('/applicant/' + applicantViewOpen.toString());
      });
      if (applicantViewOpen == applicant.applicantId) {
        return;
      }
      Navigator.pop(context);
    }
    int count = ++applicantViewCount;
    applicantViewOpen = applicant.applicantId;
    bool suppressed = false;
    Navigator.push(
      context,
      new MaterialPageRoute(
        settings: new RouteSettings(
            name: '/applicant/' + applicant.applicantId.toString()),
        builder: (context) {
          // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
          ConfigData config = ConfigManager.of(context);
          NetworkInterface network = NetworkManager.of(context);
          NavigatorState navigator = Navigator.of(context);
          if (!suppressed) {
            network.pushSuppressChatNotifications(applicant.applicantId);
            suppressed = true;
          }
          DataApplicant latestApplicant = network.latestApplicant(applicant);
          DataBusinessOffer latestOffer =
              offer != null ? network.latestBusinessOffer(offer) : null;
          if ((latestOffer == null ||
                  latestOffer.offerId != latestApplicant.offerId) &&
              latestApplicant.offerId != 0) {
            latestOffer =
                network.tryGetBusinessOffer(latestApplicant.offerId); // TODO
          }
          if (latestOffer == null) latestOffer = DataBusinessOffer();
          DataAccount latestBusinessAccount = businessAccount != null
              ? network.latestAccount(businessAccount)
              : null;
          if ((latestBusinessAccount == null ||
                  latestBusinessAccount.state.accountId !=
                      latestApplicant.businessAccountId) &&
              latestApplicant.businessAccountId != 0) {
            latestBusinessAccount =
                network.tryGetPublicProfile(latestApplicant.businessAccountId);
          }
          if (latestBusinessAccount == null)
            latestBusinessAccount = DataAccount();
          DataAccount latestInfluencerAccount = influencerAccount != null
              ? network.latestAccount(influencerAccount)
              : network.account;
          if (latestInfluencerAccount.state.accountId !=
                  latestApplicant.influencerAccountId &&
              latestApplicant.influencerAccountId != 0) {
            latestInfluencerAccount = network
                .tryGetPublicProfile(latestApplicant.influencerAccountId);
          }
          return new HaggleView(
            account: network.account,
            businessAccount: latestBusinessAccount,
            influencerAccount: latestInfluencerAccount,
            applicant: latestApplicant,
            offer: latestOffer,
            chats: network.tryGetApplicantChats(applicant.applicantId),
            onUploadImage: network.uploadImage,
            onPressedProfile: (DataAccount account) {
              navigateToPublicProfile(network.tryGetPublicProfile(
                  account.state.accountId,
                  fallback: account));
            },
            onPressedOffer: (DataBusinessOffer offer) {
              navigateToOfferView(
                  network.tryGetPublicProfile(offer.accountId,
                      fallback: latestBusinessAccount),
                  offer);
            },
            onReport: (String message) async {
              await network.reportApplicant(applicant.applicantId, message);
            },
            onSendPlain: (String text) {
              network.chatPlain(applicant.applicantId, text);
            },
            onSendHaggle: (String deliverables, String reward, String remarks) {
              network.chatHaggle(
                  applicant.applicantId, deliverables, reward, remarks);
            },
            onSendImageKey: (String imageKey) {
              network.chatImageKey(applicant.applicantId, imageKey);
            },
            onWantDeal: (DataApplicantChat chat) async {
              await network.wantDeal(chat.applicantId, chat.chatId.toInt());
            },
          );
        },
      ),
    ).whenComplete(() {
      if (count == applicantViewCount) {
        applicantViewOpen = null;
      }
      if (suppressed) {
        network.popSuppressChatNotifications();
      }
    });
  }

  void navigateToPublicProfile(DataAccount account) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new ProfileView(
        account: network.latestAccount(account),
      );
    }));
  }

  void navigateToProfileView(BuildContext context) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new ProfileView(
          account: network.account,
          onEditPressed: () {
            navigateToProfileEdit(context);
          });
    }));
  }

  void navigateToProfileEdit(BuildContext context) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new ProfileEdit(
        account: network.account,
      );
    }));
  }

  void navigateToDebugAccount() {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new DebugAccount(
        account: network.account,
      );
    }));
  }

  void navigateToSearchOffers(TextEditingController searchQueryController) {
    TextEditingController searchQueryControllerFallback =
        searchQueryController ?? new TextEditingController();
    fadeToPage(context, (context, animation, secondaryAnimation) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new SearchPageCommon(
          searchHint: "Find nearby offers...",
          searchTooltip: "Search for nearby offers",
          searchQueryController: searchQueryControllerFallback,
          onSearchRequest: (String searchQuery) async {
            try {
              await network.refreshDemoAllOffers();
            } catch (error, stack) {
              await showDialog<Null>(
                context: this.context,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: new Text('Search Failed'),
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Text('An error has occured.'),
                          new Text('Please try again later.'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [new Text('Ok'.toUpperCase())],
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              print("Failed to search for offers: $error\n$stack");
            }
          },
          searchResults: network.demoAllOffers.values
              .map((offer) => new OfferCard(
                  businessOffer: offer,
                  onPressed: () {
                    navigateToOfferView(
                        network.tryGetPublicProfile(offer.accountId,
                            fallbackOffer: offer),
                        offer);
                  }))
              .toList()
                ..sort((a, b) => b.businessOffer.offerId
                    .compareTo(a.businessOffer.offerId)) //<Widget>[],
          );
    });
  }

  MapController _mapController = new MapController();
  bool _mapFilter = false;
  DataBusinessOffer _mapHighlightOffer;

  Widget _buildApplicantList(
      BuildContext context, bool Function(DataApplicant applicant) test) {
    NetworkInterface network = NetworkManager.of(context);
    return new ApplicantsListInfluencer(
      applicants: network.applicants.where(test),
      getAccount: (BuildContext context, int accountId) {
        NetworkInterface network = NetworkManager.of(context);
        return network.tryGetPublicProfile(accountId);
      },
      getBusinessOffer: (BuildContext context, int offerId) {
        NetworkInterface network = NetworkManager.of(context);
        return network.tryGetBusinessOffer(offerId);
      },
      onApplicantPressed: (applicant) {
        navigateToApplicantView(
            applicant,
            network.tryGetBusinessOffer(applicant.offerId),
            network.tryGetPublicProfile(applicant.businessAccountId),
            network.tryGetPublicProfile(applicant.influencerAccountId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    bool enoughSpaceForBottom = (MediaQuery.of(context).size.height > 480.0);
    assert(network != null);
    return new DashboardCommon(
      account: network.account,
      mapTab: 0,
      proposalsTab: 1,
      agreementsTab: 2,
      map: new Builder(builder: (context) {
        ConfigData config = ConfigManager.of(context);
        NetworkInterface network = NetworkManager.of(context);
        List<int> showcaseOfferIds = enoughSpaceForBottom
            ? network.demoAllOffers.keys.toList()
            : <int>[]; // TODO
        Widget showcase = showcaseOfferIds.isNotEmpty
            ? new OffersShowcase(
                getOffer: (BuildContext context, int offerId) {
                  NetworkInterface network = NetworkManager.of(context);
                  return network.tryGetBusinessOffer(offerId);
                },
                getAccount: (BuildContext context, int accountId) {
                  NetworkInterface network = NetworkManager.of(context);
                  return network.tryGetPublicProfile(accountId);
                },
                offerIds: network.demoAllOffers.keys.toList(),
                onOfferPressed: (DataBusinessOffer offer) {
                  navigateToOfferView(
                      network.tryGetPublicProfile(offer.accountId,
                          fallbackOffer: offer),
                      network.latestBusinessOffer(offer));
                },
                onOfferCenter: (DataBusinessOffer offer) {
                  _mapController.move(
                      new LatLng(offer.latitude, offer.longitude),
                      _mapController.zoom);
                  setState(() {
                    _mapHighlightOffer = offer;
                  });
                },
              )
            : null;
        /*if (showcase != null) {
          showcase = new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: showcase,
          );
        }*/
        /*if (showcase != null) {
          showcase = new Material(
            child: showcase,
          );
        }*/
        Widget map = new OffersMap(
          filterState: _mapFilter,
          account: network.account,
          mapboxUrlTemplate: Theme.of(context).brightness == Brightness.dark
              ? config.services.mapboxUrlTemplateDark
              : config.services.mapboxUrlTemplateLight,
          mapboxToken: config.services.mapboxToken,
          onSearchPressed: () {
            navigateToSearchOffers(null);
          },
          onFilterPressed: enoughSpaceForBottom
              ? () {
                  setState(() {
                    _mapFilter = !_mapFilter;
                  });
                }
              : null,
          filterTooltip: "Filter map offers by category",
          searchTooltip: "Search for nearby offers",
          mapController: _mapController,
          bottomSpace: (showcase != null) ? 156.0 : 0.0,
          offers: network.demoAllOffers.values.toList(),
          highlightOffer: _mapHighlightOffer,
          onOfferPressed: (DataBusinessOffer offer) {
            navigateToOfferView(
                network.tryGetPublicProfile(offer.accountId,
                    fallbackOffer: offer),
                network.latestBusinessOffer(offer));
          },
        );
        return showcase != null
            ? new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  map,
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      showcase,
                    ],
                  )
                ],
              )
            : map;
      }),
      onNavigateProfile: () {
        navigateToProfileView(context);
      },
      onNavigateDebugAccount: navigateToDebugAccount,
      proposalsSent: new Builder(
        builder: (context) {
          return _buildApplicantList(
              context,
              (DataApplicant applicant) =>
                  (applicant.senderAccountId ==
                      network.account.state.accountId) &&
                  (applicant.state == ApplicantState.AS_HAGGLING));
        },
      ),
      proposalsReceived: new Builder(
        builder: (context) {
          return _buildApplicantList(
              context,
              (DataApplicant applicant) =>
                  (applicant.senderAccountId !=
                      network.account.state.accountId) &&
                  (applicant.state == ApplicantState.AS_HAGGLING));
        },
      ),
      proposalsRejected: new Builder(
        builder: (context) {
          return _buildApplicantList(
              context,
              (DataApplicant applicant) =>
                  (applicant.state == ApplicantState.AS_REJECTED));
        },
      ),
      agreementsActive: new Builder(
        builder: (context) {
          return _buildApplicantList(
              context,
              (DataApplicant applicant) =>
                  (applicant.state == ApplicantState.AS_DEAL) ||
                  (applicant.state == ApplicantState.AS_DISPUTE));
        },
      ),
      agreementsHistory: new Builder(
        builder: (context) {
          return _buildApplicantList(
              context,
              (DataApplicant applicant) =>
                  (applicant.state == ApplicantState.AS_COMPLETE) ||
                  (applicant.state == ApplicantState.AS_RESOLVED));
        },
      ),
    );
  }
}

/* end of file */
