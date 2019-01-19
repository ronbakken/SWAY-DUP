import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/domain/domain.dart';
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
    userManager = backend.get<UserManager>();
    configService = backend.get<ConfigService>();

    user = userManager.currentUser.copyWith();

    _socialMediaRows.clear();
    for (var provider in configService.socialNetworkProviders) {
      if (provider.logoMonochromeData.isNotEmpty) {
        var connectedAccount = user.socialMediaAccounts
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
            row.connected
                ? InfSwitch(
                    onChanged: (enabled) {
                      setState(() {});
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
