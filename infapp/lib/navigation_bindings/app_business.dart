/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inf/network_inheritable/cross_account_navigation.dart';
import 'package:inf/network_inheritable/multi_account_selection.dart';

import 'package:inf/protobuf/inf_protobuf.dart';
import 'package:inf/network_mobile/config_manager.dart';
import 'package:inf/network_mobile/network_manager.dart';
import 'package:inf/screens/account_switch.dart';

import 'package:inf/widgets/progress_dialog.dart';

import 'package:inf/screens/profile_view.dart';
import 'package:inf/screens/profile_edit.dart';
import 'package:inf/screens/dashboard_common.dart';
import 'package:inf/screens/offer_create.dart';
import 'package:inf/screens/offer_view.dart';
import 'package:inf/screens/business_offer_list.dart';
import 'package:inf/screens/debug_account.dart';
import 'package:inf/screens/applicants_list_placeholder.dart';
import 'package:inf/screens/haggle_view.dart';

// Business user
class AppBusiness extends StatefulWidget {
  const AppBusiness({
    Key key,
  }) : super(key: key);

  @override
  _AppBusinessState createState() => new _AppBusinessState();
}

class _AppBusinessState extends State<AppBusiness> {
  NetworkInterface _network;
  ConfigData _config;
  CrossAccountNavigator _navigator;
  StreamSubscription<NavigationRequest> _navigationSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _config = ConfigManager.of(context);
    NetworkInterface network = NetworkManager.of(context);
    if (network != _network) {
      _network = network;
    }
    CrossAccountNavigator navigator = CrossAccountNavigation.of(context);
    if (navigator != _navigator) {
      if (_navigationSubscription != null) {
        _navigationSubscription.cancel();
      }
      _navigator = navigator;
      _navigationSubscription = _navigator.listen(_config.services.domain,
          new Int64(_network.account.state.accountId), onNavigationRequest);
    }
  }

  @override
  void dispose() {
    if (_navigationSubscription != null) {
      _navigationSubscription.cancel();
      _navigationSubscription = null;
    }
    super.dispose();
  }

  void onNavigationRequest(NavigationTarget target, Int64 id) {
    switch (target) {
      case NavigationTarget.Offer:
        // TODO
        break;
      case NavigationTarget.Profile:
        navigateToPublicProfile(_network.tryGetPublicProfile(id.toInt()));
        break;
      case NavigationTarget.Proposal:
        DataApplicant applicant = _network.tryGetApplicant(id.toInt());
        navigateToApplicantView(applicant, null, null, null);
        break;
    }
  }

  void navigateToMakeAnOffer(BuildContext context) {
    Navigator.push(
        // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
        context, new MaterialPageRoute(builder: (context) {
      ConfigData config = ConfigManager.of(context);
      NetworkInterface network = NetworkManager.of(context);
      NavigatorState navigator = Navigator.of(context);
      return new OfferCreate(
        onUploadImage: network.uploadImage,
        onCreateOffer: (NetCreateOfferReq createOffer) async {
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
                      new Text("Creating offer..."),
                    ],
                  ),
                );
              });
          DataBusinessOffer offer;
          try {
            // Create the offer
            offer = await network.createOffer(createOffer);
          } catch (error, stack) {
            print("[INF] Exception creating offer': $error\n$stack");
          }
          closeProgressDialog(progressDialog);
          if (offer == null) {
            await showDialog<Null>(
              context: this.context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('Create Offer Failed'),
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
            Navigator.of(this.context).pop();
            navigateToOfferView(network.account, offer);
          }
        },
      );
    }));
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
              : network.account;
          if (latestBusinessAccount.state.accountId !=
                  latestApplicant.businessAccountId &&
              latestApplicant.businessAccountId != 0) {
            latestBusinessAccount =
                network.tryGetPublicProfile(latestApplicant.businessAccountId);
          }
          DataAccount latestInfluencerAccount = influencerAccount != null
              ? network.latestAccount(influencerAccount)
              : null;
          if ((latestInfluencerAccount == null ||
                  latestInfluencerAccount.state.accountId !=
                      latestApplicant.influencerAccountId) &&
              latestApplicant.influencerAccountId != 0) {
            latestInfluencerAccount = network
                .tryGetPublicProfile(latestApplicant.influencerAccountId);
          }
          if (latestInfluencerAccount == null)
            latestInfluencerAccount = DataAccount();
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

  void navigateToSwitchAccount() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      // Important: Cannot depend on context outside Navigator.push and cannot use variables from container widget!
      ConfigData config = ConfigManager.of(context);
      // NetworkInterface network = NetworkManager.of(context);
      // NavigatorState navigator = Navigator.of(context);
      MultiAccountClient selection = MultiAccountSelection.of(context);
      return new AccountSwitch(
        domain: config.services.domain,
        accounts: selection.accounts,
        onAddAccount: () {
          selection.addAccount();
        },
        onSwitchAccount: (LocalAccountData localAccount) {
          selection.switchAccount(localAccount.domain, localAccount.accountId);
        },
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

  @override
  Widget build(BuildContext context) {
    NetworkInterface network = NetworkManager.of(context);
    assert(network != null);
    return new DashboardCommon(
      account: network.account,
      //mapTab: 2,
      offersTab: 0,
      proposalsTab: 1,
      agreementsTab: 2,
      map: new Text("/* Map */"),
      /*new Builder(builder: (context) {
        ConfigData config = ConfigManager.of(context);
        return new NearbyCommon(
          account: network.account,
          onSearchPressed: (TextEditingController searchQuery) {
            Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text("Not yet implemented.")));
          },
          mapboxUrlTemplate: Theme.of(context).brightness == Brightness.dark
              ? config.services.mapboxUrlTemplateDark
              : config.services.mapboxUrlTemplateLight,
          mapboxToken: config.services.mapboxToken,
          searchHint: "Find nearby influencers...",
          searchTooltip: "Search for nearby influencers",
        );
      }),*/
      offersCurrent: new Builder(builder: (context) {
        NetworkInterface network = NetworkManager.of(context);
        return new BusinessOfferList(
            businessOffers: network.offers.values
                .where(
                    (offer) => (offer.state != BusinessOfferState.BOS_CLOSED))
                .toList()
                  ..sort((a, b) => b.offerId.compareTo(a.offerId)),
            onRefreshOffers: (network.connected == NetworkConnectionState.Ready)
                ? network.refreshOffers
                : null,
            onOfferPressed: (DataBusinessOffer offer) {
              navigateToOfferView(network.account, offer);
            });
      }),
      offersHistory: new Builder(builder: (context) {
        NetworkInterface network = NetworkManager.of(context);
        return new BusinessOfferList(
            businessOffers: network.offers.values
                .where(
                    (offer) => (offer.state == BusinessOfferState.BOS_CLOSED))
                .toList()
                  ..sort((a, b) => b.offerId.compareTo(a.offerId)),
            onRefreshOffers: (network.connected == NetworkConnectionState.Ready)
                ? network.refreshOffers
                : null,
            onOfferPressed: (DataBusinessOffer offer) {
              navigateToOfferView(network.account,
                  offer); // account will be able to use a future value provider thingy for not-mine offers
            });
      }),
      proposalsSent: new Builder(
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
      onMakeAnOffer: (network.connected == NetworkConnectionState.Ready)
          ? () {
              navigateToMakeAnOffer(context);
            }
          : null,
      onNavigateProfile: () {
        navigateToProfileView(context);
      },
      onNavigateSwitchAccount: navigateToSwitchAccount,
      onNavigateDebugAccount: navigateToDebugAccount,
    );
  }
}

/* end of file */
