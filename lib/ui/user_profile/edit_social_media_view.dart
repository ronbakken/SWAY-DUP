import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_switch.dart';
import 'package:inf_api_client/inf_api_client.dart';

class _SocialMediaRow {
  final SocialNetworkProvider provider;
  SocialMediaAccountWrapper account;
  bool get connected => account != null;
  _SocialMediaRow({this.provider, this.account,});
}

class EditSocialMediaView extends StatefulWidget {
  @override
  _EditSocialMediaViewState createState() => _EditSocialMediaViewState();
}

class _EditSocialMediaViewState extends State<EditSocialMediaView> {
  UserManager userManager;
  ConfigService configService;
  User user;

  StreamSubscription _socialMediaAccountsSubcription;

  final List<_SocialMediaRow> _socialMediaRows = <_SocialMediaRow>[];

  @override
  void initState() {
    userManager = backend.get<UserManager>();
    configService = backend.get<ConfigService>();

    user = userManager.currentUser.clone();

    _socialMediaAccountsSubcription =
        backend.get<UserManager>().currentSocialMediaAccountsUpdates.listen((socialMediaAccounts) {
      _socialMediaRows.clear();
      for (var provider in configService.socialNetworkProviders) {
        if (provider.logoMonochromeData.isNotEmpty) {
          var connectedAccount = socialMediaAccounts.firstWhere(
              (account) => account.socialMediaAccount.socialNetworkProviderId == provider.id,
              orElse: () => null);
          _socialMediaRows.add(_SocialMediaRow(account: connectedAccount, provider: provider));
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _socialMediaAccountsSubcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var entries = <Widget>[];
    for (var row in _socialMediaRows) {
      BoxDecoration logoDecoration;
      if (row.provider.logoBackgroundData.isNotEmpty) {
        logoDecoration = BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(Uint8List.fromList(row.provider.logoBackgroundData)),
            fit: BoxFit.fill,
          ),
        );
      } else {
        logoDecoration = BoxDecoration(
          shape: BoxShape.circle,
          color: Color(row.provider.logoBackGroundColor),
        );
      }

      entries.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
                width: 32,
                height: 32,
                decoration: logoDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InfMemoryImage(
                    Uint8List.fromList(row.provider.logoMonochromeData),
                    height: 20,
                  ),
                )),
            SizedBox(
              width: 16.0,
            ),
            Text(row.provider.name),
            Spacer(),
            row.connected
                ? InfSwitch(
                    onChanged: (enabled) {
                      setState(() {
                        if (enabled) {
                          assert(!user.activeSocialMediaProviders.contains(row.provider.id));
                          user.activeSocialMediaProviders.add(row.provider.id);
                        } else {
                          assert(user.activeSocialMediaProviders.contains(row.provider.id));
                          user.activeSocialMediaProviders.remove(row.provider.id);
                        }
                      });
                    },
                    value: row.connected,
                    activeColor: AppTheme.blue,
                  )
                : Icon(
                    Icons.add,
                    size: 32,
                  ),
            row.connected
                ? Icon(
                    Icons.delete,
                    size: 32,
                  )
                : SizedBox()
          ],
        ),
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: entries,
    );
  }
}
