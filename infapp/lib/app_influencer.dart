/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inf/offers_showcase.dart';

import 'protobuf/inf_protobuf.dart';
import 'network/config_manager.dart';
import 'network/network_manager.dart';

import 'utility/progress_dialog.dart';

import 'profile/profile_view.dart';
import 'profile/profile_edit.dart';

import 'dashboard_common.dart';
import 'nearby_common.dart';
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
          .notificationNavigateApplicant
          .listen(onNotificationNavigateApplicant);
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

  void navigateToOfferView(
      BuildContext context, DataAccount account, DataBusinessOffer offer) {
    NetworkInterface network = NetworkManager.of(context);
    network.backgroundReloadBusinessOffer(offer.offerId);
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new OfferView(
        account: network.account,
        businessAccount: network.latestAccount(account),
        businessOffer: network.latestBusinessOffer(offer),
        onApplicantPressed: (int applicantId) {
          navigateToApplicantView(network.tryGetApplicant(applicantId), offer,
              account, network.account);
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
    }));
  }

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
      Navigator.pop(context);
    }
    network.pushSuppressChatNotifications(applicant.applicantId);
    applicantViewOpen = applicant.applicantId;
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
      applicantViewOpen = null;
      network.popSuppressChatNotifications();
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
    fadeToPage(context, (context, animation, secondaryAnimation) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new SearchPageCommon(
          searchHint: "Find nearby offers...",
          searchTooltip: "Search for nearby offers",
          searchQueryController: searchQueryController,
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
                        context,
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

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return new DashboardCommon(
      account: network.account,
      mapTab: 0,
      proposalsTab: 1,
      agreementsTab: 2,
      map: new Builder(builder: (context) {
        ConfigData config = ConfigManager.of(context);
        NetworkInterface network = NetworkManager.of(context);
        Widget map = new NearbyCommon(
          account: network.account,
          mapboxUrlTemplate: Theme.of(context).brightness == Brightness.dark
              ? config.services.mapboxUrlTemplateDark
              : config.services.mapboxUrlTemplateLight,
          mapboxToken: config.services.mapboxToken,
          onSearchPressed: (TextEditingController searchQuery) {
            navigateToSearchOffers(searchQuery);
            // query.text = ":)";
            // Scaffold.of(context).showSnackBar(
            //     new SnackBar(content: new Text("Not yet implemented.")));
          },
          searchHint: "Find nearby offers...",
          searchTooltip: "Search for nearby offers",
        );
        Widget showcase = new OffersShowcase(
          getOffer: (int offerId) => network.tryGetBusinessOffer(offerId),
          offerIds: network.demoAllOffers.keys.toList(),
          onOfferPressed: (DataBusinessOffer offer) {
            navigateToOfferView(
                context,
                network.tryGetPublicProfile(offer.accountId,
                    fallbackOffer: offer),
                network.latestBusinessOffer(offer));
          },
        );
        return new Column(
          children: <Widget>[
            new Flexible(
              child: map,
            ),
            /*new SizedBox(
              height: 132.0,*/
              /*child:*/ new Material(
                color: Theme.of(context).canvasColor,
                elevation: 4.0,
                child: showcase
              /*),*/
            )
          ],
        );
      }),
      onNavigateProfile: () {
        navigateToProfileView(context);
      },
      onNavigateDebugAccount: navigateToDebugAccount,
      proposalsApplying: new Builder(
        builder: (context) {
          return new ApplicantsListPlaceholder(
            applicants: network.applicants,
            onApplicantPressed: (applicant) {
              navigateToApplicantView(
                  applicant,
                  network.tryGetBusinessOffer(applicant.offerId),
                  network.tryGetPublicProfile(applicant.businessAccountId),
                  network.tryGetPublicProfile(applicant.influencerAccountId));
            },
          );
        },
      ),
    );
  }
}

/* end of file */
