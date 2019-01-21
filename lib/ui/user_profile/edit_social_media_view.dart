import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
import 'package:inf/ui/user_profile/social_media_connector.dart';
import 'package:inf/ui/widgets/dialogs.dart';
import 'package:inf/ui/widgets/inf_memory_image..dart';
import 'package:inf/ui/widgets/inf_switch.dart';

class _SocialMediaRow {
  final SocialNetworkProvider provider;
  SocialMediaAccount account;
  bool get connected => account != null;
  _SocialMediaRow({
    this.provider,
    this.account,
  });
}

class EditSocialMediaView extends StatefulWidget {
  final List<SocialMediaAccount> socialMediaAccounts;

  const EditSocialMediaView({Key key, this.socialMediaAccounts}) : super(key: key);
  @override
  _EditSocialMediaViewState createState() => _EditSocialMediaViewState();
}

class _EditSocialMediaViewState extends State<EditSocialMediaView> {
  UserManager userManager;
  ConfigService configService;
  User user;

  final List<_SocialMediaRow> _socialMediaRows = <_SocialMediaRow>[];

  @override
  void initState() {
    configService = backend.get<ConfigService>();

    _socialMediaRows.clear();
    for (var provider in configService.socialNetworkProviders) {
      if (provider.logoMonochromeData.isNotEmpty) {
        var connectedAccount = widget.socialMediaAccounts
            .firstWhere((account) => account.socialNetWorkProvider.id == provider.id, orElse: () => null);
        _socialMediaRows.add(_SocialMediaRow(account: connectedAccount, provider: provider));
      }
    }
    super.initState();
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
                InfSwitch(
                    onChanged: (enabled) async {
                      if (enabled) {
                        var newAccount = await connectToSocialMediaAccount(row.provider, context);
                        if (newAccount != null) {
                          row.account = newAccount;
                        } else {
                          await showMessageDialog(context, 'Connection problem',
                              'There was a problem connecting your social media account. Please try again later');
                        }
                      }
                      else
                      {
                        row.account = null;
                      }
                      setState(() {});
                    },
                    value: row.connected,
                    activeColor: AppTheme.blue,
                  )
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
